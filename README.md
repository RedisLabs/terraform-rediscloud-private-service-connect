# Redis Cloud Private Service Connect Module

This module creates Private Service Connect service and endpoints in Redis Cloud and also provisions IP Address, forwarding
rules and DNS entries a particular GCP subnetwork. It can create those resources in Active-Active and Pro subscriptions 
depending on the module `rediscloud_subscription_type`.


## Usage

For a complete examples, see: [examples/active_active](examples/active_active) and [examples/pro](examples/pro)

```hcl
provider "gcp" {
  region = var.region
}

module "psc" {
  source  = "RedisLabs/private_service_connect/rediscloud"

  rediscloud_subscription_type = "active-active"
  rediscloud_subscription_id   = var.subscription_id
  rediscloud_region_id         = var.region_id

  gcp_region              = var.gcp_region
  
  endpoints = [
    {
        gcp_project_id          = var.gcp_project_id
        gcp_vpc_name            = var.gcp_vpc_name
        gcp_vpc_subnetwork_name = var.gcp_vpc_subnetwork_name
    }
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_active_active_psc"></a> [active\_active\_psc](#module\_active\_active\_psc) | ./modules/active_active_private_service_connect | n/a |
| <a name="module_psc"></a> [psc](#module\_psc) | ./modules/private_service_connect | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_record_ttl"></a> [dns\_record\_ttl](#input\_dns\_record\_ttl) | TTL for the DNS A Record | `number` | `300` | no |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | List of endpoints to provision | <pre>list(object({<br/>    gcp_project_id           = string # The Google Cloud Project ID<br/>    gcp_vpc_name             = string # The GCP VPC Network name<br/>    gcp_vpc_subnetwork_name  = string # The GCP VPC Subnetwork name<br/>    gcp_response_policy_name = string # The DNS Response Policy Name<br/>  }))</pre> | `[]` | no |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | The GCP Region to use | `string` | n/a | yes |
| <a name="input_rediscloud_region_id"></a> [rediscloud\_region\_id](#input\_rediscloud\_region\_id) | The ID of the Region associated with Active-Active Subscription. This is required for `active-active` subscription type | `number` | `null` | no |
| <a name="input_rediscloud_subscription_id"></a> [rediscloud\_subscription\_id](#input\_rediscloud\_subscription\_id) | The ID of the Active-Active subscription | `string` | n/a | yes |
| <a name="input_rediscloud_subscription_type"></a> [rediscloud\_subscription\_type](#input\_rediscloud\_subscription\_type) | The subscription type - `active-active` or `pro` | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_service_connect_endpoint_ids"></a> [private\_service\_connect\_endpoint\_ids](#output\_private\_service\_connect\_endpoint\_ids) | The IDs of the Private Service Connect Endpoints |
| <a name="output_private_service_connect_service_id"></a> [private\_service\_connect\_service\_id](#output\_private\_service\_connect\_service\_id) | The ID of the Private Service Connect |
| <a name="output_redis_dns_records"></a> [redis\_dns\_records](#output\_redis\_dns\_records) | List of Redis DNS records for each endpoint |
<!-- END_TF_DOCS -->

# Development

## Requirements

* Terraform >= 1.x
* Go >= 1.23
* Redis Cloud Account
* GCP Account
* [Terraform Docs](https://terraform-docs.io/)
* [TFLint](https://github.com/terraform-linters/tflint)

## Formatting

```shell
terraform fmt  --recursive
terraform-docs markdown --recursive . --output-file README.md
tflint --recursive
```

## Testing the Module

### Environment Variables

* `REDISCLOUD_ACCESS_KEY` - Account Cloud API Access Key
* `REDISCLOUD_SECRET_KEY` - Individual user Cloud API Secret Key
* `REDISCLOUD_URL` - (Optional) Redis Cloud API Base URL
* `GCP_PROJECT` - The GCP project ID
* `GOOGLE_APPLICATION_CREDENTIALS` or other supported environment variables described in [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication-configuration)

```shell
go test ./test
```