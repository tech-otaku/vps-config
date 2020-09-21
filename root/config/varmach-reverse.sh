#!/bin/bash

apt-get --yes remove curl

userdel steve
rm -R /home/steve

if [ -f /root/.bashrc.bak ]; then
	rm /root/.bashrc 
	mv /root/.bashrc.bak /root/.bashrc
	source /root/.bashrc
fi

sudo ufw --force disable
sudo ufw --force reset

sed -i 's/Port 7822/#Port 22/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin prohibit-password/#PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/#PasswordAuthentication yes/g' /etc/ssh/sshd_config

systemctl restart ssh

shutdown -r now