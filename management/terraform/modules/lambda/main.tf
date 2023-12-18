resource "aws_iam_role" "main_role" {
  name = "example-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "main_policy" {
  name        = "lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = ["arn:aws:logs:*:*:*"]
    },
    {
      Effect = "Allow"
      Action = ["ssm:GetParameter"]
      Resource = [aws_ssm_parameter.event_bus_arn.arn]
    },
    {
      Effect = "Allow"
      Action = ["ssm:GetParameter"]
      Resource = [aws_ssm_parameter.tag_ec2_cluster.arn]
    },
    {
      Effect = "Allow"
      Action = ["ec2:DescribeInstances"]
      Resource = ["*"]
    }
    ]
  }
  )
}

resource "aws_iam_role_policy_attachment" "main_attachment" {
  policy_arn = aws_iam_policy.main_policy.arn
  role = aws_iam_role.main_role.name
}

data "archive_file" "source" {
  type         = "zip"
  source_file  = "${path.module}/lambda_function.py"
  output_path  = "${path.module}/lambda_function.zip"
}
resource "aws_lambda_function" "main_lambda" {
  function_name    = "filter-ec2-tags"
  timeout          = 5
  filename         = "${path.module}/lambda_function.zip"
  source_code_hash = data.archive_file.source.output_base64sha256
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.main_role.arn
  runtime          = "python3.12"
}
data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "trigger_permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main_lambda.arn
  principal     = "events.amazonaws.com"

  #corrigir
  source_arn = "arn:aws:events:us-east-1:${data.aws_caller_identity.current.account_id}:rule/*"
}


resource "aws_ssm_parameter" "event_bus_arn" {
  name  = "event_bus_arn"
  type  = "String"
  value = var.event_bus_arn
}

resource "aws_ssm_parameter" "tag_ec2_cluster" {
  name  = "tag_ec2_cluster"
  type  = "String"
  value = var.ec2_tag_to_filter
}