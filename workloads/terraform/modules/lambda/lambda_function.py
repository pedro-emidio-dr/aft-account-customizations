import json
import boto3

def extract_tags_from_json(event):
    return [
        tag
        for tag_spec in event.get('detail', {}).get('requestParameters', {}).get('tagSpecificationSet', {}).get('items', [])
        for tag in tag_spec.get('tags', [])
    ]


def detect_ec2_cluster_tag(tags, tag_to_detect):
    return any(tag['key'] == tag_to_detect for tag in tags)

    
def lambda_handler(event, context):
    client = boto3.client('ec2')
    ssm_client = boto3.client('ssm')
    
    topic_arn = ssm_client.get_parameter(Name="/alarms/topic_arn")
    tag_ec2_Cluster = ssm_client.get_parameter(Name="/alarms/tag_ec2_cluster")
    
    tags = extract_tags_from_json(event)
    tag_to_detect = tag_ec2_Cluster['Parameter']['Value']

    tag_detected = detect_ec2_cluster_tag(tags, tag_to_detect)

    if tag_detected:
        print(f"The key {tag_to_detect} exists in the event. This event will not be notified.")
    else:
        print(f"The key {tag_to_detect} does not exist in the event. This event will be notified.")
        
        sns_client = boto3.client('sns')
        
        message = f"EC2 State Change: {event}"

        response = sns_client.publish(
            TopicArn=topic_arn['Parameter']['Value'],
            Message=message,
        )
        print(response)
        print(f"Message sent successfully! Message ID: {response['MessageId']}")
        
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
