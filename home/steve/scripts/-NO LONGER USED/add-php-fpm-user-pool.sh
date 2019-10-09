#!/bin/bash
# Steve Ward: 2016-03-09

# USAGE: add-php-fpm-user-pool.sh <user>


if [ "$1" == "" ]; then
    echo "ERROR: No user name was specified."
    exit 1
fi

php_version=$(php --version | awk '/^PHP/ {print $2}' | cut -d '.' -f 1-2)

for user in "$@"
do

	if [ `grep -c "^$user:" /etc/passwd` == 1 ]; then
	
		echo -e "WARNING: User '$user' already exists. Skipping...\n"
		
	else
 
		sudo adduser $user --quiet --shell=/bin/false --no-create-home --disabled-login --gecos ""
		#sudo adduser $user --quiet --shell=/bin/false --disabled-login --gecos ""
		echo "User '$user' added."

		sudo cp /etc/php/"${php_version}"/fpm/pool.d/www.conf /etc/php/"${php_version}"/fpm/pool.d/$user.conf 
		echo -e "Pool '/etc/php/${php_version}/fpm/pool.d/$user.conf' created.\n"

		sudo sed -i "s/pool named 'www'./pool named '$user'./g" /etc/php/"${php_version}"/fpm/pool.d/$user.conf												# ; Start a new pool named 'username'.
		sudo sed -i "s/name ('www' here)/name ('$user' here)/g" /etc/php/"${php_version}"/fpm/pool.d/$user.conf												# ; pool name ('username' here)
		sudo sed -i "s/\[www\]/\[$user\]/g" /etc/php/"${php_version}"/fpm/pool.d/$user.conf																	# [username]
		sudo sed -i "s/user = www-data/user = $user/g" /etc/php/"${php_version}"/fpm/pool.d/$user.conf															# user = username
		sudo sed -i "s/listen = \/run\/php\/php${php_version}-fpm.sock/listen = \/run\/php\/php${php_version}-fpm.$user.sock/g" /etc/php/"${php_version}"/fpm/pool.d/$user.conf		# listen = /run/php/php"${php_version}"-fpm.username.sock
		sudo sed -i "s/pm = dynamic/pm = ondemand/g" /etc/php/"${php_version}"/fpm/pool.d/$user.conf														# pm = ondemand
		
	fi
	
done

echo "Restarting PHP-FPM"
sudo systemctl restart php"${php_version}"-fpm
