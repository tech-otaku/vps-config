#!/bin/bash

clear

echo '--> CONFIGURING FIREWALL.....'

ufw default deny incoming
ufw default allow outgoing

# http
ufw allow 80/tcp

# https
ufw allow 443/tcp

# ssh
ufw allow 7822/tcp

# webmin
ufw allow 10000/tcp

echo '--> ENABLING FIREWALL.....'
ufw enable

echo '--> CONFIGURATION COMPLETE.'