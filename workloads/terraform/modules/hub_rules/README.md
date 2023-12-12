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
| [aws_cloudwatch_event_rule.default_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.default_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_sns_topic_arn"></a> [aws\_sns\_topic\_arn](#input\_aws\_sns\_topic\_arn) | Arn of target AWS SNS Topic. | `string` | n/a | yes |
| <a name="input_event_bus_arn"></a> [event\_bus\_arn](#input\_event\_bus\_arn) | AWS Event bus arn. | `string` | n/a | yes |
| <a name="input_event_pattern_rule"></a> [event\_pattern\_rule](#input\_event\_pattern\_rule) | The event pattern described a JSON object. | `string` | n/a | yes |
| <a name="input_rule_description"></a> [rule\_description](#input\_rule\_description) | Description of rule. | `string` | `""` | no |
| <a name="input_rule_name"></a> [rule\_name](#input\_rule\_name) | Create a cloud watch event rule. It is also necessary to pass event\_pattern\_rule. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_event_rule_arn"></a> [event\_rule\_arn](#output\_event\_rule\_arn) | Arn of Cloud Watch event |
<!-- END_TF_DOCS -->
<!-- BEGIN_TF_EXAMPLES -->
## Example
```hcl
module "." {
  source             = "."
  rule_name          = string | __required__
  rule_description   = string | ""
  event_pattern_rule = string | __required__
  event_bus_arn      = string | __required__
}
```
<!-- END_TF_EXAMPLES -->
