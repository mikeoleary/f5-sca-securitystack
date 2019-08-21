import json
from ha_iapp import validate

@validate({'client': 's3', 'bucket': 'str'})
def get(client, bucket):
    """
    Get the BIG-IP admin password from the S3 bucket created by the CFT
    """
    data = client.get_object(Bucket=bucket, Key="credentials/master")
    json_data = data['Body'].read()
    return json.loads(json_data)['password']