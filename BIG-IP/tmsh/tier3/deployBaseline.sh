#!/usr/bin/bash
# partition
partition="mgmt"
# nodes
node1="1.2.3.4"
# virtual addresss
virtualAddress="6.7.8.9"
# internal gateway
network=$(/bin/ifconfig internal | grep 'inet' | cut -d: -f2 | awk '{print $2}' | cut -d"." -f1-3)
gw="$network"".1"
#echo $gw
# make gw pool
# make 1918 virutal servers
# For 10.0.0.0/8, 172.16.0.0/12 and 192.168.0.0/16
# use gw pool for each

echo  -e 'create cli transaction;
create auth partition '${partition}' { };
submit cli transaction' | tmsh -q

echo  -e 'create cli transaction;
cd /'${partition}';
create ltm node /'${partition}'/'${node1}' { address '${node1}' };
create ltm node /'${partition}'/'${gw}' { address '${gw}' };
create ltm pool /'${partition}'/internal_gw_pool { members replace-all-with { /'${partition}'/'${gw}':any { address '${gw}' } } min-active-members 1 monitor min 1 of { /Common/gateway_icmp }};
create ltm virtual /'${partition}'/internal_10 { description foward_internal_10 destination /'${partition}'/10.0.0.0:any mask 255.0.0.0 persist replace-all-with { /Common/source_addr {default yes } } profiles replace-all-with { /Common/fastL4 {} } pool /'${partition}'/internal_gw_pool source 0.0.0.0/0 source-address-translation { type automap } translate-address disabled translate-port disabled };
create ltm virtual /'${partition}'/internal_172 { description foward_internal_172 destination /'${partition}'/172.16.0.0:any mask 255.240.0.0 persist replace-all-with { /Common/source_addr {default yes } } profiles replace-all-with { /Common/fastL4 {} } pool /'${partition}'/internal_gw_pool source 0.0.0.0/0 source-address-translation { type automap } translate-address disabled translate-port disabled };
create ltm virtual /'${partition}'/internal_192 { description foward_internal_192 destination /'${partition}'/192.168.0.0:any mask 255.255.0.0 persist replace-all-with { /Common/source_addr {default yes } } profiles replace-all-with { /Common/fastL4 {} } pool /'${partition}'/internal_gw_pool source 0.0.0.0/0 source-address-translation { type automap } translate-address disabled translate-port disabled };
create ltm virtual /'${partition}'/forward_outbound { description foward_outbound destination /'${partition}'/0.0.0.0:any mask any persist replace-all-with { /Common/source_addr {default yes } } profiles replace-all-with { /Common/fastL4 {} } source 0.0.0.0/0 source-address-translation { type automap } translate-address disabled translate-port disabled };
create ltm pool /'${partition}'/jumphost_http_pool { members replace-all-with { /'${partition}'/'${node1}':http { address '${node1}' } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open }};
create ltm virtual /'${partition}'/bigip1_mgmt_http { description jumphost_mgmt_http destination /'${partition}'/'${virtualAddress}':http ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr {default yes }} pool /'${partition}'/jumphost_http_pool profiles replace-all-with { /Common/f5-tcp-progressive {} } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled };
create ltm pool /'${partition}'/jumphost_https_pool { members replace-all-with { /'${partition}'/'${node1}':https { address '${node1}' } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open } };
create ltm virtual /'${partition}'/bigip1_mgmt_https {  description jumphost_mgmt_https destination /'${partition}'/'${virtualAddress}':https ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr { default yes } } pool /'${partition}'/jumphost_https_pool profiles replace-all-with { /Common/f5-tcp-progressive { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled };
create ltm pool /'${partition}'/jumphost_ssh_pool { members replace-all-with { /'${partition}'/'${node1}':ssh { address '${node1}' } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open }};
create ltm virtual /'${partition}'/jumphost_mgmt_ssh {  description jumphost_mgmt_ssh destination /'${partition}'/'${virtualAddress}':ssh ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr { default yes } } pool /'${partition}'/jumphost_ssh_pool profiles replace-all-with { /Common/f5-tcp-progressive { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled };
submit cli transaction' | tmsh -q