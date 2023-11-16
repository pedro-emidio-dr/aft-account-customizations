module "iam_changes_sns_topic" {
  source = "./modules/sns_topics"

  sns_topic_name = "iam_changes_sns_topic"
  kms_key_id     = "alias/aws/sns"
}

module "iam_changes_event" {
  source = "./modules/cloud_watch_event"

  rule_name        = "iam_changes"
  descripiton_rule = "Alert when IAM are changed"

  event_pattern_rule = <<PATTERN
{
  "source": ["aws.iam"],
  "detail-type": ["Alert when IAM are changed"],
  "detail": {
    "eventName": [
      "AddUserToGroup",
      "AttachUserPolicy",
      "DetachUserPolicy",
      "PutUserPolicy",
      "DeleteUserPolicy",
      "CreateRole",
      "DeleteRole"
    ]
  }
}
PATTERN
  target_id     = "iamChangeAlert"
  target_arn    = module.iam_changes_sns_topic.arn
  event_bus_name = module.critical_events.arn
}