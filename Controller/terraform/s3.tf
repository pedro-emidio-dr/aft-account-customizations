data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "backend_bucket" {
  bucket = "aft-backend-${data.aws_caller_identity.current.account_id}"
  acl    = "private"
}
