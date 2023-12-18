variable "rule_name" {
  type        = string
  description = "If passed, create a cloud watch event rule. If it is passed, it is also necessary to pass event_pattern_rule."
}
variable "descripiton_rule" {
  type        = string
  default     = ""
  description = "Description of rule. It is only necessary if rule_name is provided."
}
variable "event_pattern_rule" {
  type        = string
  description = "The event pattern described a JSON object. It is only necessary if rule_name is provided."
}
variable target_arn {
  type        = string
  description = "Arn of target (Examples: SNS Topic Arn or Lambda Arn)."
}
variable "target_id" {
  type        = string
  description = "Target identifier"
}