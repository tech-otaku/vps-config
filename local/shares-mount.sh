#!/bin/bash
# Steve Ward: 2018-08-10
# Iterates through a list of shares on the local network contained in /Users/steve/Dropbox/Digital\ Ocean/local/shares.csv and attempts to mount each share providing it is not (on) the local computer.

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

	shopt -s nocasematch
	# Case-insensitive comparison to only mount shares if they are not (on) the local computer i.e. $bonjour not equal to local computer's Bonjour name and $netbios not equal to local computer's NetBIOS name.
	if [[ $bonjour != `scutil --get LocalHostName`.local ]] && [[ $netbios != `defaults read /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName` ]]; then

		if ! df | awk '{print $NF}' | grep -Eqx "/Volumes/$mount"; then		# Source: https://stackoverflow.com/questions/22192842/how-to-check-if-filepath-is-mounted-in-os-x-using-bash
			sudo mkdir "/Volumes/$mount"

			if [ $filesys == 'smbfs' ]; then
				sudo mount -t $filesys $protocol://steve@$bonjour/$volume /Volumes/$mount
			elif [ $filesys == 'afp' ]; then	# For the AFP protocol we use mount_afp as we need to prompt for the password with the -i flag which is unavailable in the mount command.
				sudo mount_afp -i $protocol://steve@$bonjour/$volume /Volumes/$mount
			fi

			if [ $? == 0 ]; then
				echo -e "\n'$name' mounted at '/Volumes/$mount'\n"
			else
				echo -e "\nUnable to mount '$name'\n"
			fi

		else
			echo -e "\n'$name' is already mounted at '/Volumes/$mount'\n"
		fi
	fi
	shopt -u nocasematch
done < $INPUT
IFS=$OLDIFS

sudo -k
