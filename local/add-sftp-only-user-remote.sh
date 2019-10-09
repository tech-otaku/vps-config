#!/bin/bash
# Steve Ward: 2019-09-20

# USAGE: ssh -p 7822 root@94.130.177.167 -S ~/.ssh/controlmasters/%r@%h "bash -s" < /Users/steve/Developer/GitHub/vps-config/local/add-sftp-only-user-remote.sh "${@}" > "/tmp/${TEMP_FILE}.tmp" &


# Files and directories below marked '-*-' are created/modified by this script.
#
# |--- home/										0755 root:root				
#      |-*- user/									0755 root:user			
#      |    |-*- www/								0755 root:root			
#      |-*-.ssh/									0700 user:user			



if [ -z "${1}" ]; then
    echo "ERROR: No user name was specified."
    exit 1
fi

PHP_VERSION=$(php --version | awk '/^PHP/ {print $2}' | cut -d '.' -f 1-2)

for NAME in "$@"; do

	if [ $(grep -c "^${NAME}:" /etc/passwd) -eq 0 ]; then
	
		adduser "${NAME}" --quiet --shell=/bin/false --disabled-password --gecos ''
		
		chmod 0755 "/home/${NAME}"
		chown root:"${NAME}" "/home/${NAME}"
		
		mkdir "/home/${NAME}/www"
		chmod 0755 "/home/${NAME}/www"
		chown root:root "/home/${NAME}/www"
		
		mkdir "/home/${NAME}/.ssh"
		chmod 0700 "/home/${NAME}/.ssh"
		chown "${NAME}:${NAME}" "/home/${NAME}/.ssh"
		
		if ! grep -q -E "^sftp-only:" /etc/group; then
			groupadd -g 9001 sftp-only
		fi
		
		usermod -a -G sftp-only "${NAME}"
	
		printf "${NAME}\n"

		cp "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf" "/etc/php/${PHP_VERSION}/fpm/pool.d/${NAME}.conf" 

		sed -i "s/pool named 'www'./pool named '${NAME}'./g" "/etc/php/${PHP_VERSION}/fpm/pool.d/${NAME}.conf"																		# ; Start a new pool named 'username'.
		sed -i "s/name ('www' here)/name ('${NAME}' here)/g" "/etc/php/${PHP_VERSION}/fpm/pool.d/${NAME}.conf"																		# ; pool name ('username' here)
		sed -i "s/\[www\]/\[${NAME}\]/g" "/etc/php/${PHP_VERSION}/fpm/pool.d/${NAME}.conf"																							# [username]
		sed -i "s/user = www-data/user = ${NAME}/g" "/etc/php/${PHP_VERSION}/fpm/pool.d/${NAME}.conf"																				# user = username
		sed -i "s/listen = \/run\/php\/php${PHP_VERSION}-fpm.sock/listen = \/run\/php\/php${PHP_VERSION}-fpm.${NAME}.sock/g" "/etc/php/${PHP_VERSION}/fpm/pool.d/${NAME}.conf"		# listen = /run/php/php"${PHP_VERSION}"-fpm.username.sock
		sed -i "s/pm = dynamic/pm = ondemand/g" "/etc/php/${PHP_VERSION}/fpm/pool.d/${NAME}.conf"																					# pm = ondemand
		
	fi
	
done

#echo "Restarting php${PHP_VERSION}-fpm"
systemctl restart php"${PHP_VERSION}"-fpm
