from troposphere import GetAtt, Join, Ref, Template, Parameter
from troposphere.iam import Role
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

pLambdaS3BucketName = template.add_parameter(Parameter(
    'pLambdaS3BucketName',
    Description='S3 bucket where lambda code is stored',
    Type='String'
))

pLambdaS3KeyPrefix = template.add_parameter(Parameter(
    'pLambdaS3KeyPrefix',
    Description='S3 Key Prefix where lambda code is stored',
    Type='String'
))

# add IAM Role
iamRole = template.add_resource(Role(
    'LambdaRole',
    AssumeRolePolicyDocument=PolicyDocument(
        Statement=[
            Statement(
                Effect=Allow,
                Action=[AssumeRole],
                Principal=Principal('Service', ['lambda.amazonaws.com'])
            )
        ]
    ),
    Path='/',
    ManagedPolicyArns = [
        'arn:aws:iam::aws:policy/AmazonVPCFullAccess',
        'arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole',
        'arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess'
    ]
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

ha_lambda = template.add_resource(Function(
    'HAiApp',
    Handler= 'index.lambda_handler',
    Role=  GetAtt('LambdaRole', 'Arn'),
    Code= Code(
        S3Bucket=Ref('pLambdaS3BucketName'),
        S3Key=Join("", [
            Ref('pLambdaS3KeyPrefix'),
            "/ha_iapp.zip"
        ])
    ),
    Runtime='python3.6',
    Timeout=30
))

# print(template.to_yaml())
f = open('ha_iapp.json', "w+")
f.write(template.to_json())
f.close()