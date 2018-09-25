#!/bin/bash
set -e
#
# config and start shadowsocks-libev services
#

PASSWORD="jack6-ss-ru"
PORT1="9388"
PORT2="9488"

echo "... generating config files for shadowsocks-libev ..."
mkdir -p /etc/shadowsocks-libev

cat > /etc/shadowsocks-libev/config-1.json <<EOF
{
    "server": "0.0.0.0",
    "server_port" : ${PORT1},
    "password": "${PASSWORD}",
    "local_address": "127.0.0.1",
    "local_port": 1181,
    "timeout": 150,
    "method": "chacha20",
    "fast_open": true,
    "mptcp": true,
    "mode": "tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}

EOF

cat > /etc/shadowsocks-libev/config-2.json <<EOF
{
    "server": "0.0.0.0",
    "server_port" : ${PORT2},
    "password": "${PASSWORD}",
    "local_address": "127.0.0.1",
    "local_port": 1181,
    "timeout": 150,
    "method": "chacha20",
    "fast_open": true,
    "mptcp": true,
    "mode": "tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}

EOF

echo "... generating default settings for shadowsocks-libev ..."

cat > /etc/default/shadowsocks-libev <<EOF
# default config file, required
#CONF_FILE="/etc/shadowsocks-libev/config.json"
CONF_FILE_1="/etc/shadowsocks-libev/config-1.json"
CONF_FILE_2="/etc/shadowsocks-libev/config-2.json"
# default pid_file, required
#PID_FILE="/var/run/shadowsocks-libev.pid"
PID_FILE_1="/var/run/shadowsocks-libev-1.pid"
PID_FILE_2="/var/run/shadowsocks-libev-2.pid"
# other daemon options not supported in config.json
#DAEMON_OPS="-v --firewall --plugin obfs-local --plugin-opts \"obfs=http;obfs-host=www.baidu.com\"; "
#DAEMON_OPS="--plugin obfs-local --plugin-opts \"obfs=http;obfs-host=www.baidu.com\"; "
DAEMON_OPS=""

EOF

echo "... generating systemd services for shadowsocks-libev ..."

cat > /lib/systemd/system/shadowsocks-libev-${PORT1}.service <<EOF
[Unit]
Description=Shadowsocks Server Service
After=network.target

[Service]
User=root
Type=forking
EnvironmentFile=-/etc/default/shadowsocks-libev
ExecStart=/usr/local/bin/ss-server -c \$CONF_FILE_1 -f \$PID_FILE_1 \$DAEMON_OPS -v
Restart=on-failure
LimitNOFILE=32768

[Install]
WantedBy=multi-user.target

EOF


cat > /lib/systemd/system/shadowsocks-libev-${PORT2}.service <<EOF
[Unit]
Description=Shadowsocks Server Service
After=network.target

[Service]
User=root
Type=forking
EnvironmentFile=-/etc/default/shadowsocks-libev
ExecStart=/usr/local/bin/ss-server -c \$CONF_FILE_2 -f \$PID_FILE_2 \$DAEMON_OPS -v
Restart=on-failure
LimitNOFILE=32768

[Install]
WantedBy=multi-user.target

EOF

echo "... enable and start shadowsocks-libev services ..."
systemctl enable shadowsocks-libev-${PORT1}.service
systemctl enable shadowsocks-libev-${PORT2}.service
systemctl start shadowsocks-libev-${PORT1}.service
systemctl start shadowsocks-libev-${PORT2}.service
echo "... everything is done ..."

