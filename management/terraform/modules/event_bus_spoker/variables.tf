variable "pCentralCriticalActionsAlertOrganizationEventBus" {
  description = "ARN of Critical Actions Alert Event Bus pCentralCriticalActionsAlertOrganizationEventBus"
  type        = string
}

variable target_arn {
  type        = string
  default     = ""
  description = "Target ARN (Event Bus)"
}