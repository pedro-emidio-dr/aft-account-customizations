resource "aws_cloudwatch_event_rule" "default_event_rule" {
  name           = var.rule_name
  description    = var.descripiton_rule
  event_pattern  = var.event_pattern_rule
}

resource "aws_cloudwatch_event_target" "default_event_target" {
  target_id = var.target_id
  arn       = var.target_arn
  rule      = aws_cloudwatch_event_rule.default_event_rule.name
  # role_arn  = aws_iam_role.event_bus_invoke_remote_event_bus.arn
}