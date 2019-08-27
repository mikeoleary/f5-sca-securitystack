from f5_sca_libs import bigip
from f5_sca_libs import password
import boto3
import json
import logging
import cfnresponse

def lambda_handler(event, context):
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    logger.info('Received event: ' + json.dumps(event, indent=2))

    if event['RequestType'] == 'Create':
        # obtain required variables
        mgmt_ip = event['ResourceProperties'].get('mgmt_ip')
        iapp_url = event['ResourceProperties'].get('iapp_url')
        route_table_id = event['ResourceProperties'].get('route_table_id')
        interface = event['ResourceProperties'].get('interface')
        s3_bucket = event['ResourceProperties'].get('s3_bucket')

        if not mgmt_ip or not iapp_url or not route_table_id or not interface or not s3_bucket:
            raise Exception(f'ERROR: missing required event attributes {json.dumps(event, indent=2)} ')

        # make sure we always return a reponse to CFN
        try:
            # obtain BIG-IP Password
            s3_client = boto3.client('s3')
            pwd = password.get(s3_client, s3_bucket)
            if not pwd:
                raise Exception('ERROR: unable to obtain BIG-IP password')

            # deploy and configure ha_iapp
            client = bigip.client(mgmt_ip, 'admin', pwd)
            bigip.install_iapp(client, iapp_url)
            iapp_name = iapp_url.split('/')[-1].replace('.tmpl', '')
            bigip.cfg_ha_iapp(client, iapp_name, route_table_id, interface)

            logger.info('Successfully updated the HA iApp')
            cfnresponse.send(event, context, cfnresponse.SUCCESS, True)
            return
            
        except Exception:
            logger.exception('Signaling failure to CloudFormation.')
            cfnresponse.send(event, context, cfnresponse.FAILED, {})

    if event['RequestType'] == 'Delete':
        cfnresponse.send(event, context, cfnresponse.SUCCESS, {})