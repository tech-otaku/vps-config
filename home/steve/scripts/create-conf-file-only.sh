#!/bin/bash
# Steve Ward: 2017-02-08

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

DIRECTORY="/var/tmp/apache2-conf-files"
if [ ! -d "$DIRECTORY" ]; then
  	sudo mkdir ${DIRECTORY}
fi

echo "==================================================================="
echo "Create Apache .conf file for domain $1.$TLD"
echo "File is $DIRECTORY/$1.$TLD.conf"
echo "==================================================================="

ssl="Y"
read -e -i "$ssl" -p "> Configure for SSL (Y/n) ? " input
ssl="${input:-$ssl}"

www="Y"
read -e -i "$www" -p "> Does this domain have a www prefix (Y/n) ? " input
www="${input:-$www}"

if [[ $www =~ [A-Z] && $www == "Y" ]]; then
	force="Y"
	read -e -i "$force" -p "> Redirect non-www requests to 'www.' (Y/n) ? " input
	force="${input:-$force}"
	echo ""
else
	force="n"
fi

wp="Y"
read -e -i "$wp" -p "> Is this a WordPress site (Y/n) ? " input
wp="${input:-$wp}"


n=$(date "+%d/%m/%y at %H:%M:%S")

if [[ $ssl =~ [A-Z] && $ssl == "Y" ]]; then
	if [[ $www =~ [A-Z] && $www == "Y" ]]; then
		if [[ $force =~ [A-Z] && $force == "Y" ]]; then
			sudo cp /home/steve/templates/-a-vhost-config-template-ssl-www-force.conf $DIRECTORY/$1.$TLD.conf
		else
			sudo cp /home/steve/templates/-b-vhost-config-template-ssl-www.conf $DIRECTORY/$1.$TLD.conf
		fi
	else
		sudo cp /home/steve/templates/-c-vhost-config-template-ssl.conf $DIRECTORY/$1.$TLD.conf
	fi
else
	if [[ $www =~ [A-Z] && $www == "Y" ]]; then
		if [[ $force =~ [A-Z] && $force == "Y" ]]; then
			sudo cp /home/steve/templates/-d-vhost-config-template-www-force.conf $DIRECTORY/$1.$TLD.conf
		else
			sudo cp /home/steve/templates/-e-vhost-config-template-www.conf $DIRECTORY/$1.$TLD.conf
		fi
	else
		sudo cp /home/steve/templates/-f-vhost-config-template.conf $DIRECTORY/$1.$TLD.conf
	fi
fi
	
sudo sed -i 's/EXAMPLE.COM/'"$1"'.'"$TLD"'/g' $DIRECTORY/$1.$TLD.conf

# The / separator replaced with ! in sed to avoid conflict with / in $n date
sudo sed -i 's!# Created on!# Created on '"$n"' by '"$0"'!g' $DIRECTORY/$1.$TLD.conf

if [[ $wp =~ [A-Z] && $wp == "Y" ]]; then
	# Enable .htaccess Overrides
	if grep -q "#AllowOverride All" $DIRECTORY/$1.$TLD.conf; then
		sudo sed -i 's/#AllowOverride All/AllowOverride All/g' $DIRECTORY/$1.$TLD.conf
		echo "Allowing .htaccess overrides..."
	fi
fi

echo "A temporary Apache .conf file has been created at $DIRECTORY/$1.$TLD"
echo "For the file to take effect run the following commands:"
echo "   sudo mv $DIRECTORY/$1.$TLD /var/www$DIRECTORY/$1.$TLD.conf"
echo "   sudo systemctl reload apache2"

if [[ $ssl =~ [A-Z] && $ssl == "Y" ]]; then
	echo ""
	echo "WARNING: This virtual host has been configured to rewrite all requests to HTTPS."
	echo "To avoid a redirect loop ensure $1.$TLD is paused – not active – on Cloudflare."
	echo ""
fi