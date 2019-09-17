#!/usr/bin/bash
# partition
partition="app2"
appName="app2"
# tag
appTag="Tier2Vip"
# nodes
node1="5.6.7.9"
# virtual addresss
virtualAddress="9.10.11.12"
# afm policy
afmPolicy="app2"
# partition
echo  -e 'create cli transaction;
create auth partition '${partition}' { };
submit cli transaction' | tmsh -q
# afm policy
echo  -e 'create cli transaction;
cd /'${partition}';
create security firewall rule-list /'${partition}'/'${afmPolicy}' { rules replace-all-with { http { action accept-decisively ip-protocol tcp protocol-inspection-profile /Common/protocol_inspection uuid auto-generate destination { ports replace-all-with { http { } } } } https { action accept-decisively ip-protocol tcp protocol-inspection-profile /Common/protocol_inspection uuid auto-generate destination { ports replace-all-with { https { } } } } } };
create security firewall policy /'${partition}'/'${afmPolicy}' { rules replace-all-with { _'${partition}'_'${appName}' { rule-list '${appName}' } deny { action drop ip-protocol any log yes uuid auto-generate } } };
submit cli transaction' | tmsh -q

# logging profile
echo  -e 'create cli transaction;
cd /'${partition}';
create security log profile /'${partition}'/'${afmPolicy}'_afm { ip-intelligence { log-publisher local-db-publisher } network replace-all-with { '${partition}'/'${afmPolicy}'_afm { publisher local-db-publisher } } protocol-inspection { log-publisher local-db-publisher } }
submit cli transaction' | tmsh -q

#service Discovery pool
echo  -e 'create cli transaction;
create sys application service /'${partition}'/'${appName}' template f5.service_discovery device-group same_az_failover_group traffic-group traffic-group-1 strict-updates disabled variables replace-all-with { basic__advanced { value no } basic__display_help { value hide } cloud__aws_bigip_in_ec2 { value yes } cloud__aws_region { value us-east-1 } cloud__aws_use_role { value no } cloud__cloud_provider { value aws } monitor__frequency { value 30 } monitor__http_method { value GET } monitor__http_version { value http11 } monitor__monitor { value "/#create_new#" } monitor__response { value 200 } monitor__type { value https } monitor__uri { value / } pool__interval { value 10 } pool__member_conn_limit { value 0 } pool__member_port { value 443 } pool__pool_to_use { value "/#create_new#" } pool__public_private { value private } pool__tag_key { value '${appTag}' } pool__tag_value { value '${appName}' } };
submit cli transaction' | tmsh -q

#virtual servers
echo  -e 'create cli transaction;
cd /'${partition}';
create ltm node /'${partition}'/'${node1}' { address '${node1}' };
create ltm virtual /'${partition}'/'${appName}'_http { description '${appName}'_http destination /'${partition}'/'${virtualAddress}':http ip-protocol tcp mask 255.255.255.255 persist none profiles replace-all-with { /Common/f5-tcp-progressive {} http } rules { /Common/_sys_https_redirect } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled };
create ltm virtual /'${partition}'/'${appName}'_https {  description '${appName}'_https destination /'${partition}'/'${virtualAddress}':https ip-protocol tcp mask 255.255.255.255 pool /'${partition}'/'${appName}'.app/'${appName}'_pool profiles replace-all-with { /Common/f5-tcp-progressive { } http } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled }
submit cli transaction' | tmsh -q

# add afm and logging
echo  -e 'create cli transaction;
modify ltm virtual /'${partition}'/'${afmPolicy}'_https fw-enforced-policy /'${partition}'/'${afmPolicy}' security-log-profiles add { /'${partition}'/'${afmPolicy}'_afm } ip-intelligence-policy ip-intelligence;
modify ltm virtual /'${partition}'/'${afmPolicy}'_http ip-intelligence-policy ip-intelligence;
submit cli transaction' | tmsh -q

# save config
echo  -e 'create cli transaction;
save sys config partitions all;
submit cli transaction' | tmsh -q
