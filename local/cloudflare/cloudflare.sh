#!/bin/bash

IP=$1

scp -P 7822 -pr /Users/steve/Developer/GitHub/vps-config/local/cloudflare/cloudflare.ini root@$IP:/etc/letsencrypt
ssh -p 7822 root@$IP 'chown root:root /etc/letsencrypt/cloudflare.ini; chmod 600 /etc/letsencrypt/cloudflare.ini'