#!/usr/bin/env bash
# Steve Ward: 2019-09-29

# USAGE: sudo permissions.sh <domain> [<tld>]
# NOTE: If <tld> is not supplied a tld of 'com' is assumed i.e. add-vhost.sh tech-otaku or add-vhost.sh steveward me.uk
# ALIAS: none
# CODE: /home/steve/scripts/permissions.sh

# TREE: Files and directories (and their sub-directories) below marked '-*-' are modified by this script.
#
# |--- home/
#      |--- user/
#           |--- www/	
#                |-*- domain.tld/					0755 root:www-data
#                     |-*- public_html/				2750 user:www-data
#                          |-*- <FILES>.*			0640 user:www-data 
#                          |-*- <DIRECTORIES>.*		0750 user:www-data
#                     |-*- .htdbm					0440 user:www-data
#                     |-*- .prevent_deletion		0400 root:root
#                     |-*- mysql-credentials.ini	0640 user:www-data
#                     |-*- wp-config.* 				0640 user:www-data

#clear

# Make sure root is running this script
if [ $EUID -ne 0  ]; then
   printf "ERROR: This script must be run as root.\n" 1>&2
   exit 1
fi

# Exit if no domain name was specified.
if [ -z "${1}" ]; then
    printf "ERROR: No domain name was specified.\n"
    exit 1
fi

# Exit if the configuration file doesn't exist.
if [ ! -f "/home/steve/config/vhost-config.json" ]; then
	printf "ERROR: Can't find the configuration file '/home/steve/config/vhost-config.json'.\n"
	exit 1
fi

DOMAIN="${1}"

if [ -z "${2}" ]; then
	TLD="com"
else 
	TLD="${2}"
fi

# Exit if the configuration file doesn't contain configuration data for the domain.
grep -q '"'$DOMAIN.$TLD'"' /home/steve/config/vhost-config.json
if [ $? -ne 0 ]; then
	printf "ERROR: No configuration data found for domain '$DOMAIN.$TLD'.\n"
	exit 1
fi


ROOT_DIR=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['domain']['$DOMAIN.$TLD']['root_dir'])")

# # Exit if the domain's root directory doesn't exist.
if [ ! -d "${ROOT_DIR}" ]; then
  	echo "ERROR: The directory "${ROOT_DIR}" doesn't exist."
    exit 1
fi

DOCUMENT_ROOT=$ROOT_DIR/public_html
GROUP=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['defaults']['group'])")
OWNER=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['domain']['$DOMAIN.$TLD']['owner'])")

#fperm=640	# All Files
#dperm=750	# All directories
#hperm=640	# .htaccess, .htdbm, .htpasswds, .user.ini
#wperm=750	# wp-content directory and sub-directories 
#xperm=640	# wp-config
OWNER_CONF=$(grep "SetHandler \"proxy:unix:" "/etc/apache2/sites-available/$DOMAIN.$TLD.conf" | cut -d '-' -f 2 | cut -d '.' -f 2)

printf "${GROUP}\n"
printf "${ROOT_DIR}\n"
printf "${OWNER}\n"
printf "${OWNER_CONF}\n"
printf "${DOCUMENT_ROOT}\n"
#exit


#group=www-data

#echo "N.B. Setting permissions to those other than recommended below may render your site inaccessible!"
#read -e -i "$owner" -p "> Set ownership to: " input
#owner="${input:-$owner}"

#read -e -i "$group" -p "> Set group to ('www-data' recommended): " input
#group="${input:-$group}"
#echo ""

#read -e -i "$fperm" -p "> Set file permissions to ($fperm recommended): " input
#fperm="${input:-$fperm}"

#read -e -i "$dperm" -p "> Set directory permissions to ($dperm recommended): " input
#dperm="${input:-$dperm}"


#read -e -i "$wperm" -p "> Set permissions on /wp-content/ and sub-directories to ($wperm recommended): " input
#wperm="${input:-$wperm}"

#read -e -i "$hperm" -p "> Set permissions on .htaccess, .htdbm and .user.ini to ($hperm recommended): " input
#hperm="${input:-$hperm}"

#read -e -i "$xperm" -p "> Set permissions on wp-config.php to ($xperm recommended): " input
#xperm="${input:-$xperm}"

chown root:"${GROUP}" "${ROOT_DIR}"
chmod 755 "${ROOT_DIR}"
find "${ROOT_DIR}"/. -name .htdbm -exec chown "${OWNER}":"${GROUP}" {} \; -exec chmod 440 {} \;
find "${ROOT_DIR}"/. -name .prevent-deletion -exec chown root:root {} \; -exec chmod 400 {} \;
find "${ROOT_DIR}"/. -name mysql-credentials.ini -exec chown "${OWNER}":"${GROUP}" {} \; -exec chmod 640 {} \;
find "${ROOT_DIR}"/. -name wp-config.* -exec chown "${OWNER}":"${GROUP}" {} \; -exec chmod 640 {} \;
find "${DOCUMENT_ROOT}"/. -type d -exec chmod 750 {} +
find "${DOCUMENT_ROOT}"/. -type f -exec chmod 640 {} +
chown -R "${OWNER}":"${GROUP}" "${DOCUMENT_ROOT}"
chmod g+s "${DOCUMENT_ROOT}"
#setfacl -Rdm g:www-data:rx "${DOCUMENT_ROOT}"
setfacl -Rdm g:"${GROUP}":rx "${DOCUMENT_ROOT}"


#sudo chown -R $owner:$group $DIRECTORY/*

#sudo find $DIRECTORY/public_html -type d -exec chmod g+s {} \;

#sudo find $DIRECTORY/. -type d -exec chmod $dperm {} +
#sudo find $DIRECTORY/. -type f -exec chmod $fperm {} +

#if [ -d $DIRECTORY/public_html/wp-content ]; then
#	sudo find $DIRECTORY/public_html/wp-content/.  -type d -print0 | xargs -0 chmod $wperm
#	sudo find $DIRECTORY/public_html/wp-content/.  -type f -print0 | xargs -0 chmod $fperm
#fi

#sudo find $DIRECTORY/. -name .htaccess -exec chmod $hperm {} +
#sudo find $DIRECTORY/. -name .user.ini -exec chmod $hperm {} +
#sudo find $DIRECTORY/. -name .htdbm -exec chmod $hperm {} +
#sudo find $DIRECTORY/. -name wp-config.* -exec chmod $xperm {} +
