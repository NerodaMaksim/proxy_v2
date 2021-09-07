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
ip -6 addr add 2001:470:8a17:ff63:6c04:9e10:1ae5:8260 dev enp0s3
ip -6 addr add 2001:470:8a17:cb61:939d:ac81:4dee:bc23 dev enp0s3
ip -6 addr add 2001:470:8a17:d9bc:19f7:25ae:50bf:af7c dev enp0s3
ip -6 addr add 2001:470:8a17:d58e:a246:9938:410c:ac56 dev enp0s3
ip -6 addr add 2001:470:8a17:e365:3d14:1f7c:ddf2:8ebf dev enp0s3
ip -6 addr add 2001:470:8a17:0c5f:3452:7781:ba42:734c dev enp0s3
ip -6 addr add 2001:470:8a17:2d7b:77f7:c781:6c38:6ed4 dev enp0s3
ip -6 addr add 2001:470:8a17:85f8:0868:b83e:4230:131a dev enp0s3
ip -6 addr add 2001:470:8a17:5bf1:d93d:d7f0:3257:7096 dev enp0s3
ip -6 addr add 2001:470:8a17:7335:dcdc:8606:d345:2b67 dev enp0s3

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