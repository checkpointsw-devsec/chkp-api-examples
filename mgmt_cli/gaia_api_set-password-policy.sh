#!\bin\bash
# Execute with: # curl_cli -kLs -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/mgmt_cli/gaia_api_set-password-policy.sh | bash
#
uid=admin
pwd=vpn123
mgmt_sid=$(mgmt_cli login user $uid password $pwd -f json | jq -r '.sid')
gaia_sid=$(mgmt_cli login user $uid password $pwd --context gaia_api -f json | jq -r '.sid')

gw_and_srv=$(mgmt_cli show-gateways-and-servers details-level full --session-id $mgmt_sid -f json)

gaia_ip=$(echo "$gw_and_srv" | jq -r '.objects[] | select((.type != "CpmiGatewayCluster") and ."sic-status" == "communicating") | ."ipv4-address"')

rm -f pasword_complexity_report_for_auditor.out
mgmt_cli show-hostname \
  -m $gaia_ip \
  --version 1.3 \
  --context gaia_api \
  --session-id $gaia_sid \
  --format json \
| tee -a pasword_complexity_report_for_auditor.out
mgmt_cli set-password-policy \
  password-history.check-history-enabled true \
  password-history.repeated-history-length 12 \
  password-strength.complexity 3 \
  password-strength.minimum-length 12 \
  --management $gaia_ip \
  --version 1.3 \
  --context gaia_api \
  --session-id $gaia_sid \
  --format json \
| tee -a pasword_complexity_report_for_auditor.out
