resource "aws_iam_role" "cross_account_role" {
  count = length(var.source_event_account_id)
  name = "CrossAccountEventBusRole_${var.source_event_account_id[count.index]}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.source_event_account_id[count.index]}"
        }
      }
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "souce_account_access_target_account" {
  count = length(var.source_event_account_id)
  name = "${var.source_event_account_id[count.index]}_access_target_account"
  role = aws_iam_role.cross_account_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "events:TagResource",
        ]
        Effect   = "Allow"
        Resource = aws_cloudwatch_event_bus.main_event_bus.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  count = length(var.source_event_account_id)
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
  role       = aws_iam_role.cross_account_role[count.index].name
}


resource "aws_cloudwatch_event_bus" "main_event_bus" {
  name = var.event_bus_name
}
