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
    ssh -i $sshKey -oStrictHostKeyChecking=no admin@"$ip" "create /sys application service aws_HA template f5.aws_advanced_ha.v1.4.0rc3 tables add { subnet_routes__cidr_blocks { column-names { route_table_id dest_cidr_block } rows { { row { "rtb-06ed70ecb5a149f64" "0.0.0.0/0" } } } } } variables add { subnet_routes__route_management { value yes }  }" 
done

# below line is from across AZ iApp -don't use, for notes only
#"create /sys application service HA_Across_AZs template f5.aws_advanced_ha.v1.4.0rc3 tables add { eip_mappings__mappings { column-names { eip az1_vip az2_vip } rows { { row { ${VIPEIP} /Common/${EXTPRIVIP} /Common/${PEER_EXTPRIVIP} } } } } } variables add { eip_mappings__inbound { value yes } }\"\n",





#"load sys application template /config/cloud/aws/f5.aws_advanced_ha.v1.4.0rc3.tmpl"