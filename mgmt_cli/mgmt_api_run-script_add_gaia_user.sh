#!/bin/bash
# This command will use the Check Point Mangement API run-script endpoint to create a gaia user on the target machine: corporate-gateway
# https://sc1.checkpoint.com/documents/latest/APIs/index.html#cli/run-script
# uid jimo
# pwd admin
mgmt_cli --root true --format json run-script \
  script-name "Add Gaia user: jimo" \
  \
  script "clish -c 'lock database override';\
          clish -s -c 'add user jimo uid 0 homedir /home/jimo';\
          clish -s -c 'set user jimo password-hash $1$/PAfqAlg$1T9G28s.2jBHq6rFYOdIA1';\
          clish -s -c 'add rba user jimo roles adminRole'" \
  \
  targets.1 "corporate-gateway"\
  | jq -r '.tasks[]."task-details"[].responseMessage' | base64 --decode -i

# The command will produce an output like this
# ---------------------------------------------
# Time: [14:48:53] 29/2/2020
# ---------------------------------------------
# "smsg60 - Add Gaia user: jimo"  succeeded  (100%)
# CLINFR0771  Config lock is owned by admin. Use the command 'lock database override' to acquire the lock.
# WARNING Must set password and a role before user can login.
# - Use 'set user USER password' to set password.
# - Use 'add rba user USER roles ROLE' to set a role.
