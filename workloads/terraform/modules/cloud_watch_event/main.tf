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
    resources = [var.target_arn]
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

resource "aws_cloudwatch_event_rule" "default_event_rule" {
  name           = var.rule_name
  event_bus_name = var.event_bus_name
  description    = var.descripiton_rule

  event_pattern = var.event_pattern_rule
}

resource "aws_cloudwatch_event_target" "default_event_target" {
  rule      = aws_cloudwatch_event_rule.default_event_rule.name
  target_id = var.target_id
  arn       = var.target_arn
  role_arn  = aws_iam_role.event_bus_invoke_remote_event_bus.arn
}