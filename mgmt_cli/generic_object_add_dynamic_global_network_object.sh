#!/bin/bash
#====================================================================================================
# TITLE:            generic_object_add_dynamic_global_network_object.sh
# USAGE:            bash generic_object_add_dynamic_global_network_object.sh <object_name>
#
# DESCRIPTION:	    This script will creat an Dynamic Global_Network_Object where: 
#                   object_name is the name of the object as it will be seen in Check Point management
#                   This object can only be created in the global domain of a MDS
#
# AUTHORS:          Jim Oqvist | Check Point Security Management Solution Expert 
#
# VERSION:	        1.0
#====================================================================================================
function usage()
{
  echo ""
  echo "Usage:"
  echo "bash $0 <object_name>"
  echo ""
  echo "<object_name> is the name of the object as it will be seen in Check Point management"
  echo "This object can only be created in the global domain of a MDS"
  exit 1
}

# Start the script and check that all parameters are added as required
[[ $# -eq 0 ]] && usage

mgmt_cli -r true -d Global -f json add-generic-object create "com.checkpoint.blades_common.objects.DynamicGlobalNetworkObject" name "$1"
