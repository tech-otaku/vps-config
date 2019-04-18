#!/bin/bash
# Steve Ward: 2016-09-23

# USAGE: sudo wp-restrictive.sh <domain.tld>

# Check if domain name was passed as parameter - if not, exit.
if [ "$1" == "" ]; then
	echo 'ERROR: No domain  name was specified.'
	exit 1
fi

DIRECTORY="/var/www/$1"

# Check if directory for domain name exits - if not, exit.
if [ ! -d "$DIRECTORY" ]; then
  	echo "ERROR: The directory "${DIRECTORY}" doesn't exist."
    exit 1
fi

# Check if WordPress is installed in directory - if not, exit.
if [ ! -d "$DIRECTORY/public_html/wp-admin" ]; then
  	echo "ERROR: WordPress is not installed in "${DIRECTORY}
    exit 1
fi

if ! grep -q "//define('FS_METHOD', 'direct');" $DIRECTORY/wp-config.php; then
	sudo sed -i "s/define('FS_METHOD/\/\/define('FS_METHOD/g" $DIRECTORY/wp-config.php
fi

sudo chown -R steve:www-data $DIRECTORY/*

sudo find $DIRECTORY/public_html -type d -exec chmod g+s {} \;

find $DIRECTORY/* -type d -exec chmod 755 {} +
find $DIRECTORY/* -type f -exec chmod 644 {} +
find $DIRECTORY/* -name .htaccess -exec chmod 444 {} +

if [ -f $DIRECTORY/wp-config.php ]; then
	chmod 444 $DIRECTORY/wp-config.php
elif [ -f $DIRECTORY/public_html/wp-config.php ]; then
	chmod 444 $DIRECTORY/public_html/wp-config.php
fi

if sudo [ -f /var/tmp/wp-restrictive.$1 ]; then
	sudo rm /var/tmp/wp-restrictive.$1
fi

if sudo [ -f /var/tmp/wp-permissive.$1 ]; then
	sudo rm /var/tmp/wp-permissive.$1
fi
	
sudo touch /var/tmp/wp-restrictive.$1