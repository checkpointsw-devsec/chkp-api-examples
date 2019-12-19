#!/bin/bash
# Execute with: # curl_cli -kLs -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/mgmt_cli/mgmt_api_export_hosts_to_csv.sh | bash
echo Export hosts to CSV
hosts=$(mgmt_cli -r true -f json show hosts details-level full)
echo $hosts |  jq -r '.objects[]| [.name, ."ipv4-address", .color] | @csv' | tee add_hosts.csv
echo $hosts |  jq -r '.objects[]| [.name] | @csv' | tee delete_hosts.csv
echo Add headers with parameter names to the CSV
sed -i '1 s/^/"name","ipv4-address", "color"\n/' add_hosts.csv
sed -i '1 s/^/"name"\n/' delete_hosts.csv
echo data is exported to add_hosts.csv and delete_hosts.csv
