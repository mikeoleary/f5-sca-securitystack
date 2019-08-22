from f5_sca_libs import bigip
from f5_sca_libs import password
import boto3
import json

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    # obtain required variables
    mgmt_ip = event['Records'][0]['bigip']['mgmt_ip']
    iapp_url = event['Records'][0]['bigip']['iapp_url']
    route_table_id = event['Records'][0]['bigip']['route_table_id']
    interface = event['Records'][0]['bigip']['interface']
    s3_bucket = event['Records'][0]['bigip']['s3_bucket']

    if not mgmt_ip or not iapp_url or not route_table_id or not interface or not s3_bucket:
        raise Exception(f'ERROR: missing required event attributes {json.dumps(event, indent=2)} ')

    # obtain BIG-IP Password
    s3_client = boto3.client('s3')
    password = password.get(s3_client, s3_bucket)

    # deploy and configure ha_iapp
    client = bigip.client(mgmt_ip, 'admin', password)
    bigip.install_iapp(client, iapp_url)
    iapp_name = iapp_url.split('/')[-1].replace('.tmpl', '')
    bigip.cfg_ha_iapp(client, iapp_name, route_table_id, interface)