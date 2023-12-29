# LambdaRole
resource "aws_iam_role" "lambda_role" {
  name = var.role_name_for_lambda

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  inline_policies = {
    get_resources = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Sid    = "GetResources",
          Effect = "Allow",
          Action = [
            "iam:GetAccountAuthorizationDetails",
            "cloudformation:SignalResource"
          ],
          Resource = "*"
        },
        {
          Sid    = "PublicResults",
          Effect = "Allow",
          Action = [
            "sns:Publish"
          ],
          Resource = aws_sns_topic.sns_topic_for_security_alerts.arn
        },
        {
          Sid    = "AssumeRolesInOtherAccounts",
          Effect = "Allow",
          Action = "sts:AssumeRole",
          Resource = join("", ["arn:aws:iam::*:role/", var.role_name_for_xacc])
        }
      ]
    })
  }
}

# detectUnusedPrivilege Lambda Function
resource "aws_lambda_function" "detect_unused_privilege" {
  function_name = var.lambda_function_name
  handler       = "index.lambda_handler"
  runtime       = "python3.7"
  timeout       = 900
  memory_size   = 128

  environment = {
    VARIABLES = jsonencode({
      DAYS_UNUSED_FOR    = var.days_to_detect,
      EMAIL_SUBJECT      = var.email_subject,
      TOPIC_ARN          = aws_sns_topic.sns_topic_for_security_alerts.arn,
      MASTER_ACCOUNT     = var.master_account,
      SECURITY_ACCOUNT   = aws_caller_identity.current.account_id,
      ROLE_NAME          = var.role_name_for_xacc,
    })
  }

  role = aws_iam_role.lambda_role.arn

  source_code_hash = filebase64("lambda_function_code.zip")
}

# Lambda Log Group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.detect_unused_privilege.function_name}"
  retention_in_days = var.logs_retention_in_days
}

# snsTopicForSecurityAlerts
resource "aws_sns_topic" "sns_topic_for_security_alerts" {
  name = var.sns_topic_name
}

# MySubscription
resource "aws_sns_topic_subscription" "my_subscription" {
  endpoint = var.email_address
  protocol = "email"
  topic_arn = aws_sns_topic.sns_topic_for_security_alerts.arn
}

# ScheduledRule
resource "aws_cloudwatch_event_rule" "scheduled_rule" {
  name        = var.event_bridge_rule_name
  description = "ScheduledRule"
  schedule_expression = "rate(7 days)"
  state       = "ENABLED"

  targets = [
    {
      id   = "ScheduledRulev1"
      arn  = aws_lambda_function.detect_unused_privilege.arn
    }
  ]
}

# PermissionForEventsToInvokeLambda
resource "aws_lambda_permission" "permission_for_events_to_invoke_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.detect_unused_privilege.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_rule.arn
}
