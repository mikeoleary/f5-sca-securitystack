bigip_username="admin"
bigip_password=""
bigip_host="localhost"
bigip_port="8100"


curl -sk -u ${bigip_username}:${bigip_password} -H "Content-type: application/json" -X PATCH --data @iapp-payload.json http://${bigip_host}:${bigip_port}/mgmt/tm/sys/application/service/~Common~www_sd.app~www_sd?ver=14.1.0 | python -m json.tool

# testing
curl -sk -u ${bigip_username}:${bigip_password} -H "Content-type: application/json" -X PATCH--data @iapp-payload.json http://${bigip_host}:${bigip_port}/mgmt/tm/sys/application/service/~Common~www_sd.app~www_sd?ver=14.1.0 | python -m json.tool

# 
create sys application service www_sd template f5.service_discovery


aws resourcegroupstaggingapi get-resources --tag-filters Key=Application,Values=[f5app]

aws ec2 describe-instances --filters Name=tag-key,Values=Application --query
aws ec2 describe-instances --filters Name=tag-key,Values=Application --query 'Reservations[].Instances[]'
