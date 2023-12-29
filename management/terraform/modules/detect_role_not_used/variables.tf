# Parameters
variable "email_subject" {
  type        = string
  default     = "CloudSec Alert | Unused privileges detected"
  description = "The subject of the email that will alert you"
}

variable "days_to_detect" {
  type        = string
  default             = 90
  description         = "Number of days that a privilege is considered 'unused'"
}

variable "logs_retention_in_days" {
    type        = number
  default     = 90
  description = "Specifies the number of days to retain log events in the specified log group."
}

variable "master_account" {
    type        = string
  description = "AccountID of the master account"
}

variable "email_address" {
    type        = string
  default     = "example@example.com"
  description = "Email account that will receive the alerts"
}

variable "role_name_for_lambda" {
    type        = string
  default     = "sec-svc-listprivilegedetails"
  description = "Role name for the Lambda function"
}

variable "policy_name_created" {
    type        = string
  default     = "sec-getiamdetails"
  description = "Policy name used by the role of the Lambda function"
}

variable "lambda_function_name" {
    type        = string
  default     = "sec-detectunusedprivilege"
  description = "Lambda function name"
}

variable "event_bridge_rule_name" {
    type        = string
  default     = "sec-detectunusedprivilege"
  description = "EventBridge rule name"
}

variable "sns_topic_name" {
    type        = string
  default     = "sec-reports"
  description = "SNS topic name"
}

variable "role_name_for_xacc" {
    type        = string
  default     = "sec-xacc-listprivilegedetails"
  description = "Name of the role that will be deployed in all accounts for cross-account access"
}