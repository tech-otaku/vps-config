#!/bin/bash
# Steve Ward: 2016-03-09

# USAGE: add-vhost.sh <domain> [<tld>]
# ALIAS: vhost-add <domain> [<tld>]
# CODE: /home/steve/scripts/add-vhost.sh
# If <tld> is not supplied a tld of 'com' is assumed i.e. sudo bash add-vhost.sh tech-otaku or sudo bash add-vhost.sh steveward me.uk

# SOURCE: https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-14-04-lts

clear

# Make sure root is not running this script
if [[ $EUID -eq 0 ]]; then
   echo "ERROR:This script must NOT be run as root." 1>&2
   exit 1
fi

if [ "$1" == "" ]; then
    echo 'ERROR: No virtual host name was specified.'
    exit 1
fi


if [ "$2" == "" ]; then
	TLD="com"
else 
	TLD="$2"
fi

DIRECTORY="/var/www/$1.$TLD/public_html"
if [ ! -d "$DIRECTORY" ]; then
  	echo "ERROR: The directory ${DIRECTORY} doesn't  exist."
    exit 1
fi

echo "==================================================================="
echo "Maintenance Page Script for domain $1.$TLD"
echo "==================================================================="


day=$(date +%a)
tz=$(date +%Z)
VER=$(date "+FAC-`echo "$day" | perl -ne 'print lc'`%Y%m%d%H%M%S`echo "$tz" | perl -ne 'print lc'`")

cp /home/steve/templates/maintenance.php /var/www/$1.$TLD/public_html/maintenance.php
sudo sed -i 's/REPLACE WITH TITLE/'"$1"'.'"$TLD"' | Maintenance/g' /var/www/$1.$TLD/public_html/maintenance.php
sudo sed -i 's/REPLACE WITH DOMAIN/'"$1"'.'"$TLD"'/g' /var/www/$1.$TLD/public_html/maintenance.php
sudo sed -i 's/REPLACE WITH VERSION/'"$VER"'/g' /var/www/$1.$TLD/public_html/maintenance.php