#!/bin/bash

# apt upgrade
echo -e "
=====================================
1. apt upgrade started ...
=====================================
"

apt -y update && apt -y upgrade

export INST_V2RAY=0
echo "--> INST_V2RAY is ${INST_V2RAY}"

# update caddy
echo -e "
=====================================
2. update abiosoft/caddy started ...
====================================="

ret_1=$(mktemp)
docker pull abiosoft/caddy | tee -a ${ret_1}
if grep 'Image is up to date for' ${ret_1}; then
	INST_V2RAY=0
	echo "--> INST_V2RAY is ${INST_V2RAY}"
else
	INST_V2RAY=1
	echo "--> INST_V2RAY is ${INST_V2RAY}"
fi

rm -f ${ret_1}

# update official
echo -e "
=====================================
3. update v2ray/official started ...
====================================="

ret_2=$(mktemp)
docker pull v2ray/official | tee -a ${ret_2}

if grep 'Image is up to date for' ${ret_2}; then
	echo "--> INST_V2RAY is ${INST_V2RAY}"
else
        INST_V2RAY=1
	echo "--> INST_V2RAY is ${INST_V2RAY}"
fi

rm -f ${ret_2}

# run v2ray
echo -e "
=====================================
4. re-run v2ray docker instances ...
====================================="
if [ "${INST_V2RAY}" -eq "1" ]; then
	echo "re-run docker instances based on new images ..."
	bash /opt/bashScripts/run-v2ray-docker.sh
else
	echo "skipped due to images has no updates ..."
fi
INST_V2RAY=0

# finish
echo -e "
=====================================
5. ALL PROCESSES finished ...
====================================="


