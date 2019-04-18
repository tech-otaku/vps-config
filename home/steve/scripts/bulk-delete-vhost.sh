#!/bin/bash
# Steve Ward: 2016-09-24

# USAGE: bulk-delete-vhost.sh
# Bulk deletion of virtual hosts in /var/www/ excluding /var/www/html/

for i in /var/www/*; do 
	if [ -d $i ]; then 
		if [ ! $i == "/var/www/html" ] && [ ! $i == "/var/www/steveward.me.uk" ]  && [ ! $i == "/var/www/tech-otaku.com" ]; then
			#echo $i 
			#echo "$(basename $i)" | awk -F. '{print $1}'
			echo "--> Deleting " $i
			sudo a2dissite $(basename $i).conf
			sudo rm /etc/apache2/sites-available/$(basename $i).conf
			sudo rm -rf $i
			echo "--> $i deleted."
		fi
	fi
done

sudo systemctl restart apache2