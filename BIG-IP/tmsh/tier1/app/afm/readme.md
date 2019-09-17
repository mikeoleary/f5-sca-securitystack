# create rule list
<!-- security firewall rule-list app2 { rules { http { action accept-decisively ip-protocol tcp protocol-inspection-profile /Common/protocol_inspection rule-number 1 uuid 0146eee5-4539-506c-ff2e-160b3f092e28 destination { ports { http { } } } } https { action accept-decisively ip-protocol tcp protocol-inspection-profile /Common/protocol_inspection rule-number 2 uuid 0143096a-7d74-506c-ff2e-160b46e31745 destination { ports { https { } } } } } } -->

create security firewall rule-list app1 { rules replace-all-with { http { action accept-decisively ip-protocol tcp protocol-inspection-profile /Common/protocol_inspection uuid auto-generate destination { ports replace-all-with { http { } } } } https { action accept-decisively ip-protocol tcp protocol-inspection-profile /Common/protocol_inspection uuid auto-generate destination { ports replace-all-with { https { } } } } } }

# create policy
<!-- security firewall policy app2 { rules { _Common_app2 { rule-list app2 rule-number 1 } deny { action drop ip-protocol any log yes rule-number 2 uuid 013c0051-c0b1-506c-ff2e-160be629e23d } } } -->

create security firewall policy app1 { rules replace-all-with { _Common_app1 { rule-list app1 } deny { action drop ip-protocol any log yes uuid auto-generate } } }

# create log profiles
<!-- security log profile app2_afm { ip-intelligence { log-publisher local-db-publisher } network { app2_afm { publisher local-db-publisher } } protocol-inspection { log-publisher local-db-publisher } } -->

create security log profile app1_afm { ip-intelligence { log-publisher local-db-publisher } network replace-all-with { app1_afm { publisher local-db-publisher } } protocol-inspection { log-publisher local-db-publisher } }

# attach to virtual
modify ltm virtual /app1/app1_https fw-enforced-policy /app1/app1 security-log-profiles add { /app1/app1_afm }


# save config
tmsh save sys config
