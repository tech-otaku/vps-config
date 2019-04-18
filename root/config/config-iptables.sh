#!/bin/bash

clear

echo '--> CONFIGURING IPTABLES.....'

n=$(date +"%C%y-%m-%d_%H-%M-%S")

echo '--> Backing-up current iptables to /opt directory....'
iptables-save > /opt/iptables.$n

echo '--> Flushing iptables.....'
iptables --policy INPUT ACCEPT
iptables --policy FORWARD ACCEPT
iptables --policy OUTPUT ACCEPT
iptables -F

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 7822 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 10000 -j ACCEPT
iptables -I INPUT 1 -i lo -j ACCEPT

iptables --policy INPUT DROP

#iptables -A INPUT -j DROP

echo '--> Displaying new iptables.....'
iptables -nL

echo '--> Installing iptables-persistent.....'
apt-get install iptables-persistent

echo '--> To save any subsequent changes to the iptables use "sudo netfilter-persistent save" after making the changes.'

echo '--> CONFIGURATION COMPLETE.'