provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

data "rediscloud_payment_method" "card" {
  card_type = "Visa"
}

resource "google_compute_network" "network" {
  project                 = var.gcp_project_id
  name                    = var.prefix
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  project       = var.gcp_project_id
  name          = var.prefix
  ip_cidr_range = cidrsubnet(var.subnet_cidr_range, 8, 0)
  region        = var.gcp_region
  network       = google_compute_network.network.id
}

resource "google_dns_response_policy" "response_policy" {
  response_policy_name = "redis-${google_compute_network.network.name}"
  project              = var.gcp_project_id

  networks {
    network_url = google_compute_network.network.id
  }
}

resource "rediscloud_subscription" "subscription" {
  name              = "${var.prefix}-psc"
  payment_method_id = data.rediscloud_payment_method.card.id

  cloud_provider {
    provider = "GCP"
    region {
      region                     = var.gcp_region
      networking_deployment_cidr = var.redis_cidr_range
    }
  }

  creation_plan {
    dataset_size_in_gb           = 15
    quantity                     = 1
    replication                  = true
    throughput_measurement_by    = "operations-per-second"
    throughput_measurement_value = 20000
  }
}

module "psc" {
  source = "../../"

  rediscloud_subscription_type = "pro"
  rediscloud_subscription_id   = rediscloud_subscription.subscription.id

  gcp_region = var.gcp_region
  endpoints = [
    {
      gcp_project_id           = var.gcp_project_id
      gcp_vpc_name             = google_compute_network.network.name
      gcp_vpc_subnetwork_name  = google_compute_subnetwork.subnet.name
      gcp_response_policy_name = google_dns_response_policy.response_policy.response_policy_name
    }
  ]

  depends_on = [
    google_compute_network.network,
    google_compute_subnetwork.subnet
  ]
}
