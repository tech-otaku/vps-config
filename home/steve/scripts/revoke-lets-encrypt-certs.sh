#!/bin/bash
# Steve Ward: 2016-03-09

if [ "$1" == "" ]; then
    echo 'ERROR: No virtual host name was specified.'
    exit 1
fi

#sudo ls -la /etc/letsencrypt/live/"$1"/cert.pem

sudo certbot revoke -d "$1" --cert-path /etc/letsencrypt/live/"$1"/cert.pem
sudo rm -rf /etc/letsencrypt/archive/"$1"/
sudo rm -rf /etc/letsencrypt/live/"$1"/
sudo rm -rf /etc/letsencrypt/renewal/"$1".conf