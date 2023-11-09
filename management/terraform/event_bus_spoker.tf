module "spoker" {
    source = "./modules/"

    pCentralCriticalActionsAlertOrganizationEventBus = "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*"
    target_arn = "arn:aws:events:us-east-1:604828680752:event-bus/CentralCriticalActionsAlertOrganizationEventBus"
}
