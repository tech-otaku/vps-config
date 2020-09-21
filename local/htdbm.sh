#!/bin/bash

eval $(op signin my)

NAMES=(chiaki kiyoka michiyo miyuki tomoka)	
TMP=$(mktemp)

i=1
t=$(echo "${#NAMES[@]}")
for NAME in "${NAMES[@]}"; do 
	printf "Processing %d/%d\n" $i $t
	op get item "HTTP Authentication [$NAME]" --fields username,password --format CSV >> $TMP
	((i=i+1))
done

rsync -a -P $TMP -e 'ssh -p 7822' steve@159.69.248.143:/home/steve/htdbm.source
rsync -a -P ~/Developer/GitHub/vps-config/home/steve/scripts/create-http-auth-passwords.sh -e 'ssh -p 7822' steve@159.69.248.143:/home/steve/scripts/create-http-auth-passwords.sh
ssh -p 7822 steve@159.69.248.143 'bash /home/steve/scripts/create-http-auth-passwords.sh'

rm -f $TMP

op signout