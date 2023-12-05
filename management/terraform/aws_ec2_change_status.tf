provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
provider "aws" {
  alias  = "saopaulo"
  region = "sa-east-1"
}

module "hub" {
  source = "./modules/spoke_account"
  
  providers = {
    aws = aws.virginia
  }

rule_name = "getIAMRoleAcctions"
    descripiton_rule = ""
event_pattern_rule = <<PATTERN
{
  "source": ["aws.iam"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["iam.amazonaws.com"],
    "eventName": ["CreateRole", "DeleteRole"]
  }
}
PATTERN

event_bus_name = "arn:aws:events:us-east-1:065058211633:event-bus/EventBusCriticalAlerts"
target_id = "getIAMActions"
}

module "spoker-sp" {
  source = "./modules/spoke_account"
  
  providers = {
    aws = aws.saopaulo
  }
  
rule_name = "getIAMRoleAcctions"
    descripiton_rule = ""
event_pattern_rule = <<PATTERN
{
  "source": ["aws.iam"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["iam.amazonaws.com"],
    "eventName": ["CreateRole", "DeleteRole"]
  }
}
PATTERN

event_bus_name = "arn:aws:events:us-east-1:065058211633:event-bus/EventBusCriticalAlerts"
target_id = "getIAMActions"
}