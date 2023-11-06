# AWS Access Analyzer one per account
resource "aws_accessanalyzer_analyzer" "main_analyzer" {
  analyzer_name = "main_analyzer"
  type          = "ACCOUNT"
}