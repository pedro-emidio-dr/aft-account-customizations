resource "aws_iam_role" "event_bus_invoke_remote_event_bus" {
  name               = "event_bus_invoke_remote_event_bus"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "event_bus_invoke_remote_event_bus" {
  name   = "event_bus_invoke_remote_event_bus"
  policy = data.aws_iam_policy_document.event_bus_invoke_remote_event_bus.json
}

resource "aws_iam_role_policy_attachment" "event_bus_invoke_remote_event_bus" {
  role       = aws_iam_role.event_bus_invoke_remote_event_bus.name
  policy_arn = aws_iam_policy.event_bus_invoke_remote_event_bus.arn
}

resource "aws_cloudwatch_event_rule" "SpokeEC2CriticalAPICallEventToBus" {
  name                = "SpokeEC2CriticalAPICallEventToBus"
  description         = "Routes from Account default bus to CentralCriticalActionsAlertOrganizationEventBus"
  event_bus_name = "default"
  event_pattern = jsonencode({
    source = ["aws.ec2"],
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
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "default_target" {
  target_id = "Target_Critical_alterts"
  arn       = var.target_arn == "" ? "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:event-bus/default" : var.target_arn
  rule      = aws_cloudwatch_event_rule.SpokeEC2CriticalAPICallEventToBus.name
  role_arn  = aws_iam_role.event_bus_invoke_remote_event_bus.arn
}