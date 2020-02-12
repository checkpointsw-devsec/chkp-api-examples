#!/bin/bash
# Execute with: 
# curl_cli -kLs -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/jimoq/CHKP_api_examples/master/mgmt_cli/mgmt_api_add-simple-cluster.sh | bash
#
mgmt_cli -r true add-simple-cluster \
  name "cluster1" color "yellow" \
  version "R80.20" \
  ip-address "172.23.23.30" \
  os-name "Gaia" \
  cluster-mode "cluster-xl-ha" \
  firewall true \
  vpn false \
\
interfaces.0.name "eth0" \
  interfaces.0.ip-address "172.23.23.100" \
  interfaces.0.network-mask "255.255.255.0" \
  interfaces.0.interface-type "cluster" \
  interfaces.0.topology "EXTERNAL" \
  interfaces.0.anti-spoofing true \
  interfaces.1.name "eth1" \
  interfaces.1.ip-address "1.1.2.3" \
  interfaces.1.network-mask "255.255.255.0" \
  interfaces.1.interface-type "sync" \
  interfaces.1.topology "INTERNAL" \
  interfaces.1.topology-settings.ip-address-behind-this-interface "network defined by the interface ip and net mask" \
  interfaces.1.topology-settings.interface-leads-to-dmz false interfaces.2.name "eth2" \
\
interfaces.2.ip-address "192.168.1.1" \
  interfaces.2.network-mask "255.255.255.0" \
  interfaces.2.interface-type "cluster" \
  interfaces.2.topology "INTERNAL" \
  interfaces.2.anti-spoofing true \
  interfaces.2.topology-settings.ip-address-behind-this-interface "network defined by the interface ip and net mask" \
  interfaces.2.topology-settings.interface-leads-to-dmz false \
  interfaces.4.name "eth3.1" \
  interfaces.4.ip-address "10.1.1.1" \
  interfaces.4.network-mask "255.255.255.0" \
  interfaces.4.interface-type "cluster" \
  interfaces.4.topology "INTERNAL" \
  interfaces.4.anti-spoofing true \
\
members.0.name "member-1" \
  members.0.ip-address "172.23.23.32" \
  members.0.interfaces.0.name "eth0" \
  members.0.interfaces.0.ip-address "172.23.23.32" \
  members.0.interfaces.0.network-mask "255.255.255.0" \
  members.0.interfaces.1.name "eth1" \
  members.0.interfaces.1.ip-address "1.1.2.4" \
  members.0.interfaces.1.network-mask "255.255.255.0" \
  members.0.interfaces.2.name "eth2" \
  members.0.interfaces.2.ip-address "192.168.1.4" \
  members.0.interfaces.2.network-mask "255.255.255.0" \
  members.0.interfaces.4.name "eth3.1" \
  members.0.interfaces.4.ip-address "10.1.1.3" \
  members.0.interfaces.4.network-mask "255.255.255.0" \
\
members.1.name "member-2" \
  members.1.ip-address "172.23.23.33" \
  members.1.interfaces.0.name "eth0" \
  members.1.interfaces.0.ip-address "172.23.23.33" \
  members.1.interfaces.0.network-mask "255.255.255.0" \
  members.1.interfaces.1.name "eth1" \
  members.1.interfaces.1.ip-address "1.1.2.5" \
  members.1.interfaces.1.network-mask "255.255.255.0" \
  members.1.interfaces.2.name "eth2" \
  members.1.interfaces.2.ip-address "192.168.1.5" \
  members.1.interfaces.2.network-mask "255.255.255.0" \
  members.1.interfaces.4.name "eth3.1" \
  members.1.interfaces.4.ip-address "10.1.1.4" \
  members.1.interfaces.4.network-mask "255.255.255.0"
