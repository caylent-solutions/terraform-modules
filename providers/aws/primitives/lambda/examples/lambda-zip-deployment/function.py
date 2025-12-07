import json
import os

def lambda_handler(event, context):
    """
    Simple Lambda function handler for testing
    """
    log_level = os.environ.get('LOG_LEVEL', 'INFO')
    env = os.environ.get('ENV', 'unknown')
    
    print(f"Log Level: {log_level}")
    print(f"Environment: {env}")
    print(f"Event: {json.dumps(event)}")
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Function executed successfully',
            'environment': env
        })
    }
