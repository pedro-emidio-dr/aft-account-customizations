module "spoker-role" {
  source = "./modules/spoke_account"

  rule_name = "getIAMRoleAcctions"
  descripiton_rule = ""
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.iam"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["iam.amazonaws.com"],
    "eventName": ["CreateUser", "AttachUserPolicy"]
  }
}
PATTERN

  event_bus_name = "arn:aws:events:REGION_EVENT_BUS:ACCOUNT_ID_EVENT_BUS:event-bus/EventBusCriticalAlerts"
  target_id = "getIAMActions"
}
module "spoker-user-actions" {
  source = "./modules/spoke_account"

  rule_name = "getIAMUserAcctions"
  descripiton_rule = ""
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.iam"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["iam.amazonaws.com"],
    "eventName": ["CreateUser", "AttachUserPolicy"]
  }
}
PATTERN

  event_bus_name = "arn:aws:events:REGION_EVENT_BUS:ACCOUNT_ID_EVENT_BUS:event-bus/EventBusCriticalAlerts"
  target_id = "getIAMUserActions"
}
module "spoker-ec2-status" {
  source = "./modules/spoke_account"

  rule_name = "ec2StatusChecnges"
  descripiton_rule = ""
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

  event_bus_name = "arn:aws:events:REGION_EVENT_BUS:ACCOUNT_ID_EVENT_BUS:event-bus/EventBusCriticalAlerts"
  target_id = "ec2StatusChecnges"
}
module "spoker-root-user-login" {
  source = "./modules/spoke_account"

  rule_name = "rotUserLogin"
  descripiton_rule = ""
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.signin"],
  "detail-type": ["AWS Console Sign In via CloudTrail"],
  "detail": {
    "userIdentity": {
      "type": [
        "Root"
      ]
    }
  }
}
PATTERN

  event_bus_name = "arn:aws:events:REGION_EVENT_BUS:ACCOUNT_ID_EVENT_BUS:event-bus/EventBusCriticalAlerts"
  target_id = "rotUserLogin"
}
module "spoker-generate-access-key" {
  source = "./modules/spoke_account"

  rule_name = "IAMUserGenerateAccessKey"
  descripiton_rule = ""
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.iam"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["iam.amazonaws.com"],
    "eventName": ["CreateAccessKey", "DeleteAccessKey", "UpdateAccessKey"]
  }
}
PATTERN

  event_bus_name = "arn:aws:events:REGION_EVENT_BUS:ACCOUNT_ID_EVENT_BUS:event-bus/EventBusCriticalAlerts"
  target_id = "IAMUserGenerateAccessKey"
}
module "spoker-SG-acctions" {
  source = "./modules/spoke_account"

  rule_name = "SgAcctions"
  descripiton_rule = ""
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.ec2"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["ec2.amazonaws.com"],
    "eventName": ["CreateSecurityGroup", "DeleteSecurityGroup", "AuthorizeSecurityGroupIngress", "RevokeSecurityGroupIngress"]
  }
}
PATTERN

  event_bus_name = "arn:aws:events:REGION_EVENT_BUS:ACCOUNT_ID_EVENT_BUS:event-bus/EventBusCriticalAlerts"
  target_id = "SgAcctions"
}
module "spoker-s3-acctions" {
  source = "./modules/spoke_account"

  rule_name = "s3Acctions"
  descripiton_rule = ""
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutBucketPolicy", "DeleteBucketPolicy"]
  }
}
PATTERN

  event_bus_name = "arn:aws:events:REGION_EVENT_BUS:ACCOUNT_ID_EVENT_BUS:event-bus/EventBusCriticalAlerts"
  target_id = "s3Acctions"
}