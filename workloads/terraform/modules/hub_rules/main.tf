# -------------- AWS Event Bridge Event Rule --------------
resource "aws_cloudwatch_event_rule" "default_event_rule" {
  name           = var.rule_name
  description    = var.rule_description
  event_bus_name = var.event_bus_arn
  event_pattern  = var.event_pattern_rule
}

resource "aws_cloudwatch_event_target" "default_event_target" {
  target_id      = "eventBusEvents"
  arn            = var.target_arn
  rule           = aws_cloudwatch_event_rule.default_event_rule.name
  event_bus_name = var.event_bus_arn
}