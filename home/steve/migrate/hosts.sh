#!/bin/bash

IGNORE=("N/A")

PHPVERSION=$(echo php$(php --version | awk '/^PHP/ {print $2}' | cut -d '.' -f 1-2)-fpm)

while IFS="" read -r host || [ -n "$host" ]; do
	DOMAIN=$(echo "$host" | cut -d';' -f1)
	TLD=$(echo "$host" | cut -d';' -f2)
	OWNER=$(echo "$host" | cut -d';' -f3)
	
	if [[ ! " ${IGNORE[@]} " =~ " ${DOMAIN}.${TLD} " ]]; then
		printf "Processing '%s'\n" $DOMAIN.$TLD
		
		if [ -d /home/steve/tmp/home/$OWNER/www/$DOMAIN.$TLD ]; then
		
			sudo mv /home/steve/tmp/home/$OWNER/www/$DOMAIN.$TLD /home/$OWNER/www
			sudo mv /home/steve/tmp/etc/apache2/sites-available/$DOMAIN.$TLD.conf /etc/apache2/sites-available
			sudo chown root:root /etc/apache2/sites-available/$DOMAIN.$TLD.conf
			sudo chmod 644 /etc/apache2/sites-available/$DOMAIN.$TLD.conf
			sudo sed -i.$(date +"%Y%m%d-%H%M%S") 's|php7.2-fpm.|${PHPVERSION}.|' /etc/apache2/sites-available/$DOMAIN.$TLD.conf
			sudo /home/steve/scripts/permissions.sh $DOMAIN $TLD
			sudo cp /home/steve/templates/info/info-full.php /home/$OWNER/www/$DOMAIN.$TLD/public_html/info.php
			sudo chown $OWNER:www-data /home/$OWNER/www/$DOMAIN.$TLD/public_html/info.php
			sudo chmod 640 /home/$OWNER/www/$DOMAIN.$TLD/public_html/info.php
			sudo a2ensite $DOMAIN.$TLD.conf
		else
			printf "     Looks like '%s' has already been migrated?\n" $DOMAIN.$TLD
		fi
	fi

done < ./hosts.migrate

sudo systemctl restart apache2 && sudo systemctl restart ${PHPVERSION}

