#!/bin/bash
# Steve Ward: 2017-02-09

current_dir=$PWD

if [ ! -d /home/steve/site-backups ]; then
	mkdir /home/steve/site-backups
fi

cd /var/www/

NOW=$(env TZ=Europe/London date +"%C%y-%m-%d_%H-%M-%S")

[ -d /var/www/tech-otaku.com ] && tar cv --exclude='_*.gz' --exclude='public_html/wp-content/wflogs' tech-otaku.com | gzip --best > /home/steve/site-backups/tech-otaku.com_$NOW.gz

NOW=$(env TZ=Europe/London date +"%C%y-%m-%d_%H-%M-%S")

[ -d /var/www/steveward.me.uk ] && tar cv --exclude='_*.gz' --exclude='public_html/wp-content/wflogs' steveward.me.uk | gzip --best > /home/steve/site-backups/steveward.me.uk_$NOW.gz

cd $current_dir

#echo ""
#echo ""
#echo "DOWNLOAD THIS FILE LOCALLY USING scp -P 7822 steve@45.55.154.177:/home/steve/site-backups/_tech-otaku.com_$NOW.gz /Users/steve/Downloads"
#echo ""
#echo ""
