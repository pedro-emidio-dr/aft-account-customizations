<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="provider_archive"></a> [archive](#provider_archive) | n/a     |
| <a name="provider_aws"></a> [aws](#provider_aws)             | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                     | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_policy.main_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                     | resource    |
| [aws_iam_role.main_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                           | resource    |
| [aws_iam_role_policy_attachment.main_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_lambda_function.main_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)                           | resource    |
| [aws_lambda_permission.trigger_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)                | resource    |
| [aws_ssm_parameter.event_bus_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter)                             | resource    |
| [aws_ssm_parameter.tag_ec2_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter)                           | resource    |
| [archive_file.source](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file)                                           | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                            | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                              | data source |

## Inputs

| Name                                                                                 | Description                                                    | Type     | Default | Required |
| ------------------------------------------------------------------------------------ | -------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_ec2_tag_to_filter"></a> [ec2_tag_to_filter](#input_ec2_tag_to_filter) | EC2 tag that identifies that the instance belongs to a cluster | `string` | n/a     |   yes    |
| <a name="input_event_bus_arn"></a> [event_bus_arn](#input_event_bus_arn)             | Event bus Arn                                                  | `string` | n/a     |   yes    |

## Outputs

| Name                                                              | Description         |
| ----------------------------------------------------------------- | ------------------- |
| <a name="output_lambda_arn"></a> [lambda_arn](#output_lambda_arn) | Lambda function Arn |

<!-- END_TF_DOCS -->

<!-- BEGIN_TF_EXAMPLES -->

## Example

```hcl
module "." {
  source             = "."
  ec2_tag_to_filter  = string | __required__
  event_bus_arn      = string | __required__
}
```

<!-- END_TF_EXAMPLES -->
