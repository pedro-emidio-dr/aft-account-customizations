module "api_call_via_cloudtrail" {
  source = "./modules/spoke_account"

  rule_name        = "api_call_via_cloudtrail"
  descripiton_rule = "Alert when call api via cloudtrail"
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.cloudtrail"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["cloudtrail.amazonaws.com"]
  }
}
PATTERN
  target_id      = "apiCallViaCloudtrail"
  event_bus_name = "arn:aws:events:us-east-1:065058211633:event-bus/criticalEventsTarget" #target
}