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


# remove items
echo  -e 'create cli transaction;
delete ltm virtual /'${partition}'/app1_http;
delete ltm virtual /'${partition}'/app1_https;
delete ltm pool /'${partition}'/app1_https_pool;
delete ltm node /'${partition}'/'${node1}';
delete ltm policy /'${partition}'/app1_asm_policy_https;
delete asm policy owasp-auto-tune;
submit cli transaction' | tmsh -q

# remove partition
echo  -e 'create cli transaction;
delete auth partition '${partition}'
submit cli transaction' | tmsh -q