#!/bin/bash
# Steve Ward: 2016-10-13

# USAGE: sudo /Users/steve/Dropbox/Digital\ Ocean/local/remove-rsa-keys.sh <hostname | [hostname]:port>

clear

# Check if hostname was passed as parameter - if not, exit.
if [ "$1" == "" ]; then
	echo "ERROR: Please specify a hostname <hostname | [hostname]:port>."
	exit 1
fi

# Get the password for user `steve` on `Steve's MacBook Pro`
#read -s -p "> Enter single password for user steve on Steve's MacBook Pro: " password
#echo

# Mount `Steve's MacBook Pro` using SMB protocol
open smb://steve@steves-mbp/steve

# Delay to allow `Steve's MacBook Pro` to mount successfully
echo "Waiting...."
sleep 3

if [ $? == 0 ]; then
	echo "Steve's MacBook Pro mounted"
	# Get the mount point for `Steve's MacBook Pro`. Should be `/Volumes/steve` or `/Volumes/steve1` or `/Volumes/steve2` etc.
	mount_point=`df | grep "steve" | awk '{print $9}'`
else
	echo "Could not mount Steve's MacBook Pro"
	exit 1
fi

#ln=`ssh-keygen -f ~/.ssh/known_hosts -l -F "$1" |  awk '/line/ { print $NF }'`

# Use grep to return the line number of the rsa key `<hostname | [hostname]:port>` in the known_hosts file and store it in the variable 'ln'
ln=`grep -n -F "$1" ~/.ssh/known_hosts | cut -f1 -d:`

# Delete the rsa key in the known_hosts file. The length of variable 'ln' will be 0 if the rsa key does not exist
if [ ! ${#ln} == 0 ]; then
	# Only execute sed if the length of the variable 'ln' is not zero - i.e. contains a valid line number
	sed -i .old "${ln}d" ~/.ssh/known_hosts
fi

# Copy amended `known_hosts` and `known_hosts.old` files to `Steve's MacBook Pro`
sudo cp ~/.ssh/known_hosts "$mount_point"/.ssh/known_hosts
sudo cp ~/.ssh/known_hosts.old "$mount_point"/.ssh/known_hosts.old

# Unmount `Steve's MacBook Pro`
umount "$mount_point"

sudo -k

#sudo ln=`ssh-keygen -f /Volumes/steves-imac-24/.ssh/known_hosts -l -F "$1" |  awk '/line/ { print $NF }'`
#sudo sed -i .old "${ln}d" /Volumes/steves-imac-24/.ssh/known_hosts

#sudo ln=`ssh-keygen -f /Volumes/steves-macbook/.ssh/known_hosts -l -F "$1" |  awk '/line/ { print $NF }'`
#sudo sed -i .old "${ln}d" /Volumes/steves-macbook/.ssh/known_hosts
