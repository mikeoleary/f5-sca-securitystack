waiting for cloud libs install to complete
2019-08-21T14:42:44.350Z info: [pid: 16764] [scripts/runScript.js] /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/runScript.js called with /usr/bin/f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/runScript.js --signal PASSWORD_CREATED --file f5-rest-node --cl-args ******* --log-level silly -o /var/log/cloud/aws/generatePassword.log
2019-08-21T14:42:44.368Z debug: [pid: 16764] [scripts/runScript.js] Found clArgs - checking for single quotes

2019-08-21T14:42:44.590Z info: [pid: 16782] [scripts/onboard.js] /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/onboard.js called with /usr/bin/f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/onboard.js --install-ilx-package file:///config/cloud/f5-appsvcs-3.5.1-5.noarch.rpm --wait-for NETWORK_CONFIG_DONE --signal ONBOARD_DONE -o /var/log/cloud/aws/onboard.log --log-level silly --no-reboot --host localhost --user admin --password-url file:///config/cloud/aws/.adminPassword --password-encrypted --hostname ip-10-0-4-210.ec2.internal --ntp 0.pool.ntp.org --tz UTC --dns 10.0.0.2 --modules ltm:nominal,asm:nominal,apm:nominal --license EHTBV-IHDYV-GXEHV-HNERY-KFDDBBC --metrics cloudName:aws,region: us-east-1 ,bigipVersion:14.1.0.3-0.0.6,customerId:62d33d58f94413a41e47b34da94447240dbeae43005b7a9dba8e21bb41858e6382db043801e468b44d320907afb898f91a03b8cbe0e8b2d9fe6fcf48bb4b1f3e,deploymentId:46d4639e8b24f3f864c2a0262318f84bcfc020c90dce37b0b6373d89e0570836cd679befc414ff0357c248a63eda67efa5583deb6c46446b0771833bd413219d,templateName:f5-existing-stack-same-az-cluster-byol-3nic-bigip.template,templateVersion:4.2.0,licenseType:byol -d tm.tcpudptxchecksum:software-only --ping

2019-08-21T14:42:44.708Z info: [pid: 16788] [scripts/cluster.js] /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/cluster.js called with /usr/bin/f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/cluster.js --wait-for CUSTOM_CONFIG_DONE --signal CLUSTER_DONE -o /var/log/cloud/aws/cluster.log --log-level silly --host localhost --user admin --password-url file:///config/cloud/aws/.adminPassword --password-encrypted --cloud aws --provider-options s3Bucket: mazza-sca-test-f5bigip2-1agxzrpt4jyvk-s3bucket-5go7zs1n44nj  --config-sync-ip 10.0.3.222 --join-group --device-group same_az_failover_group --remote-host 10.0.4.144


2019-08-21T14:42:56.616Z debug: [pid: 16764] [lib/ipc.js] Sending signal PASSWORD_CREATED
2019-08-21T14:42:56.616Z info: [pid: 16764] [lib/util.js] Custom script finished.
2019-08-21T14:42:57.491Z debug: [pid: 16765] [scripts/runScript.js] Signal received.
2019-08-21T14:42:57.493Z info: [pid: 16765] [scripts/runScript.js] /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/createUser.sh starting.
2019-08-21T14:42:57.493Z debug: [pid: 16765] [lib/ipc.js] Sending signal SCRIPT_RUNNING
2019-08-21T14:43:01.299Z info: [pid: 16765] [scripts/runScript.js] /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/createUser.sh exited with code 0
2019-08-21T14:43:01.301Z debug: [pid: 16765] [scripts/runScript.js]
2019-08-21T14:43:01.305Z debug: [pid: 16765] [lib/ipc.js] Sending signal ADMIN_CREATED
2019-08-21T14:43:01.306Z info: [pid: 16765] [lib/util.js] Custom script finished.




/config/cloud/aws/.adminPassword


cat /var/log/cloud/aws/install.log | grep Bucket


if master 
"065-cluster": {
"command": {
else:
--join-group

#failing:
box1
[admin@ip-10-0-4-210:Active:Standalone] ~ # cat /var/log/cloud/aws/install.log | grep Bucket
2019-08-21T14:42:44.708Z info: [pid: 16788] [scripts/cluster.js] /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/cluster.js called with /usr/bin/f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/cluster.js --wait-for CUSTOM_CONFIG_DONE --signal CLUSTER_DONE -o /var/log/cloud/aws/cluster.log --log-level silly --host localhost --user admin --password-url file:///config/cloud/aws/.adminPassword --password-encrypted --cloud aws --provider-options s3Bucket: mazza-sca-test-f5bigip2-1agxzrpt4jyvk-s3bucket-5go7zs1n44nj  --config-sync-ip 10.0.3.222 --join-group --device-group same_az_failover_group --remote-host 10.0.4.144
2019-08-21T14:47:57.738Z silly: [pid: 16788] [lib/awsCloudProvider.js] getting object {"Bucket":"mazza-sca-test-f5bigip2-1agxzrpt4jyvk-s3bucket-5go7zs1n44nj","Key":"credentials/master"}
2019-08-21T14:49:09.395Z silly: [pid: 16788] [lib/awsCloudProvider.js] getting object {"Bucket":"mazza-sca-test-f5bigip2-1agxzrpt4jyvk-s3bucket-5go7zs1n44nj","Key":"credentials/master"}
2019-08-21T14:50:20.623Z silly: [pid: 16788] [lib/awsCloudProvider.js] getting object {"Bucket":"mazza-sca-test-f5bigip2-1agxzrpt4jyvk-s3bucket-5go7zs1n44nj","Key":"credentials/master"}
2019-08-21T14:51:32.105Z silly: [pid: 16788] [lib/awsCloudProvider.js] getting object {"Bucket":"mazza-sca-test-f5bigip2-1agxzrpt4jyvk-s3bucket-5go7zs1n44nj","Key":"credentials/master"}
2019-08-21T14:52:43.484Z silly: [pid: 16788] [lib/awsCloudProvider.js] getting object {"Bucket":"mazza-sca-test-f5bigip2-1agxzrpt4jyvk-s3bucket-5go7zs1n44nj","Key":"credentials/master"}
box2
[admin@ip-10-0-4-210:Active:Standalone] ~ # cat /var/log/cloud/aws/install.log | grep Bucket
2019-08-21T14:42:44.708Z info: [pid: 16788] [scripts/cluster.js] /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/cluster.js called with /usr/bin/f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/cluster.js --wait-for CUSTOM_CONFIG_DONE --signal CLUSTER_DONE -o /var/log/cloud/aws/cluster.log --log-level silly --host localhost --user admin --password-url file:///config/cloud/aws/.adminPassword --password-encrypted --cloud aws --provider-options s3Bucket: mazza-sca-test-f5bigip2-1agxzrpt4jyvk-s3bucket-5go7zs1n44nj  --config-sync-ip 10.0.3.222 --join-group --device-group same_az_failover_group --remote-host 10.0.4.144


#working:
box1
[admin@ip-10-0-4-145:Standby:In Sync] ~ # cat /var/log/cloud/aws/install.log | grep Bucket
2019-08-21T14:42:44.734Z info: [pid: 16786] [scripts/cluster.js] /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/cluster.js called with /usr/bin/f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/cluster.js --wait-for CUSTOM_CONFIG_DONE --signal CLUSTER_DONE -o /var/log/cloud/aws/cluster.log --log-level silly --host localhost --user admin --password-url file:///config/cloud/aws/.adminPassword --password-encrypted --cloud aws --provider-options s3Bucket: mazza-sca-test-f5bigip1-1cfpxm0jqb0j1-s3bucket-hjjo43cvrf9g  --master --config-sync-ip 10.0.1.94 --create-group --device-group same_az_failover_group --sync-type sync-failover --network-failover --device ip-10-0-4-145.ec2.internal --auto-sync
box2


# tests
curl -v http://169.254.169.254/latest/meta-data/hostname

cat /var/log/cloud/aws/install.log



# bot def

#!/bin/bash
partition="app1"
appName="app1"
virtualAddress='10.0.2.59'
virtualAddress2='10.0.2.247'
node1='10.0.4.11'

asmPolicy="app1"
asmFile="/config/owasp-auto-tune.xml"
# create BotDef and logging profile
echo  -e 'create cli transaction;
create security log profile /'${partition}'/'${appName}'_sec_log application replace-all-with { /'${partition}'/'${appName}' { filter replace-all-with { log-challenge-failure-requests { values replace-all-with { enabled } } request-type { values replace-all-with { all } } } response-logging illegal } } bot-defense replace-all-with { /'${partition}'/'${appName}' { filter { log-alarm enabled log-block enabled log-browser enabled log-browser-verification-action enabled log-captcha enabled log-challenge-failure-request enabled log-device-id-collection-request enabled log-honey-pot-page enabled log-malicious-bot enabled log-mobile-application enabled log-none enabled log-rate-limit enabled log-redirect-to-pool enabled log-suspicious-browser enabled log-tcp-reset enabled log-trusted-bot enabled log-unknown enabled log-untrusted-bot enabled } local-publisher /Common/local-db-publisher } };
create security bot-defense profile /'${partition}'/'${appName}'_bot { allow-browser-access enabled api-access-strict-mitigation enabled app-service none blocking-page {  type default } browser-mitigation-action block captcha-response { failure {  type default } first { type default } } cross-domain-requests allow-all description none deviceid-mode generate-after-access  dos-attack-strict-mitigation enabled enforcement-mode transparent enforcement-readiness-period 7 grace-period 300 honeypot-page {  type default } mobile-detection { allow-android-rooted-device disabled allow-any-android-package enabled allow-any-ios-package enabled allow-emulators disabled allow-jailbroken-devices disabled block-debugger-enabled-device enabled client-side-challenge-mode pass } perform-challenge-in-transparent disabled redirect-to-pool-name none signature-staging-upon-update disabled single-page-application disabled template relaxed whitelist replace-all-with { apple_touch_1 { match-order 2 url /apple-touch-icon*.png } favicon_1 { match-order 1 url /favicon.ico } } };
submit cli transaction' | tmsh -q

# add asm bot and logging
echo  -e 'create cli transaction;
modify ltm virtual /'${partition}'/'${appName}'_https profiles add { /'${partition}'/'${appName}'_bot } policies add { /'${partition}'/'${appName}'_asm_policy_https} security-log-profiles replace-all-with { /'${partition}'/'${appName}'_sec_log };
submit cli transaction' | tmsh -q


echo  -e 'create cli transaction;
create security log profile /'${partition}'/'${appName}'_sec_log application replace-all-with { /'${partition}'/'${appName}' { filter replace-all-with { log-challenge-failure-requests { values replace-all-with { enabled } } request-type { values replace-all-with { all } } } response-logging illegal } } bot-defense replace-all-with { /'${partition}'/'${appName}' { filter { log-alarm enabled log-block enabled log-browser enabled log-browser-verification-action enabled log-captcha enabled log-challenge-failure-request enabled log-device-id-collection-request enabled log-honey-pot-page enabled log-malicious-bot enabled log-mobile-application enabled log-none enabled log-rate-limit enabled log-redirect-to-pool enabled log-suspicious-browser enabled log-tcp-reset enabled log-trusted-bot enabled log-unknown enabled log-untrusted-bot enabled } local-publisher /Common/local-db-publisher } };
submit cli transaction' | tmsh -q