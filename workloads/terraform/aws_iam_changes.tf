module "critical_events"{
    source = "./modules/event_bus"

    event_bus_name = "criticalEventsTeste"
}

module "critical_events_target"{
    source = "./modules/event_bus"

    event_bus_name = "criticalEventsTesteTarget"
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
  target_id      = "iamChangeAlert"
  target_arn     = module.critical_events.arn        #source
  event_bus_name = module.critical_events_target.arn #target
}