variable ec2_tag_to_filter {
  type        = string
  description = "EC2 tag that identifies that the instance belongs to a cluster"
}
variable event_bus_arn {
  type        = string
  description = "Event bus Arn"
}
