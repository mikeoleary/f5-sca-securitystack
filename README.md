# f5-sca-securitystack

## Introduction

This README will provide a baseline introduction into the Secure Cloud Architecture (SCA). Links will be provided for more in-depth explanations.


**Under construction**

## Secure Cloud Architecture

Focusing on delivering a concept to migrate to the cloud with security as a priority, not an after thought

## Design principles

Security is built-in, …

## Business Outcomes



## What is included in this template? 

The Secure Cloud Architecture (SCA) provides a 3-Tier architecture. This architecture has the following components:

5 subnets:
	1. Management 
	2. "Outside" 
	3. DMZ #1
	4. DMZ #2 
	5. "Internal" 


![Image of 3-Tier Architecture](images/SCA.jpg)




Tier 1 and Tier 3 are F5 BIG-IP devices (HA via API), while Tier 2 IPS is a Ubuntu box with routing enabled. The reason of this is to allow flexibility in Tier 2 so that the customer is not locked into a F5 device. 

There is a root Cloud Formation Template (CFT) which runs 5 child-CFT's 



![Image of CFTs](images/CFT.jpg)



First, the TGW (transit gateway) and VPC (virtual private cloud) are deployed.

Second is the template for the jump host and IPS to be deployed. 

Third, BIG-IP tier 1 and tier 2 are deployed 
**Note: This is created after the jump host and IPS because 1 of the inputs to this is a private IP of the jump host

Fourth, routes are replaced utilizing lambda functions since it's not natively allowed

Lastly, the AS3 Update template updates AS3 

## Development
This project uses the AWS CloudPipeline to build the require Lambda functions as well as generating some of the CFN Templates.

To start developing against this project please follow the below procedures:

1) Create a GitHub [Personal Access Token](https://docs.aws.amazon.com/codepipeline/latest/userguide/GitHub-create-personal-token-CLI.html)
2) Add the GitHub PAT to your AWS Secrets Manager.  **Note:** ensure the key uses the value GitHubPersonalAccessToken
3) Deploy the deploy-pipeline.template CloudFormation Template
    1. BranchName: the branch name of your Git repository - usually master unless you created a branch for development.
	2. GitHubOwner: the GitHub account owner for the repository.  This is used to build the GitHub URL to access the repository.
	3. OAuthSecretName: the name of your AWS Secrets Manager object that stores the GitHub PAT
	4. RepositoryName: the Git repository name.  This is used to build the GitHub URL to access the repository.
	5. S3Bucket: the S3 bucket you want the CFN templates and lambda files installed to. **Note:** this bucket must already exists.
	6. S3Key: the directory inside your S3 bucket that will contain the deployment artifacts. 
