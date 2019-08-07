proc script::run {node,virtual} {
  # run me tmsh run cli script file ./delete.tcl
  # constants
  set node "1.2.3.4"
  set virtual "6.7.8.9"
  # delete all
  # 
  # create transaction
  tmsh::begin_transaction
  tmsh::create ltm node /mgmt/$node { address $node }
  
  # submit transaction
  tmsh::commit_transaction
 
}

#  run cli script file ./new.tcl verbatim-arguments "1.2.3.4","6.7.8.9"
set standard_maintenance_vips { }
set vips_standard [tmsh::get_config /ltm virtual $standard_maintenance_vips]
foreach vip $vips_standard {
puts [tmsh::get_name $vip]


proc script::run {} {
set standard_maintenance_vips { }
set vips_standard [tmsh::get_config /ltm virtual $standard_maintenance_vips]
foreach vip $vips_standard {
puts [tmsh::get_name $vip]
}
}