#!/usr/bin/bash
# partition
partition="app1"
# app name
appName="app1"
# nodes
node1="5.6.7.8"
# virtual addresss
virtualAddress="9.10.11.1"
# asm policy
asmPolicy="app1"
asmFile="/config/owasp-auto-tune.xml"


# remove items
echo  -e 'create cli transaction;
delete ltm virtual /'${partition}'/'${appName}'_http;
delete ltm virtual /'${partition}'/'${appName}'_https;
delete ltm pool /'${partition}'/'${appName}'_https_pool;
delete ltm node /'${partition}'/'${node1}';
delete ltm policy /'${partition}'/'${appName}'_asm_policy_https;
delete asm policy owasp-auto-tune;
delete security log profile /'${partition}'/'${appName}'_sec_log
delete security bot-defense profile /'${partition}'/'${appName}'_bot
submit cli transaction' | tmsh -q

# remove partition
echo  -e 'create cli transaction;
delete auth partition '${partition}'
submit cli transaction' | tmsh -q