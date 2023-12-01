module "critical_alerts_sns_topic" {
  source = "./modules/sns_topics"

  sns_topic_name = "critical_alerts_sns_topic"
  e_mail         = "pedro.emidio@datarain.com.br"
}

module "capture_event_bus_events" {
  source = "./modules/hub_account"

  event_bus_name          = "criticalEventsTarget"

  rule_name          = "capture_event_bus_events"
  descripiton_rule   = "Capture event bus events and send to sns topic"
  
  arn_of_target = module.critical_alerts_sns_topic.arn
}