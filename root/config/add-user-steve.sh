#!/bin/bash

# Test if user exists: returns 0 = false, 1 = true
# grep -c '^steve:' /etc/passwd

clear

echo '--> CREATING NEW USER.....'

r=$(grep -c '^steve:' /etc/passwd)
if [ $r -eq 0 ]; then

    echo '--> Encrypting new user password.....'
    
    # Assign a temporary password - will be prompted to change at first login
    pass=$(perl -e 'print crypt("steve", "9c");')

    echo '--> Adding new user.....'
    useradd -m -s /bin/bash -p "$pass" steve

    echo '--> Installing sudo.....'
    apt-get install sudo

    echo '--> Adding new user to sudoers.....'
    usermod -a -G sudo steve
    
    echo '--> Adding new user to www-data.....'
    usermod -a -G www-data steve
    
    #echo '--> Making templates subdirectory.....'
    #mkdir /home/steve/templates
    
    #echo '--> Copy files to templates subdirectory.....'
    #cp /root/config/templates/*.* /home/steve/templates
    
    #echo '--> Changing ownership on templates subdirectory.....'
    #chown -R steve:steve /home/steve/templates
    
    #echo '--> Adding /home/steve/scripts directory to PATH variable.....'
    #export PATH=$PATH:/home/steve/scripts
    
    #echo '--> Removing templates subdirectory for root.....'
    #rm -rf /root/config/templates

    echo '--> Disabling root login in /etc/ssh/sshd_config.....'
    sed -i '/prohibit-password/! s/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config; sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

    echo '--> Restarting ssh service.....'
    service ssh restart
    
    echo '--> Copying vi configuration file.....'
    cp /root/config/.vimrc /root/.vimrc
    cp /root/config/.vimrc /home/steve/.vimrc

    # Force password change for user steve at next (first) login
    # Source: http://www.cyberciti.biz/faq/rhel-debian-force-users-to-change-passwords/
    chage -d 0 steve
    
    echo '--> NEW USER CREATED.'
    
else

    echo '--> USER ALREADY EXISTS.'
    
fi


