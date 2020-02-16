#!\bin\bash
# Execute with: # curl_cli -kLs https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/mgmt_cli/gaia_api_set-password-policy.sh | bash
#
#!/bin/bash

# Define the inventory file
inventory="/tmp/gaia_api_set-password-policy-inventory.out"

# Define the report file
report="/tmp/password_complexity_report_for_auditor.csv"

# Create headers for csv file
echo "hostname,password-repeated-history-length,password-check-history-enabled,password-complexity,password-minimum-length" > $report

# Define the function to set password policy
function set-password-complexity()
{
  while IFS= read -r gaia_ip
  do
    # Login to GAiA
	gaia_sid=$(mgmt_cli login \
	  --management $gaia_ip \
	  --context gaia_api \
	  --unsafe-auto-accept true \
	  --format json \
	  user $uid \
	  password $pwd \
	| jq -r '.sid')

	# Get GAiA hostname
	gaia_hostname=$(mgmt_cli show-hostname \
      --management $gaia_ip \
      --version 1.3 \
      --context gaia_api \
	  --unsafe-auto-accept true \
      --session-id $gaia_sid \
      --format json \
	| jq -r '.name')
	echo "Processing $gaia_hostname"

    # Set GAiA password policy and store the result
	mgmt_cli set-password-policy \
      --management $gaia_ip \
      --version 1.3 \
      --context gaia_api \
	  --unsafe-auto-accept true \
      --session-id $gaia_sid \
      --format json \
	  password-history.repeated-history-length 12 \
      password-history.check-history-enabled true \
      password-strength.complexity 3 \
      password-strength.minimum-length 12 \
	| jq -r --arg hostname "$gaia_hostname" '[$hostname, ."password-history"."repeated-history-length", ."password-history"."check-history-enabled", ."password-strength"."complexity", ."password-strength"."minimum-length"] | @csv' >> $report
  done < "$inventory"
}

#Get the login credentials for GAiA
printf "\n"
read -p "Enter GAiA admin username : " uid
read -s -p "Enter GAiA admin password : " pwd
printf "\n"

# Login to the management sever
mgmt_sid=$(mgmt_cli login --unsafe-auto-accept true --root true --format json | jq -r '.sid')

# Get all the Check Point Gatways and servers from the management database
gw_and_srv=$(mgmt_cli show-gateways-and-servers details-level full --session-id $mgmt_sid -f json)

# Build the inventory list of Check Point Gateways and Servers
echo "$gw_and_srv" | jq -r '.objects[] | select((.type != "CpmiGatewayCluster") and ."sic-status" == "communicating") | ."ipv4-address"' > $inventory

# Run the funtion to set password policy
set-password-complexity

# Cleanup
rm $inventory

# Notifying user
printf "\n"
printf "Password policy set on all GAiA systems\n"
printf "The report is stored in $report\n"
printf "\n"