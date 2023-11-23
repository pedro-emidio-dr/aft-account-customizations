resource "aws_sns_topic" "default_sns_topic" {
  name              = var.sns_topic_name
  kms_master_key_id = var.kms_key_id
}

resource "aws_sns_topic_subscription" "sns_subscription" {
  count     = var.e_mail != "" ? 1 : 0
  topic_arn = aws_sns_topic.default_sns_topic.arn
  protocol  = "email"
  endpoint  = var.e_mail
}