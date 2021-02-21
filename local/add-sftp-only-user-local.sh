#!/usr/bin/env bash

# USAGE: [bash] /Users/steve/Developer/GitHub/vps-config/local/add-sftp-only-user-local.sh <space-separated list of usernames>

# Files and directories below marked '-*-' are created/modified by this script.
#
# |--- home/										0755 root:root				
#      |--- user/									0755 root:user			
#      |    |--- www/								0755 root:root			
#      |---.ssh/									0700 user:user		
#           | -*- authorized_keys					0600 user:user
 
clear

if [ -z "${1}" ]; then
    echo "ERROR: No user name was specified."
    exit 1
fi

read -p "> IP address of server to target: " input
IP="${input:-$IP}"

#echo ${IP}
#exit

TEMP_FILE=$(cat /dev/urandom | LC_ALL=C tr -dc "a-zA-Z0-9" | fold -w 24 | head -n 1)

ssh -p 7822 root@${IP} -N -f -M -S ~/.ssh/controlsockets/%r@%h:%p

ssh -p 7822 root@${IP} -S ~/.ssh/controlsockets/%r@%h:%p "bash -s" < /Users/steve/Developer/GitHub/vps-config/local/add-sftp-only-user-remote.sh "${@}" > "/tmp/${TEMP_FILE}.tmp" &

wait

while read NAME; do
	[ ! -d /Users/steve/.ssh/ids/${IP}/${NAME} ] && mkdir /Users/steve/.ssh/ids/${IP}/${NAME}
	yes "y" | ssh-keygen -o -a 100 -t ed25519 -f /Users/steve/.ssh/ids/${IP}/${NAME}/id_ed25519 -N "" -C ${NAME}-$(date +"%Y%m%d%H%M%S-%Z" | awk '{print tolower($0)}')
	[ ! -d ~/.ssh/ids/tech-otaku.com ] && mkdir ~/.ssh/ids/tech-otaku.com
	cp -rp ~/.ssh/ids/${IP}/${NAME} ~/.ssh/ids/tech-otaku.com/${NAME}
	cat ~/.ssh/ids/${IP}/${NAME}/id_ed25519.pub | ssh -p 7822 root@${IP} -S ~/.ssh/controlsockets/%r@%h:%p "cat >> /home/${NAME}/.ssh/authorized_keys && chown ${NAME}:${NAME} /home/${NAME}/.ssh/authorized_keys && chmod 600 /home/${NAME}/.ssh/authorized_keys"
   	printf "User '${NAME}' has been created.\n"
done < "/tmp/${TEMP_FILE}.tmp"

#ssh -O exit -S ~/.ssh/controlsockets/%r@%h ${IP}
ssh -p 7822 root@${IP} -O exit -S ~/.ssh/controlsockets/%r@%h:%p

rm "/tmp/${TEMP_FILE}.tmp"

