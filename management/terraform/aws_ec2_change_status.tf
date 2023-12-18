module "ec2_lambda_filter" {
  source = "./modules/lambda"

  ec2_tag_to_filter = "eks:cluster:name"
  event_bus_arn     = "arn:aws:events:us-east-1:065058211633:event-bus/EventBusCriticalAlerts"
}

module "spoker-us-east-1" {
  source = "./modules/spoke_rule_with_lambda"

  rule_name          = "getEC2ChangeStatus"
  descripiton_rule   = ""
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.ec2"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["ec2.amazonaws.com"],
    "eventName": ["StopInstances","RunInstances","StartInstances","TerminateInstances"]
  }
}
PATTERN

  target_arn = module.ec2_lambda_filter.lambda_arn
  target_id  = "getEC2ChangeStatus"
}
