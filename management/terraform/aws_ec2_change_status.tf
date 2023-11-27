module "ec2_termination_rule" {
  source = "./modules/spoke_account"

  rule_name        = "ec2_instance_termination_prd"
  descripiton_rule = "Monitor for termination of EC2 instances with 'PRD' tag"
  event_pattern_rule = <<PATTERN
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["terminated", "shutting-down", "stopping", "stopped"]
  }
}

PATTERN
  target_id      = "SendToEventBus"
  event_bus_name = "arn:aws:events:us-east-1:065058211633:event-bus/criticalEventsTarget" 
}