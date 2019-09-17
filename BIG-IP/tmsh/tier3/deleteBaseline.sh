#!/usr/bin/bash
# partition
partition="mgmt"
# nodes
node1="1.2.3.4"

# remove items
echo  -e 'create cli transaction;
delete ltm virtual /'${partition}'/jumphost_mgmt_ssh;
delete ltm virtual /'${partition}'/bigip1_mgmt_https;
delete ltm virtual /'${partition}'/bigip1_mgmt_http;
delete ltm virtual /'${partition}'/forward_outbound;
delete ltm pool /'${partition}'/jumphost_ssh_pool;
delete ltm pool /'${partition}'/jumphost_https_pool;
delete ltm pool /'${partition}'/jumphost_http_pool;
delete ltm node /'${partition}'/'${node1}';
submit cli transaction' | tmsh -q

# remove partition
echo  -e 'create cli transaction;
delete auth partition '${partition}'
submit cli transaction' | tmsh -q

echo "done"