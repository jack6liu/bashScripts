#/bin/bash

apt -y install make gcc
rm -rf tsunami
mkdir tsunami && cd tsunami
<<<<<<< HEAD
=======
# only for kernel version 5.1.x
>>>>>>> 2ddfa0a08fe3349a5523cde9a545087aa6135834
wget -O ./tcp_tsunami.c https://raw.githubusercontent.com/KozakaiAya/TCP_BBR/master/v5.1/tcp_tsunami.c
echo "obj-m:=tcp_tsunami.o" > Makefile
make -C /lib/modules/$(uname -r)/build M=`pwd` modules CC=/usr/bin/gcc
cp tcp_tsunami.ko /lib/modules/$(uname -r)/kernel/drivers/
echo 'tcp_tsunami' | sudo tee -a /etc/modules
depmod
modprobe tcp_tsunami
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=tsunami" >> /etc/sysctl.conf
sysctl -p

cd ..
