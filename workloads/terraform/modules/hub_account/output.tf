output event_bus_arn {
  value       = aws_cloudwatch_event_bus.main_event_bus.arn
  description = "ARN of event bus"
}
output "sns_topic_arn" {
  value       = aws_sns_topic.default_sns_topic.arn
  description = "Arn of sns topic"
}
output "kms_key_arn"{
  value       = aws_kms_key.main_key.arn
  description = "KMS Key Arn"
}