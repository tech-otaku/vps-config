#!/bin/bash
# Steve Ward: 2016-03-09

# USAGE: bash /home/steve/templates/delete-vhost.sh <domain> [<tld>]
# ALIAS: vhost-del <domain> [<tld>]
# If <tld> is not supplied a tld of 'com' is assumed i.e. bash delete-vhost.sh tech-otaku or bash delete-vhost.sh steveward me.uk

# Source: https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-14-04-lts

if [ "$1" == "" ]; then
    echo 'ERROR: No virtual host name was specified.'
    exit 1
fi

if [ "$2" == "" ]; then
	TLD="com"
else 
	TLD="$2"
fi

DIRECTORY="/var/www/$1.$TLD/public_html/"

if [ ! -d "$DIRECTORY" ]; then
  	echo "ERROR: The directory "${DIRECTORY}" doesn't exist."
    exit 1
fi

sudo a2dissite $1.$TLD.conf
sudo rm /etc/apache2/sites-available/$1.$TLD.conf
sudo rm -rf /var/www/$1.$TLD
sudo systemctl restart apache2
