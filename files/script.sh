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
ip -6 addr add 2001:470:8a17:50b3:c3c1:3dbf:22a6:b06e dev enp0s3
ip -6 addr add 2001:470:8a17:a48a:18c6:c26c:fea1:5499 dev enp0s3
ip -6 addr add 2001:470:8a17:fe52:0b06:756a:3f3f:0766 dev enp0s3
ip -6 addr add 2001:470:8a17:93c0:5049:be8f:b5c4:990a dev enp0s3
ip -6 addr add 2001:470:8a17:2fd2:2e95:80a5:43c7:d61a dev enp0s3
ip -6 addr add 2001:470:8a17:b381:23f3:43c2:0507:fcd3 dev enp0s3
ip -6 addr add 2001:470:8a17:e854:1c7c:31ad:6ecd:ef0e dev enp0s3
ip -6 addr add 2001:470:8a17:ea13:befc:c310:1a7c:f649 dev enp0s3
ip -6 addr add 2001:470:8a17:9977:60b1:16bf:161c:9b8e dev enp0s3
ip -6 addr add 2001:470:8a17:e334:81b4:aaa4:fd72:021d dev enp0s3

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