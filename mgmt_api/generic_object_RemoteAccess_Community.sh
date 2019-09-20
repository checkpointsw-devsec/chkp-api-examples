# Add
varSid=$(mgmt_cli -r true -d "SMC User" -f json login | jq -r '.sid')
varGWUid=$(mgmt_cli --session-id $varSid -f json show-generic-objects name gw1 | jq -r '.objects[].uid')
varRAUid=$(mgmt_cli --session-id $varSid -f json show-generic-objects name RemoteAccess | jq -r '.objects[].uid')
mgmt_cli --session-id $varSid -f json set-generic-object uid $varRAUid participantGateways.add $varGWUid
mgmt_cli --session-id $varSid -f json publish
mgmt_cli --session-id $varSid -f json logout

# Remove
varSid=$(mgmt_cli -r true -d "SMC User" -f json login | jq -r '.sid')
varGWUid=$(mgmt_cli --session-id $varSid -f json show-generic-objects name gw1 | jq -r '.objects[].uid')
varRAUid=$(mgmt_cli --session-id $varSid -f json show-generic-objects name RemoteAccess | jq -r '.objects[].uid')
mgmt_cli --session-id $varSid -f json set-generic-object uid $varRAUid participantGateways.remove $varGWUid
mgmt_cli --session-id $varSid -f json publish
mgmt_cli --session-id $varSid -f json logout