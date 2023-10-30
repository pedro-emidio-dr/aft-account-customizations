data "aws_caller_identity" "current" {}

locals {
  analyzer_name = "main_analyzer"
}

resource "aws_accessanalyzer_analyzer_org" "main_analyzer" {
  # depends_on = [aws_organizations_organization.example]

  analyzer_name = local.analyzer_name
  type          = "controller"
}
resource "aws_accessanalyzer_analyzer_account" "main_analyzer" {
  # depends_on = [aws_organizations_organization.example]

  analyzer_name = local.analyzer_name
  type          = data.aws_caller_identity.current.account_id
}