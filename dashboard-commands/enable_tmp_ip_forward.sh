#!/bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING ! -d 127.0.0.1 -j MASQUERADE

# To make persistent add 'net.ipv4.ip_forward=1' to /etc/sysctl.conf
# and POSTROUTING rule to your firewall

