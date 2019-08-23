from troposphere import GetAtt, Join, Ref, Template, Parameter
from troposphere.cloudformation import AWSCustomObject, CustomResource
from troposphere.awslambda import Code, Function

from awacs.aws import Allow, Statement, Principal, PolicyDocument
from awacs.sts import AssumeRole

template = Template()

# add parameters
piAppUrl = template.add_parameter(Parameter(
    'piAppUrl',
    Description='URL to download the BIG-IP AWS HA iApp',
    Default='https://raw.githubusercontent.com/F5Networks/f5-aws-cloudformation/v3.1.0/iApps/f5.aws_advanced_ha.v1.4.0rc3.tmpl',
    Type='String'
))

pBigIPMgmt = template.add_parameter(Parameter(
    'pBigIPMgmt',
    Description='Active BIG-IP Management IP address',
    Type='String'
))

pBigIPRouteTableId = template.add_parameter(Parameter(
    'pBigIPRouteTableId',
    Description='BIG-IP route table id for HA',
    Type='String'
))

pBigIPInterface = template.add_parameter(Parameter(
    'pBigIPInterface',
    Description='Tier 1 BIG-IP interface for HA',
    Type='String'
))


pBigIPS3Bucket = template.add_parameter(Parameter(
    'pBigIPS3Bucket',
    Description='BIG-IP S3 bucket where password is stored',
    Type='String'
))

custom = template.add_resource(CustomResource(
    'CustomLambdaExec',
    ServiceToken=GetAtt('HAiApp', 'Arn'),
    mgmt_ip=Ref('pBigIPMgmt'),
    iapp_url=Ref('piAppUrl'),
    route_table_id=Ref('pBigIPRouteTableId'),
    interface=Ref('pBigIPInterface'),
    s3_bucket=Ref('pBigIPS3Bucket')
))

# print(template.to_json())
f = open('ha_iapp.json', "w+")
f.write(template.to_json())
f.close()