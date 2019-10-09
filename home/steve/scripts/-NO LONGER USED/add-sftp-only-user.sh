#!/bin/bash
# Steve Ward: 2016-03-09

# USAGE: add-sftp-only-user.sh <user>


if [ "$1" == "" ]; then
    echo "ERROR: No user name was specified."
    exit 1
fi

PHP_VERSION=$(php --version | awk '/^PHP/ {print $2}' | cut -d '.' -f 1-2)

for NAME in "$@"
do

	if [ $(grep -c "^${NAME}:" /etc/passwd) -eq 1 ]; then
	
		printf "WARNING: User '${NAME}' already exists. Skipping...\n"
		
	else
	
		printf ""
 
		#sudo adduser ${NAME} --shell /bin/false 
		
		#echo "User '${NAME}' added."

		#sudo cp /etc/php/"${PHP_VERSION}"/fpm/pool.d/www.conf /etc/php/"${PHP_VERSION}"/fpm/pool.d/${NAME}.conf 
		#echo -e "Pool '/etc/php/${PHP_VERSION}/fpm/pool.d/${NAME}.conf' created.\n"

		#sudo sed -i "s/pool named 'www'./pool named '${NAME}'./g" /etc/php/"${PHP_VERSION}"/fpm/pool.d/${NAME}.conf												# ; Start a new pool named 'username'.
		#sudo sed -i "s/name ('www' here)/name ('${NAME}' here)/g" /etc/php/"${PHP_VERSION}"/fpm/pool.d/${NAME}.conf												# ; pool name ('username' here)
		#sudo sed -i "s/\[www\]/\[${NAME}\]/g" /etc/php/"${PHP_VERSION}"/fpm/pool.d/${NAME}.conf																	# [username]
		#sudo sed -i "s/user = www-data/user = ${NAME}/g" /etc/php/"${PHP_VERSION}"/fpm/pool.d/${NAME}.conf															# user = username
		#sudo sed -i "s/listen = \/run\/php\/php${PHP_VERSION}-fpm.sock/listen = \/run\/php\/php${PHP_VERSION}-fpm.${NAME}.sock/g" /etc/php/"${PHP_VERSION}"/fpm/pool.d/${NAME}.conf		# listen = /run/php/php"${PHP_VERSION}"-fpm.username.sock
		#sudo sed -i "s/pm = dynamic/pm = ondemand/g" /etc/php/"${PHP_VERSION}"/fpm/pool.d/${NAME}.conf														# pm = ondemand
		
	fi
	
done

#echo "Restarting PHP-FPM"
#sudo systemctl restart php"${PHP_VERSION}"-fpm
