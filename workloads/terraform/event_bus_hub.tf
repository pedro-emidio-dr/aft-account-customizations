# module "hub"{
#     source = "./modules/event_bus_hub"

#     pOrganizationId = "o-5pdcv5dwqk"
# }
resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-${data.aws_caller_identity.current.account_id}"
}