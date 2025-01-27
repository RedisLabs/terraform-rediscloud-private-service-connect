variable "prefix" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_regions" {
  type = list(string)
  default = [
    "us-central1",
    "europe-west1"
  ]
}

variable "cidr_range" {
  type    = string
  default = "10.0.0.0/16"
}
