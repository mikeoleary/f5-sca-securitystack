# delete S3 bucket content for BIG-IP clusters
# aws s3api list-buckets --query "[Buckets][*][?contains(Name, '$stackName')].[Name]"
for i in `aws s3api list-buckets --query "[Buckets][*][?contains(Name, '$stackName')].[Name]" | jq -r .[][][]`; 
do 
    echo $i
    aws s3 ls s3://$i
    aws s3 rm s3://$i --recursive
done

# find CFT outputs


# find BIG-IP management IP addresses
# aws cloudformation list-exports --query 'Exports[?contains(Name, `cody-sca-test`)]'
# aws cloudformation list-exports --query 'Exports[?contains(Name, `cody-sca-test`)]|[?contains(Name, `BIGIP`)]|[?contains(Name, `External`)].[Value]'
# aws ec2 describe-network-interfaces --network-interface-id=eni-03bd3f82d34f9eed4
# aws ec2 describe-network-interfaces --network-interface-id=eni-03bd3f82d34f9eed4 --query 'NetworkInterfaces[*].Association.[PublicIp]'

# release BIG-IP licenses
# for i in {1..4}
# do
#     echo "bigip$i";
#     # echo $bigip1
#     ip=bigip${i}
#     echo "${!ip}"
#     ssh -i $sshKey -oStrictHostKeyChecking=no admin@"${!ip}" 'modify cli preference pager disabled display-threshold 0; revoke sys license'
# done