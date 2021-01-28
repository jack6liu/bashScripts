#!/bin/bash

# apt upgrade
echo -e "
=====================================
1. apt upgrade started ...
=====================================
"

apt -y update && apt -y upgrade

echo -e "

-------------------------------------
   print variables ...
"

export INST_V2RAY=0
echo "--> INST_V2RAY is ${INST_V2RAY}"

export INST_XRAY=0
echo "--> INST_XRAY is ${INST_XRAY}"

export INST_SNELL=0
echo "--> INST_SNELL is ${INST_SNELL}"


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
3. update jrohy/v2ray started ...
====================================="

ret_2=$(mktemp)
#docker pull v2ray/official | tee -a ${ret_2}
docker pull jrohy/v2ray | tee -a ${ret_2}

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

# update official
echo -e "
=====================================
5. update teddysun/xray started ...
====================================="

ret_3=$(mktemp)
docker pull teddysun/xray | tee -a ${ret_3}

if grep 'Image is up to date for' ${ret_3}; then
	echo "--> INST_XRAY is ${INST_XRAY}"
else
        INST_XRAY=1
	echo "--> INST_XRAY is ${INST_XRAY}"
fi

rm -f ${ret_3}


# run xray
echo -e "
=====================================
6. re-run xray docker instances ...
====================================="
if [ "${INST_XRAY}" -eq "1" ]; then
	echo "re-run docker instances based on new images ..."
	bash /opt/bashScripts/run-xray-docker.sh
else
	echo "skipped due to images has no updates ..."
fi
INST_XRAY=0


# update official
echo -e "
=====================================
7. update echoer/snell started ...
====================================="

ret_4=$(mktemp)
docker pull echoer/snell | tee -a ${ret_4}

if grep 'Image is up to date for' ${ret_4}; then
	echo "--> INST_SNELL is ${INST_SNELL}"
else
        INST_SNELL=1
	echo "--> INST_SNELL is ${INST_SNELL}"
fi

rm -f ${ret_4}

# run xray
echo -e "
=====================================
8. re-run snell docker instances ...
====================================="
if [ "${INST_SNELL}" -eq "1" ]; then
	echo "re-run docker instances based on new images ..."
	bash /opt/bashScripts/run-snell.sh
else
	echo "skipped due to images has no updates ..."
fi
INST_SNELL=0

# finish
echo -e "
=====================================
9. cleaning packages ...
====================================="
apt -y autoremove

# finish
echo -e "
=====================================
10. ALL PROCESSES finished ...
====================================="

