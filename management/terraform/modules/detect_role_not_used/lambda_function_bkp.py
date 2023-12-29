import json
import boto3
import datetime
import os

unsed_for_days = int(os.environ['DAYS_UNUSED_FOR'])
topic_sns = os.environ['TOPIC_ARN']
email_subject = os.environ['EMAIL_SUBJECT']
master_account = os.environ['MASTER_ACCOUNT']
security_account = os.environ['SECURITY_ACCOUNT']
role_name = os.environ['ROLE_NAME']

def lambda_handler(event, context):
    print('[INFO] Assuming role in master account')
    accountAndRolesDetected = {}
    accounts = list_accounts_in_organizations(master_account)

    for eachAccount in accounts['Accounts']:
        try:
            results = detect_unused_roles(eachAccount['Id'])
            if str(results) != '{}' :
                accountAndRolesDetected[eachAccount['Id']] = results
        except Exception as e:
            print (e)

    if str(accountAndRolesDetected) != '{}' :
        send_notification(accountAndRolesDetected)
    else:
        print('No issues found!')

def send_notification(rolesDetected):
    try:
        clientSNS = boto3.client('sns')
        msgBody = 'The roles below have not been used for the past ' + str(unsed_for_days) + '\n'
        msgRoles = json.dumps(rolesDetected, indent=4)
        msg = msgBody + msgRoles
        response = clientSNS.publish(
            TopicArn=topic_sns,
            Message=msg,
            Subject=str(email_subject),
        )
    except Exception as e:
        print(e)

def detect_unused_roles(account):

    if ( security_account == account):
        client = boto3.client('iam')
    else:
        sts_connection = boto3.client('sts')
        acct_b = sts_connection.assume_role(
            RoleArn="arn:aws:iam::" + str(account) + ":role/" + str(role_name),
            RoleSessionName="cross_acct_lambda"
        )

        ACCESS_KEY = acct_b['Credentials']['AccessKeyId']
        SECRET_KEY = acct_b['Credentials']['SecretAccessKey']
        SESSION_TOKEN = acct_b['Credentials']['SessionToken']

        client = boto3.client(
            'iam',
            aws_access_key_id=ACCESS_KEY,
            aws_secret_access_key=SECRET_KEY,
            aws_session_token=SESSION_TOKEN,
        )

    rolesDetected = {}

    try:
        response = client.get_account_authorization_details()
    except Exception as e:
        print(e)

    for eachRole in response['RoleDetailList']:
        print('[INFO] Analyzing role: ' + eachRole['RoleName'])
        try:
            lastUsedDate = eachRole['RoleLastUsed']['LastUsedDate']
        except Exception as e:
            print("[WARN] The following role was never used: " + eachRole['RoleName'])
            continue

        today = datetime.datetime.now()
        definedDaysAgo = today - datetime.timedelta(days=unsed_for_days)

        if definedDaysAgo.date() > lastUsedDate.date():
            daysNotUsed = today.date() - lastUsedDate.date()
            print ('[WARN] The role ' + eachRole['RoleName'] + ' have not been used since ' + str(lastUsedDate) + ' (' + str(daysNotUsed) + ')')
            rolesDetected[eachRole['RoleName']] = str(daysNotUsed)

    return rolesDetected

def list_accounts_in_organizations(masterAccountID):
    sts_connection = boto3.client('sts')

    try:
        acct_b = sts_connection.assume_role(
            RoleArn="arn:aws:iam::" + str(masterAccountID) + ":role/" + str(role_name),
            RoleSessionName="cross_acct_lambda"
        )
        ACCESS_KEY = acct_b['Credentials']['AccessKeyId']
        SECRET_KEY = acct_b['Credentials']['SecretAccessKey']
        SESSION_TOKEN = acct_b['Credentials']['SessionToken']
        # Create client for IAM
        organizationClient = boto3.client(
        'organizations',
        aws_access_key_id=ACCESS_KEY,
        aws_secret_access_key=SECRET_KEY,
        aws_session_token=SESSION_TOKEN,
        )
        accounts = organizationClient.list_accounts()
        return accounts
    except Exception as e:
        print(e)