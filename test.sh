if [ -f "./load-keys.sh" ]; then source "./load-keys.sh"; fi

# Get password for BIG-IPs in tier-1
if [ -z ${stackName} ]; then echo "stackName is unset" && exit 1; fi
S3bucket=`aws s3api list-buckets --query "[Buckets][*][?contains(Name, '$stackName-f5bigip1')].[Name]" | jq -r .[][][]`
export bigip1_pwd=`aws s3 cp s3://$S3bucket/credentials/master - | jq -r .password`
echo $bigip1_pwd

# find the route table for tier1
aws cloudformation list-exports --query "Exports[?contains(Name, '$stackName')]|[?contains(Name, 'VdssDmz1SubnetRouteTable')]" | jq -r .[][]

# # install ha iApp and configure
# for ip in `aws cloudformation list-exports --query "Exports[?contains(Name, '$stackName')]|[?contains(Name, 'BIGIP1')]|[?contains(Name, 'Management')].[Value]" | jq -r .[][]`;
# do
#     echo "install HA iApp for Tier-1 BIG-IP $ip"
#     ssh -i $sshKey -oStrictHostKeyChecking=no admin@"$ip" "create /sys application service aws_HA template f5.aws_advanced_ha.v1.4.0rc3 tables add { subnet_routes__cidr_blocks { column-names { route_table_id dest_cidr_block } rows { { row { "rtb-06ed70ecb5a149f64" "0.0.0.0/0" } } } } } variables add { subnet_routes__route_management { value yes }, subnet_routes__interface { value /Common/internal }  }" 
# done
