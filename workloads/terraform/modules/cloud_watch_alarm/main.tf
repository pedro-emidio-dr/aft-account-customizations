resource "aws_cloudwatch_metric_alarm" "main_alarm" {
  alarm_name          = var.alarm_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  alarm_description   = var.alarm_description
  dimensions          = var.dimensions
  alarm_actions       = var.alarm_actions
}

resource "aws_cloudwatch_log_group" "main_log_group" {
  count = var.log_group_name != null ? 1 : 0
  name  = var.log_group_name
}

resource "aws_cloudwatch_log_metric_filter" "main_log_metric_filter" {
  count = var.log_group_name != null ? 1 : 0

  name                  = var.log_group_name
  pattern               = var.pattern
  
  metric_transformation{
    name      = var.metric_transformation["name"]
    namespace = var.metric_transformation["namespace"]
    value     = var.metric_transformation["value"]
  }
    
  log_group_name        = aws_cloudwatch_log_group.main_log_group[0].name
}