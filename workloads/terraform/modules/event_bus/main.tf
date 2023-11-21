resource "aws_iam_role" "cross_account_role" {
  name = "CrossAccountEventBusRole"
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
          "sts:ExternalId": "${var.source_event_account_id}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
  role       = aws_iam_role.cross_account_role.name
}


resource "aws_cloudwatch_event_bus" "main_event_bus" {
  name = var.event_bus_name
}
