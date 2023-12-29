variable "rule_name" {
  type        = string
  description = "Create a cloud watch event rule. It is also necessary to pass event_pattern_rule."
}
variable "rule_description" {
  type        = string
  default     = ""
  description = "Description of rule."
}
variable "event_pattern_rule" {
  type        = string
  description = "The event pattern described a JSON object."
}
variable "event_bus_arn"{
  type        = string
  description = "AWS Event bus arn."
}
variable target_arn {
  type        = string
  description = "Arn of target (Examples: SNS Topic Arn or Lambda Arn)."
}
