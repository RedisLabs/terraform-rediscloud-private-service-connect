# Private Service Connect Module (for Pro Subscriptions)

This module creates Private Service Connect service and endpoints in Redis Cloud and also provisions IP addresses, forwarding
rules and DNS entries a particular GCP subnetwork.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2 |
| <a name="requirement_rediscloud"></a> [rediscloud](#requirement\_rediscloud) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rediscloud"></a> [rediscloud](#provider\_rediscloud) | ~> 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp_service_attachments"></a> [gcp\_service\_attachments](#module\_gcp\_service\_attachments) | ../gcp_service_attachments | n/a |

## Resources

| Name | Type |
|------|------|
| [rediscloud_private_service_connect.service](https://registry.terraform.io/providers/RedisLabs/rediscloud/latest/docs/resources/private_service_connect) | resource |
| [rediscloud_private_service_connect_endpoint.endpoint](https://registry.terraform.io/providers/RedisLabs/rediscloud/latest/docs/resources/private_service_connect_endpoint) | resource |
| [rediscloud_private_service_connect_endpoint_accepter.accepter](https://registry.terraform.io/providers/RedisLabs/rediscloud/latest/docs/resources/private_service_connect_endpoint_accepter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_record_ttl"></a> [dns\_record\_ttl](#input\_dns\_record\_ttl) | TTL for the DNS A Record | `number` | `300` | no |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | List of endpoints to provision | <pre>list(object({<br/>    gcp_project_id           = string # The Google Cloud Project ID<br/>    gcp_vpc_name             = string # The GCP VPC Network name<br/>    gcp_vpc_subnetwork_name  = string # The GCP VPC Subnetwork name<br/>    gcp_response_policy_name = string # The DNS Response Policy Name<br/>  }))</pre> | `[]` | no |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | The GCP Region to use | `string` | n/a | yes |
| <a name="input_rediscloud_subscription_id"></a> [rediscloud\_subscription\_id](#input\_rediscloud\_subscription\_id) | The ID of the Pro subscription | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_service_connect_endpoint_ids"></a> [private\_service\_connect\_endpoint\_ids](#output\_private\_service\_connect\_endpoint\_ids) | The IDs of the Private Service Connect Endpoints |
| <a name="output_private_service_connect_service_id"></a> [private\_service\_connect\_service\_id](#output\_private\_service\_connect\_service\_id) | The ID of the Private Service Connect |
| <a name="output_redis_dns_records"></a> [redis\_dns\_records](#output\_redis\_dns\_records) | List of Redis DNS records for each endpoint |
<!-- END_TF_DOCS -->