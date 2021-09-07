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
ip -6 addr add 2001:470:8a17:e81e:84bf:dad9:9ec1:ec62 dev enp0s3
ip -6 addr add 2001:470:8a17:9d8c:ee83:39c5:9865:308c dev enp0s3
ip -6 addr add 2001:470:8a17:d310:210f:1eed:ad55:712d dev enp0s3
ip -6 addr add 2001:470:8a17:4e42:a078:ed95:1fbc:7f77 dev enp0s3
ip -6 addr add 2001:470:8a17:2973:d657:71d0:86c5:bf19 dev enp0s3
ip -6 addr add 2001:470:8a17:3136:f02f:6b1a:a4fb:90db dev enp0s3
ip -6 addr add 2001:470:8a17:d39f:91d8:46e8:ead8:d439 dev enp0s3
ip -6 addr add 2001:470:8a17:6d6b:ef96:8772:d268:d975 dev enp0s3
ip -6 addr add 2001:470:8a17:2e56:3b45:2e72:59ea:9a97 dev enp0s3
ip -6 addr add 2001:470:8a17:cf6c:5d56:d7f1:eb8f:fae9 dev enp0s3

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