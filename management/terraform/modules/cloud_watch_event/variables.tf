variable "rule_name" {
  type        = string
  default     = ""
  description = "If passed, create a cloud watch event rule. If it is passed, it is also necessary to pass event_pattern_rule."
}
variable "descripiton_rule" {
  type        = string
  default     = ""
  description = "Description of rule. It is only necessary if rule_name is provided."
}
variable "event_pattern_rule" {
  type        = string
  default     = ""
  description = "The event pattern described a JSON object. It is only necessary if rule_name is provided."
}
variable "event_bus_name" {
  type        = string
  default     = null
  description = "Event bus name. It is only necessary if rule_name is provided."
}
variable "target_id" {
  type        = string
  description = "Target identifier"
}

