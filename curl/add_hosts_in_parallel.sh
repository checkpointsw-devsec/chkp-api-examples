#!/bin/bash
#====================================================================================================
# TITLE:            add_hosts_in_parallel.sh
# USAGE:            dos2unix ./add_hosts_in_parallel.sh
#                   bash add_hosts_in_parallel.sh
#
# DESCRIPTION:	    Script will in parallel create X number of host using curl.
#
# AUTHOR:           Jim Oqvist (Check Point Security Management Solution Expert)
#
# VERSION:		      1.2
# DATE:             April 2018
#====================================================================================================
#====================================================================================================
#  variabels
#====================================================================================================
# R80.10 Secuity Management API URL
read -p "Enter management server IP : " varMgtIP
read -p "Enter admin username : " varAdmin
read -s -p "Enter admin password : " varPwd
printf "\n"
read -p "Enter number of subnets to create (max 254) : " varSub
read -p "Enter number of host in each subnet (max 254) : " varHost
printf "\n"
var_api_url="https://$varMgtIP/web_api"
var_curl=curl_cli
#====================================================================================================
# Timestamp start of script
#====================================================================================================
s_time=$(/bin/date)
#====================================================================================================
#  Login to management server and retrive the session_id
#====================================================================================================
printf "\nStart" 1>  add_hosts_in_parallel.out
printf "\n\n############# Logging in, creating policy API_Policy ###############\n\n" | tee -a add_hosts_in_parallel.out
SID=`$var_curl -k -H "Content-Type: application/json" -X POST -d '{  "user" : "'$varAdmin'", "password" : "'$varPwd'", "domain" : "SMC User"}' $var_api_url/login 2> add_hosts_in_parallel.err | jq '.sid' | sed s/\"//g`
#====================================================================================================
# Add hosts in parallel (https://$varMgtIP/web_api/add-host)
#====================================================================================================
printf "\n\n############# Adding hosts and groups at: $s_time ###############\n\n" | tee -a add_hosts_in_parallel.out
for s in $(seq 1 $varSub)
    do 
         for h in $(seq 1 $varHost); 
            do
	        echo 192.168.$s.$h
            $var_curl -k -H "Content-Type: application/json" -H "X-chkp-sid: $SID" -X POST -d '{  "name" : "host_192.168.'$s'.'$h'", "ip-address" : "192.168.'$s'.'$h'" }' $var_api_url/add-host 2>> add_hosts_in_parallel.err 1>> add_hosts_in_parallel.out &
            printf "#"
			sleep 0.3
        done
    done
printf "## Waiting for hosts to be created##"
wait	
pre_host_pub_time=$(/bin/date)
#====================================================================================================
# Publish the hosts
# (https://$varMgtIP/web_api/publish)
#====================================================================================================
TASK=`$var_curl -k -H "Content-Type: application/json" -H "X-chkp-sid: $SID" -X POST -d '{}' $var_api_url/publish 2>> add_hosts_in_parallel.err | jq .[] | sed s/\"//g`
STATUS=`$var_curl -k -H "Content-Type: application/json" -H "X-chkp-sid: $SID" -X POST -d '{"task-id" : "'$TASK'" }' $var_api_url/show-task 2>> add_hosts_in_parallel.err | jq .tasks[].status | sed s/\"//g`
printf "\n\n############# Publishing hosts: $STATUS ###############\n" | tee -a add_hosts_in_parallel.out
	while [  "$STATUS" != "succeeded" ]
		do
		  STATUS=`$var_curl -k -H "Content-Type: application/json" -H "X-chkp-sid: $SID" -X POST -d '{"task-id" : "'$TASK'" }' $var_api_url/show-task 2>> add_hosts_in_parallel.err | jq .tasks[].status | sed s/\"//g`
          printf "#$STATUS"
		  sleep 5 # wait 5 sec
		done 
printf "\n\n############# Rules published at: $post_rule_pub_time Logging out ###############\n\n" | tee -a add_hosts_in_parallel.out
#====================================================================================================
# Logout and closing the session(https://$varMgtIP/web_api/Logout)
#====================================================================================================
$var_curl -k -H "Content-Type: application/json" -H "X-chkp-sid: $SID" -X POST -d '{}' $var_api_url/logout 2>> add_hosts_in_parallel.err | jq .
e_time=$(/bin/date)
#====================================================================================================
# Printing time stamps
#====================================================================================================
printf "\n\n\n\nHosts, Groups and Rules have been added into API_Policy package" | tee -a add_hosts_in_parallel.out
printf "\nScript Start time $s_time" | tee -a add_hosts_in_parallel.out
printf "\nScript hosts added but not published at: $pre_host_pub_time" | tee -a add_hosts_in_parallel.out
printf "\nScript End time $e_time\n" | tee -a add_hosts_in_parallel.out
