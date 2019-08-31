#!/bin/bash
# Steve Ward: 2017-02-09

# $1 = domain

if [ ! -d /home/steve/site-backups ]; then
	sudo mkdir /home/steve/site-backups
fi

cd /var/www/

if [ -d /var/www/"${1}" ]; then

	NOW=$(env TZ=Europe/London date +"%C%y-%m-%d_%H-%M-%S")

	tar cv --exclude='_*.gz' --exclude='public_html/wp-content/wflogs' $1 | gzip --best > /home/steve/site-backups/"${1}"_${NOW}.gz

	chown steve:steve  /home/steve/site-backups/"${1}"_${NOW}.gz
	
fi
