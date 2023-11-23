<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_bus.main_event_bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus) | resource |
| [aws_cloudwatch_event_permission.OrganizationAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_permission) | resource |
| [aws_cloudwatch_event_rule.default_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.default_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_organizations_organization.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arn_of_target"></a> [arn\_of\_target](#input\_arn\_of\_target) | The Amazon Resource Name (ARN) of the target.(Example: SNS Topic or Event Bus target ARN | `string` | `null` | no |
| <a name="input_descripiton_rule"></a> [descripiton\_rule](#input\_descripiton\_rule) | Description of rule. It is only necessary if rule\_name is provided. | `string` | `""` | no |
| <a name="input_event_bus_name"></a> [event\_bus\_name](#input\_event\_bus\_name) | Event Bus name. | `string` | n/a | yes |
| <a name="input_event_pattern_rule"></a> [event\_pattern\_rule](#input\_event\_pattern\_rule) | The event pattern described a JSON object. It is only necessary if rule\_name is provided. | `string` | `""` | no |
| <a name="input_rule_name"></a> [rule\_name](#input\_rule\_name) | If passed, create a cloud watch event rule. If it is passed, it is also necessary to pass event\_pattern\_rule. | `string` | `""` | no |
| <a name="input_source_event_account_id"></a> [source\_event\_account\_id](#input\_source\_event\_account\_id) | Source event account id | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_event_bus_arn"></a> [event\_bus\_arn](#output\_event\_bus\_arn) | ARN of event bus |
| <a name="output_event_rule_arn"></a> [event\_rule\_arn](#output\_event\_rule\_arn) | Arn of Cloud Watch event |
<!-- END_TF_DOCS -->
<!-- BEGIN_TF_EXAMPLES -->
## Example
```hcl
module "." {
  source             = "."
  rule_name          = string | ""
  descripiton_rule   = string | ""
  event_pattern_rule = string | ""
  arn_of_target      = string | null
}
```
<!-- END_TF_EXAMPLES -->
