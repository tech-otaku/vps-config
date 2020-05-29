#!/bin/bash

clear

echo '--> CONFIGURING FIREWALL.....'

ufw default deny incoming
ufw default allow outgoing

# http
#ufw allow 80/tcp

# https
#ufw allow 443/tcp

# ssh
ufw limit 7822/tcp comment 'Rate-limit connections'

# webmin
#ufw allow 10000/tcp

echo '--> ENABLING FIREWALL.....'
ufw enable

echo '--> CONFIGURATION COMPLETE.'