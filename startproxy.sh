#!/bin/bash
pkill -9 3proxy > /dev/null 2>&1
echo "wait 3 second before starting proxy...."
sleep 3s
iptables -F
ulimit -n 999999
echo "999999" > /proc/sys/fs/file-max
/etc/3proxy/3proxy /etc/3proxy/3proxy.cfg
if [ 0 -eq 0 ]; then
echo "Proxy started OK"
fi