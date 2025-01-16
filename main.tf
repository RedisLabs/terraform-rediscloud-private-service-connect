module "active_active_psc" {
  source = "./modules/active_active_private_service_connect"

  count = var.rediscloud_subscription_type == "active-active" ? 1 : 0

  rediscloud_subscription_id = var.rediscloud_subscription_id
  rediscloud_region_id       = var.rediscloud_region_id
  gcp_region                 = var.gcp_region
  endpoints                  = var.endpoints
  dns_record_ttl             = var.dns_record_ttl
}

module "psc" {
  source = "./modules/private_service_connect"

  count = var.rediscloud_subscription_type == "pro" ? 1 : 0

  rediscloud_subscription_id = var.rediscloud_subscription_id
  gcp_region                 = var.gcp_region
  endpoints                  = var.endpoints
  dns_record_ttl             = var.dns_record_ttl
}
