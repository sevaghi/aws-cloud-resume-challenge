import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('portfolio-web-counter')

def lambda_handler(event, context):
    response = table.get_item(Key={
       'record_id':'0'
    })
    return response['Item']['record_count']