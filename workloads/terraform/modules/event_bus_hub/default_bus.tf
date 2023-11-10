resource "aws_cloudwatch_event_target" "DefaultBusEC2CriticalAPICallAlert" {
  rule      = aws_cloudwatch_event_rule.DefaultBusEC2CriticalAPICallEvent.name
  target_id = "DefaultBusEC2CriticalAPICallAlert"
  arn       = aws_sns_topic.CentralCriticalActionsAlertNotificationSNS.arn

  input_transformer {
    input_template = <<-EOT
      "EC2 critical API Call Alert!"
      "Principal <principal> has executed action API - <eventname> - in AWS account <accountId> at <eventtime> (UTC)."
      "Event Details:"
      "Event ID: <eventid>"
      "Permission Set Used: <permissionset>"
      "Source IP: <sourceip>"
      "Please proceed to investigate in CloudTrail using Event ID to see all the event details"
    EOT

    input_paths = {
      principal     = "$.detail.userIdentity.arn"
      accountId     = "$.detail.userIdentity.accountId"
      eventid       = "$.detail.eventID"
      permissionset = "$.detail.userIdentity.sessionContext.sessionIssuer.userName"
      sourceip      = "$.detail.sourceIPAddress"
      eventtime     = "$.detail.eventTime"
      eventname     = "$.detail.eventName"
    }
  }
}


resource "aws_cloudwatch_event_rule" "DefaultBusEC2CriticalAPICallEvent" {
  name           = "DefaultBusEC2CriticalAPICallEvent"
  description    = "Send notification if some activity matches the event pattern"
  event_bus_name = "default"
  event_pattern = jsonencode({
    source        = ["aws.ec2"],
    "detail-type" = ["AWS API Call via CloudTrail"],
    detail = {
      eventSource = ["ec2.amazonaws.com"],
      eventName = [
        "CreateNetworkAclEntry",
        "AuthorizeSecurityGroupIngress",
        "CreateSecurityGroup",
        "CreateInternetGateway",
        "AttachInternetGateway",
        "ReplaceNetworkAclAssociation",
        "CreateVpcPeeringConnection"
      ],
    },
  })
}