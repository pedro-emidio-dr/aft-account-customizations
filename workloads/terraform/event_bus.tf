module "hub" {
  source = "./modules/hub_account"

  event_bus_name = "EventBusCriticalAlerts"
  sns_topic_name = "CriticalAlertsTopic"
  e_mail         = "pedro.emidio@datarain.com.br"
}

module "hub_rule" {
  source = "./modules/hub_rules"

  rule_name          = "IAMActionsRule"
  rule_description    = "Get events by custom event bus of IAM"
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.iam"]
}
  PATTERN
  event_bus_arn      = module.hub.event_bus_arn
  target_arn         = module.hub.sns_topic_arn
}


module "hub_rule_lambda"{
  source = "./modules/hub_rules"

  rule_name          = "ec2-tag-filter"
  rule_description    = "When the event is aws.ec2 invokes lambda to filter event based on tag"
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.ec2"]
}
  PATTERN
  event_bus_arn      = module.hub.event_bus_arn
  target_arn         = module.hub.sns_topic_arn
}