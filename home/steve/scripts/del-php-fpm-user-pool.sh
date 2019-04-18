#!/bin/bash
# Steve Ward: 2016-03-09

# USAGE: del-php-fpm-user-pool.sh <user>
# ALIAS: vhost-add <domain> [<tld>]

if [ "$1" == "" ]; then
    echo "ERROR: No user name was specified."
    exit 1
fi

if [ `grep -c "^$1:" /etc/passwd` == 0 ]; then
	echo "ERROR: User '$1' doesn't exist."
	exit -1
fi

#sudo userdel -r $1
sudo deluser --quiet --remove-home $1
echo "User '$1' deleted."

if [ -f /etc/php/7.0/fpm/pool.d/$1.conf ]; then
	sudo rm /etc/php/7.0/fpm/pool.d/$1.conf
fi
echo "Pool '/etc/php/7.0/fpm/pool.d/$1.conf' deleted."

echo "Restarting PHP-FPM"
sudo systemctl restart php7.0-fpm

