import json
import boto3
from boto3.dynamodb.types import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('portfolio-web-counter')

def lambda_handler(event, context):
    try:
        if event['httpMethod'] == 'GET':
            table.update_item(
                Key={'record_id': '0'},
                UpdateExpression='SET record_count = record_count + :val',
                ExpressionAttributeValues={':val': Decimal('1')},
                ReturnValues='UPDATED_NEW'
            )
            response = table.get_item(Key={'record_id': '0'})
            item = response.get('Item', {})
            count = item.get('record_count', Decimal('0')).quantize(Decimal('1'))

            return {
                'statusCode': 200,
                'headers': {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
                    'Access-Control-Allow-Methods': 'OPTIONS,GET',
                    'Content-Type': 'application/json'
                },
                'body': json.dumps({'record_count': str(count)})
            }

    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET',
                'Content-Type': 'application/json'
            },
            'body': json.dumps({'error': str(e)})
        }
