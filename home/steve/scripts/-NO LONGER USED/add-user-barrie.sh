#!/bin/bash

#Test if user exists: returns 0 = false, 1 = true
#grep -c '^baz:' /etc/passwd

clear

echo '--> CREATING NEW USER.....'

r=$(grep -c '^baz:' /etc/passwd)
if [ $r = 0 ]

then

    echo '--> Encrypting new user password.....'
    
    # Assign a temporary password - will be prompted to change at first login
    pass=$(perl -e 'print crypt("baz", "9c");')

    echo '--> Adding new user.....'
    sudo useradd -m -s /bin/bash -p "$pass" baz
    
    echo '--> Adding new user to www-data.....'
    sudo usermod -a -G www-data baz
    
    echo '--> Setting ownership & permissions for `/var/www/barrieward.com/public_html`'
    sudo chown -R baz:www-data /var/www/barrieward.com/public_html
    sudo chmod 750 /var/www/barrieward.com/public_html
    
    echo '--> Giving `steve` full access to `/var/www/barrieward.com/public_html`'
    sudo setfacl -R -m user:steve:rwx /var/www/barrieward.com/public_html
    
    sudo cp /home/baz/.bashrc /home/baz/.bashrc.bak
	sudo sed -i 's/($debian_chroot)}\\u\@\\h:\\/($debian_chroot)}\\u\@\`curl -s http:\/\/icanhazip.com\`:\\/g' 	/home/baz/.bashrc
	sudo sed -i 's/($debian_chroot)}\\\[\\033\[01;32m\\\]\\u\@\\h/($debian_chroot)}\\\[\\033\[01;32m\\\]\\u\@\`curl -s http:\/\/icanhazip.com\`/g' /home/baz/.bashrc
	
	echo 'cd /var/www/barrieward.com/public_html' | sudo tee --append /home/baz/.bashrc > /dev/null

    # Force password change for user steve at next (first) login
    # Source: http://www.cyberciti.biz/faq/rhel-debian-force-users-to-change-passwords/
    sudo chage -d 0 baz
    
    echo '--> NEW USER CREATED.'
    
else

    echo '--> USER ALREADY EXISTS.'
    
fi

# TO DELETE, ENTER IN TERMINAL: sudo userdel -r baz


