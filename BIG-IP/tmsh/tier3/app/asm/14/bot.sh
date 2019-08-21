#!/usr/bin/bash
# partition
partition="app2"
# app name
appName="app2"

#create security bot-defense profile /app2/app2 { allow-browser-access enabled api-access-strict-mitigation enabled app-service none blocking-page {  type default } browser-mitigation-action block captcha-response { failure {  type default } first { type default } } cross-domain-requests allow-all description none deviceid-mode generate-after-access  dos-attack-strict-mitigation enabled enforcement-mode transparent enforcement-readiness-period 7 grace-period 300 honeypot-page {  type default } mobile-detection { allow-android-rooted-device disabled allow-any-android-package enabled allow-any-ios-package enabled allow-emulators disabled allow-jailbroken-devices disabled block-debugger-enabled-device enabled client-side-challenge-mode pass } perform-challenge-in-transparent disabled redirect-to-pool-name none signature-staging-upon-update disabled single-page-application disabled template relaxed whitelist replace-all-with { apple_touch_1 { match-order 2 url /apple-touch-icon*.png } favicon_1 { match-order 1 url /favicon.ico } } }
# add BotDef and logging profile
echo  -e 'create cli transaction;
create security log profile /'${partition}'/'${appName}'_sec_log application replace-all-with { /'${partition}'/'${appName}' { filter replace-all-with {  request-type { values replace-all-with { all } } } response-logging illegal } } bot-defense replace-all-with { /'${partition}'/'${appName}' { filter { log-alarm enabled log-block enabled log-browser enabled log-browser-verification-action enabled log-captcha enabled log-device-id-collection-request enabled log-malicious-bot enabled log-mobile-application enabled log-none enabled log-rate-limit enabled log-suspicious-browser enabled log-tcp-reset enabled log-trusted-bot enabled log-unknown enabled log-untrusted-bot enabled } local-publisher /Common/local-db-publisher } };
create security bot-defense profile /'${partition}'/'${appName}'_bot {  api-access-strict-mitigation enabled app-service none blocking-page {  type default }  captcha-response { failure {  type default } first { type default } } cross-domain-requests allow-all description none deviceid-mode generate-after-access  dos-attack-strict-mitigation enabled enforcement-mode transparent enforcement-readiness-period 7 grace-period 300  mobile-detection { allow-android-rooted-device disabled allow-any-android-package enabled allow-any-ios-package enabled allow-emulators disabled allow-jailbroken-devices disabled block-debugger-enabled-device enabled client-side-challenge-mode pass } perform-challenge-in-transparent disabled signature-staging-upon-update disabled single-page-application disabled template relaxed whitelist replace-all-with { apple_touch_1 { match-order 2 url /apple-touch-icon*.png } favicon_1 { match-order 1 url /favicon.ico } } };
submit cli transaction' | tmsh -q

allow-browser-access enabled
browser-mitigation-action block
honeypot-page {  type default }
redirect-to-pool-name none

#create security bot-defense profile /'${partition}'/'${appName}'_bot {  api-access-strict-mitigation enabled app-service none blocking-page {  type default }  captcha-response { failure {  type default } first { type default } } cross-domain-requests allow-all description none deviceid-mode generate-after-access  dos-attack-strict-mitigation enabled enforcement-mode transparent enforcement-readiness-period 7 grace-period 300  mobile-detection { allow-android-rooted-device disabled allow-any-android-package enabled allow-any-ios-package enabled allow-emulators disabled allow-jailbroken-devices disabled block-debugger-enabled-device enabled client-side-challenge-mode pass } perform-challenge-in-transparent disabled signature-staging-upon-update disabled single-page-application disabled template relaxed whitelist replace-all-with { apple_touch_1 { match-order 2 url /apple-touch-icon*.png } favicon_1 { match-order 1 url /favicon.ico } } };

log-challenge-failure-requests { values replace-all-with { enabled } }
log-challenge-failure-request enabled
log-honey-pot-page enabled
log-redirect-to-pool enabled

#create security log profile /app2/app2_sec_log application replace-all-with { /app2/app2 { filter replace-all-with {  request-type { values replace-all-with { all } } } response-logging illegal } } bot-defense replace-all-with { /app2/app2 { filter { log-alarm enabled log-block enabled log-browser enabled log-browser-verification-action enabled log-captcha enabled log-device-id-collection-request enabled log-malicious-bot enabled log-mobile-application enabled log-none enabled log-rate-limit enabled log-suspicious-browser enabled log-tcp-reset enabled log-trusted-bot enabled log-unknown enabled log-untrusted-bot enabled } local-publisher /Common/local-db-publisher } };
