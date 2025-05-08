locals {
  # As Terraform needs to know the number of GCP resources that we will be created at
  # plan time, we cannot use `service_attachments` from the private service connect endpoint directly
  # as those are only computed after applying the plan. Because of that we need a fixed count
  # here unfortunately.
  service_attachment_count = 1
}

data "google_compute_subnetwork" "subnet" {
  project = var.gcp_project_id
  name    = var.gcp_vpc_subnetwork_name
  region  = var.gcp_region
}

resource "google_compute_address" "redis_ip_addresses" {
  count = local.service_attachment_count

  project      = var.gcp_project_id
  name         = var.rediscloud_service_attachments[count.index].ip_address_name
  subnetwork   = data.google_compute_subnetwork.subnet.id
  address_type = "INTERNAL"
  region       = var.gcp_region
}

resource "google_compute_forwarding_rule" "redis_forwarding_rules" {
  count = local.service_attachment_count

  name                  = var.rediscloud_service_attachments[count.index].forwarding_rule_name
  project               = var.gcp_project_id
  region                = var.gcp_region
  ip_address            = google_compute_address.redis_ip_addresses[count.index].id
  network               = var.gcp_vpc_name
  target                = var.rediscloud_service_attachments[count.index].name
  load_balancing_scheme = ""
}

resource "google_dns_response_policy_rule" "redis_response_policy_rules" {
  count = local.service_attachment_count

  project         = var.gcp_project_id
  response_policy = var.gcp_response_policy_name
  rule_name       = "${var.rediscloud_service_attachments[count.index].forwarding_rule_name}-${var.gcp_region}-rule"
  dns_name        = var.rediscloud_service_attachments[count.index].dns_record

  local_data {
    local_datas {
      name    = var.rediscloud_service_attachments[count.index].dns_record
      type    = "A"
      ttl     = var.dns_record_ttl
      rrdatas = [google_compute_address.redis_ip_addresses[count.index].address]
    }
  }
}
