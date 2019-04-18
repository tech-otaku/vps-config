#!/bin/bash

# Changes 
#		'($debian_chroot)}\u@\h:\' to '($debian_chroot)}\u@`curl -s http://icanhazip.com:\'
#		'($debian_chroot)}\[\033[01;32m\]\u@\h' to '($debian_chroot)}\[\033[01;32m\]\u@`curl -s http://icanhazip.com`'

sudo cp /root/.bashrc /root/.bashrc.bak
sudo sed -i 's/($debian_chroot)}\\u\@\\h:\\/($debian_chroot)}\\u\@\`curl -s http:\/\/icanhazip.com\`:\\/g' /root/.bashrc
sudo sed -i 's/($debian_chroot)}\\\[\\033\[01;32m\\\]\\u\@\\h/($debian_chroot)}\\\[\\033\[01;32m\\\]\\u\@\`curl -s http:\/\/myip.dnsomatic.com\`/g' /root/.bashrc

cat >> /root/.bashrc <<HEREDOC

alias wp-install='bash /home/steve/scripts/install-wordpress.sh'
alias wp-remove='bash /home/steve/scripts/remove-wordpress.sh'
alias vhost-add='bash /home/steve/scripts/add-vhost.sh'
alias vhost-del='bash /home/steve/scripts/delete-vhost.sh'
alias update='sudo -- sh -c "apt update; apt upgrade -y; apt dist-upgrade -y; apt autoremove -y; apt autoclean -y"'

HEREDOC

# Add /home/steve/scripts to root's PATH variable. Allows scripts in the /home/steve/scripts directory to be run as sudo without the full path i.e. 'sudo test.sh' and not 'sudo /home/steve/scriptstest.sh'
sed -i -E 's/secure_path="(.*)"/secure_path="\1:\/home\/steve\/scripts"/g' /etc/sudoers

sudo cp /home/steve/.bashrc /home/steve/.bashrc.bak
sudo sed -i 's/($debian_chroot)}\\u\@\\h:\\/($debian_chroot)}\\u\@\`curl -s http:\/\/icanhazip.com\`:\\/g' /home/steve/.bashrc
sudo sed -i 's/($debian_chroot)}\\\[\\033\[01;32m\\\]\\u\@\\h/($debian_chroot)}\\\[\\033\[01;32m\\\]\\u\@\`curl -s http:\/\/myip.dnsomatic.com\`/g' /home/steve/.bashrc

cat >> /home/steve/.bashrc <<HEREDOC

alias wp-install='bash /home/steve/scripts/install-wordpress.sh'
alias wp-remove='bash /home/steve/scripts/remove-wordpress.sh'
alias vhost-add='bash /home/steve/scripts/add-vhost.sh'
alias vhost-del='bash /home/steve/scripts/delete-vhost.sh'
alias update='sudo -- sh -c "apt update; apt upgrade -y; apt dist-upgrade -y; apt autoremove -y; apt autoclean -y"'

export PATH=$PATH:/home/steve/scripts

HEREDOC
