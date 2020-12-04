#!/bin/bash
#====================================================================================================
# TITLE:            add_host_using_curl.sh
# USAGE:            dos2unix ./add_host_using_curl.sh
#                   bash ./add_host_using_curl.sh
#
# DESCRIPTION:	    Script will creat a host object with ip 1.1.1.1
#
# AUTHOR:           Jim Oqvist (Check Point Security Management Solution Expert)
#
# VERSION:		    1.0
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
varIP=1.1.1.1
var_api_url="https://$varMgtIP/web_api"
var_curl=curl

#====================================================================================================
# Timestamp start of script
#====================================================================================================
s_time=$(/bin/date)
#====================================================================================================
#  Login to management server and retrive the session_id
#====================================================================================================
printf "\n\n############# Logging in, creating policy API_Policy ###############\n\n" | tee -a add_host.out
SID=`$var_curl -k -H "Content-Type: application/json" -X POST -d '{  "user" : "'$varAdmin'", "password" : "'$varPwd'", "domain" : "SMC User"}' $var_api_url/login 2> add_host.err | jq '.sid' | sed s/\"//g`
#====================================================================================================
# Add host object (https://$varMgtIP/web_api/add-host)
#====================================================================================================
printf "\n\n############# Adding host " | tee -a add_host.out
$var_curl -k -H "Content-Type: application/json" -H "X-chkp-sid: $SID" -X POST -d '{  "name" : "host_'$varIP'", "ip-address" : "'$varIP'" }' $var_api_url/add-host 2>> add_host.err 1>> add_host.out &
printf "## Waiting for hosts to be created##"
#====================================================================================================
# Publish the hosts
# (https://$varMgtIP/web_api/publish)
#====================================================================================================
TASK=`$var_curl -k -H "Content-Type: application/json" -H "X-chkp-sid: $SID" -X POST -d '{}' $var_api_url/publish 2>> add_host.err | jq .[] | sed s/\"//g`
STATUS=`$var_curl -k -H "Content-Type: application/json" -H "X-chkp-sid: $SID" -X POST -d '{"task-id" : "'$TASK'" }' $var_api_url/show-task 2>> add_host.err | jq .tasks[].status | sed s/\"//g`
printf "\n\n############# Publishing hosts: $STATUS ###############\n" | tee -a add_host.out
	while [  "$STATUS" != "succeeded" ]
		do
		  STATUS=`$var_curl -k -H "Content-Type: application/json" -H "X-chkp-sid: $SID" -X POST -d '{"task-id" : "'$TASK'" }' $var_api_url/show-task 2>> add_host.err | jq .tasks[].status | sed s/\"//g`
          printf "#$STATUS"
		  sleep 5 # wait 5 sec
		done 
post_host_pub_time=$(/bin/date)
printf "\n\n############# Rules published at: $post_rule_pub_time Logging out ###############\n\n" | tee -a add_host.out
#====================================================================================================
# Logout and closing the session(https://$varMgtIP/web_api/Logout)
#====================================================================================================
$var_curl -k -H "Content-Type: application/json" -H "X-chkp-sid: $SID" -X POST -d '{}' $var_api_url/logout 2>> add_host.err | jq .
e_time=$(/bin/date)
#====================================================================================================
# Printing time stamps
#====================================================================================================
printf "\n\n\n\nHosts, Groups and Rules have been added into API_Policy package" | tee -a add_host.out
printf "\nScript Start time $s_time" | tee -a add_host.out
printf "\nScript Publish finished at: $post_host_pub_time" | tee -a add_host.out
printf "\nScript End time $e_time\n" | tee -a add_host.out