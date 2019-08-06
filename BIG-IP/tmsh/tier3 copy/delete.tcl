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