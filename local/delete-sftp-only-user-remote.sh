#!/bin/bash
# Steve Ward: 2019-09-20

# USAGE: ssh -p 7822 root@94.130.177.167 -S ~/.ssh/controlmasters/%r@%h "bash -s" < /Users/steve/Developer/GitHub/vps-config/local/delete-sftp-only-user-remote.sh "${@}" > "/tmp/${TEMP_FILE}.tmp" &

if [ -z "${1}" ]; then
    echo "ERROR: No user name was specified."
    exit 1
fi

PHP_VERSION=$(php --version | awk '/^PHP/ {print $2}' | cut -d '.' -f 1-2)

for NAME in "$@"; do

	if [ $(grep -c "^${NAME}:" /etc/passwd) -eq 1 ]; then
	
		#tar -cf "/home/${NAME}".tar --files-from /dev/null			# Create an empty .tar file
	
		[ -f "/etc/php/${PHP_VERSION}/fpm/pool.d/${NAME}.conf" ] && rm -f "/etc/php/${PHP_VERSION}/fpm/pool.d/${NAME}.conf"
		
		#[ -d "/var/www/${NAME}" ] && rm -rf "/var/www/${NAME}"
		
		deluser --quiet --remove-home "${NAME}"
	
		printf "${NAME}\n"
		
	fi
	
done

#echo "Restarting PHP-FPM"
#systemctl restart php"${PHP_VERSION}"-fpm


#sudo tar -cf empty.tar --files-from /dev/null
#sudo tar -rf empty.tar /etc/php/7.2/fpm/pool.d/penny.conf
#sudo tar -rf empty.tar /home/penny/sites/demo.barrieward.com