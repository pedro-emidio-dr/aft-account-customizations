<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                          | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_event_bus.main_event_bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus)                   | resource    |
| [aws_cloudwatch_event_permission.OrganizationAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_permission) | resource    |
| [aws_kms_alias.main_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias)                                         | resource    |
| [aws_kms_key.main_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)                                                   | resource    |
| [aws_kms_key_policy.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy)                                      | resource    |
| [aws_sns_topic.default_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)                                      | resource    |
| [aws_sns_topic_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy)                                  | resource    |
| [aws_sns_topic_subscription.sns_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription)             | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                 | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                | data source |
| [aws_organizations_organization.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization)           | data source |

## Inputs

| Name                                                                        | Description               | Type     | Default | Required |
| --------------------------------------------------------------------------- | ------------------------- | -------- | ------- | :------: |
| <a name="input_e_mail"></a> [e_mail](#input_e_mail)                         | E-mail subscribe on topic | `string` | `""`    |    no    |
| <a name="input_event_bus_name"></a> [event_bus_name](#input_event_bus_name) | Event Bus name.           | `string` | n/a     |   yes    |
| <a name="input_sns_topic_name"></a> [sns_topic_name](#input_sns_topic_name) | SNS Topic name            | `string` | n/a     |   yes    |

## Outputs

| Name                                                                       | Description      |
| -------------------------------------------------------------------------- | ---------------- |
| <a name="output_event_bus_arn"></a> [event_bus_arn](#output_event_bus_arn) | ARN of event bus |
| <a name="output_kms_key_arn"></a> [kms_key_arn](#output_kms_key_arn)       | KMS Key Arn      |
| <a name="output_sns_topic_arn"></a> [sns_topic_arn](#output_sns_topic_arn) | Arn of sns topic |

<!-- END_TF_DOCS -->

<!-- BEGIN_TF_EXAMPLES -->
## Example
```hcl
module "." {
  source         = "."
  sns_topic_name = string | __required__
  e_mail         = string | ""
}
```
<!-- END_TF_EXAMPLES -->
