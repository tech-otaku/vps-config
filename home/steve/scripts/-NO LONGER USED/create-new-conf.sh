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
  	echo "ERROR: The directory ${DIRECTORY} doesn't exist."
    exit 1
fi

echo "==================================================================="
echo "Create New Virtual Host .conf File for domain $1.$TLD"
echo "File will be named /etc/apache2/sites-available/$1.$TLD.conf.new"
echo "Current config is `grep '# ssl:' /etc/apache2/sites-available/$1.$TLD.conf`"
echo "==================================================================="

php_version_major=$(php --version | awk '/^PHP/ {print $2}' | cut -d '.' -f 1)
php_version_minor=$(php --version | awk '/^PHP/ {print $2}' | cut -d '.' -f 2)

# Get server's IP address
IP=$(curl -s http://icanhazip.com)

if [ "$IP" == "198.100.45.145" ]; then
	HOST="A2 Hosting"
else 
	HOST="Digital Ocean"
fi

# Get the port Apache is listening on
#apacheport=`sudo netstat -tlpn | grep apache2 | awk '{print $4}' | grep -o '[0-9]*'`
#read -e -i "$apacheport" -p "> Apache is listening on port: " input
#apacheport="${input:-$apacheport}"

if [[ $php_version_major -ge 7 && $php_version_minor -ge 2 ]]; then
	pool=`grep "SetHandler \"proxy" /etc/apache2/sites-available/$1.$TLD.conf | cut -d '-' -f2 | cut -d '.' -f2`
else
	pool=`grep "AddHandler php7-fcgi-" /etc/apache2/sites-available/$1.$TLD.conf | cut -d '-' -f 3 | cut -d ' ' -f1`
fi

read -e -i "$pool" -p "> PHP-FPM Pool to use: " input
pool="${input:-$pool}"
echo ""

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

# FOR TESTING ONLY
#template="a"
#read -e -i "$template" -p "> Which template [a|b|c|d|e|f] ? " input
#template="${input:-$template}"
#sudo cp /home/steve/templates/new/$template.conf /etc/apache2/sites-available/$1.$TLD.conf
# END FOR TESTING ONLY

# Check for existence of SSL certificate and enable mod_ssl
if [[ $ssl =~ [A-Z] && $ssl == "Y" ]]; then
	if sudo [ ! -d "/etc/letsencrypt/live/$1.$TLD" ]; then
		echo "ERROR: The certificate directory /etc/letsencrypt/live/$1.$TLD does not"
		echo "exist which will cause Apache to throw an error."
		echo "See the 'Configure SSL Certificates with Let’s Encrypt' section of the"
		echo "'Digital Ocean VPS Configuration.docx' document."
		exit -1
	fi
    if [ ! -f "/etc/apache2/mods-enabled/ssl.load" ]; then
	    sudo a2enmod ssl
    fi
fi

n=$(date "+%d/%m/%y at %H:%M:%S")

if [[ $ssl =~ [A-Z] && $ssl == "Y" ]]; then
	if [[ $www =~ [A-Z] && $www == "Y" ]]; then
		if [[ $force =~ [A-Z] && $force == "Y" ]]; then
			sudo cp /home/steve/templates/php-fpm/-a-vhost-config-template-ssl-www-force.conf /etc/apache2/sites-available/$1.$TLD.conf.new
		else
			sudo cp /home/steve/templates/php-fpm/-b-vhost-config-template-ssl-www.conf /etc/apache2/sites-available/$1.$TLD.conf.new
		fi
	else
		sudo cp /home/steve/templates/php-fpm/-c-vhost-config-template-ssl.conf /etc/apache2/sites-available/$1.$TLD.conf.new
	fi
else
	if [[ $www =~ [A-Z] && $www == "Y" ]]; then
		if [[ $force =~ [A-Z] && $force == "Y" ]]; then
			sudo cp /home/steve/templates/php-fpm/-d-vhost-config-template-www-force.conf /etc/apache2/sites-available/$1.$TLD.conf.new
		else
			sudo cp /home/steve/templates/php-fpm/-e-vhost-config-template-www.conf /etc/apache2/sites-available/$1.$TLD.conf.new
		fi
	else
		sudo cp /home/steve/templates/php-fpm/-f-vhost-config-template.conf /etc/apache2/sites-available/$1.$TLD.conf.new
	fi
fi
	
sudo sed -i 's/EXAMPLE.COM/'"$1"'.'"$TLD"'/g' /etc/apache2/sites-available/$1.$TLD.conf.new
sudo sed -i 's/POOL/'"$pool"'/g' /etc/apache2/sites-available/$1.$TLD.conf.new

# The / separator replaced with ! in sed to avoid conflict with / in $n date
sudo sed -i 's!# Created on!# Created on '"$n"' by '"$0"'!g' /etc/apache2/sites-available/$1.$TLD.conf.new

echo "Renaming $1.$TLD.conf as $1.$TLD.conf.old"
sudo mv /etc/apache2/sites-available/$1.$TLD.conf /etc/apache2/sites-available/$1.$TLD.conf.old

echo "Renaming $1.$TLD.conf.new as $1.$TLD.conf"
sudo mv /etc/apache2/sites-available/$1.$TLD.conf.new /etc/apache2/sites-available/$1.$TLD.conf

echo "Restarting Apache"
sudo systemctl restart apache2

echo "Restarting PHP-FPM"
sudo systemctl restart php"${php_version_major}.${php_version_minor}"-fpm
