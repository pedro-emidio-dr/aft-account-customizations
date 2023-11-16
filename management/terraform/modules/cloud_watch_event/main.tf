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
}