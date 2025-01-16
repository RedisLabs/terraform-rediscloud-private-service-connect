variable "prefix" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

variable "subnet_cidr_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "redis_cidr_range" {
  type    = string
  default = "10.0.0.0/24"
}