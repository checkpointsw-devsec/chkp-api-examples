#!/bin/bash
# Execute with: # curl_cli -kLs -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/mgmt_cli/mgmt_api_add-objects-batch.sh | bash
echo Adding 4 hosts named TaskXhost, creating a group named Task4Group and adding the hosts as members to the group
mgmt_cli –r true add-objects-batch objects.1.type "host" objects.1.list.1.name "Task4Host1" objects.1.list.1.ip-address "192.0.4.1" objects.1.list.2.name "Task4Host2" objects.1.list.2.ip-address "192.0.4.2” objects.1.list.3.name "Task4Host3" objects.1.list.3.ip-address "192.0.4.3” objects.1.list.4.name "Task4Host4" objects.1.list.4.ip-address "192.0.4.4” objects.2.type "group" objects.2.list.1.name "Task4Group" objects.2.list.1.members.1 "Task4Host1" objects.2.list.2.members.2 "Task4Host2"  objects.2.list.2.members.3 "Task4Host3" objects.2.list.2.members.4 "Task4Host4"