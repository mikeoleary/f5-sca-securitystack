proc script::run {} {
  # create transaction
  tmsh::begin_transaction
  #create partition mgmt
  tmsh::create auth partition mgmt { }
  # jumphost
  tmsh::create ltm node /mgmt/ReplaceWithJumpHostIP { address ReplaceWithJumpHostIP }
  # forward outbound
  tmsh::create ltm virtual /mgmt/forward_outbound { description foward_outbound destination /mgmt/0.0.0.0:any mask any persist replace-all-with { /Common/source_addr {default yes } } profiles replace-all-with { /Common/fastL4 {} } source 0.0.0.0/0 source-address-translation { type automap } translate-address disabled translate-port disabled }
  # jumphost http
  tmsh::create ltm pool /mgmt/jumphost_http_pool { members replace-all-with { /mgmt/ReplaceWithJumpHostIP:http { address ReplaceWithJumpHostIP } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open }}
  tmsh::create ltm virtual /mgmt/bigip1_mgmt_http { description jumphost_mgmt_http destination /mgmt/ReplaceWithVIP1:http ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr {default yes }} pool /mgmt/jumphost_http_pool profiles replace-all-with { /Common/f5-tcp-progressive {} } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled }
  # jumphost https
  tmsh::create ltm pool /mgmt/jumphost_https_pool { members replace-all-with { /mgmt/ReplaceWithJumpHostIP:https { address ReplaceWithJumpHostIP } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open } }
  tmsh::create ltm virtual /mgmt/bigip1_mgmt_https {  description jumphost_mgmt_https destination /mgmt/ReplaceWithVIP1:https ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr { default yes } } pool /mgmt/jumphost_https_pool profiles replace-all-with { /Common/f5-tcp-progressive { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled }
  # jumphost ssh
  tmsh::create ltm pool /mgmt/jumphost_ssh_pool { members replace-all-with { /mgmt/ReplaceWithJumpHostIP:ssh { address ReplaceWithJumpHostIP } } min-active-members 1 monitor min 1 of { /Common/tcp_half_open }}
  tmsh::create ltm virtual /mgmt/jumphost_mgmt_ssh {  description jumphost_mgmt_ssh destination /mgmt/ReplaceWithVIP1:ssh ip-protocol tcp mask 255.255.255.255 persist replace-all-with { /Common/source_addr { default yes } } pool /mgmt/jumphost_ssh_pool profiles replace-all-with { /Common/f5-tcp-progressive { } } source 0.0.0.0/0 source-address-translation { type automap } translate-address enabled translate-port enabled }
  # submit transaction
  tmsh::commit_transaction
}