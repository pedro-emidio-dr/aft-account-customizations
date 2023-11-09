data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_cloudwatch_event_bus" "CentralCriticalActionsAlertOrganizationEventBus" {
  name = "default"
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

data "aws_iam_policy_document" "event_bus_invoke_remote_event_bus" {
  statement {
    effect    = "Allow"
    actions   = ["events:PutEvents"]
    resources = [var.pCentralCriticalActionsAlertOrganizationEventBus]
  }
}