#!/bin/bash

#Test if user exists: returns 0 = false, 1 = true
#grep -c '^steve:' /etc/passwd

clear

echo '--> DELETING USER.....'

r=$(grep -c '^steve:' /etc/passwd)
if [ $r = 1 ]; then

    echo '--> Removing user steve from sudoers.....'
    sudo deluser steve sudo

    echo '--> Deleting user steve.....'
    userdel steve

    echo '--> Removing home directory for user steve.....'
    rm -rf /home/steve

    echo '--> Enabling root login in /etc/ssh/sshd_config.....'
    sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config

    echo '--> Restarting ssh service.....'
    service ssh restart
    
    echo '--> USER DELETED.'
    
else

    echo '--> USER DOES NOT EXIST.'

fi