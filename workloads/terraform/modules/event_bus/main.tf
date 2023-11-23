# resource "aws_cloudwatch_event_bus" "main_event_bus" {
#   name = var.event_bus_name
# }

# resource "aws_cloudwatch_event_permission" "example" {
#   count          = length(var.source_event_account_id)
#   statement_id   = "Cross_account_permission_${var.source_event_account_id[count.index]}"
#   principal      = var.source_event_account_id[count.index]
#   event_bus_name = aws_cloudwatch_event_bus.main_event_bus.name
# }

