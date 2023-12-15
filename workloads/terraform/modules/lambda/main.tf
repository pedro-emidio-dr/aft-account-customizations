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
    },{
      Effect = "Allow"
      Action = ["sns:Publish"]
      Resource = [var.topic_arn]
    },{
      Effect = "Allow"
      Action = [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey"
      ]
      Resource = [var.kms_key_arn]
    },
    {
      Effect = "Allow"
      Action = ["ssm:GetParameter"]
      Resource = [aws_ssm_parameter.topic_arn.arn]
    },
    {
      Effect = "Allow"
      Action = ["ssm:GetParameter"]
      Resource = [aws_ssm_parameter.tag_ec2_cluster.arn]
    }
    ]
  }
  )
}

resource "aws_iam_role_policy_attachment" "main_attachment" {
  policy_arn = aws_iam_policy.main_policy.arn
  role = aws_iam_role.main_role.name
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "./lambda_function.js"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "main_lambda" {
  function_name    = "filter-ec2-tags"
  filename         = "lambda_function.zip"
  source_code_hash = data.archive_file.lambda_code.output_base64sha256
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.main_role.arn
  runtime          = "Python 3.11"
}

resource "aws_ssm_parameter" "topic_arn" {
  name  = "topic_arn"
  type  = "String"
  value = var.topic_arn
}

resource "aws_ssm_parameter" "tag_ec2_cluster" {
  name  = "tag_ec2_cluster"
  type  = "String"
  value = var.ec2_tag_to_filter
}