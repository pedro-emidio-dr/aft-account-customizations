variable "alarm_name" {
  type        = string
  description = "Alarm name"
}
variable "alarm_description" {
  type        = string
  default     = ""
  description = "Description"
}
variable "comparison_operator" {
  type        = string
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold"
}
variable "evaluation_periods" {
  type        = string
  description = "The number of periods over which data is compared to the specified threshold."
}
variable "metric_name" {
  type        = string
  description = "Supported values: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html"
}
variable "namespace" {
  type        = string
  description = "Supported values: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html"
}
variable "period" {
  type        = string
  default     = "300"
  description = "The period in seconds over which the specified statistic is applied. Valid values are 10, 30, or any multiple of 60."
}
variable "statistic" {
  type        = string
  default     = "Minimum"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
}
variable "threshold" {
  type        = string
  default     = "1"
  description = "The value against which the specified statistic is compared. This parameter is required for alarms based on static thresholds, but should not be used for alarms based on anomaly detection models."
}
variable "dimensions" {
  type        = map(string)
  default     = {}
  description = "The dimensions for the alarm's associated metric. For the list of available dimensions see the AWS documentation https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html"
}
variable "alarm_actions" {
  type        = list(any)
  default     = []
  description = "description"
}
variable "log_group_name" {
  type        = string
  default     = null
  description = "Log group name. If passed, a log group and metric filter will be created"
}
variable "pattern" {
  type        = string
  default     = null
  description = "A valid CloudWatch Logs filter pattern for extracting metric data out of ingested log events."
}
variable "metric_transformation" {
  type        = map(string)
  default     = null
  description = "A block defining collection of information needed to define how metric data gets emitted. See more https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter#metric_transformation"
}

