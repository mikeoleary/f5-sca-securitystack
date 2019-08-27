from troposphere import GetAtt, Join, Ref, Template, Parameter, Sub
from troposphere.iam import Role
from troposphere.awslambda import Code, Function

from awacs.aws import Allow, Statement, Principal, PolicyDocument
from awacs.sts import AssumeRole

template = Template()

# add parameters
pPrefix = template.add_parameter(Parameter(
    'pPrefix',
    Description='Lambda Function Name Prefix',
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

ha_lambda = template.add_resource(Function(
    'HAiApp',
    FunctionName= Sub('${pPrefix}-ha-iapp'),
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
f = open('install_lambda.json', "w+")
f.write(template.to_json())
f.close()