resource "random_integer" "random_number" {
  min = 1
  max = 5000
}

resource "aws_iam_role" "event_bus_invoke_remote_event_bus" {
  name               = "InvokeRemoteEventBus_${var.rule_name}_${random_integer.random_number.result}"
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
  name   = "invoke_remote_event_bus_${var.rule_name}_${random_integer.random_number.result}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "events:PutEvents",
      Resource  = var.target_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "event_bus_invoke_remote_event_bus_custom" {
  role       = aws_iam_role.event_bus_invoke_remote_event_bus.name
  policy_arn = aws_iam_policy.event_bus_invoke_remote_event_bus.arn
}

resource "aws_iam_role_policy_attachment" "event_bus_invoke_remote_event_bus" {
  role       = aws_iam_role.event_bus_invoke_remote_event_bus.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_cloudwatch_event_rule" "default_event_rule" {
  name           = var.rule_name
  description    = var.descripiton_rule
  event_pattern  = var.event_pattern_rule
}

resource "aws_cloudwatch_event_target" "default_event_target" {
  target_id = var.target_id
  arn       = var.target_arn
  rule      = aws_cloudwatch_event_rule.default_event_rule.name
  role_arn  = aws_iam_role.event_bus_invoke_remote_event_bus.arn
}