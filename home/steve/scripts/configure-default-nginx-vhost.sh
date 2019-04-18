#!/bin/bash
# Steve Ward: 2016-12-04

clear

# Make sure root is not running this script
if [[ $EUID -eq 0 ]]; then
   echo "ERROR:This script must NOT be run as root." 1>&2
   exit 1
fi


#DIRECTORY="/usr/share/nginx/000-default.net"
#if [ ! -d "$DIRECTORY" ]; then
#  	echo "ERROR: The directory "${DIRECTORY}" doesn't exist."
#    exit 1
#fi

# Disable the default host by deleting its symlink
if [ -f "/etc/nginx/sites-enabled/default" ]; then
	sudo rm "/etc/nginx/sites-enabled/default"
fi

DOMAIN=$(echo $(hostname -f) | sed 's/\.[^.][^.]*$//')
read -e -i "$DOMAIN" -p "> Domain name to be used is: " input
DOMAIN="${input:-$DOMAIN}"

TLD=$(echo $(hostname -f) | rev | cut -d'.' -f1 | rev)
read -e -i "$TLD" -p "> TLD to be used is: " input
TLD="${input:-$TLD}"

template=d
read -e -i "$template" -p "> Use template [a|b|c|d|e|f]: " input
template="${input:-$template}"


DIRECTORY="/usr/share/nginx/$DOMAIN.$TLD/public_html"
if [ ! -d "$DIRECTORY" ]; then
	sudo mkdir -p "$DIRECTORY"
fi

echo "==================================================================="
echo "Create Virtual Host Script for domain $DOMAIN.$TLD"
echo "Installation directory: $DIRECTORY/"
echo "==================================================================="

day=$(date +%a)
tz=$(date +%Z)
VER=$(date "+FAC-`echo "$day" | perl -ne 'print lc'`%Y%m%d%H%M%S`echo "$tz" | perl -ne 'print lc'`")

sudo cp /home/steve/templates/index.html $DIRECTORY/index.html
sudo sed -i 's/REPLACE WITH TITLE/'"$DOMAIN"'.'"$TLD"' | Coming Soon/g' $DIRECTORY/index.html
sudo sed -i 's/REPLACE WITH DOMAIN/'"$DOMAIN"'.'"$TLD"' | '"$HOST"'/g' $DIRECTORY/index.html
sudo sed -i 's/REPLACE WITH TAG LINE/The future home of something cool/g' $DIRECTORY/index.html
sudo sed -i 's/REPLACE WITH VERSION/'"$VER"'/g' $DIRECTORY/index.html

echo "<?php phpinfo(); ?>" | sudo tee $DIRECTORY/info.php

if [ $template == "a" ]; then
	sudo cp /home/steve/templates/-a-nginx-vhost-config-template.conf /etc/nginx/sites-available/$DOMAIN.$TLD
fi

if [ $template == "b" ]; then
	sudo cp /home/steve/templates/-b-nginx-vhost-config-template.conf /etc/nginx/sites-available/$DOMAIN.$TLD
fi

if [ $template == "c" ]; then
	sudo cp /home/steve/templates/-c-nginx-vhost-config-template.conf /etc/nginx/sites-available/$DOMAIN.$TLD
fi

if [ $template == "d" ]; then
	sudo cp /home/steve/templates/-d-nginx-vhost-config-template.conf /etc/nginx/sites-available/$DOMAIN.$TLD
fi

if [ $template == "e" ]; then
	sudo cp /home/steve/templates/-e-nginx-vhost-config-template.conf /etc/nginx/sites-available/$DOMAIN.$TLD
fi

if [ $template == "f" ]; then
	sudo cp /home/steve/templates/-f-nginx-vhost-config-template.conf /etc/nginx/sites-available/$DOMAIN.$TLD
fi

n=$(date "+%d/%m/%y at %H:%M:%S")
# The / separator replaced with ! in sed to avoid conflict with / in $n date
sudo sed -i 's!# Created on!# Created on '"$n"' by '"$0"'!g' /etc/nginx/sites-available/$DOMAIN.$TLD
sudo sed -i 's/EXAMPLE.COM/'"$DOMAIN"'.'"$TLD"'/g' /etc/nginx/sites-available/$DOMAIN.$TLD

cat << EOF > /tmp/nginx-403-forbidden.tmp
server {
    listen 80 default_server;
    return 403;
}
EOF

sudo sed -e '/# 403 FORBIDDEN PLACEHOLDER/ {' -e 'r /tmp/nginx-403-forbidden.tmp' -e 'd' -e'}' -i /etc/nginx/sites-available/$DOMAIN.$TLD

# Enable site
sudo ln -s /etc/nginx/sites-available/$DOMAIN.$TLD /etc/nginx/sites-enabled/$DOMAIN.$TLD

sudo systemctl reload nginx

