resource "aws_cloudwatch_event_bus" "main_event_bus" {
  name = var.event_bus_name
}

resource "aws_cloudwatch_event_permission" "example" {
  count          = length(var.source_event_account_id)
  statement_id   = "Cross_account_permission_${var.source_event_account_id[count.index]}"
  principal      = var.source_event_account_id[count.index]
  event_bus_name = aws_cloudwatch_event_bus.main_event_bus.name
}

resource "aws_iam_role" "event_bus_invoke_remote_event_bus" {
  name               = "InvokeRemoteEventBus"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      },
      Action = "sts:AssumeRole",
    }],
  })
}

resource "aws_iam_policy" "event_bus_invoke_remote_event_bus" {
  name   = "invoke_remote_event_bus"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
    {
      Effect    = "Allow",
      Action    = "events:PutEvents",
      Resource  = aws_cloudwatch_event_bus.main_event_bus.arn
    },
      Effect    = "Allow",
      Action    = "sns:Publish",
      Resource  = var.arn_of_target
    ]
  })
}

resource "aws_iam_role_policy_attachment" "event_bus_invoke_remote_event_bus_custom" {
  role       = aws_iam_role.event_bus_invoke_remote_event_bus.name
  policy_arn = aws_iam_policy.event_bus_invoke_remote_event_bus.arn
}

resource "aws_iam_role_policy_attachment" "event_bus_invoke_remote_event_bus" {
  role       = aws_iam_role.event_bus_invoke_remote_event_bus.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}

resource "aws_cloudwatch_event_rule" "default_event_rule" {
  name           = var.rule_name
  description    = var.descripiton_rule
  event_pattern  = var.event_pattern_rule
}

resource "aws_cloudwatch_event_target" "default_event_target" {
  target_id = var.target_id
  arn       = var.arn_of_target
  rule      = aws_cloudwatch_event_rule.default_event_rule.name
  role_arn  = aws_iam_role.event_bus_invoke_remote_event_bus.arn
}