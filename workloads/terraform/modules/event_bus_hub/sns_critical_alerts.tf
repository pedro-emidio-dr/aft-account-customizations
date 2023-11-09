#------------------------------ SNS ------------------------------#
resource "aws_sns_topic" "CentralCriticalActionsAlertNotificationSNS" {
  name         = "CriticalActionsAlertNotification"
  kms_master_key_id = "alias/aws/sns"
  display_name = "User Login Alert"
}

resource "aws_sns_topic_policy" "EventTopicPolicy" {
  arn  = aws_sns_topic.CentralCriticalActionsAlertNotificationSNS.arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "events.amazonaws.com" },
        Action    = "sns:Publish",
        Resource  = "*",
      },
    ]
  })
}