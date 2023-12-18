import json
import boto3
import logging

# Setting up the logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_current_region():
    sts_client = boto3.client('sts')
    response = sts_client.get_caller_identity()
    arn = response['Arn']
    region = arn.split(':')[3]
    return region


def get_instance_id_from_event(event):
    try:
        instances = [
            item['instanceId']
            for item in (
                event.get('detail', {})
                .get('requestParameters', {})
                .get('instancesSet', {})
                .get('items', [])
            )
        ]
        return instances[0] if instances else None
    except (KeyError, IndexError) as e:
        logger.error(f"Error retrieving instance ID from the event: {e}")
        return None

def get_ec2_tags(instance_id):
    try:
        ec2_client = boto3.client('ec2')
        response = ec2_client.describe_instances(InstanceIds=[instance_id])
        reservations = response.get('Reservations', [])

        if not reservations:
            logger.warning(f"Instance with ID {instance_id} not found.")
            return None
        instance = reservations[0]['Instances'][0]

        tags = instance.get('Tags', [])
        return tags
    except Exception as e:
        logger.error(f"Error retrieving instance tags: {e}")
        return None

def check_tag_exists(tags, target_tag):
    if tags is None:
        return False
    tag_exists = any(tag['Key'] == target_tag for tag in tags)
    return tag_exists

def send_event(event_bus_arn, event_details):
    try:
        client = boto3.client('events')

        event_details_json = json.dumps(event_details)

        response = client.put_events(
            Entries=[
                {
                    'Source': 'custom.application',
                    'DetailType': 'custom.event',
                    'Detail': event_details_json,
                    'EventBusName': event_bus_arn
                }
            ]
        )
        if response['FailedEntryCount'] == 0:
            logger.info("Event sent successfully!")
        else:
            logger.error(f"Failed to send event. Details: {response['Entries'][0]['ErrorCode']} - {response['Entries'][0]['ErrorMessage']}")
    except Exception as e:
        logger.error(f"Error sending event: {e}")

def lambda_handler(event, context):
    try:
        ssm_client = boto3.client('ssm')

        tag_ec2_cluster_parameter_name = f"/alarm/filter-ec2-tags/{get_current_region()}/tag_ec2_cluster"
        tag_ec2_cluster = ssm_client.get_parameter(Name=tag_ec2_cluster_parameter_name)['Parameter']['Value']

        instance_id = get_instance_id_from_event(event)
        tags = get_ec2_tags(instance_id)
        
        if check_tag_exists(tags, tag_ec2_cluster):
            logger.info(f"The key {tag_ec2_cluster} exists in the event. This event will not be notified.")
        else:
            logger.info(f"The key {tag_ec2_cluster} does not exist in the event. This event will be notified.")
           
            event_bus_arn_parameter_name = f"/alarm/filter-ec2-tags/{get_current_region()}/event_bus_arn"
            event_bus_arn = ssm_client.get_parameter(Name=event_bus_arn_parameter_name)['Parameter']['Value']
            send_event(event_bus_arn, event )
    
            logger.info("Success")
    except Exception as e:
        logger.error(f"Error in lambda_handler processing: {e}")

    return {
        'statusCode': 200,
        'body': json.dumps('Success')
    }
