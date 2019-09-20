# This script print all users that have expired or will expier at current date. Then it will change the expiration date of these uses to 10-Apr-2021
# if you need to do this on a mds change the domain from "SMC User" to the name of the domain
#!/bin bash
# Download jq 1.6 or later
curl_cli -Lk https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o jq-linux64-v1.6
# set execution permission on the binary
chmod +x jq-linux64-v1.6
# Create a time stamp variable with current date
varTimestamp=$(date "+%s")
# Print all users username, UID and expiration date for users that that have an expiration timestamp that is lower than current timestamp = all expired users from current date
mgmt_cli -r true -d "SMC User" -f json show generic-objects class-name "com.checkpoint.objects.classes.dummy.CpmiUser" details-level "full" | ./jq-linux64-v1.6 -r --arg varTimestamp "$varTimestamp" '.objects[] | select ( .adminExpirationBaseData.expirationDate | strptime("%d-%b-%Y")|mktime < ($varTimestamp|tonumber)) | "Name : " + .name, "UID : " + .uid, "Expired at : " + .adminExpirationBaseData.expirationDate'

#The output will look like this
# Name : Liv
# UID : 22ff3244-e41c-43b6-a122-50964169f6b6
# Expired at : 02-Sep-2019
# Name : kalle
# UID : 65ab6c7d-a6dd-4211-bfa1-e08bec045d04
# Expired at : 15-Sep-2019
# Name : Jim
# UID : 8ff47835-b0ed-4c34-87df-3461e0773460
# Expired at : 18-Sep-2019
# Name : lisa
# UID : c2325e07-770a-4c1f-866a-bb423b656bc2
# Expired at : 19-Sep-2019

# Now if you want to change the expiration date you can do this by combining this with a command from my checkmates post here: https://community.checkpoint.com/t5/API-CLI-Discussion-and-Samples/Change-expiration-date-of-users-using-generic-object-API-calls/td-p/39643
#***NOTE****: In order to change the users expiration the expiration date needs to be written in date format "dd-mmm-yyyy" for example 10-Apr-2018, if you do not follow this. Then you will corrupt the expiration date data for the user you are changing.

#Then it would look something like this
# Download latest binary of jq
# curl_cli -Lk https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o jq-linux64-v1.6
# set execution permission on the binary
# chmod +x jq-linux64-v1.6
# Create a time stamp variable with current date
varTimestamp=$(date "+%s")
# Following command will set expiration date to 10-Apr-2021 for users that that have an expiration timestamp that is lower than current timestamp = all expired users from current date
mgmt_cli -r true -d "SMC User" -f json show generic-objects class-name "com.checkpoint.objects.classes.dummy.CpmiUser" details-level "full" | ./jq-linux64-v1.6 -r --arg varTimestamp "$varTimestamp" '.objects[] | select ( .adminExpirationBaseData.expirationDate | strptime("%d-%b-%Y")|mktime < ($varTimestamp|tonumber)) | "mgmt_cli -r true -d \"SMC User\" -f json set generic-object uid " + .uid + " .adminExpirationBaseData.expirationDate \"10-Apr-2021\""' | bash

#if you do not pipe it to bash in the end then you will see an output like this instead, without making any change:
# mgmt_cli -r true -d "SMC User" -f json set generic-object uid 22ff3244-e41c-43b6-a122-50964169f6b6 .adminExpirationBaseData.expirationDate "10-Apr-2021"
# mgmt_cli -r true -d "SMC User" -f json set generic-object uid 65ab6c7d-a6dd-4211-bfa1-e08bec045d04 .adminExpirationBaseData.expirationDate "10-Apr-2021"
# mgmt_cli -r true -d "SMC User" -f json set generic-object uid 8ff47835-b0ed-4c34-87df-3461e0773460 .adminExpirationBaseData.expirationDate "10-Apr-2021"
# mgmt_cli -r true -d "SMC User" -f json set generic-object uid c2325e07-770a-4c1f-866a-bb423b656bc2 .adminExpirationBaseData.expirationDate "10-Apr-2021"

# to see the updated expiration date run this command again
mgmt_cli -r true -d "SMC User" -f json show generic-objects class-name "com.checkpoint.objects.classes.dummy.CpmiUser" details-level "full" | ./jq-linux64-v1.6 -r --arg varTimestamp "$varTimestamp" '.objects[] | select ( .adminExpirationBaseData.expirationDate | strptime("%d-%b-%Y")|mktime < ($varTimestamp|tonumber)) | "Name : " + .name, "UID : " + .uid, "Expired at : " + .adminExpirationBaseData.expirationDate'
