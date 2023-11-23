output "event_rule_arn" {
  value       = aws_cloudwatch_event_rule.default_event_rule.arn
  description = "Arn of Cloud Watch event"
}

output event_bus_arn {
  value       = aws_cloudwatch_event_bus.main_event_bus.arn
  description = "ARN of event bus"
}
