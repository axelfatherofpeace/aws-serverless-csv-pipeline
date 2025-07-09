import json
import csv
import boto3
import os

# AWS clients
s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

# Environment variables
table_name = os.environ['DDB_TABLE']
table = dynamodb.Table(table_name)

# Optional: SNS for alerts (must define sns_topic in env if used)
# sns = boto3.client('sns')
# sns_topic = os.environ.get('SNS_TOPIC')


def lambda_handler(event, context):
    try:
        for record in event['Records']:  # Loop through each file event
            bucket = record['s3']['bucket']['name']
            key = record['s3']['object']['key']

            print(f"Processing File: s3://{bucket}/{key}")

            # Download the file
            response = s3.get_object(Bucket=bucket, Key=key)
            content = response['Body'].read().decode('utf-8').splitlines()

            # Parse CSV into dict
            reader = csv.DictReader(content)

            inserted = 0  # Counter

            for row in reader:
                if 'id' not in row:
                    print(f"Skipping row without 'id': {row}")
                    continue

                table.put_item(Item=row)
                inserted += 1

            print(f"✅ Successfully inserted {inserted} rows from {key}")

        return {
            'statusCode': 200,  
            'body': json.dumps(f"Processed {inserted} rows successfully")
        }

    except Exception as e:
        print(f"❌ Error processing file: {str(e)}")

        # Optional SNS notification block (disabled for now)
        # if sns_topic:
        #     sns.publish(
        #         TopicArn=sns_topic,
        #         Subject="CSV Pipeline Failure",
        #         Message=f"Lambda error: {str(e)}"
        #     )

        raise e
