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
| <a name="input_descripiton_rule"></a> [descripiton\_rule](#input\_descripiton\_rule) | Description of rule. It is only necessary if rule\_name is provided. | `string` | `""` | no |
| <a name="input_event_pattern_rule"></a> [event\_pattern\_rule](#input\_event\_pattern\_rule) | The event pattern described a JSON object. It is only necessary if rule\_name is provided. | `string` | n/a | yes |
| <a name="input_rule_name"></a> [rule\_name](#input\_rule\_name) | If passed, create a cloud watch event rule. If it is passed, it is also necessary to pass event\_pattern\_rule. | `string` | n/a | yes |
| <a name="input_target_arn"></a> [target\_arn](#input\_target\_arn) | Arn of target (Examples: SNS Topic Arn or Lambda Arn). | `string` | n/a | yes |
| <a name="input_target_id"></a> [target\_id](#input\_target\_id) | Target identifier | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Arn of Cloud Watch event |
<!-- END_TF_DOCS -->

<!-- BEGIN_TF_EXAMPLES -->
## Example
```hcl
module "." {
  source             = "."
  rule_name          = string | __required__
  descripiton_rule   = string | ""
  event_pattern_rule = string | __required__
  target_id          = string | __required__
}
```
<!-- END_TF_EXAMPLES -->
