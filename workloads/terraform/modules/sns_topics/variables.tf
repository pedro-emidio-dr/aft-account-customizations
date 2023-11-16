variable "sns_topic_name" {
  type        = string
  description = "SNS Topic name"
}
variable "kms_key_id" {
  type        = string
  default     = ""
  description = "KMS Key id. Default is alias/aws/sns"
}
variable "e_mail" {
  type        = string
  default     = ""
  description = "E-mail subscribe on topic"
}


