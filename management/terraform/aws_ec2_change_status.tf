module "spoker-us-east-1" {
  source = "./modules/spoke_account"

  rule_name = "getEC2ChangeStatus"
  descripiton_rule = ""
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.ec2"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["ec2.amazonaws.com"],
    "eventName": ["StopInstances","RunInstances","StartInstances","TerminateInstances"]
    "requestParameters.tagSpecificationSet.items.tags.value": [{ "anything-but": "True"}],
    "requestParameters.tagSpecificationSet.items.tags.key": ["IsEksCluster"],
  }
}
PATTERN

event_bus_name = "arn:aws:events:us-east-1:065058211633:event-bus/EventBusCriticalAlerts"
target_id = "getEC2ChangeStatus"
}