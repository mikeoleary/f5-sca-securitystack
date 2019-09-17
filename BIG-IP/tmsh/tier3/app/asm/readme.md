# https://github.com/f5devcentral/f5-asm-policy-templates
# https://raw.githubusercontent.com/f5devcentral/f5-asm-policy-templates/master/owasp_ready_template/owasp-auto-tune-v1.1.xml
# create policy 
load asm policy file /config/owasp-auto-tune.xml

# expects
root@(ilxdev)(cfg-sync Standalone)(Active)(/Common)(tmos)# load asm policy file /config/owasp-auto-tune.xml
The imported policy has been loaded as /Common/owasp-auto-tune

# create taffic policy
create ltm policy /app1/Drafts/app1_asm_policy_https controls add { asm } rules add { default { actions add { 1 { asm enable policy /Common/owasp-auto-tune} } ordinal 1 } } strategy /Common/first-match

# publish policy
publish ltm policy /app1/Drafts/app1_asm_policy_https
# attach to virtual

modify ltm virtual /app1/app1_https policies add { /app1/app1_asm_policy_https} profiles add { http websecurity } 

# log profile
modify ltm virtual /app1/app1_https security-log-profiles add { "Log all requests" }
 
# save config
tmsh save sys config
