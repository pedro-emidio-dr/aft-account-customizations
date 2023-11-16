output "arn" {
  value       = aws_sns_topic.default_sns_topic.arn
  description = "Arn of sns topic"
}
