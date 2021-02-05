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

export INST_CADDY_V1=0
echo "--> INST_CADDY_V1 is ${INST_CADDY_V1}"

export INST_XRAY=0
echo "--> INST_XRAY is ${INST_XRAY}"

export INST_SNELL=0
echo "--> INST_SNELL is ${INST_SNELL}"

export INST_TROJAN_GO=0
echo "--> INST_TROJAN_GO is ${INST_TROJAN_GO}"

export INST_NAIVEPROXY=0
echo "--> INST_NAIVEPROXY is ${INST_NAIVEPROXY}"

# update caddy-v1
echo -e "
=====================================
2. update abiosoft/caddy started ...
====================================="

ret_1=$(mktemp)
docker pull abiosoft/caddy | tee -a ${ret_1}
if grep 'Image is up to date for' ${ret_1}; then
        INST_CADDY_V1=0
        echo "--> INST_CADDY_V1 is ${INST_CADDY_V1}"
else
        INST_CADDY_V1=1
        echo "--> INST_CADDY_V1 is ${INST_CADDY_V1}"
fi

rm -f ${ret_1}

# run caddy-v1
echo -e "
=====================================
3. re-run caddy-v1 docker instances ...
====================================="
if [ "${INST_CADDY_V1}" -eq "1" ]; then
        echo "re-run docker instances based on new images ..."
        bash /opt/bashScripts/run-caddy-v1.sh
else
        echo "skipped due to images has no updates ..."
fi
INST_CADDY_V1=0

# update xray
echo -e "
=====================================
4. update teddysun/xray started ...
====================================="

ret_2=$(mktemp)
docker pull teddysun/xray | tee -a ${ret_2}

if grep 'Image is up to date for' ${ret_2}; then
        echo "--> INST_XRAY is ${INST_XRAY}"
else
        INST_XRAY=1
        echo "--> INST_XRAY is ${INST_XRAY}"
fi

rm -f ${ret_2}


# run xray
echo -e "
=====================================
5. re-run xray docker instances ...
====================================="
if [ "${INST_XRAY}" -eq "1" ]; then
        echo "re-run docker instances based on new images ..."
        bash /opt/bashScripts/run-xray-docker.sh
else
        echo "skipped due to images has no updates ..."
fi
INST_XRAY=0


# update snell
echo -e "
=====================================
6. update echoer/snell started ...
====================================="

ret_3=$(mktemp)
docker pull echoer/snell | tee -a ${ret_3}

if grep 'Image is up to date for' ${ret_3}; then
        echo "--> INST_SNELL is ${INST_SNELL}"
else
        INST_SNELL=1
        echo "--> INST_SNELL is ${INST_SNELL}"
fi

rm -f ${ret_3}

# run snell
echo -e "
=====================================
7. re-run snell docker instances ...
====================================="
if [ "${INST_SNELL}" -eq "1" ]; then
        echo "re-run docker instances based on new images ..."
        bash /opt/bashScripts/run-snell.sh
else
        echo "skipped due to images has no updates ..."
fi
INST_SNELL=0

# update teddysun/trojan-go
echo -e "
=====================================
8. update teddysun/trojan-go started ...
====================================="

ret_4=$(mktemp)
docker pull teddysun/trojan-go | tee -a ${ret_4}

if grep 'Image is up to date for' ${ret_4}; then
        echo "--> INST_TROJAN_GO is ${INST_TROJAN_GO}"
else
        INST_TROJAN_GO=1
        echo "--> INST_TROJAN_GO is ${INST_TROJAN_GO}"
fi

rm -f ${ret_4}

# run teddysun/trojan-go
echo -e "
=====================================
9. re-run teddysun/trojan-go docker instances ...
====================================="
if [ "${INST_TROJAN_GO}" -eq "1" ]; then
        echo "re-run docker instances based on new images ..."
        bash /opt/bashScripts/run-trojan-go.sh
else
        echo "skipped due to images has no updates ..."
fi
INST_TROJAN_GO=0

# update pocat/naiveproxy
echo -e "
=====================================
10. update pocat/naiveproxy started ...
====================================="

ret_5=$(mktemp)
docker pull pocat/naiveproxy | tee -a ${ret_5}

if grep 'Image is up to date for' ${ret_5}; then
        echo "--> INST_NAIVEPROXY is ${INST_NAIVEPROXY}"
else
        INST_NAIVEPROXY=1
        echo "--> INST_NAIVEPROXY is ${INST_NAIVEPROXY}"
fi

rm -f ${ret_5}

# runpocat/naiveproxy
echo -e "
=====================================
11. re-run pocat/naiveproxy docker instances ...
====================================="
if [ "${INST_NAIVEPROXY}" -eq "1" ]; then
        echo "re-run docker instances based on new images ..."
        bash /opt/bashScripts/run-naiveproxy.sh
else
        echo "skipped due to images has no updates ..."
fi
INST_NAIVEPROXY=0

# cleaning
echo -e "
=====================================
12. cleaning packages ...
====================================="
apt -y autoremove

# finish
echo -e "
=====================================
13. ALL PROCESSES finished ...
====================================="
