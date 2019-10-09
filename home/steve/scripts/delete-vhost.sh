#!/usr/bin/env bash
# Steve Ward: 2019-09-29

# USAGE: sudo delete-vhost.sh <domain> [<tld>]
# NOTE: If <tld> is not supplied a tld of 'com' is assumed i.e. add-vhost.sh tech-otaku or add-vhost.sh steveward me.uk
# ALIAS: vhost-del <domain> [<tld>]
# CODE: /home/steve/scripts/delete-vhost.sh

# TREE: Files and directories below marked '-*-' are deleted by this script.
#
# |--- etc/
#      |--- apache2/
#           |--- sites-available/
#                |-*- domain.tld.conf				0644 root:root
#
# |--- home/
#      |--- user/
#           |--- www/	
#                |-*- domain.tld/					0755 root:www-data


clear

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

#DIRECTORY="/var/www/$1.$TLD/public_html/"
ROOT_DIR=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['domain']['$DOMAIN.$TLD']['root_dir'])")
DOCUMENT_ROOT=$ROOT_DIR/public_html
PHP_VERSION=$(php --version | awk '/^PHP/ {print $2}' | cut -d '.' -f 1-2)

# Exit if the domain's document root directory doesn't exist.
if [ ! -d "${DOCUMENT_ROOT}" ]; then
  	printf "ERROR: The directory ${DOCUMENT_ROOT} doesn't exist."
    exit 1
fi

CONT="Y"

if [ ! -f "${ROOT_DIR}/.prevent-deletion" ]; then
	read -e -i "${CONT}" -p "> WARNING: Are you sure you want to delete the virtual host '${DOMAIN}.${TLD}' (Y/n) ? " input
else
	echo "WARNING: The virtual host '${DOMAIN}.${TLD}' is protected from deletion."
	echo -e "If you wish to proceed, you'll be prompted to enter a 4-digit confirmation code before it's deleted.\n"
	read -e -i "${CONT}" -p "> Do you want to continue with the deletion of the virtual host '${DOMAIN}.${TLD}' (Y/n) ? " input
fi

CONT="${input:-$CONT}"

if [[ $CONT == "Y" ]]; then

	if [ -f "${ROOT_DIR}/.prevent-deletion" ]; then
		CODE=$(shuf -i 1000-9999 -n 1)
		DEL=""
		read -e -i "${DEL}" -p "> Type '$CODE' to delete it or press any key to leave intact: " input
		DEL="${input:-$DEL}"
		if [[ ! $DEL == $CODE ]]; then
			echo "INFORMATION: The virtual host '${DOMAIN}.${TLD}' has *** NOT *** been deleted."
			exit 1
		fi
	fi
	
	printf "\n"
	
	printf "1. The domain '${DOMAIN}.${TLD}' will be disabled.\n"
	printf "2. The file '/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf' will be deleted.\n"
	printf "3. The directory '${ROOT_DIR}' will be deleted.\n"
	
	CONT="Y"
	read -e -i "${CONT}" -p "> Continue  (Y/n) ? " input
	CONT="${input:-$CONT}"
	
	if [[ ! $CONT == "Y" ]]; then
		echo "INFORMATION: The virtual host '${DOMAIN}.${TLD}' has *** NOT *** been deleted."
		exit 1
	fi

	printf "INFORMATION: Disabling domain '${DOMAIN}.${TLD}'\n"
	a2dissite "${DOMAIN}.${TLD}.conf"
	
	printf "INFORMATION: Deleting file '/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf'\n"
	rm "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
	
	printf "INFORMATION: Deleting directory '${ROOT_DIR}'\n"
	rm -rf "${ROOT_DIR}"
	
	printf "INFORMATION: Restarting Apache\n"
	systemctl restart apache2

	printf "INFORMATION: Restarting php${PHP_VERSION}-fpm\n"
	systemctl restart php"${PHP_VERSION}"-fpm

	echo "INFORMATION: The virtual host '${DOMAIN}.${TLD}' has been deleted."
	
else

	echo "INFORMATION: The virtual host '${DOMAIN}.${TLD}' has *** NOT *** been deleted."
	
fi