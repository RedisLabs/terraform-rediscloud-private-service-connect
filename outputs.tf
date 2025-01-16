output "private_service_connect_service_id" {
  value       = var.rediscloud_subscription_type == "active-active" ? module.active_active_psc[0].private_service_connect_service_id : module.psc[0].private_service_connect_service_id
  description = "The ID of the Private Service Connect"
}

output "private_service_connect_endpoint_ids" {
  value       = var.rediscloud_subscription_type == "active-active" ? module.active_active_psc[0].private_service_connect_endpoint_ids : module.psc[0].private_service_connect_endpoint_ids
  description = "The IDs of the Private Service Connect Endpoints"
}

output "redis_dns_records" {
  value       = var.rediscloud_subscription_type == "active-active" ? module.active_active_psc[0].redis_dns_records : module.psc[0].redis_dns_records
  description = "List of Redis DNS records for each endpoint"
}