#!/bin/bash
EXTIP='10.0.2.40'
EXTPRIVIP='10.0.2.30'
MGMTIP=$(/sbin/ifconfig mgmt | grep 'inet' | cut -d: -f2 | awk '{print $2}')
/sbin/ip route add 169.254.169.254/32 via $MGMTIP dev mgmt 2>/dev/null
HOSTNAME=`curl -s -f --retry 20 http://169.254.169.254/latest/meta-data/hostname`
INTIP='10.0.3.160'
PEER_EXTPRIVIP='10.0.2.13'
VIPEIP='3.224.194.235'
PROGNAME=$(basename $0)
function error_exit {
echo "${PROGNAME}: ${1:-\"Unknown Error\"}" 1>&2
exit 1
}
declare -a tmsh=()
echo 'starting custom-config.sh'
tmsh+=(
"tmsh modify sys db dhclient.mgmt { value disable }"
"tmsh modify cm device ${HOSTNAME} unicast-address { { effective-ip ${INTIP} effective-port 1026 ip ${INTIP} } }"
"tmsh load sys application template /config/cloud/aws/f5.service_discovery.tmpl"
"tmsh load sys application template /config/cloud/aws/f5.cloud_logger.v1.0.0.tmpl"
"tmsh save /sys config")
for CMD in "${tmsh[@]}"
do
  "/config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/waitForMcp.sh"
    if $CMD;then
        echo "command $CMD successfully executed."
    else
        error_exit "$LINENO: An error has occurred while executing $CMD. Aborting!"
    fi
done
date
### START CUSTOM CONFIGURATION
source /config/cloud/aws/onboard_config_vars
deployed="no"
url_regex="(http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$"
file_loc="/config/cloud/custom_config"
if [[ $declarationUrl =~ $url_regex ]]; then
  response_code=$(/usr/bin/curl -sk -w "%{http_code}" $declarationUrl -o $file_loc)
  if [[ $response_code == 200 ]]; then
    echo "Custom config download complete; checking for valid JSON."
    cat $file_loc | jq .class
    if [[ $? == 0 ]]; then
      response_code=$(/usr/bin/curl -skvvu ${adminUsername}:$passwd -w "%{http_code}" -X POST -H "Content-Type: application/json" https://localhost:${managementGuiPort}/mgmt/shared/appsvcs/declare -d @$file_loc -o /dev/null)
      if [[ $response_code == 200 || $response_code == 502 ]]; then
        echo "Deployment of custom application succeeded."
        deployed="yes"
      else
         echo "Failed to deploy custom application; continuing..."
      fi
    else
      echo "Custom config was not valid JSON, continuing..."
    fi
  else
    echo "Failed to download custom config; continuing..."
  fi
else
  echo "Custom config was not a URL, continuing..."
fi
### END CUSTOM CONFIGURATION