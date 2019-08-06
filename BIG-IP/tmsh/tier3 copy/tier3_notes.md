proc script::run {} {
  # run me: tmsh run cli script file ./mgmt.tcl
  # create transaction
  tmsh::begin_transaction
  #create partition mgmt
  tmsh::create auth partition mgmt { }
  # jumphost
  tmsh::create ltm node ReplaceWithJumpHostIP { address ReplaceWithJumpHostIP partition mgmt }
  # forward outbound
  tmsh::create ltm virtual forward_outbound {  description forward_outbound destination /mgmt/0.0.0.0:any mask any partition mgmt persist { /Common/source_addr { default yes } } profiles { /Common/fastL4 { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address disabled translate-port disabled vlans { /Common/internal } vlans-enabled vs-index 6 }
  # jumphost http
  tmsh::create ltm pool jumphost_http_pool { members { /mgmt/ReplaceWithJumpHostIP:http { address ReplaceWithJumpHostIP session monitor-enabled state down metadata { source { value declaration } } } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open } partition mgmt }
  tmsh::create ltm virtual bigip1_mgmt_https {  description jumphost_mgmt_http destination /mgmt/ReplaceWithVIP1:http ip-protocol tcp  mask 255.255.255.255 partition mgmt persist { /Common/source_addr { default yes } } pool jumphost_http_pool profiles { /Common/f5-tcp-progressive { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled vs-index 5 }
  # jumphost https
  tmsh::create ltm pool jumphost_https_pool { members { /mgmt/ReplaceWithJumpHostIP:https { address ReplaceWithJumpHostIP session monitor-enabled state down metadata { source { value declaration } } } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open } partition mgmt }
  tmsh::create ltm virtual bigip1_mgmt_https {  description jumphost_mgmt_https destination /mgmt/ReplaceWithVIP1:https ip-protocol tcp mask 255.255.255.255 partition mgmt persist { /Common/source_addr { default yes } } pool jumphost_https_pool profiles { /Common/f5-tcp-progressive { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled vs-index 4 }
  # jumphost ssh
  tmsh::create ltm pool jumphost_ssh_pool { members { /mgmt/ReplaceWithJumpHostIP:ssh { address ReplaceWithJumpHostIP session monitor-enabled state down metadata { source { value declaration } } } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open } partition mgmt }
  tmsh::create ltm virtual jumphost_mgmt_ssh {  description jumphost_mgmt_ssh destination /mgmt/ReplaceWithVIP1:ssh ip-protocol tcp mask 255.255.255.255 partition mgmt persist { /Common/source_addr { default yes } } pool jumphost_ssh_pool profiles { /Common/f5-tcp-progressive { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled vs-index 3 }
  # submit transaction
  tmsh::commit_transaction
}


proc script::run {} {
  # create transaction
  tmsh::begin_transaction
  #create partition mgmt
  tmsh::create auth partition mgmt { }
  # jumphost
  tmsh::create ltm node /mgmt/1.2.3.4 { address 1.2.3.4 }
  # forward outbound
  tmsh::create ltm virtual /mgmt/forward_outbound { description foward_outbound destination /mgmt/0.0.0.0:any mask any persist replace-all-with { /Common/source_addr {default yes } } profiles replace-all-with { /Common/fastL4 {} } source 0.0.0.0/0 source-address-translation { type automap } translate-address disabled translate-port disabled }
  # jumphost http
  tmsh::create ltm pool /mgmt/jumphost_http_pool { members replace-all-with { /mgmt/1.2.3.4:http { address 1.2.3.4 } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open }}
  tmsh::create ltm virtual /mgmt/bigip1_mgmt_http { description jumphost_mgmt_http destination /mgmt/8.7.6.9:http ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr {default yes }} pool /mgmt/jumphost_http_pool profiles replace-all-with { /Common/f5-tcp-progressive {} } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled }
  # jumphost https
  tmsh::create ltm pool /mgmt/jumphost_https_pool { members replace-all-with { /mgmt/1.2.3.4:https { address 1.2.3.4 } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open } }
  tmsh::create ltm virtual /mgmt/bigip1_mgmt_https {  description jumphost_mgmt_https destination /mgmt/8.7.6.9:https ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr { default yes } } pool /mgmt/jumphost_https_pool profiles replace-all-with { /Common/f5-tcp-progressive { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled }
  # jumphost ssh
  tmsh::create ltm pool /mgmt/jumphost_ssh_pool { members replace-all-with { /mgmt/1.2.3.4:ssh { address 1.2.3.4 } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open }}
  tmsh::create ltm virtual /mgmt/jumphost_mgmt_ssh {  description jumphost_mgmt_ssh destination /mgmt/8.7.6.9:ssh ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr { default yes } } pool /mgmt/jumphost_ssh_pool profiles replace-all-with { /Common/f5-tcp-progressive { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled }
  # submit transaction
  tmsh::commit_transaction
}

proc script::run {} {
  # run me tmsh run cli script file ./mgmt.tcl
  # delete all
  # 
  # create transaction
  tmsh::begin_transaction
  # vs
  tmsh::delete ltm virtual /mgmt/jumphost_mgmt_ssh
  tmsh::delete ltm virtual /mgmt/bigip1_mgmt_https
  tmsh::delete ltm virtual /mgmt/bigip1_mgmt_http
  tmsh::delete ltm virtual /mgmt/forward_outbound
  # pools
  tmsh::delete ltm pool /mgmt/jumphost_ssh_pool
  tmsh::delete ltm pool /mgmt/jumphost_https_pool
  tmsh::delete ltm pool /mgmt/jumphost_http_pool
  tmsh::delete ltm node /mgmt/1.2.3.4
  # partition
  tmsh::delete auth partition mgmt
  # submit transaction
  tmsh::commit_transaction
}


proc script::run {} {
  # run me tmsh run cli script file ./delete.tcl
  # delete all
  # 
  # create transaction
  tmsh::begin_transaction
  # vs
  tmsh::delete ltm virtual /mgmt/jumphost_mgmt_ssh
  tmsh::delete ltm virtual /mgmt/bigip1_mgmt_https
  tmsh::delete ltm virtual /mgmt/bigip1_mgmt_http
  tmsh::delete ltm virtual /mgmt/forward_outbound
  # pools
  tmsh::delete ltm pool /mgmt/jumphost_ssh_pool
  tmsh::delete ltm pool /mgmt/jumphost_https_pool
  tmsh::delete ltm pool /mgmt/jumphost_http_pool
  tmsh::delete ltm node /mgmt/ReplaceWithJumpHostIP
  # submit transaction
  tmsh::commit_transaction
 
  # parition
  tmsh::begin_transaction
  # partition
  tmsh::delete auth partition mgmt
  # submit transaction
  tmsh::commit_transaction

}