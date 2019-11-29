#!/bin/bash
# enable SME
mgmtName=`clish -c "show hostname"`
touch dbeditForSE.sh
chmod 777 dbeditForSE.sh
echo "Setting configuration for:"
echo $mgmtName
#enable SmartEvent
echo modify network_objects $mgmtName abacus_server true >> dbeditForSE.sh
#enable log indexer
echo modify network_objects $mgmtName log_indexer true >> dbeditForSE.sh
#enable correlation unit
echo modify network_objects $mgmtName event_analyzer true >> dbeditForSE.sh
echo "update_all" >> dbeditForSE.sh
dbedit -local -f dbeditForSE.sh