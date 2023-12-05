# ---------------------- AWS Event Bridge ----------------------
variable event_bus_name {
  type        = string
  description = "Event Bus name."
}
# ---------------------- SNS ----------------------
variable "sns_topic_name" {
  type        = string
  description = "SNS Topic name"
}
variable "e_mail" {
  type        = string
  default     = ""
  description = "E-mail subscribe on topic"
}


