#!/usr/bin/bash
# partition
partition="app1"
appName="app1"
# nodes
node1="5.6.7.9"
# virtual addresss
virtualAddress="9.10.11.12"
# afm policy
afmPolicy="app1"
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

#virtual servers
echo  -e 'create cli transaction;
cd /'${partition}';
create ltm node /'${partition}'/'${node1}' { address '${node1}' };
create ltm virtual /'${partition}'/'${appName}'_http { description '${appName}'_http destination /'${partition}'/'${virtualAddress}':http ip-protocol tcp mask 255.255.255.255 persist none profiles replace-all-with { /Common/f5-tcp-progressive {} http } rules { /Common/_sys_https_redirect } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled };
create ltm pool /'${partition}'/'${appName}'_https_pool { members replace-all-with { /'${partition}'/'${node1}':https { address '${node1}' } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open } };
create ltm virtual /'${partition}'/'${appName}'_https {  description '${appName}'_https destination /'${partition}'/'${virtualAddress}':https ip-protocol tcp mask 255.255.255.255 pool /'${partition}'/'${appName}'_https_pool profiles replace-all-with { /Common/f5-tcp-progressive { } http } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled }
submit cli transaction' | tmsh -q

# add afm and logging
echo  -e 'create cli transaction;
modify ltm virtual /'${partition}'/'${afmPolicy}'_https fw-enforced-policy '${partition}'/'${afmPolicy}' security-log-profiles add { '${partition}'/'${afmPolicy}'_afm };
submit cli transaction' | tmsh -q

# save config
echo  -e 'create cli transaction;
save sys config partitions all;
submit cli transaction' | tmsh -q
