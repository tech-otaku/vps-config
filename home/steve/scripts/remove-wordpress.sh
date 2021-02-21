DOCUMENT_ROOT#!/bin/bash
# Steve Ward: 2016-08-30

# USAGE: sudo bash /home/steve/templates/remove-wordpress.sh <domain.tld>
# ALIAS: wp-remove <domain.tld>
# Removes WordPress files and directories in the /var/www/<domain.tld>/public_html directory

clear

if [ "$1" == "" ]; then
	echo 'ERROR: No domain  name was specified.'
	exit 1
fi

# Exit if the configuration file doesn't exist.
if [ ! -f "/home/steve/config/vhost-config.json" ]; then
	printf "ERROR: Can't find the configuration file '/home/steve/config/vhost-config.json'.\n"
	exit 1
fi

# Exit if the configuration file doesn't contain configuration data for the domain.
grep -q '"'$1'"' /home/steve/config/vhost-config.json
if [ $? -ne 0 ]; then
	printf "ERROR: No configuration data found for domain '$1'.\n"
	exit 1
fi

#DIRECTORY="/var/www/$1"
DIRECTORY=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['domain']['$1']['root_dir'])")
#DOCUMENT_ROOT="$DIRECTORY/public_html"
DOCUMENT_ROOT=$DIRECTORY/public_html

#DIRECTORY="/var/www/$1/public_html"
if [ ! -d "$DOCUMENT_ROOT" ]; then
  	echo "ERROR: The directory "${DOCUMENT_ROOT}" doesn't exist."
    exit 1
fi

INSTALLED=0

echo "==================================================================="
echo "WordPress Removal Script for domain $1"
echo "Installation Directory: $DOCUMENT_ROOT/"
echo "==================================================================="

#read -e -p "Delete wp-config.php (y/n) " delete

#if [ "$delete" == n ] ; then
#    if [ -f "$DOCUMENT_ROOT/wp-config.php" ] then
#	sudo mv $DOCUMENT_ROOT/wp-config.php /var/www/$1
#else
#
#fi

echo ""
read -e -p "Remove WordPress from $DOCUMENT_ROOT/? (Y/n) " run
if  ! [[ $run =~ [A-Z] && $run == "Y" ]]; then
#if [ "$run" == n ] ; then
	exit 1
fi


TARGET="$DOCUMENT_ROOT/wp-admin"
if [ -d "$TARGET" ]; then
    sudo rm -rf $TARGET
	INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-content"
if [ -d "$TARGET" ]; then
    sudo rm -rf $TARGET
    INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-includes"
if [ -d "$TARGET" ]; then
    sudo rm -rf $TARGET
	INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/.htpasswd"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/.htdbm"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/.user.ini"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/.htaccess"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-admin/.htaccess"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi


TARGET="$DOCUMENT_ROOT/index.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/license.txt"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/readme.html"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-activate.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-blog-header.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-comments-post.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-config-sample.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-config.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-config.bak"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-config.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-cron.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-links-opml.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-load.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-login.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-mail.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-settings.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-signup.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/wp-trackback.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DOCUMENT_ROOT/xmlrpc.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

#Disable .htaccess Overrides
if ! grep -q "#AllowOverride All" /etc/apache2/sites-available/$1.conf; then
    sudo sed -i 's/AllowOverride All/#AllowOverride All/g' /etc/apache2/sites-available/$1.conf
fi

echo ""

if [ "$INSTALLED" == 0 ]; then
	echo "No WordPress install found in $DOCUMENT_ROOT"
else
	echo "WordPress has been removed from $DOCUMENT_ROOT"
fi

echo ""
