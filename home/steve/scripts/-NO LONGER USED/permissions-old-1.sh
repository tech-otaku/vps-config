#!/bin/bash
# Steve Ward: 2016-09-23

# USAGE: sudo permissions.sh <domain.tld>

clear

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

WP="N"
# Check if WordPress is installed in directory.
if [ ! -d "$DIRECTORY/public_html/wp-admin" ]; then
	WP="Y"
#  	echo "ERROR: WordPress is not installed in "${DIRECTORY}
#    exit 1
fi

#if ! grep -q "//define('FS_METHOD', 'direct');" $DIRECTORY/wp-config.php; then
#	sudo sed -i "s/define('FS_METHOD/\/\/define('FS_METHOD/g" $DIRECTORY/wp-config.php
#fi

fperm=640	# All Files
dperm=750	# All directories
hperm=640	# .htaccess, .htdbm, .htpasswds, .user.ini
wperm=750	# wp-content directory and sub-directories 
xperm=640	# wp-config
owner=`grep "AddHandler php7-fcgi-" /etc/apache2/sites-available/$1.conf | cut -d '-' -f 3 | cut -d ' ' -f1`
group=www-data

echo "N.B. Setting permissions to those other than recommended below may render your site inaccessible!"
read -e -i "$owner" -p "> Set ownership to: " input
owner="${input:-$owner}"

read -e -i "$group" -p "> Set group to ('www-data' recommended): " input
group="${input:-$group}"
echo ""

read -e -i "$fperm" -p "> Set file permissions to ($fperm recommended): " input
fperm="${input:-$fperm}"

read -e -i "$dperm" -p "> Set directory permissions to ($dperm recommended): " input
dperm="${input:-$dperm}"


read -e -i "$wperm" -p "> Set permissions on /wp-content/ and sub-directories to ($wperm recommended): " input
wperm="${input:-$wperm}"

read -e -i "$hperm" -p "> Set permissions on .htaccess, .htdbm and .user.ini to ($hperm recommended): " input
hperm="${input:-$hperm}"

read -e -i "$xperm" -p "> Set permissions on wp-config.php to ($xperm recommended): " input
xperm="${input:-$xperm}"


sudo chown -R $owner:$group $DIRECTORY/*

sudo find $DIRECTORY/public_html -type d -exec chmod g+s {} \;

sudo find $DIRECTORY/. -type d -exec chmod $dperm {} +
sudo find $DIRECTORY/. -type f -exec chmod $fperm {} +

if [ -d $DIRECTORY/public_html/wp-content ]; then
	sudo find $DIRECTORY/public_html/wp-content/.  -type d -print0 | xargs -0 chmod $wperm
	sudo find $DIRECTORY/public_html/wp-content/.  -type f -print0 | xargs -0 chmod $fperm
fi

sudo find $DIRECTORY/. -name .htaccess -exec chmod $hperm {} +
sudo find $DIRECTORY/. -name .user.ini -exec chmod $hperm {} +
sudo find $DIRECTORY/. -name .htdbm -exec chmod $hperm {} +
sudo find $DIRECTORY/. -name wp-config.* -exec chmod $xperm {} +

# Give user 'steve' full access to /var/www/$1.$TLD/ and all its files and sub-directories to allow correct use in ForkLift
#sudo setfacl -R -m user:steve:rwx $DIRECTORY

#if sudo [ -f /var/tmp/wp-restrictive.$1 ]; then
#	sudo rm /var/tmp/wp-restrictive.$1
#fi

#if sudo [ -f /var/tmp/wp-permissive.$1 ]; then
#	sudo rm /var/tmp/wp-permissive.$1
#fi
	
#sudo touch /var/tmp/wp-restrictive.$1