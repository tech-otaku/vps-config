#!/bin/bash
# Steve Ward: 2018-08-10
# Iterates through a list of shares on the local network contained in /Users/steve/Dropbox/Digital\ Ocean/local/shares.csv and attempts to ummount each mounted share.

INPUT=/Users/steve/Dropbox/Digital\ Ocean/local/shares.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
clear
while read filesys protocol bonjour netbios ip name volume mount
do
	case $filesys in
		''|\#*) continue ;;		# skip blank lines and lines starting with `#`. Source: https://unix.stackexchange.com/questions/244465/how-to-make-bash-built-in-read-ignore-commented-or-empty-lines
   	esac

	if df | awk '{print $NF}' | grep -Eqx "/Volumes/$mount"; then	# Source: https://stackoverflow.com/questions/22192842/how-to-check-if-filepath-is-mounted-in-os-x-using-bash
		sudo umount /Volumes/$mount

		if [ $? == 0 ]; then
			echo -e "\n'$name' unmounted\n"
		fi

	fi
done < $INPUT
IFS=$OLDIFS

sudo -k
