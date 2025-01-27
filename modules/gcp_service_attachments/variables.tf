variable "rediscloud_service_attachments" {
  type = list(object({
    name                 = string
    forwarding_rule_name = string
    ip_address_name      = string
    dns_record           = string
  }))
  description = "Private Service Connect Service Attachments"
}

variable "gcp_project_id" {
  type        = string
  description = "The Google Cloud Project ID"
}

variable "gcp_region" {
  type        = string
  description = "The GCP Region to use"
}

variable "gcp_response_policy_name" {
  type        = string
  description = "The DNS Response Policy Name"
}

variable "gcp_vpc_name" {
  type        = string
  description = "The GCP VPC Network name"
}

variable "gcp_vpc_subnetwork_name" {
  type        = string
  description = "The GCP VPC Subnetwork name"
}

variable "dns_record_ttl" {
  type        = number
  default     = 300
  description = "TTL for the DNS A Record"
}