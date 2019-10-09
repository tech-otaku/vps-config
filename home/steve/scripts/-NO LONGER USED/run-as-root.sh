#!/bin/bash
# Init
#FILE="/tmp/out.$$"
#GREP="/bin/grep"
#....
# Make sure only root can run our script
if [[ $EUID -eq 0 ]]; then
   echo "This script must not be run as root" 1>&2
   exit 1
fi
# ...

sudo ls -a