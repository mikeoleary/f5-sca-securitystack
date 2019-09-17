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


# remove items
echo  -e 'create cli transaction;
delete ltm virtual /'${partition}'/app1_http;
delete ltm virtual /'${partition}'/app1_https;
delete ltm pool /'${partition}'/app1_https_pool;
delete ltm node /'${partition}'/'${node1}';
delete security firewall policy /'${partition}'/'${appName}';
delete security firewall rule-list /'${partition}'/'${appName}'
delete security log profile /'${partition}'/'${appName}'_afm 
submit cli transaction' | tmsh -q

# remove partition
echo  -e 'create cli transaction;
delete auth partition '${partition}'
submit cli transaction' | tmsh -q