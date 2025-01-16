output "private_service_connect_service_id" {
  value       = rediscloud_private_service_connect.service.private_service_connect_service_id
  description = "The ID of the Private Service Connect"
}

output "private_service_connect_endpoint_ids" {
  value       = rediscloud_private_service_connect_endpoint.endpoint[*].private_service_connect_endpoint_id
  description = "The IDs of the Private Service Connect Endpoints"
}

output "redis_dns_records" {
  value = [
    for e in rediscloud_private_service_connect_endpoint.endpoint :
    [for s in e.service_attachments : s.dns_record]
  ]
  description = "List of Redis DNS records for each endpoint"
}