#!/bin/bash
# Steve Ward: 2016-10-13

# USAGE: /Users/steve/Dropbox/Digital\ Ocean/local/sudo mount-network-volumes.sh

if [ ! -d "/Volumes/steves-macbook-pro" ]; then
	sudo mkdir "/Volumes/steves-macbook-pro"
fi	

read -s -p "> Enter single password for user steve on Steve's MacBook Pro, Steve's MacBook and Steve's iMac 24\": " password
echo

#read -s -p "> Enter password for user steve on Steve's MacBook Pro: " password
#echo

sudo mount_afp afp://steve:"$password"@Steves-MacBook-Pro.local/steve /Volumes/steves-macbook-pro

# In interactive mode [-i] you are prompted for the password if you did not supply one in the url.
#sudo mount_afp -i afp://steve:@Steves-MacBook-Pro.local/steve /Volumes/steves-macbook-pro

if [ "$?" == 0 ]; then
	echo "Steve's MacBook Pro mounted" 
fi


if [ ! -d "/Volumes/steves-imac-24" ]; then
	sudo mkdir "/Volumes/steves-imac-24"
fi	

#read -s -p "> Enter password for user steve on Steve's iMac 24\": " password
#echo

sudo mount_afp afp://steve:"$password"@Steves-iMac-24.local/steve /Volumes/steves-imac-24

# In interactive mode [-i] you are prompted for the password if you did not supply one in the url.
#sudo mount_afp -i afp://steve:@Steves-iMac-24.local/steve /Volumes/steves-imac-24

if [ "$?" == 0 ]; then
	echo "Steve's iMac 24\" mounted"
	#ssh-keygen -f /Volumes/steves-imac-24/Desktop/known_hosts -R 
fi


if [ ! -d "/Volumes/steves-macbook" ]; then
	sudo mkdir "/Volumes/steves-macbook"
fi	

#read -s -p "> Enter password for user steve on Steve's MacBook: " password
#echo

sudo mount_afp afp://steve:"$password"@Steves-MacBook.local/steve /Volumes/steves-macbook

# In interactive mode [-i] you are prompted for the password if you did not supply one in the url.
#sudo mount_afp -i afp://steve:@Steves-MacBook.local/steve /Volumes/steves-macbook

if [ "$?" == 0 ]; then
	echo "Steve's MacBook mounted"
fi

sudo -k