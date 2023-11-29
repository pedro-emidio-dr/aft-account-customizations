module "root_apis_activity" {
  source = "./modules/spoke_account"

  rule_name        = "root_apis_activity"
  descripiton_rule = "Root account activitys"
  event_pattern_rule = <<PATTERN
{
  "detail-type": [
    "AWS Console Sign In via CloudTrail", 
    "AWS API Call via CloudTrail"
  ],
  "detail":{
    "userIdentity":{
      "type": [
        "Root"
      ]
    }
  }
}
PATTERN
  target_id      = "consoleSignInViaCloudTrail"
  event_bus_name = "arn:aws:events:us-east-1:065058211633:event-bus/criticalEventsTarget" #target
}