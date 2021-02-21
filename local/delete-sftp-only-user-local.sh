#!/usr/bin/env bash

# USAGE: [bash] /Users/steve/Developer/GitHub/vps-config/local/delete-sftp-only-user-local.sh <space-separated list of usernames>

clear

if [ -z "${1}" ]; then
    echo "ERROR: No user name was specified."
    exit 1
fi

read -p "> IP address of server to target: " input
IP="${input:-$IP}"

TEMP_FILE=$(cat /dev/urandom | LC_ALL=C tr -dc "a-zA-Z0-9" | fold -w 24 | head -n 1)

ssh -p 7822 steve@${IP} -N -f -M -S ~/.ssh/controlsockets/%r@%h

ssh -p 7822 root@${IP} -S ~/.ssh/controlsockets/%r@%h "bash -s" < /Users/steve/Developer/GitHub/vps-config/local/delete-sftp-only-user-remote.sh "${@}" > "/tmp/${TEMP_FILE}.tmp" &

wait

while read LINE; do
	[ -d /Users/steve/.ssh/ids/${IP}/${LINE} ] && rm -rf /Users/steve/.ssh/ids/${IP}/${LINE}
	printf "User '${LINE}' has been deleted.\n"
done < "/tmp/${TEMP_FILE}.tmp"

ssh -O exit -S ~/.ssh/controlsockets/%r@%h ${IP}

rm "/tmp/${TEMP_FILE}.tmp"

#cat /tmp/new-users-created.tmp

