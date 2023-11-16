output "alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.main_alarm.arn
  description = "Arn of Cloud Watch metric alarm"
}
output "log_group_arn" {
  value       = aws_cloudwatch_log_group.main_log_group[0].arn
  description = "Arn of Cloud Watch log group"
}
output "log_metric_filter_arn" {
  value       = aws_cloudwatch_log_metric_filter.main_log_metric_filter[0].id
  description = "Arn of Cloud Watch metric filter"
}
