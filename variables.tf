variable "rediscloud_subscription_type" {
  type        = string
  description = "The subscription type - `active-active` or `pro`"
  validation {
    condition     = can(regex("^(active-active|pro)$", var.rediscloud_subscription_type))
    error_message = "rediscloud_subscription_type must be either active-active or pro"
  }
}

variable "rediscloud_subscription_id" {
  type        = string
  description = "The ID of the Active-Active subscription"
}

variable "rediscloud_region_id" {
  type        = number
  description = "The ID of the Region associated with Active-Active Subscription. This is required for `active-active` subscription type"
  default     = null
}

variable "gcp_region" {
  type        = string
  description = "The GCP Region to use"
}

variable "endpoints" {
  type = list(object({
    gcp_project_id           = string # The Google Cloud Project ID
    gcp_vpc_name             = string # The GCP VPC Network name
    gcp_vpc_subnetwork_name  = string # The GCP VPC Subnetwork name
    gcp_response_policy_name = string # The DNS Response Policy Name
  }))
  description = "List of endpoints to provision"
  default     = []
}

variable "dns_record_ttl" {
  type        = number
  default     = 300
  description = "TTL for the DNS A Record"
}