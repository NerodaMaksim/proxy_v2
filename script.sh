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
ip -6 addr add 2001:470:8a17:5184:7a73:0ba7:3d66:f1c0 dev enp0s3
ip -6 addr add 2001:470:8a17:c3dd:6b98:e093:b69d:b877 dev enp0s3
ip -6 addr add 2001:470:8a17:f194:7b5c:ae86:0464:e239 dev enp0s3
ip -6 addr add 2001:470:8a17:d908:c1c2:27d2:bda8:36f5 dev enp0s3
ip -6 addr add 2001:470:8a17:ad23:b023:b135:db91:f3f1 dev enp0s3
ip -6 addr add 2001:470:8a17:51f9:f152:4530:3a4b:e324 dev enp0s3
ip -6 addr add 2001:470:8a17:f535:5ba4:8706:438b:6276 dev enp0s3
ip -6 addr add 2001:470:8a17:3417:672f:0326:bcfc:3ae4 dev enp0s3
ip -6 addr add 2001:470:8a17:9ded:7ac0:91b5:d3cb:e85e dev enp0s3
ip -6 addr add 2001:470:8a17:5bd9:3f41:2c1c:7b30:5f60 dev enp0s3

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