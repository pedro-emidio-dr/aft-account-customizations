<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.default_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.default_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.event_bus_invoke_remote_event_bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.event_bus_invoke_remote_event_bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.event_bus_invoke_remote_event_bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.event_bus_invoke_remote_event_bus_custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [random_integer.random_number](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_descripiton_rule"></a> [descripiton\_rule](#input\_descripiton\_rule) | Description of rule. It is only necessary if rule\_name is provided. | `string` | `""` | no |
| <a name="input_event_bus_name"></a> [event\_bus\_name](#input\_event\_bus\_name) | Event bus name. It is only necessary if rule\_name is provided. | `string` | `null` | no |
| <a name="input_event_pattern_rule"></a> [event\_pattern\_rule](#input\_event\_pattern\_rule) | The event pattern described a JSON object. It is only necessary if rule\_name is provided. | `string` | n/a | yes |
| <a name="input_rule_name"></a> [rule\_name](#input\_rule\_name) | If passed, create a cloud watch event rule. If it is passed, it is also necessary to pass event\_pattern\_rule. | `string` | n/a | yes |
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
  event_bus_name     = string | null
  target_id          = string | __required__
}
```
<!-- END_TF_EXAMPLES -->
