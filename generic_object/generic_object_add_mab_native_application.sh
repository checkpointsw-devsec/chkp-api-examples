#!/bin/bash
#====================================================================================================
# TITLE:            generic_object_add_mab_native_application.sh
# USAGE:            bash generic_object_add_dynamic_global_network_object.sh <object_name>
#
# DESCRIPTION:	    This script will creat an native mobile application where: 
#                   a link is piblished on the portal with a embedded app
#                   by default the domain is SMC User, for MDS chnage the script to correct domain.
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
  exit 1
}

# Start the script and check that all parameters are added as required
[[ $# -eq 0 ]] && usage

# Login
var_sid=$(mgmt_cli -r true -f json login domain "SMC User" | jq -r '.sid')

# Get Authorized network, group or host object uid
var_authorized_host=$(mgmt_cli --session-id "$var_sid" -f json show generic-objects name "hst my intranet site" | jq -r '.objects[].uid')

# Get authorized service object uid
var_authorized_service=$(mgmt_cli --session-id "$var_sid" -f json show generic-objects name "http" | jq -r '.objects[].uid')

# Get embedded app object uid
var_embedded_app=$(mgmt_cli --session-id "$var_sid" -f json show generic-objects name "SSH" | jq -r '.objects[].uid')

# Create mobile access native application and add a host and a service under "Authorized Locations > advanced"
mgmt_cli  --session-id "$var_sid" add generic-object name ""$1"" singleHost "false" \
create "com.checkpoint.objects.connectra_classes.dummy.CpmiNativeApplication" \
authorizedLocations.1.create "com.checkpoint.objects.connectra_classes.dummy.CpmiHostsAndServicesForNativeApplication" \
authorizedLocations.1.owned-object.hosts.add "$var_authorized_host" \
authorizedLocations.1.owned-object.services.add "$var_authorized_service" \
portalLinks.1.create "com.checkpoint.objects.connectra_classes.dummy.CpmiLinkToApplicationInThePortalForNativeApp" \
portalLinks.1.owned-object.linkDisplayName "SSH App Embedded"  \
portalLinks.1.owned-object.displayLinkInSnxAppMode "true" \
portalLinks.1.owned-object.useApplicationLink "true"  \
portalLinks.1.owned-object.applicationType "EMBEDDED" \
portalLinks.1.owned-object.parameters "1.2.3.4" \
portalLinks.1.owned-object.embeddedApplication "$var_embedded_app" \
singleApplication  "false"

mgmt_cli  --session-id "$var_sid" publish
mgmt_cli  --session-id "$var_sid" logout