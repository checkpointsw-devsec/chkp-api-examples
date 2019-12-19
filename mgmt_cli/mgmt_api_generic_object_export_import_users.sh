#!/bin/bash
# This script will export/import all users in the Check Point management server to/from a csv file
# The users are stored on domain level
# NOTE: It is not possible to export the Check Point password field if you are using that. In this example the password for the imported users will be 'Mypaswd'.
#       For anyone using this, test it carefully before using it in production!

# Export users to CSV (if you are exporting from a domain on a MDS change "SMC User" to the dommain name)
mgmt_cli -r true -d "SMC User" -f json show generic-objects class-name "com.checkpoint.objects.classes.dummy.CpmiUser" details-level "full" | jq -r '.objects[] | ["com.checkpoint.objects.classes.dummy.CpmiUser", .name, .email, .phoneNumber, .color, .authMethod, "$(cpopenssl passwd -crypt -salt $(cpopenssl rand -base64 2) 'Mypaswd')", "com.checkpoint.objects.classes.dummy.CpmiAdminExpirationBaseData", .adminExpirationBaseData.expirationDate, "com.checkpoint.objects.classes.dummy.CpmiSpecificUserc", .userc.useGlobalEncryptionValues, "com.checkpoint.objects.classes.dummy.CpmiSpecificUsercIke"] | @csv' > users.csv
# Add headers with parameter names to the CSV
sed -i '1 s/^/"create","name","email","phoneNumber","color","authMethod","internalPassword","adminExpirationBaseData.create","adminExpirationBaseData.owned-object.expirationDate","userc.create","userc.owned-object.useGlobalEncryptionValues","userc.owned-object.ike.create"\n/' users.csv

# Import users from CSV (if you are importing from a domain on a MDS change "SMC User" to the dommain name)
mgmt_cli -r true -d "SMC User" -f json add generic-object --batch users.csv

#### Example of the CSV output
##  If you just want to import a list of users based on a CSV file this can be done by usng the add generic-object API endpoint in batch mode by formating the source csv file into a format like this:
# "create","name","email","phoneNumber","color","authMethod","internalPassword","adminExpirationBaseData.create","adminExpirationBaseData.owned-object.expirationDate","userc.create","userc.owned-object.useGlobalEncryptionValues","userc.owned-object.ike.create"
# "com.checkpoint.objects.classes.dummy.CpmiUser","Luna","","","BLACK","UNDEFINED","$(cpopenssl passwd -crypt -salt $(cpopenssl rand -base64 2) Mypaswd)","com.checkpoint.objects.classes.dummy.CpmiAdminExpirationBaseData","31-dec-2030","com.checkpoint.objects.classes.dummy.CpmiSpecificUserc",true,"com.checkpoint.objects.classes.dummy.CpmiSpecificUsercIke"
# "com.checkpoint.objects.classes.dummy.CpmiUser","Liv","","","BLACK","UNDEFINED","$(cpopenssl passwd -crypt -salt $(cpopenssl rand -base64 2) Mypaswd)","com.checkpoint.objects.classes.dummy.CpmiAdminExpirationBaseData","10-Apr-2021","com.checkpoint.objects.classes.dummy.CpmiSpecificUserc",true,"com.checkpoint.objects.classes.dummy.CpmiSpecificUsercIke"
# "com.checkpoint.objects.classes.dummy.CpmiUser","Jim","","","BLACK","UNDEFINED","$(cpopenssl passwd -crypt -salt $(cpopenssl rand -base64 2) Mypaswd)","com.checkpoint.objects.classes.dummy.CpmiAdminExpirationBaseData","10-Apr-2021","com.checkpoint.objects.classes.dummy.CpmiSpecificUserc",true,"com.checkpoint.objects.classes.dummy.CpmiSpecificUsercIke"
# "com.checkpoint.objects.classes.dummy.CpmiUser","apiuser6","api6@user.local","00468118118","BLUE_1","INTERNAL_PASSWORD","$(cpopenssl passwd -crypt -salt $(cpopenssl rand -base64 2) Mypaswd)","com.checkpoint.objects.classes.dummy.CpmiAdminExpirationBaseData","10-Apr-2020","com.checkpoint.objects.classes.dummy.CpmiSpecificUserc",true,"com.checkpoint.objects.classes.dummy.CpmiSpecificUsercIke"
#
#
##
# Add user example
# mgmt_cli -r true -d "SMC User" -f json add generic-object create "com.checkpoint.objects.classes.dummy.CpmiUser" name "apiuser11" email "api6@user.local" phoneNumber "00468118118" color "BLUE_1" authMethod "INTERNAL_PASSWORD" internalPassword $(cpopenssl passwd -crypt -salt $(cpopenssl rand -base64 2) 'Mypaswd!') adminExpirationBaseData.create "com.checkpoint.objects.classes.dummy.CpmiAdminExpirationBaseData" adminExpirationBaseData.owned-object.expirationDate "10-Apr-2020" userc.create "com.checkpoint.objects.classes.dummy.CpmiSpecificUserc" userc.owned-object.useGlobalEncryptionValues "true" userc.owned-object.ike.create "com.checkpoint.objects.classes.dummy.CpmiSpecificUsercIke"
###
#
###
# The following lines are currently a work in process to change this into an interactive script.
# this is how a interactive script could look like when exporting users
#read -p "Enter gateway name to add into RemoteAccess comunity: " varGW
#read -p "Enter management server IP : " varMgtIP
#read -p "Enter domain name: (if this is a smartCenter please enter \"SMC User\" as domain: " varMgtDomain
#read -p "Enter admin username : " varAdmin
#read -s -p "Enter admin password : " varPwd
#printf "\n"
#varSid=$(mgmt_cli -m $varMgtIP -d $varMgtDomain -f json login user $varAdmin password $varPwd | jq -r '.sid')
#mgmt_cli -m $varMgtIP --session-id $varSid -f json
###