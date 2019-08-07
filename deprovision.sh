if [ -z ${stackName} ]; then echo "stackName is unset" && exit 1; fi

# delete S3 bucket content for BIG-IP clusters
for i in `aws s3api list-buckets --query "[Buckets][*][?contains(Name, '$stackName')].[Name]" | jq -r .[][][]`; 
do 
    echo $i
    aws s3 ls s3://$i
    aws s3 rm s3://$i --recursive
done

# find BIG-IP management IP addresses, deprovision internal stacks before external stacks
for ip in `aws cloudformation list-exports --query "Exports[?contains(Name, '$stackName')]|[?contains(Name, 'BIGIP2')]|[?contains(Name, 'Management')].[Value]" | jq -r .[][]`;
do
    echo "revoke license for $ip"
    ssh -i $sshKey -oStrictHostKeyChecking=no admin@"$ip" 'modify cli preference pager disabled display-threshold 0; revoke sys license'
done

# deprovision external stack 
for ip in `aws cloudformation list-exports --query "Exports[?contains(Name, '$stackName')]|[?contains(Name, 'BIGIP1')]|[?contains(Name, 'Management')].[Value]" | jq -r .[][]`;
do
    echo "revoke license for $ip"
    ssh -i $sshKey -oStrictHostKeyChecking=no admin@"$ip" 'modify cli preference pager disabled display-threshold 0; revoke sys license'
done

# delete CFT stack
echo "deleting CFT stack $stackName"
aws cloudformation delete-stack --stack-name $stackName