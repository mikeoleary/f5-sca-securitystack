#!/usr/bin/bash
# partition
partition="app1"
# nodes
node1="5.6.7.8"
# virtual addresss
virtualAddress="9.10.11.1"
# asm policy
asmPolicy="app1"
asmFile="/config/owasp-auto-tune.xml"
# partition
echo  -e 'create cli transaction;
create auth partition '${partition}' { };
submit cli transaction' | tmsh -q
# asm policy
echo  -e 'create cli transaction;
cd /'${partition}';
load asm policy file '${asmFile}'
submit cli transaction' | tmsh -q
# traffic policy
echo  -e 'create cli transaction;
cd /'${partition}';
create ltm policy /'${partition}'/Drafts/app1_asm_policy_https controls add { asm } rules add { default { actions add { 1 { asm enable policy /Common/owasp-auto-tune} } ordinal 1 } } strategy /Common/first-match;
submit cli transaction' | tmsh -q

# publish traffic policy
echo  -e 'create cli transaction;
cd /'${partition}';
publish ltm policy /'${partition}'/Drafts/app1_asm_policy_https;
submit cli transaction' | tmsh -q

#virtual servers
echo  -e 'create cli transaction;
cd /'${partition}';
create ltm node /'${partition}'/'${node1}' { address '${node1}' };
create ltm virtual /'${partition}'/app1_http { description app1_http destination /'${partition}'/'${virtualAddress}':http ip-protocol tcp mask 255.255.255.255 persist none profiles replace-all-with { /Common/f5-tcp-progressive {} http } rules { /Common/_sys_https_redirect } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled };
create ltm pool /'${partition}'/app1_https_pool { members replace-all-with { /'${partition}'/'${node1}':https { address '${node1}' } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open } };
create ltm virtual /'${partition}'/app1_https {  description app1_https destination /'${partition}'/'${virtualAddress}':https ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/cookie { default yes } } pool /'${partition}'/app1_https_pool security-log-profiles add { "Log all requests" } profiles replace-all-with { /Common/f5-tcp-progressive { } http websecurity } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled }
submit cli transaction' | tmsh -q

# add asm and logging
echo  -e 'create cli transaction;
modify ltm virtual /'${partition}'/app1_https policies add { /'${partition}'/app1_asm_policy_https} security-log-profiles add { "Log all requests" }
submit cli transaction' | tmsh -q

# save config
echo  -e 'create cli transaction;
save sys config partitions all;
submit cli transaction' | tmsh -q
