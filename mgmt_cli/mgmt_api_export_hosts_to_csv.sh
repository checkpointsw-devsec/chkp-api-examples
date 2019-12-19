#!/bin/bash
# Export hosts to CSV
mgmt_cli -r true -f json show hosts details-level full | jq -r '.objects[]| [.name, ."ipv4-address", .color] | @csv' > hosts.csv
# Add headers with parameter names to the CSV
sed -i '1 s/^/"name","ipv4-address", "color"\n/' hosts.csv
