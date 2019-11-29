#!/bin/bash
#====================================================================================================
# TITLE:            generic_object_add_identity_tag.sh
# USAGE:            bash generic_object_add_identity_tag.sh <object_name> <external_identifier>
#
# DESCRIPTION:	    This script will creat an Identity Tag object where: 
#                   object_name is the name of the object as it will be seen in Check Point management
#                   external_identifier is the Cisco Security Group Tag as defined in Cisco ISE or 
#                   a custom tag (defined on a third party product) acquired through the Check Point Identity Web API
#
# AUTHORS:          Jim Oqvist | Check Point Security Management Solution Expert 
#
# VERSION:	        1.0
#====================================================================================================
function usage()
{
  echo ""
  echo "Usage:"
  echo "bash $0 <object_name> <external_identifier>"
  echo ""
  echo "<object_name> is the name of the object as it will be seen in Check Point management"
  echo "<external_identifier> is the Cisco Security Group Tag as defined in Cisco ISE or"
  echo "a custom tag (defined on a third party product) acquired through the Check Point Identity Web API"
  exit 1
}

# Start the script and check that all parameters are added as required
[[ $# -eq 0 ]] && usage

mgmt_cli -r true -f json add-generic-object create "com.checkpoint.management.identity_awareness.objects.CpmiIdentityTag" name "$1" tag "$2"