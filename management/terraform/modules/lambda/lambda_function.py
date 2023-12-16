import json
import boto3

def get_instance_id_from_event(event):
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

def get_ec2_tags(instance_id):
    ec2_client = boto3.client('ec2')
    response = ec2_client.describe_instances(InstanceIds=[instance_id])
    reservations = response.get('Reservations', [])

    if not reservations:
        print(f"A instância com ID {instance_id} não foi encontrada.")
        return
    instance = reservations[0]['Instances'][0]

    tags = instance.get('Tags', [])
    return tags

def check_tag_exists(tags, target_tag):
    tag_exists = any(tag['Key'] == target_tag for tag in tags)
    return tag_exists
    
def lambda_handler(event, context):
    ssm_client = boto3.client('ssm')
    
    tag_ec2_Cluster = ssm_client.get_parameter(Name="tag_ec2_cluster")

    instance_id = get_instance_id_from_event(event)
    tags = get_ec2_tags(instance_id)
    
    if check_tag_exists(tags, tag_ec2_Cluster):
        print(f"A chave {tag_ec2_Cluster} existe no evento. Este evento não será notificado.")
    else:
        print(f"A chave {tag_ec2_Cluster} não existe no evento. Este evento será notificado.")
        events_client = boto3.client('events')
        event_bus_arn = ssm_client.get_parameter(Name="event-bus-arn")
        event_payload = {
            'EventBusName': event_bus_arn,
            'Detail': json.dumps(event),
            'Source': 'custom.application',
            'DetailType': 'customEventType',
        }
        response = events_client.put_events(Entries=[event_payload])
        print(response)
        
    return {
        'statusCode': 200,
        'body': json.dumps('Olá a partir do Lambda!')
    }