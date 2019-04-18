#!/usr/bin/env bash
# Steve Ward: 2019-02-27

# USAGE: sudo [bash] /path/to/unmount-network-volume.sh [bonjour-name]

# $1 = Bonjour name of computer to unmount

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as 'root'."
    exit 1
fi

# Get the Bonjour name of the computer to unmount if it was not supplied on the command line 
if [ -z "${1}" ]; then 
	computer=steves-macbook-pro
	read -e -p "> Enter Bonjour name of computer to mount [default = $computer]: " input
	computer=${input:-"${computer}"}
else
	computer="${1}"
fi

# Unmount the computer
[ -d "/Volumes/${computer}" ] && umount /Volumes/"${computer}" > /dev/null 2>&1

if [ $? -eq 0 ]; then 
	echo "Unmounted '${computer}' ..."
else
	echo "ERROR: Unable to unmount '${computer}' ..."
fi