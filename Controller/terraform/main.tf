resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "policy test aft account costumizations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}