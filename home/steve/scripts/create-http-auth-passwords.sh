#!/bin/bash

SOURCE=/home/steve/htdbm.source
TARGET=/home/steve/.htpasswds

if [ ! -f $SOURCE ]; then
	printf "ERROR: File '%s' doesn't exist. Run 'htdbm.sh' locally first.'" $SOURCE
	exit 1
fi

if [ ! -d $TARGET ]; then
	mkdir $TARGET
fi

[ -f $TARGET/.htdbm ] && rm -f $TARGET/.htdbm

i=1
cat /home/steve/htdbm.source | while read line
do
	if [[ $i -eq 1 ]]; then
		OPTIONS=cmb
	else
		OPTIONS=mb
	fi
	
	USERNAME=$(echo $line | cut -d',' -f1)
	PASSWORD=$(echo $line | cut -d',' -f2)
	htdbm -$OPTIONS $TARGET/.htdbm $USERNAME $PASSWORD
	
	((i=i+1))
done

rm -rf $SOURCE