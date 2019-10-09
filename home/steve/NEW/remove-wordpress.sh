#!/bin/bash
# Steve Ward: 2016-08-30

# USAGE: sudo bash /home/steve/templates/remove-wordpress.sh <domain.tld>
# ALIAS: wp-remove <domain.tld>
# Removes WordPress files and directories in the /var/www/<domain.tld>/public_html directory

clear

if [ "$1" == "" ]; then
	echo 'ERROR: No domain  name was specified.'
	exit 1
fi

DIRECTORY="/var/www/$1/public_html"
if [ ! -d "$DIRECTORY" ]; then
  	echo "ERROR: The directory "${DIRECTORY}" doesn't exist."
    exit 1
fi

INSTALLED=0 

echo "==================================================================="
echo "WordPress Removal Script for domain $1"
echo "Installation Directory: $DIRECTORY/"
echo "==================================================================="

#read -e -p "Delete wp-config.php (y/n) " delete

#if [ "$delete" == n ] ; then
#    if [ -f "$DIRECTORY/wp-config.php" ] then
#	sudo mv $DIRECTORY/wp-config.php /var/www/$1
#else
#    
#fi

echo ""
read -e -p "Remove WordPress from $DIRECTORY/? (Y/n) " run
if  ! [[ $run =~ [A-Z] && $run == "Y" ]]; then
#if [ "$run" == n ] ; then
	exit 1
fi


TARGET="$DIRECTORY/wp-admin"
if [ -d "$TARGET" ]; then
    sudo rm -rf $TARGET
	INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-content"
if [ -d "$TARGET" ]; then
    sudo rm -rf $TARGET
    INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-includes"
if [ -d "$TARGET" ]; then
    sudo rm -rf $TARGET
	INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="/var/www/$1/.htpasswd"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="/var/www/$1/.htdbm"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/.user.ini"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The directory "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/.htaccess"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-admin/.htaccess"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi


TARGET="$DIRECTORY/index.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/license.txt"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/readme.html"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-activate.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-blog-header.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-comments-post.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-config-sample.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="/var/www/$1/wp-config.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="/var/www/$1/wp-config.bak"
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

TARGET="$DIRECTORY/wp-cron.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-links-opml.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-load.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-login.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-mail.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1

#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-settings.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-signup.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/wp-trackback.php"
if [ -f "$TARGET" ]; then
    sudo rm $TARGET
	INSTALLED=1
#else
  	#echo "The file "${TARGET}" doesn't exist."
fi

TARGET="$DIRECTORY/xmlrpc.php"
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
	echo "No WordPress install found in $DIRECTORY"
else
	echo "WordPress has been removed from $DIRECTORY"
fi

echo ""