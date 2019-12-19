#!/bin/bash
# Execute with: # curl_cli -kLs -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/mgmt_cli/mgmt_api_export_hosts_to_csv.sh | bash
echo Export hosts to CSV
mgmt_cli -r true -f json show hosts details-level full | jq -r '.objects[]| [.name, ."ipv4-address", .color] | @csv' | tee hosts.csv
echo Add headers with parameter names to the CSV
sed -i '1 s/^/"name","ipv4-address", "color"\n/' hosts.csv
echo data is exported to hosts.csv
