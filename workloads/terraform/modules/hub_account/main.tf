resource "aws_cloudwatch_event_bus" "main_event_bus" {
  name = var.event_bus_name
}

resource "aws_cloudwatch_event_permission" "example" {
  count          = length(var.source_event_account_id)
  statement_id   = "Cross_account_permission_${var.source_event_account_id[count.index]}"
  principal      = var.source_event_account_id[count.index]
  event_bus_name = aws_cloudwatch_event_bus.main_event_bus.name
}

resource "aws_cloudwatch_event_rule" "default_event_rule" {
  name           = var.rule_name
  description    = var.descripiton_rule
  event_bus_name = aws_cloudwatch_event_bus.main_event_bus.arn
  event_pattern  = <<PATTERN
{
  "source": ["aws.events"]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "default_event_target" {
  target_id = "eventBusEvents"
  arn       = var.arn_of_target
  rule      = aws_cloudwatch_event_rule.default_event_rule.name
}