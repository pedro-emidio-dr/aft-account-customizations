module "console_sign_in_via_cloudtrail" {
  source = "./modules/spoke_account"

  rule_name        = "console_sign_in_via_cloudtrail"
  descripiton_rule = "Alert when console sign in via AWS Cloud Trail"
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.signin"],
  "detail-type": ["AWS Console Sign In via CloudTrail"]
}
PATTERN
  target_id      = "consoleSignInViaCloudTrail"
  event_bus_name = "arn:aws:events:us-east-1:065058211633:event-bus/criticalEventsTarget" #target
}