locals {
  analyzer_name = "main_analyzer"
}

resource "aws_organizations_organization" "main_aws_services" {
  aws_service_access_principals = ["access-analyzer.amazonaws.com"]
}

resource "aws_accessanalyzer_analyzer" "main_analyzer" {
  analyzer_name = local.analyzer_name
  type          = "ACCOUNT"

  depends_on = [aws_organizations_organization.main_aws_services]
}