#!/bin/bash
# Steve Ward: 2019-08-27

if [ ! -d /home/steve/letsencrypt-backups ]; then
	sudo mkdir /home/steve/letsencrypt-backups
fi

if [ -d /etc/letsencrypt ]; then

	NOW=$(env TZ=Europe/London date +"%C%y-%m-%d_%H-%M-%S")
	
	tar -czvf /home/steve/letsencrypt-backups/letsencrypt_${NOW}.gz /etc/letsencrypt

	chown steve:steve  /home/steve/letsencrypt-backups/letsencrypt_${NOW}.gz
	
fi
