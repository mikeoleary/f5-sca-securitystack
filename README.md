# f5-sca-securitystack

***Under construction***

## Contents
- [Introduction](#introduction)
- [What is SCA?](#secure-cloud-architecture)
- [Design Principles](#design-principles)
- [Business Outcomes](#business-outcomes)
- [What is included in this template?](#What-is-included-in-this-template)
- [Getting Help](#help)
- [Installation](#installation)
- [Template Parameters](#template-parameters)


## Introduction

This README will provide a baseline introduction into the Secure Cloud Architecture (SCA). Links will be provided for more in-depth explanations.


## Secure Cloud Architecture

Focusing on delivering a concept to migrate to the cloud with security as a priority, not an after thought

## Design principles

Security is built-in, …

## Business Outcomes

---stuff here---

## What is included in this template? 

The Secure Cloud Architecture (SCA) provides a 3-Tier architecture. This architecture has the following components:

5 subnets:
1. Management 
2. "Outside" 
3. DMZ #1
4. DMZ #2 
5. "Internal" 

**Below is an image of the architecture:** <br> <br> 


![Image of 3-Tier Architecture](images/SCA.jpg)

<br> 


Tier 1 and Tier 3 are F5 BIG-IP devices (HA via API), while Tier 2 IPS is a Ubuntu box with routing enabled. The reason of this is to allow flexibility in Tier 2 so that the customer is not locked into a F5 device. 

There is a root Cloud Formation Template (CFT) which runs many child CFT's. <br> 



![Image of CFTs](images/CFT.jpg)
<br>


1. The TGW (transit gateway) and VPC (virtual private cloud) are deployed.
2. The template for the jump host and IPS to be deployed. 
3. BIG-IP is deployed in Tier 1 and Tier 3. <br>
**Note**: This is created after the jump host and IPS because 1 of the inputs to this is a private IP of the jump host
4. Routes are replaced utilizing lambda functions since it's not natively allowed
5. The AS3 Update template updates AS3 


## Help
**under construction**

## Installation

1. Navigate to your AWS Management Console.
2. Go to 'Services' -> 'CloudFormation'.
3. Click 'Create Stack' under the 'Stacks' column.
4. Under 'Prerequisite', choose 'Template is ready'. <br> <br>
![install_1](images/install_1.jpg) <br><br>
5. Under the Specify template, for 'Template source' choose 'Upload a template file'.<br><br>
![install_2](images/install_2.jpg) <br><br>
6. Click 'choose file' and find the appropriate file on your local machine, then click next.
7. You should now see the following page: <br><br>
![install_3](images/install_3.jpg) <br><br>
8. The 'Stack name' can be anything you choose. The stack name can include letters (A-Z and a-z), numbers (0-9), and dashes (-).
9. Fill in the appropriate information for the template parameters. For more information regarding the template parameters, [see below](#template-parameters). When you are finished with the template parameters, click 'Next'. 
10. You should now see the following page: <br><br>
![install_4](images/install_4.jpg) <br><br>
11. Under 'Advanced Options', expand the 'Stack creation options' and click 'Disabled' for 'Rollback on failure'. Then, click 'Next'. <br><br>
![install_5](images/install_5.jpg) <br><br>
12. You will now be on the Review page. Go ahead and review all the details to ensure it is all correct. At the very bottom of this page, under 'Capabilities' you must check the required boxes: <br><br>
![install_6](images/install_6.jpg) <br><br>
13. Lastly, go ahead and click 'Create stack'. 


## Template Parameters

| Parameter | Required | Description |
| --- | --- | --- |
| licenseKey1 | Yes | BIG-IP License #1 BYOL |
| licenseKey2 | Yes | BIG-IP License #2 BYOL |
| licenseKey3 | Yes | BIG-IP License #3 BYOL |
| licenseKey4 | Yes | BIG-IP License #4 BYOL |
| pBaselineCompliance | Yes | Choose your baseline compliance posture. 'Enterprise' consists of standard architecture. 'SCCA' consists of some extra layers of security. |
| pProject | No | Project name to use for tagging. |
| pQuickstartS3BucketName | Yes | S3 bucket name for the Quick Start assets. Quick Start bucket name can include numbers, lowercase letters, uppercase letters, and hyphens (-). It cannot start or end with a hyphen (-). <br> Default is 'f5-sca-securitystack'. |
| pQuickstartS3KeyPrefix | Yes | Quick Start key prefix can include numbers, lowercase letters, uppercase letters, hyphens (-), and forward slash (/). <br> Default is 'master'. |
| pVdssVpcCidr | Yes | CIDR Block for the VDSS VPC. <br> Default is '10.0.0.0/16'. |




## Filing Issues

If you find an issue, we would love to hear about it.
You have a choice when it comes to filing issues:

- Use the **Issues** link on the GitHub menu bar in this repository for items such as enhancement or feature requests and non-urgent bug fixes. Tell us as much as you can about what you found and how you found it.

### Contributor License Agreement

Individuals or business entities who contribute to this project must have completed and submitted the F5 Contributor License Agreement.