resource "aws_cloudwatch_event_bus" "main_event_bus" {
  name = var.event_bus_name
}
