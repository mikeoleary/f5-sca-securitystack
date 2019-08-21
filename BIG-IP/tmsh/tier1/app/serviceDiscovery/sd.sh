#!/usr/bin/bash
# partition
partition="app1"
# appname
appName="app1"
# tag
appTag="Tier2Vip"
# tag: Tier2Vip:app1

#create sys application service /app1/app1 template f5.service_discovery device-group same_az_failover_group traffic-group traffic-group-1 strict-updates disabled variables replace-all-with { basic__advanced { value no } basic__display_help { value hide } cloud__aws_bigip_in_ec2 { value yes } cloud__aws_region { value us-east-1 } cloud__aws_use_role { value no } cloud__cloud_provider { value aws } monitor__frequency { value 30 } monitor__http_method { value GET } monitor__http_version { value http11 } monitor__monitor { value "/#create_new#" } monitor__response { value 200 } monitor__type { value https } monitor__uri { value / } pool__interval { value 10 } pool__member_conn_limit { value 0 } pool__member_port { value 443 } pool__pool_to_use { value "/#create_new#" } pool__public_private { value private } pool__tag_key { value appname } pool__tag_value { value app1 } }
# service discovery pool
echo  -e 'create cli transaction;
create sys application service /'${partition}'/'${appName}' template f5.service_discovery device-group same_az_failover_group traffic-group traffic-group-1 strict-updates disabled variables replace-all-with { basic__advanced { value no } basic__display_help { value hide } cloud__aws_bigip_in_ec2 { value yes } cloud__aws_region { value us-east-1 } cloud__aws_use_role { value no } cloud__cloud_provider { value aws } monitor__frequency { value 30 } monitor__http_method { value GET } monitor__http_version { value http11 } monitor__monitor { value "/#create_new#" } monitor__response { value 200 } monitor__type { value https } monitor__uri { value / } pool__interval { value 10 } pool__member_conn_limit { value 0 } pool__member_port { value 443 } pool__pool_to_use { value "/#create_new#" } pool__public_private { value private } pool__tag_key { value '${appTag}' } pool__tag_value { value '${appName}' } };
submit cli transaction' | tmsh -q

# poolname
# /app1/app1.app/app1_pool
# /'${partition}'/'${appName}'.app/'${appName}'_pool