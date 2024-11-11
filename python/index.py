import json

def lambda_handler(event, context):
   
    body = json.loads(event.get('body', '{}'))  # Parse the JSON string in 'body'
    
    input_text = body.get('message', '') 

    output_text = f"Hello from Lambda!! The text received from front end is: '{input_text}"

    headers = {'Content-Type':'application/json',
                    'Access-Control-Allow-Origin':'*',
                    'Access-Control-Allow-Methods':'POST,PATCH,OPTIONS'}
    
    return {
        'statusCode': 200,
        # 'headers': headers,
        'body': json.dumps({
            'output': output_text
        })
    }