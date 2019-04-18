#!/bin/bash

# USAGE: bash /home/steve/scripts/mysql.sh 
# MySQL reads the password from ~/.my.cnf. This file is owned by root.

sudo mysql -u root << EOF
CREATE USER IF NOT EXISTS 'tech-otaku'@'localhost' IDENTIFIED BY '';
CREATE DATABASE IF NOT EXISTS db_ukatohcet1;
GRANT ALL PRIVILEGES ON db_ukatohcet1.* TO 'tech-otaku'@'localhost';

CREATE USER IF NOT EXISTS 'patchpeters'@'localhost' IDENTIFIED BY '';
CREATE DATABASE IF NOT EXISTS db_sretephctap;
GRANT ALL PRIVILEGES ON db_sretephctap.* TO 'patchpeters'@'localhost';

CREATE USER IF NOT EXISTS 'steveward'@'localhost' IDENTIFIED BY '';
CREATE DATABASE IF NOT EXISTS db_drawevets;
GRANT ALL PRIVILEGES ON db_drawevets.* TO 'steveward'@'localhost';

CREATE USER IF NOT EXISTS 'techotaku'@'localhost' IDENTIFIED BY '';
CREATE DATABASE IF NOT EXISTS db_ukatohcet2;
GRANT ALL PRIVILEGES ON db_ukatohcet2.* TO 'techotaku'@'localhost';

EOF
