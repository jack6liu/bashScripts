#!/bin/bash
set -e
#
# global variables
#
export _scriptName=$(basename $0)
export _fileName=$(readlink -f $0)
export _dirName=$(dirname ${_fileName})

getLocalTime() {
    printf "%.23s" "$(date '+%Y-%m-%d %H:%M:%S.%N')"
}

log() {
    currentTime=$(getLocalTime)
    prefixString="[${currentTime}] --> "
    echo "${prefixString} $@"
}

install_pkg() {
    apt-get -qq -o:Dpkg::Use-Pty=0 -y install $@
}

prettyOutput() {
    $@ 2>&1 | while read -r line; do echo -e "\\t $line"; done
}

usage() {
    cat << EOT

Usage : bash ${_scriptName} [OPTION] ...
  Install mainline kernel from ubuntu mainline repo
http://kernel.ubuntu.com/~kernel-ppa/mainline/

Options:
  -h, --help                Display this message
  -v, --version=VERSION     VERSION of mainline kernel, default value is 4.9.8
  -c, --clean               Remove all old version kernels installed on this system, default value is FALSE
  -r, --reboot              Reboot the system at the script end, default value is FALSE


Exit status:
  0   if OK,
  !=0 if serious problems.

EOT
}

#
#if [ $# -eq 0 ]; then
#    usage;
#    exit 1;
#fi

## ---- BEGIN of get options ----
OPTS=$(getopt -o hv:cr --long help,version:,clean,reboot, \
      -n "${_scriptName}" -- "$@")

if [ $? != 0 ] ; then
    echo "${_scriptName} terminated..." >&2
    exit 1
fi

# Note the quotes around `${OPTS}': they are essential!
eval set -- "${OPTS}"

VERSION=${VERSION:='4.11.12'}
CLEAN=${CLEAN:='FALSE'}
REBOOT=${REBOOT:='FALSE'}

while true; do
  case "$1" in
    -h | --help )
        usage
        exit 0 ;;
    -v | --version )
        VERSION="$2"
        shift 2 ;;
    -c | --clean )
        CLEAN="TRUE"
        shift ;;
    -r | --reboot )
        REBOOT="TRUE"
        shift ;;
    -- )
        shift
        break ;;
    * )
        break ;;
  esac
done

## ---- FINISH of get options ----
log "comparing with installed kernel ..."
CURRENT=$(uname -r | cut -d '-' -f 1)

# check if the version is installed
if [[ "${VERSION}" == "${CURRENT}" ]]; then
    log "the version: ${VERSION} is already installed!"
    #exit 0
fi

# set base url
log "checking the given kernel version ..."
BASE_URL="https://kernel.ubuntu.com/~kernel-ppa/mainline/v"${VERSION}

# check if the version number exists
ISVALID=$(curl -I -s ${BASE_URL} | head -n 1 | cut -d$' ' -f2)
if [[ "${ISVALID}" -eq 404 ]]; then
    log "the version: ${VERSION} is not valid!"
    exit ${ISVALID}
fi

# download packages
log "starting to download packages needed ..."
mkdir -p /opt/kernel-${VERSION}
cd /opt/kernel-${VERSION}

FILENAMES=$(curl -s "${BASE_URL}/" --list-only | egrep '<a href=.*generic.*amd64.deb</a><br>|_all.deb</a><br>' | cut -d '"' -f 2 | sort | uniq)

for PKG in ${FILENAMES} ; do
    log "downloading ${PKG} ..."
    prettyOutput wget -q -c ${BASE_URL}/${PKG}
done

# install downloaded kernel packages
log "installing downloaded packages ..."
prettyOutput dpkg -i *.deb

cd ~

# install tsunami bbr mod
#log "install pkgs needed for make tsunami mod ..."
#prettyOutput install_pkg make gcc

#log "get tsunami bbr source code..."
#mkdir -p ${_dirName}/tsunami && cd ${_dirName}/tsunami
#curl -k -L -o ./tcp_tsunami.c https://raw.githubusercontent.com/KozakaiAya/TCP_BBR/master/v5.0/tcp_tsunami.c

#log "build tsunami bbr mod ..."
#echo "obj-m:=tcp_tsunami.o" > Makefile
#modulePath=$(ls -d /lib/modules/${VERSION}*)
#make -C ${modulePath}/build M=`pwd` modules CC=/usr/bin/gcc

#log "load tsunami bbr mod ..."
#if [[ ! "$(grep tcp_bbr /etc/modules)" ]]; then
    #echo "tcp_bbr" | tee -a /etc/modules
#    echo 'tcp_tsunami' | tee -a /etc/modules
#fi
#depmod
#modprobe tcp_tsunami
#cp -rf ./tcp_tsunami.ko ${modulePath}/kernel/drivers/

#log "config and enable tsunami bbr mod ..."
#rm -rf /etc/sysctl.conf
#curl -k -L -o /etc/sysctl.conf https://raw.githubusercontent.com/FunctionClub/YankeeBBR/master/sysctl.conf
#sysctl -p

#cd .. && rm -rf ${workdir}/tsunami


# remove old versions
if [[ "${CLEAN}" == "TRUE" ]]; then
    log "uninstalling old kernels installed ..."
    OLD_PKGS=$(dpkg-query -l | egrep "linux-headers|linux-image" | grep -v ${VERSION} | awk '{print $2}')
    prettyOutput apt -y -qq -o:Dpkg::Use-Pty=0 remove ${OLD_PKGS}
    prettyOutput apt -y -qq -o:Dpkg::Use-Pty=0 purge ${OLD_PKGS}
fi
if [[ "${REBOOT}" == "TRUE" ]]; then
    log "system will be reboot in 3 secends ..."
    sleep 3
    /sbin/reboot
fi

