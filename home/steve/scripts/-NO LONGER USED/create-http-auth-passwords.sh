#!/bin/bash
# Steve Ward: 2016-09-22

# USAGE: bash /home/steve/templates/create-http-auth-passwords.sh <text|database>

FILEPATH="/home/steve/.htpasswds"

if [ ! -d "$FILEPATH" ]
then
	mkdir "$FILEPATH"
fi

if [ "$1" == text ]; then
	COMMAND="htpasswd"
elif [ "$1" == database ]; then
	COMMAND="htdbm"
else
	echo "ERROR: No valid storage medium specified - 'text', 'database'"
	exit -1
fi

echo "Creating $1 $FILEPATH/.$COMMAND"

USER="chiaki"
echo "User '$USER'"
$COMMAND -cm "$FILEPATH"/.$COMMAND $USER

USER="kiyoka"
echo "User '$USER'"
$COMMAND -m "$FILEPATH"/.$COMMAND $USER

USER="michiyo"
echo "User '$USER'"
$COMMAND -m "$FILEPATH"/.$COMMAND $USER

USER="miyuki"
echo "User '$USER'"
$COMMAND -m "$FILEPATH"/.$COMMAND $USER

USER="tomoka"
echo "User '$USER'"
$COMMAND -m "$FILEPATH"/.$COMMAND $USER

if [ -f "$FILEPATH"/.$COMMAND.pag ]; then mv "$FILEPATH"/.$COMMAND.pag "$FILEPATH"/.$COMMAND; fi
if [ -f "$FILEPATH"/.$COMMAND.dir ]; then rm "$FILEPATH"/.$COMMAND.dir; fi