#!/bin/bash
# Steve Ward: 2016-03-09

# USAGE: bash /home/steve/templates/delete-vhost.sh <domain> [<tld>]
# ALIAS: vhost-del <domain> [<tld>]
# If <tld> is not supplied a tld of 'com' is assumed i.e. bash delete-vhost.sh tech-otaku or bash delete-vhost.sh steveward me.uk

# Source: https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-14-04-lts

clear

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

CONT="Y"

if [ ! -f "/var/www/$1.$TLD/.prevent-deletion" ]; then
	read -e -i "${CONT}" -p "> WARNING: Are you sure you want to delete the virtual host '$1.$TLD' (Y/n) ? " input
else
	echo "WARNING: The virtual host '$1.$TLD' is protected from deletion."
	echo -e "If you wish to proceed, you'll be prompted to enter a 4-digit confirmation code before it's deleted.\n"
	read -e -i "${CONT}" -p "> Do you want to continue with the deletion of the virtual host '$1.$TLD' (Y/n) ? " input
fi

CONT="${input:-$CONT}"

if [[ $CONT == "Y" ]]; then

	if [ -f "/var/www/$1.$TLD/.prevent-deletion" ]; then
		CODE=$(shuf -i 1000-9999 -n 1)
		DEL=""
		read -e -i "${DEL}" -p "> Type '$CODE' to delete it or press any key to leave intact: " input
		DEL="${input:-$DEL}"
		if [[ ! $DEL == $CODE ]]; then
			echo "INFORMATION: The virtual host '$1.$TLD' has *** NOT *** been deleted."
			exit 1
		fi
	fi	

	sudo a2dissite $1.$TLD.conf
	sudo rm /etc/apache2/sites-available/$1.$TLD.conf
	sudo rm -rf /var/www/$1.$TLD
	sudo systemctl restart apache2

	echo "INFORMATION: The virtual host '$1.$TLD' has been deleted."
	
else

	echo "INFORMATION: The virtual host '$1.$TLD' has NOT been deleted."
	
fi