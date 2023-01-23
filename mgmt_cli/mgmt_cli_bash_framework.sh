##########
# Author: Bob_Zimmerman - https://community.checkpoint.com/t5/user/viewprofilepage/user-id/27871
# source: https://community.checkpoint.com/t5/API-CLI-Discussion/BASH-Framework-for-Management-API-Commands/m-p/168637/highlight/true#M7427
# Version 1.0
# 2023-01-21
# BASH Framework for Management API Commands
# I'm working on a program which interacts with Check Point's management API. As is common when programming anything substantial, I built some smaller tools to help me along the way. I thought I would share one, since it has broad applicability.
#
# This is a script framework to abstract away some management API implementation details and concerns which annoyed me. Specifically, it handles counting how many API command you have run and publishing every 80, setting the session details after every publish, and publishing before logging out. Using it, you never need to explicitly publish. You write API commands, and they just work. I use it to add a predictable set of objects, policies, rules, and so on to new management VMs or after rebuilding my personal standalone.
# The mgmtCmd function doesn't return anything, so if you need to get output of a command (such as to find the UUID of an object you just created), you will need to call mgmt_cli directly as you can see in the last few lines.
##########
#
#!/usr/bin/env bash
sessionName="Initial Build"
sessionDescription="Building my initial config for a new lab management."

publishEvery=80
changeCount=1
publishBatch=1

function mgmtCmd {
	commandToRun=""
	for element in "${@}"; do
		if [[ "$element" =~ \  ]]; then
			commandToRun="${commandToRun} \"${element}\""
		else
			commandToRun="${commandToRun} ${element}"
		fi
	done
	echo "${commandToRun}" | xargs mgmt_cli -s session.txt
	if [ $? -eq 0 ]; then
		echo "Success ${publishBatch}.${changeCount}"
		((changeCount+=1))
	else
		echo "Failed: ${commandToRun}"
	fi
	if [ ${changeCount} -gt ${publishEvery} ]; then
		echo "Publishing..."
		publish
		setupSession
		((publishBatch+=1))
	fi
}

function publish {
	mgmt_cli -s session.txt publish
}

function setupSession {
	changeCount=1
	mgmt_cli -s session.txt set session new-name "${sessionName}" description "${sessionDescription}" > /dev/null
}

function login {
	mgmt_cli -r true login > session.txt
	setupSession
}

function logout {
	publish
	mgmt_cli -s session.txt logout > /dev/null
	rm session.txt
}

login
mgmtCmd add dns-domain name ".github.com" is-sub-domain false
mgmtCmd add network name "RFC 10/8" subnet4 "10.0.0.0" mask-length4 8 broadcast allow
mgmtCmd add tag name "Development"
#...
#...
#...
mgmtCmd add package name "InstalledNowhere" access true
installedNowhereUuid=$(mgmt_cli -f json -s session.txt show package name "InstalledNowhere" details-level uid | jq '.uid')
mgmtCmd set generic-object uid "${installedNowhereUuid}" installationTargets "SPECIFIC_GATEWAYS"
logout
