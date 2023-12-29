# Output the Lambda function ARN
output "lambda_function_arn" {
  value = aws_lambda_function.detect_unused_privilege.arn
}

# Output the SNS Topic ARN
output "sns_topic_arn" {
  value = aws_sns_topic.sns_topic_for_security_alerts.arn
}
