# -------------- AWS KMS Key --------------
resource "aws_kms_key" "main_key" {
  description           = "AWS KMS Key for AWS SNS Topic"
  enable_key_rotation   = true
}
resource "aws_kms_alias" "main_key_alias" {
  name          = "alias/kms-key-for-sns-topic"
  target_key_id = aws_kms_key.main_key.key_id
}
resource "aws_kms_key_policy" "main_policy_key" {
  key_id = aws_kms_key.main_key.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "key-consolepolicy-3",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },  
      {
          "Sid": "Allow EventBridge to use the key",
          "Effect": "Allow",
          "Principal": {
              "Service": "events.amazonaws.com"
          },
          "Action": [
              "kms:Decrypt",
              "kms:GenerateDataKey"
          ],
          "Resource": "*"
      },  
      {
        "Sid": "Allow SNS Topic to use the key",
        "Effect": "Allow",
        "Principal": {
          "Service": "sns.amazonaws.com"
        },
        "Action": [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "aws:SourceArn": "${aws_sns_topic.default_sns_topic.arn}"
          }
        }
      }
    ]
}
POLICY
}

# -------------- AWS SNS and Subscribe --------------
resource "aws_sns_topic" "default_sns_topic" {
  name              = var.sns_topic_name
  kms_master_key_id = aws_kms_key.main_key.key_id
}

resource "aws_sns_topic_subscription" "sns_subscription" {
  count     = var.e_mail != "" ? 1 : 0
  topic_arn = aws_sns_topic.default_sns_topic.arn
  protocol  = "email"
  endpoint  = var.e_mail
}
resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.default_sns_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.default_sns_topic.arn]
  }
}

# -------------- AWS Event Bridge Event Bus and permissions --------------
resource "aws_cloudwatch_event_bus" "main_event_bus" {
  name = var.event_bus_name
}

resource "aws_cloudwatch_event_permission" "OrganizationAccess" {
  statement_id   = "Cross_account_permission"
  principal      = "*"
  event_bus_name = aws_cloudwatch_event_bus.main_event_bus.name
  condition {
    key   = "aws:PrincipalOrgID"
    type  = "StringEquals"
    value = data.aws_organizations_organization.current.id
  }
}