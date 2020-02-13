#!/bin/bash
# Execute with: # curl_cli -kLs -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/mgmt_cli/mgmt_api_add-objects-batch.sh | bash
echo Adding 10 hosts named Task4hostX, adding two address ranges called Task 4 address range X, creating a group named Task4Group and adding the hosts as members to the group
varSid=$(mgmt_cli -r true -f json login | jq -r '.sid')
mgmt_cli --session-id $varSid -f json add-objects-batch objects.1.type "host" objects.1.list.1.name "Task4Host1" objects.1.list.1.ip-address "192.0.4.1" objects.1.list.2.name "Task4Host2" objects.1.list.2.ip-address "192.0.4.2" objects.1.list.3.name "Task4Host3" objects.1.list.3.ip-address "192.0.4.3" objects.1.list.4.name "Task4Host4" objects.1.list.4.ip-address "192.0.4.4" objects.1.list.5.name "Task4Host5" objects.1.list.5.ip-address "192.0.4.5" objects.1.list.6.name "Task4Host6" objects.1.list.6.ip-address "192.0.4.6" objects.1.list.7.name "Task4Host7" objects.1.list.7.ip-address "192.0.4.7" objects.1.list.8.name "Task4Host8" objects.1.list.8.ip-address "192.0.4.8" objects.1.list.9.name "Task4Host9" objects.1.list.9.ip-address "192.0.4.9" objects.1.list.10.name "Task4Host10" objects.1.list.10.ip-address "192.0.4.1" objects.2.type "address-range" objects.2.list.1.name "Task 4 Address Range 1" objects.2.list.1.ip-address-first "192.0.2.1" objects.2.list.1.ip-address-last "192.0.2.10" objects.2.list.2.name "Task 4 Address Range 2" objects.2.list.2.ip-address-first "192.0.2.12" objects.2.list.2.ip-address-last "192.0.2.20"

mgmt_cli --session-id $varSid -f json add-group name "Task4Group" members.1 "Task4Host1" members.2 "Task4Host2" members.3 "Task4Host3" members.4 "Task4Host4"

mgmt_cli --session-id $varSid -f json publish

mgmt_cli --session-id $varSid -f json logout
