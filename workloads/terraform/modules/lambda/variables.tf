variable topic_arn {
  type        = string
  description = "SNS Topic Arn"
}
variable kms_key_arn{
  type        = string
  description = "KMS Key Arn"
}
variable ec2_tag_to_filter {
  type        = string
  description = "EC2 tag that identifies that the instance belongs to a cluster"
}
