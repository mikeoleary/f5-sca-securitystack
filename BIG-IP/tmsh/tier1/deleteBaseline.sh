#!/usr/bin/bash
# partition
partition="mgmt"
# nodes
node1="1.2.3.4"
# internal gateway
network=$(ifconfig internal | grep 'inet' | cut -d: -f2 | awk '{print $2}' | cut -d"." -f1-3)
gw="$network"".1"

# remove items
echo  -e 'create cli transaction;
delete ltm virtual /'${partition}'/jumphost_mgmt_ssh;
delete ltm virtual /'${partition}'/bigip1_mgmt_https;
delete ltm virtual /'${partition}'/bigip1_mgmt_http;
delete ltm virtual /'${partition}'/forward_outbound;
delete ltm virtual /'${partition}'/internal_10;
delete ltm virtual /'${partition}'/internal_172;
delete ltm virtual /'${partition}'/internal_192;
delete ltm pool /'${partition}'/internal_gw_pool;
delete ltm pool /'${partition}'/jumphost_ssh_pool;
delete ltm pool /'${partition}'/jumphost_https_pool;
delete ltm pool /'${partition}'/jumphost_http_pool;
delete ltm node /'${partition}'/'${node1}';
delete ltm node /'${partition}'/'${gw}';
submit cli transaction' | tmsh -q

# remove partition
echo  -e 'create cli transaction;
delete auth partition '${partition}'
submit cli transaction' | tmsh -q

echo "done"