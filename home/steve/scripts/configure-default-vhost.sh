#!/bin/bash
# Steve Ward: 2016-10-30

# USAGE: configure-default-vhost.sh [-R]
# The -R flag resets the default virtual host to its factory defaults.
# CODE: /home/steve/scripts/configure-default-vhost.sh
# Configures Apache's default virtual host: 000-default.conf

clear

# Make sure root is not running this script
if [[ $EUID -eq 0 ]]; then
   echo "ERROR:This script must NOT be run as root." 1>&2
   exit 1
fi

DIRECTORY="/var/www/html"
if [ ! -d "$DIRECTORY" ]; then
  	echo "ERROR: The directory "${DIRECTORY}" doesn't exist."
    exit 1
fi

if [ "$1" == "-R" ]; then
	echo "Resetting to factory defaults..."
	sudo a2dissite 000-default.conf
	sudo service apache2 reload
    sudo cp /home/steve/templates/apache-originals/000-default.conf /etc/apache2/sites-available/000-default.conf
    sudo cp /home/steve/templates/apache-originals/index.html /var/www/html/index.html
    sudo rm /var/www/html/error.php
    sudo a2ensite 000-default.conf
	sudo service apache2 reload
	echo "Reset to factory defaults..."
	exit
fi


DOMAIN=$(echo $(hostname -f) | sed 's/\.[^.][^.]*$//')
read -e -i "$DOMAIN" -p "> Domain name to be used is: " input
DOMAIN="${input:-$DOMAIN}"

TLD=$(echo $(hostname -f) | rev | cut -d'.' -f1 | rev)
read -e -i "$TLD" -p "> TLD to be used is: " input
TLD="${input:-$TLD}"

echo "==================================================================="
echo "Create Virtual Host Script for domain $DOMAIN.$TLD"
echo "Installation directory: $DIRECTORY/"
echo "==================================================================="


# Get server's IP address
IP=$(curl -s http://icanhazip.com)

#if [ "$IP" == "198.100.45.145" ]; then
#	HOST="A2 Hosting"
#else
	HOST="Digital Ocean"
#fi

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

# Check for existence of SSL certificate and enable mod_ssl
if [[ $ssl =~ [A-Z] && $ssl == "Y" ]]; then
	if sudo [ ! -d "/etc/letsencrypt/live/$DOMAIN.$TLD" ]; then
		echo "ERROR: The certificate directory /etc/letsencrypt/live/$DOMAIN.$TLD does not"
		echo "exist which will cause Apache to throw an error."
		echo "See the 'Configure SSL Certificates with Let’s Encrypt' section of the"
		echo "'Digital Ocean VPS Configuration.docx' document."
		exit -1
	fi
    if [ ! -f "/etc/apache2/mods-enabled/ssl.load" ]; then
	    sudo a2enmod ssl
    fi
fi


# Temporarily disable the default site
sudo a2dissite 000-default.conf
sudo service apache2 reload

day=$(date +%a)
tz=$(date +%Z)
VER=$(date "+FAC-`echo "$day" | perl -ne 'print lc'`%Y%m%d%H%M%S`echo "$tz" | perl -ne 'print lc'`")

sudo cp /home/steve/templates/index.html /var/www/html/index.html
sudo sed -i 's/REPLACE WITH TITLE/'"$DOMAIN"'.'"$TLD"' | Coming Soon/g' /var/www/html/index.html
sudo sed -i 's/REPLACE WITH DOMAIN/'"$DOMAIN"'.'"$TLD"'/g' /var/www/html/index.html
sudo sed -i 's/REPLACE WITH TAG LINE/The future home of something new/g' /var/www/html/index.html
sudo sed -i 's/REPLACE WITH VERSION/'"$VER"'/g' /var/www/html/index.html

#cp /home/steve/templates/error.php /var/www/$DOMAIN.$TLD/public_html/error.php

#FILE="/var/www/html/error.php"
if [ ! -f "$DIRECTORY/error.php" ]; then
	sudo cp /home/steve/templates/error.php $DIRECTORY/error.php
fi

#FILE="/var/www/html/info.php"
#if [ ! -f "$DIRECTORY/info.php" ]; then
#	sudo cp /home/steve/templates/info.php $DIRECTORY/info.php
#fi

#if [ ! -f "/var/www/html/index.php" ]; then
	#sudo cp /home/steve/templates/index.php /var/www/html/index.php
#fi


#cp /home/steve/templates/.htaccess /var/www/$DOMAIN.$TLD/public_html/.htaccess
#sed -i 's/example.com/'"$DOMAIN"'.'"$TLD"'/g' /var/www/$DOMAIN.$TLD/public_html/.htaccess

#echo '# Directives for this site can be found in /etc/apache2/sites-available/'"$DOMAIN"'.'"$TLD"'.conf' >> .htaccess
#sudo mv .htaccess /var/www/$DOMAIN.$TLD/public_html/.htaccess

n=$(date "+%d/%m/%y at %H:%M:%S")

if [[ $ssl =~ [A-Z] && $ssl == "Y" ]]; then
	if [[ $www =~ [A-Z] && $www == "Y" ]]; then
		if [[ $force =~ [A-Z] && $force == "Y" ]]; then
			sudo cp /home/steve/templates/php-fpm/-a-vhost-config-template-ssl-www-force.conf /etc/apache2/sites-available/000-default.conf
		else
			sudo cp /home/steve/templates/php-fpm/-b-vhost-config-template-ssl-www.conf /etc/apache2/sites-available/000-default.conf
		fi
	else
		sudo cp /home/steve/templates/php-fpm/-c-vhost-config-template-ssl.conf /etc/apache2/sites-available/000-default.conf
	fi
else
	if [[ $www =~ [A-Z] && $www == "Y" ]]; then
		if [[ $force =~ [A-Z] && $force == "Y" ]]; then
			sudo cp /home/steve/templates/php-fpm/-d-vhost-config-template-www-force.conf /etc/apache2/sites-available/000-default.conf
		else
			sudo cp /home/steve/templates/php-fpm/-e-vhost-config-template-www.conf /etc/apache2/sites-available/000-default.conf
		fi
	else
		sudo cp /home/steve/templates/php-fpm/-f-vhost-config-template.conf /etc/apache2/sites-available/000-default.conf
	fi
fi

sudo sed -i 's/\/var\/www\/EXAMPLE.COM\/public_html/\/var\/www\/html/g' /etc/apache2/sites-available/000-default.conf
sudo sed -i 's/EXAMPLE.COM/'"$DOMAIN"'.'"$TLD"'/g' /etc/apache2/sites-available/000-default.conf
sudo sed -i 's/POOL.conf/www.conf/g' /etc/apache2/sites-available/000-default.conf
sudo sed -i 's/.POOL.sock/.sock/g' /etc/apache2/sites-available/000-default.conf
sudo sed -i 's/-POOL/'""'/g' /etc/apache2/sites-available/000-default.conf

# The / separator replaced with ! in sed to avoid conflict with / in $n date
sudo sed -i 's!# Created on!# Created on '"$n"' by '"$0"'!g' /etc/apache2/sites-available/000-default.conf

sudo a2ensite 000-default.conf

echo "Restarting Apache"
sudo systemctl restart apache2

echo "Restarting PHP-FPM"
sudo systemctl restart php7.0-fpm


if [ "$" != "-R" ]; then
	return-403-forbidden.sh

	if [[ $ssl =~ [A-Z] && $ssl == "Y" ]]; then
		echo ""
		echo "WARNING: This virtual host has been configured to rewrite all requests to HTTPS."
		echo "To avoid a redirect loop ensure $DOMAIN.$TLD is paused – not active – on Cloudflare."
		echo ""
	fi
fi
