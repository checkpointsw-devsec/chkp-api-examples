# Add
#varSid=$(mgmt_cli -r true -d "SMC User" -f json login | jq -r '.sid')
#varGWUid=$(mgmt_cli --session-id $varSid -f json show-generic-objects name gw1 | jq -r '.objects[].uid')
#varRAUid=$(mgmt_cli --session-id $varSid -f json show-generic-objects name RemoteAccess | jq -r '.objects[].uid') # jq -r '.objects[] | select(.type == "CpmiGatewayCluster") | .uid' if you are working with a cluster object
#mgmt_cli --session-id $varSid -f json set-generic-object uid $varRAUid participantGateways.add $varGWUid
#mgmt_cli --session-id $varSid -f json publish
#mgmt_cli --session-id $varSid -f json logout

# Remove
#varSid=$(mgmt_cli -r true -d "SMC User" -f json login | jq -r '.sid')
#varGWUid=$(mgmt_cli --session-id $varSid -f json show-generic-objects name gw1 | jq -r '.objects[].uid')
#varRAUid=$(mgmt_cli --session-id $varSid -f json show-generic-objects name RemoteAccess | jq -r '.objects[].uid') # jq -r '.objects[] | select(.type == "CpmiGatewayCluster") | .uid' if you are working with a cluster object
#mgmt_cli --session-id $varSid -f json set-generic-object uid $varRAUid participantGateways.remove $varGWUid
#mgmt_cli --session-id $varSid -f json publish
#mgmt_cli --session-id $varSid -f json logout

# this is how a interactive script could look like when adding 
#!/bin/bash
read -p "Enter gateway name to add into RemoteAccess comunity: " varGW
read -p "Enter management server IP : " varMgtIP
read -p "Enter domain name: (if this is a smartCenter please enter \"SMC User\" as domain: " varMgtDomain
read -p "Enter admin username : " varAdmin
read -s -p "Enter admin password : " varPwd
printf "\n"
varSid=$(mgmt_cli -m $varMgtIP -d $varMgtDomain -f json login user $varAdmin password $varPwd | jq -r '.sid')
varGWUid=$(mgmt_cli -m $varMgtIP --session-id $varSid -f json show-generic-objects name $varGW | jq -r '.objects[].uid')
# change jq command to "jq -r '.objects[] | select(.type == "CpmiGatewayCluster") | .uid'" if you are working with a cluster object
varRAUid=$(mgmt_cli -m $varMgtIP --session-id $varSid -f json show-generic-objects name RemoteAccess | jq -r '.objects[].uid')
mgmt_cli -m $varMgtIP --session-id $varSid -f json set-generic-object uid $varRAUid participantGateways.add $varGWUid
mgmt_cli -m $varMgtIP --session-id $varSid -f json publish
mgmt_cli -m $varMgtIP --session-id $varSid -f json logout
