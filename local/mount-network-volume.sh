#!/usr/bin/env bash
# Steve Ward: 2019-02-27

# USAGE: sudo [bash] /path/to/mount-network-volume.sh [bonjour-name]

# $1 = Bonjour name of computer to mount
# $2 = length is NOT 0 if this script was called by another script, otherwise length is 0

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as 'root'."
    exit 1
fi

# Get the Bonjour name of the computer to mount if it was not supplied on the command line 
if [ -z "${1}" ]; then 
	computer=steves-macbook-pro
	read -e -p "> Enter Bonjour name of computer to mount [default = $computer]: " input
	computer=${input:-"${computer}"}
else
	computer="${1}"
fi

# Remove the suffix '.local' from the Bonjour name, if given.
[[ $computer == *".local" ]] && computer=${computer//.local/}

# Get the password for the user 'steve' on the computer to mount
read -s -p "> Enter password for user 'steve' on '${computer}': " password

# Make a mount point
[ ! -d "/Volumes/${computer}" ] && mkdir "/Volumes/${computer}"

# Mount the computer using SMB
mount -v -t smbfs smb://steve:${password}@${computer}.local/steve "/Volumes/${computer}" > /dev/null 2>&1

exit_status=$?

if [ $exit_status -eq 0 ]; then 
	echo -e "\nMounted '${computer}' ..."
else
	echo -e "\nERROR: Unable to mount '${computer}' ..."
	
	# Remove mount point
	[ -d "/Volumes/${computer}" ] && rm -rf "/Volumes/${computer}"
	
	# If the length of positional parameter `$2` is 0, this script has been called directly and we use `exit`
	# the length of positional parameter `$2` is NOT 0, this script has been called by another script and we use `return` 
	[ -z $2 ] && exit $exit_status || return $exit_status
fi
