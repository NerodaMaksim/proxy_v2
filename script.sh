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
ip -6 addr add 2001:470:8a17:51c8:386f:ffad:927c:c803 dev enp0s3
ip -6 addr add 2001:470:8a17:90cf:0c2d:8227:1d73:45a8 dev enp0s3
ip -6 addr add 2001:470:8a17:53b5:d645:1765:3846:f8fa dev enp0s3
ip -6 addr add 2001:470:8a17:f9cd:561c:d8ee:53e5:8ab1 dev enp0s3
ip -6 addr add 2001:470:8a17:fcad:5959:36ee:5cbf:e687 dev enp0s3
ip -6 addr add 2001:470:8a17:df7a:fc9c:7fe8:063d:e21a dev enp0s3
ip -6 addr add 2001:470:8a17:d321:77ed:7953:9466:4b2f dev enp0s3
ip -6 addr add 2001:470:8a17:c432:cd74:2271:454a:0326 dev enp0s3
ip -6 addr add 2001:470:8a17:4335:629d:9c15:05a1:899e dev enp0s3
ip -6 addr add 2001:470:8a17:29fa:4429:37c2:9379:9cda dev enp0s3

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