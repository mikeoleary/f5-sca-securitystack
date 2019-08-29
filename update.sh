if [ -f "./load-keys.sh" ]; then source "./load-keys.sh"; fi
if [ -z ${stackName} ]; then echo "stackName is unset" && exit 1; fi
if [ -z ${sshKeyName} ]; then echo "sshKeyName is unset" && exit 1; fi
if [ -z ${licenseKey1} ]; then echo "licenseKey1 is unset" && exit 1; fi
if [ -z ${licenseKey2} ]; then echo "licenseKey2 is unset"  && exit 1; fi
if [ -z ${licenseKey3} ]; then echo "licenseKey3 is unset"  && exit 1; fi
if [ -z ${licenseKey4} ]; then echo "licenseKey4 is unset"  && exit 1; fi
if [ -z ${S3Key} ]; then export s3Key="master"; fi

aws cloudformation update-stack \
--stack-name $stackName \
--template-body file://./aws-quickstart-scca-main-same-net.json \
--capabilities CAPABILITY_IAM \
--parameters ParameterKey=licenseKey1,ParameterValue=$licenseKey1  ParameterKey=licenseKey2,ParameterValue=$licenseKey2 ParameterKey=licenseKey3,ParameterValue=$licenseKey3 ParameterKey=licenseKey4,ParameterValue=$licenseKey4 ParameterKey=pBaselineCompliance,ParameterValue="Enterprise" ParameterKey=pQuickstartS3KeyPrefix,ParameterValue="$S3Key" ParameterKey=sshKey,ParameterValue="$sshKeyName" 
