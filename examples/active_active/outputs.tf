output "private_service_connect_service_id" {
  value = { for k, v in module.psc : k => v.private_service_connect_service_id }
}

output "private_service_connect_endpoint_ids" {
  value = { for k, v in module.psc : k => v.private_service_connect_endpoint_ids }
}

output "redis_dns_records" {
  value = { for k, v in module.psc : k => v.redis_dns_records }
}