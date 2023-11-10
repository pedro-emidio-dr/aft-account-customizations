#------------------------------ Event Bus ------------------------------#
resource "aws_cloudwatch_event_bus" "CentralCriticalActionsAlertOrganizationEventBus" {
  name = "CentralCriticalActionsAlertOrganizationEventBus"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "event_bus_invoke_remote_event_bus" {
  name               = "event-bus-invoke-remote-event-bus"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "event_bus_invoke_remote_event_bus" {
  statement {
    effect    = "Allow"
    actions   = ["events:PutEvents"]
    resources = [aws_cloudwatch_event_bus.CentralCriticalActionsAlertOrganizationEventBus.arn]
  }
}
resource "aws_iam_policy" "event_bus_invoke_remote_event_bus" {
  name   = "event_bus_invoke_remote_event_bus"
  policy = data.aws_iam_policy_document.event_bus_invoke_remote_event_bus.json
}

resource "aws_iam_role_policy_attachment" "event_bus_invoke_remote_event_bus" {
  role       = aws_iam_role.event_bus_invoke_remote_event_bus.name
  policy_arn = aws_iam_policy.event_bus_invoke_remote_event_bus.arn
}

#------------------------------ Cloud Watch rule ------------------------------#
resource "aws_cloudwatch_event_rule" "CentralBusEC2CriticalAPICallEvent" {
  name           = "CentralBusEC2CriticalAPICallEvent"
  description    = "Send notification if some activity matches the event pattern"
  event_bus_name = aws_cloudwatch_event_bus.CentralCriticalActionsAlertOrganizationEventBus.name
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

#------------------------------ Cloud Watch target ------------------------------#
resource "aws_cloudwatch_event_target" "CentralBusEC2CriticalAPICallAlert" {
  target_id = aws_cloudwatch_event_bus.CentralCriticalActionsAlertOrganizationEventBus.name
  rule      = aws_cloudwatch_event_rule.CentralBusEC2CriticalAPICallEvent.name
  arn       = aws_sns_topic.CentralCriticalActionsAlertNotificationSNS.arn
  event_bus_name = aws_cloudwatch_event_bus.CentralCriticalActionsAlertOrganizationEventBus.name
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
