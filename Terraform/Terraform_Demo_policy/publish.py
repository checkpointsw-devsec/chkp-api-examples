#!/usr/bin/python

import getopt
import requests
import sys
import os
import json
import time

with open('sid.json', 'r') as json_file:
    data = json.load(json_file)

sid = data['sid']

# Set login info
url = "https://10.2.0.84/web_api/publish"
payload = "{}"
headers = {
    'Content-Type': "application/json",
    'Cache-Control': "no-cache",
    'X-chkp-sid': "" + sid + "",
    }

# SSL Certificate Checking is disabled!!!
requests.packages.urllib3.disable_warnings()
response = requests.request("POST", url, data=payload, headers=headers, verify=False)

# Grab the Task id from the response
api_json = json.loads(response.text)
print "Task ID is " + api_json['task-id']

# Sleep for 2 seconds before checking the status of the Task
time.sleep(2)

# Check the status of the task
progress_percentage = 0
while progress_percentage < 100:

   url = "https://10.2.0.84/web_api/show-task"
   payload = "{\r\n  \"task-id\" : \"" + api_json['task-id'] + "\"}"
   response = requests.request("POST", url, data=payload, headers=headers, verify=False)
   task_status = json.loads(response.text)
   sys.stdout.write("\rProgress " + str(task_status['tasks'][0]['progress-percentage']) + "%")
   sys.stdout.flush()
   progress_percentage = task_status['tasks'][0]['progress-percentage']
   time.sleep(1)

print ""

