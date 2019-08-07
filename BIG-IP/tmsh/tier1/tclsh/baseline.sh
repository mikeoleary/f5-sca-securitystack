#!/user/bin/bash
# bash ./baseline.sh "tmsh run cli script file ./mgmt.tcl"
# bash ./baseline.sh "tmsh run cli script file ./delete.tcl"

command=$1

if [[ $($command) ]]; then
    echo "mgmt deployment failed"
else
    echo "mgmt deployment successful"
fi

# example:
# [root@ilxdev:Active:Standalone] config # bash ./baseline.sh "tmsh run cli script file ./mgmt.tcl"
# mgmt deployment successful
# [root@ilxdev:Active:Standalone] config #