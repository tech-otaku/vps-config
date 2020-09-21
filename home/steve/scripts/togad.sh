#!/usr/bin/env bash

# USAGE: bash /home/steve/scripts/togad.sh 0|1
# 0 = Allow, 1 = Block

if [ -z $1 ]; then
    printf "ERROR: No toggle.\n"
    exit 1
fi

# Allow access
if [[ $1 -eq 0 ]]; then
    sudo sed -i 's/Require all denied/Require all granted/' /etc/apache2/conf-enabled/adminer.conf
    printf "Access to Adminer allowed.\n"
fi

# Block access
if [[ $1 -eq 1 ]]; then
    sudo sed -i 's/Require all granted/Require all denied/' /etc/apache2/conf-enabled/adminer.conf
    printf "Access to Adminer blocked.\n"
fi

sudo systemctl restart apache2 && sudo systemctl restart php$(php --version | awk '/^PHP/ {print $2}' | cut -d '.' -f 1-2)-fpm
