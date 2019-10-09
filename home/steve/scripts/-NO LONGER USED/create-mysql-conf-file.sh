#!/bin/bash

# USAGE: bash /home/steve/scripts/create-mysql-conf-file.sh

read -s -p "> Enter the MySQL's root user password: " pass

cat << EOF > ~/.my.cnf
[client]
user=root
password=$pass
EOF

sudo chown root:root ~/.my.cnf
sudo chmod 400 ~/.my.cnf