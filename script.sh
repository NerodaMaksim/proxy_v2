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
ip -6 addr add 2001:470:8a17:0364:f089:efcb:6c8a:6c8d dev enp0s3
ip -6 addr add 2001:470:8a17:d32e:2ea0:2498:974a:53cb dev enp0s3
ip -6 addr add 2001:470:8a17:29c7:a462:e037:ce11:6aa3 dev enp0s3
ip -6 addr add 2001:470:8a17:ab66:7ae4:d21b:cdfc:5a4e dev enp0s3
ip -6 addr add 2001:470:8a17:1461:4cfc:7c27:6141:3f9a dev enp0s3
ip -6 addr add 2001:470:8a17:f72c:0e1e:0844:ba79:ed3b dev enp0s3
ip -6 addr add 2001:470:8a17:3b09:5325:0c0a:f284:2819 dev enp0s3
ip -6 addr add 2001:470:8a17:78d2:9854:a8d6:b94b:0284 dev enp0s3
ip -6 addr add 2001:470:8a17:eb15:d218:3e1f:9f16:fce5 dev enp0s3
ip -6 addr add 2001:470:8a17:a0a1:4040:93ec:8430:5478 dev enp0s3

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