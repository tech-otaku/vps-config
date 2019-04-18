#!/usr/bin/env bash
# Steve Ward: 2019-02-27

# USAGE: sudo [bash] path/to/remove-rsa-keys.sh <hostname>

# $1 = hostname in the form of an IP address

clear

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Please run as root."
    exit
fi

# Check if host name was passed as parameter - if not, exit.
#if [ -z "$1" ]; then
#	echo 'ERROR: Please specify a hostname.'
#	exit 1
#fi

# Get the directory where this script is located
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# In order for this current script to have access to the `$computer` variable set in the `mount-network-volume.sh`
# script, the `mount-network-volume.sh` script is executed in the same process using the `source` command (below).
# However, doing so makes the the hostname - passed to this script as the positional parameter `$1` - available
# to the `mount-network-volume.sh` script as its positional parameter `$1`. To avoid any spurious results
# this will cause, an empty string (zero-length) is the 1st parameter passed to the `mount-network-volume.sh` script.
# The 2nd parameter passed can be any value providing it's not a zero-length string and is used to denote that in this
# instance the `mount-network-volume.sh` script was called by another script.

source ${__dir}/mount-network-volume.sh	'' 'set'

if [ $? -eq 0 ]; then

	#sed -i .bak '/'"${1}"'/d' ~/.ssh/known_hosts
	#echo "Updated ~/.ssh/known_hosts ..."

    rm -rf /Volumes/"${computer}"/.ssh
	cp -r ~/.ssh/ /Volumes/"${computer}"/.ssh
	echo "Copied ~/.ssh/ to /Volumes/"${computer}"/ ..."

	source ${__dir}/unmount-network-volume.sh "${computer}"

fi
