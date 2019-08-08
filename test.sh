# if [ -z ${BIGIP_PWD} ]; then echo "stackName is unset" && exit 1; fi
# Change admin password on BIG-IP appliances in tier-1
# for ip in `aws cloudformation list-exports --query "Exports[?contains(Name, '$stackName')]|[?contains(Name, 'BIGIP1')]|[?contains(Name, 'Management')].[Value]" | jq -r .[][]`;
# do
#     echo "set password for Tier-1 BIG-IP $ip"
#     ssh -i $sshKey -oStrictHostKeyChecking=no admin@"$ip" "modify auth user admin password $BIGIP_PWD"
# done

# # Change admin password on BIG-IP appliances in tier-2
# for ip in `aws cloudformation list-exports --query "Exports[?contains(Name, '$stackName')]|[?contains(Name, 'BIGIP2')]|[?contains(Name, 'Management')].[Value]" | jq -r .[][]`;
# do
#     echo "set password for Tier-2 BIG-IP $ip"
#     ssh -i $sshKey -oStrictHostKeyChecking=no admin@"$ip" "modify auth user admin password $BIGIP_PWD"
# done

# Get password for BIG-IPs in tier-1
if [ -z ${stackName} ]; then echo "stackName is unset" && exit 1; fi
S3bucket=`aws s3api list-buckets --query "[Buckets][*][?contains(Name, '$stackName-f5bigip1')].[Name]" | jq -r .[][][]`
export bigip1_pwd=`aws s3 cp s3://$S3bucket/credentials/master - | jq -r .password`
echo $bigip1_pwd



# # install ha iApp and configure
for ip in `aws cloudformation list-exports --query "Exports[?contains(Name, '$stackName')]|[?contains(Name, 'BIGIP1')]|[?contains(Name, 'Management')].[Value]" | jq -r .[][]`;
do
    echo "install HA iApp for Tier-1 BIG-IP $ip"
    ssh -i $sshKey -oStrictHostKeyChecking=no admin@"$ip" "load sys application template /config/cloud/aws/f5.aws_advanced_ha.v1.4.0rc3.tmpl"
done
