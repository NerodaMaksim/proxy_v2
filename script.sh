#!/bin/bash
apt -y update && apt -y upgrade
apt-get -y install  build-essential git ifupdown
cd ~
git clone https://github.com/z3APA3A/3proxy.git
cd 3proxy/
make -f Makefile.Linux
mkdir /etc/3proxy
mv bin/3proxy /etc/3proxy/
cd ~/files${etcNetworkInterfaces}
systemctl restart networking
ip -6 addr add 2001:470:8a17:c0d1:8dfa:2db6:ced5:b322 dev enp0s3
ip -6 addr add 2001:470:8a17:40cd:8551:7c8e:5b46:9043 dev enp0s3
ip -6 addr add 2001:470:8a17:522e:6ebf:11e3:feaa:8fc1 dev enp0s3
ip -6 addr add 2001:470:8a17:98c2:7803:25e3:baf5:ae0b dev enp0s3
ip -6 addr add 2001:470:8a17:aeae:9338:8bf8:5274:94ee dev enp0s3
ip -6 addr add 2001:470:8a17:fb4b:0130:be88:b50c:dbeb dev enp0s3
ip -6 addr add 2001:470:8a17:3498:7da8:46d8:4b8b:2efd dev enp0s3
ip -6 addr add 2001:470:8a17:c6cb:104c:fa9b:ae52:d4d6 dev enp0s3
ip -6 addr add 2001:470:8a17:f358:5d3f:8cb9:18b8:cf3b dev enp0s3
ip -6 addr add 2001:470:8a17:90cd:8083:8370:2a4b:c8d8 dev enp0s3

ip -6 addr add 2001:470:8a17::/48 dev enp0s3
ip -6 route add default via 2001:470:1f06:4db::1 dev he-ipv6
ip -6 route add local 2001:470:8a17::/48 dev lo
if [ -e /etc/3proxy/3proxy ]; then
echo "3proxy installed"
else
mv ~/3proxy/bin/3proxy /etc/3proxy
fi
if [ -e ~/files/3proxy.cfg ]; then
mv ./3proxy.cfg /etc/3proxy/
fi
if [ -e /etc/startproxy.sh ]; then
/etc/startproxy.sh
else
mv ~/files/startproxy.sh /etc/startproxy.sh
/etc/startproxy.sh
fi