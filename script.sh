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
ip -6 addr add 2001:470:8a17:f22b:b241:adbc:307c:64e2 dev enp0s3
ip -6 addr add 2001:470:8a17:93c2:3397:ec36:0837:95d4 dev enp0s3
ip -6 addr add 2001:470:8a17:fcf2:b781:e6a3:33db:ccaa dev enp0s3
ip -6 addr add 2001:470:8a17:7da5:d372:f6ea:252c:e7c7 dev enp0s3
ip -6 addr add 2001:470:8a17:1f74:0c1f:5926:5590:efbf dev enp0s3
ip -6 addr add 2001:470:8a17:25b7:8117:20d3:69a0:67b7 dev enp0s3
ip -6 addr add 2001:470:8a17:818c:4367:7fb6:d3d7:e0c9 dev enp0s3
ip -6 addr add 2001:470:8a17:4146:ba5b:280d:7e97:e048 dev enp0s3
ip -6 addr add 2001:470:8a17:e1ea:7c33:de27:dd60:713c dev enp0s3
ip -6 addr add 2001:470:8a17:bf93:b72b:6e1e:b31b:06a5 dev enp0s3

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