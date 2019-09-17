#usr/bin/bash
# partition
partition="mgmt"
# nodes
node1="1.2.3.4"
# virtual addresss
virtualAddress="6.7.8.9"

echo  -e 'create cli transaction;
create auth partition '${partition}' { };
submit cli transaction' | tmsh -q

echo  -e 'create cli transaction;
cd /'${partition}';
create ltm node /'${partition}'/'${node1}' { address '${node1}' };
create ltm virtual /'${partition}'/forward_outbound { description foward_outbound destination /'${partition}'/0.0.0.0:any mask any persist replace-all-with { /Common/source_addr {default yes } } profiles replace-all-with { /Common/fastL4 {} } source 0.0.0.0/0 source-address-translation { type automap } translate-address disabled translate-port disabled };
create ltm pool /'${partition}'/jumphost_http_pool { members replace-all-with { /'${partition}'/'${node1}':http { address '${node1}' } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open }};
create ltm virtual /'${partition}'/bigip1_mgmt_http { description jumphost_mgmt_http destination /'${partition}'/'${virtualAddress}':http ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr {default yes }} pool /'${partition}'/jumphost_http_pool profiles replace-all-with { /Common/f5-tcp-progressive {} } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled };
create ltm pool /'${partition}'/jumphost_https_pool { members replace-all-with { /'${partition}'/'${node1}':https { address '${node1}' } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open } };
create ltm virtual /'${partition}'/bigip1_mgmt_https {  description jumphost_mgmt_https destination /'${partition}'/'${virtualAddress}':https ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr { default yes } } pool /'${partition}'/jumphost_https_pool profiles replace-all-with { /Common/f5-tcp-progressive { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled };
create ltm pool /'${partition}'/jumphost_ssh_pool { members replace-all-with { /'${partition}'/'${node1}':ssh { address '${node1}' } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open }};
create ltm virtual /'${partition}'/jumphost_mgmt_ssh {  description jumphost_mgmt_ssh destination /'${partition}'/'${virtualAddress}':ssh ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr { default yes } } pool /'${partition}'/jumphost_ssh_pool profiles replace-all-with { /Common/f5-tcp-progressive { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled };
modify security ip-intelligence global-policy ip-intelligence-policy ip-intelligence;
submit cli transaction' | tmsh -q