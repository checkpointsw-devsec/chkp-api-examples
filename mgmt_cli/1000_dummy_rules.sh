#!/bin/bash
#====================================================================================================
# TITLE:            1000_dummy_rules.sh
# USAGE:            dos2unix ./1000_dummy_rules.sh
#                   bash 1000_dummy_rules.sh
#
# DESCRIPTION:	    Script will add a policy with 1000 dummy rules using 192.168.1.0 / 24 network
#
# AUTHOR:           Jim Oqvist (Check Point Security Management Solution Expert)
#
# VERSION:		      1.0
# DATE:             November 2021
# Tested on         R81.10
#====================================================================================================

VAR_SID=$(mgmt_cli -r true -f json login domain "SMC User" | jq -r '.sid')
mgmt_cli --session-id "$VAR_SID" -f json add package name "Thousand_dummy_rules" comments "Policy with 1000 dummy rules using 192.168.0.0 / 16 network" color "orange" tags "1000 Dummy rules"
mgmt_cli --session-id "$VAR_SID" -f json add network name "Dummy Net 168.168.1.0_24" subnet "192.168.1.0" subnet-mask "255.255.255.0" color "orange" tags "1000 Dummy rules"
mgmt_cli --session-id "$VAR_SID" -f json add access-section layer "Thousand_dummy_rules Network" position top name "Dummy rules section"
mgmt_cli --session-id "$VAR_SID" -f json add access-section layer "Thousand_dummy_rules Network" position 1 name "Clean up section"
for RULE in $(seq 1 1000)
 do 
     mgmt_cli --session-id "$VAR_SID" -f json add access-rule layer "Thousand_dummy_rules Network" position.bottom "Dummy rules section" name "Dummy Rule $RULE" source "Dummy Net 168.168.1.0_24" destination "Dummy Net 168.168.1.0_24" service "Any" | jq -r '.name'
 done
mgmt_cli --session-id "$VAR_SID" -f json publish
mgmt_cli --session-id "$VAR_SID" -f json logout
