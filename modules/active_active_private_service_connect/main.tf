resource "rediscloud_active_active_private_service_connect" "service" {
  subscription_id = var.rediscloud_subscription_id
  region_id       = var.rediscloud_region_id
}

resource "rediscloud_active_active_private_service_connect_endpoint" "endpoint" {
  count = length(var.endpoints)

  subscription_id                    = var.rediscloud_subscription_id
  region_id                          = var.rediscloud_region_id
  private_service_connect_service_id = rediscloud_active_active_private_service_connect.service.private_service_connect_service_id
  gcp_project_id                     = var.endpoints[count.index].gcp_project_id
  gcp_vpc_name                       = var.endpoints[count.index].gcp_vpc_name
  gcp_vpc_subnet_name                = var.endpoints[count.index].gcp_vpc_subnetwork_name
  endpoint_connection_name           = "redis-${var.rediscloud_subscription_id}-${count.index}"
}

module "gcp_service_attachments" {
  source = "../gcp_service_attachments"

  count = length(var.endpoints)

  rediscloud_service_attachments = rediscloud_active_active_private_service_connect_endpoint.endpoint[count.index].service_attachments

  gcp_project_id           = var.endpoints[count.index].gcp_project_id
  gcp_region               = var.gcp_region
  gcp_vpc_name             = var.endpoints[count.index].gcp_vpc_name
  gcp_vpc_subnetwork_name  = var.endpoints[count.index].gcp_vpc_subnetwork_name
  gcp_response_policy_name = var.endpoints[count.index].gcp_response_policy_name

  dns_record_ttl = var.dns_record_ttl
}

resource "rediscloud_active_active_private_service_connect_endpoint_accepter" "accepter" {
  count = length(var.endpoints)

  subscription_id                     = var.rediscloud_subscription_id
  region_id                           = var.rediscloud_region_id
  private_service_connect_service_id  = rediscloud_active_active_private_service_connect.service.private_service_connect_service_id
  private_service_connect_endpoint_id = rediscloud_active_active_private_service_connect_endpoint.endpoint[count.index].private_service_connect_endpoint_id
  action                              = "accept"

  depends_on = [module.gcp_service_attachments]
}