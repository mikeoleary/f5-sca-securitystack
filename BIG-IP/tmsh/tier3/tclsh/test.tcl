proc script::run {node,virtual} {
  # expects node virtual
  # run me tmsh run cli script file ./delete.tcl
  # constants
  set node $tmsh::argv 0
  set virtual $tmsh::argv 1
  # delete all
  # 
  # create transaction
  tmsh::begin_transaction
  tmsh::create ltm node /mgmt/$node { address $node }
  
  # submit transaction
  tmsh::commit_transaction
 
}