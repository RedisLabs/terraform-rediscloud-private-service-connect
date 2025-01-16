# GCP Service Attachments

This module provisioning IP Addresses, forwarding rules and DNS entries a particular GCP subnetwork.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.redis_ip_addresses](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_forwarding_rule.redis_forwarding_rules](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |
| [google_dns_response_policy_rule.redis_response_policy_rules](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_response_policy_rule) | resource |
| [google_compute_subnetwork.subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_record_ttl"></a> [dns\_record\_ttl](#input\_dns\_record\_ttl) | TTL for the DNS A Record | `number` | `300` | no |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | The Google Cloud Project ID | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | The GCP Region to use | `string` | n/a | yes |
| <a name="input_gcp_response_policy_name"></a> [gcp\_response\_policy\_name](#input\_gcp\_response\_policy\_name) | The DNS Response Policy Name | `string` | n/a | yes |
| <a name="input_gcp_vpc_name"></a> [gcp\_vpc\_name](#input\_gcp\_vpc\_name) | The GCP VPC Network name | `string` | n/a | yes |
| <a name="input_gcp_vpc_subnetwork_name"></a> [gcp\_vpc\_subnetwork\_name](#input\_gcp\_vpc\_subnetwork\_name) | The GCP VPC Subnetwork name | `string` | n/a | yes |
| <a name="input_rediscloud_service_attachments"></a> [rediscloud\_service\_attachments](#input\_rediscloud\_service\_attachments) | Private Service Connect Service Attachments | <pre>list(object({<br/>    name                 = string<br/>    forwarding_rule_name = string<br/>    ip_address_name      = string<br/>    dns_record           = string<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->