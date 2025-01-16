provider "google" {
  project = var.gcp_project_id
  region  = "us-central1"
}

data "rediscloud_payment_method" "card" {
  card_type = "Visa"
}

resource "google_compute_network" "network" {
  project                 = var.gcp_project_id
  name                    = var.prefix
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  for_each      = { for idx, key in var.gcp_regions : key => idx }
  project       = var.gcp_project_id
  name          = "${var.prefix}-${each.key}"
  ip_cidr_range = cidrsubnet(var.cidr_range, 8, each.value)
  region        = each.key
  network       = google_compute_network.network.id
}

resource "google_dns_response_policy" "response_policy" {
  response_policy_name = "redis-${google_compute_network.network.name}"
  project              = var.gcp_project_id

  networks {
    network_url = google_compute_network.network.id
  }
}

resource "rediscloud_active_active_subscription" "subscription" {
  name              = "${var.prefix}-psc-aa"
  payment_method_id = data.rediscloud_payment_method.card.id
  cloud_provider    = "GCP"

  creation_plan {
    memory_limit_in_gb = 1
    quantity           = 1
    dynamic "region" {
      for_each = { for idx, key in var.gcp_regions : key => idx }
      content {
        region                      = region.key
        networking_deployment_cidr  = cidrsubnet(var.cidr_range, 8, region.value)
        write_operations_per_second = 1000
        read_operations_per_second  = 1000
      }
    }
  }
}

resource "rediscloud_active_active_subscription_database" "database" {
  subscription_id         = rediscloud_active_active_subscription.subscription.id
  name                    = "db"
  memory_limit_in_gb      = 1
  global_data_persistence = "aof-every-1-second"
  global_password         = "some-random-pass"
}

resource "rediscloud_active_active_subscription_regions" "regions" {
  subscription_id = rediscloud_active_active_subscription.subscription.id

  dynamic "region" {
    for_each = { for idx, key in var.gcp_regions : key => idx }
    content {
      region                     = region.key
      networking_deployment_cidr = cidrsubnet(var.cidr_range, 8, region.value)
      database {
        database_id                       = rediscloud_active_active_subscription_database.database.db_id
        database_name                     = rediscloud_active_active_subscription_database.database.name
        local_write_operations_per_second = 1000
        local_read_operations_per_second  = 1000
      }
    }
  }
}

module "psc" {
  source = "../../"

  for_each = toset(var.gcp_regions)

  rediscloud_subscription_type = "active-active"
  rediscloud_subscription_id   = rediscloud_active_active_subscription.subscription.id
  rediscloud_region_id         = { for r in rediscloud_active_active_subscription_regions.regions.region : r.region => r.region_id }[each.key]

  gcp_region = each.key
  endpoints = [
    {
      gcp_project_id           = var.gcp_project_id
      gcp_vpc_name             = google_compute_network.network.name
      gcp_vpc_subnetwork_name  = google_compute_subnetwork.subnets[each.key].name
      gcp_response_policy_name = google_dns_response_policy.response_policy.response_policy_name
    }
  ]

  depends_on = [
    google_compute_network.network,
    google_compute_subnetwork.subnets
  ]
}
