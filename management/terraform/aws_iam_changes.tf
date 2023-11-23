module "iam_changes_event" {
  source = "./modules/spoke_account"

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
  target_id      = "iamChangeAlert"
  event_bus_name = "arn:aws:events:us-east-1:065058211633:event-bus/criticalEventsTarget" #target
}