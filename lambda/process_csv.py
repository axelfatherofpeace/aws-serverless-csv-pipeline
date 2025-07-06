import json 
import csv
import boto3
import os

s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

table_name = os.environ['DDB_TABLE']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    try:
        for record in event['Records']:                    #Loop through each record if multiple files are uploaded
            bucket = record['s3']['bucket']['name']        #s3 bucket name 
            key = record['s3']['object']['key']            #File key

            print(f"Processing File: s3://{bucket}/{key}")
               
            #Get file from s3
            response = s3.get_object(Bucket=bucket, Key=key)
            content = response['Body'].read('utf-8').splitlines()

            #parse CSV into dicts
            reader = csv.DictReader(content)

            inserted = 0 #count successful inserts
