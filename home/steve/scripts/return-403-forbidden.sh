#!/bin/bash
# Steve Ward: 2016-09-28

# USAGE: sudo bash /home/steve/templates/configure-default-vhost.sh 

clear

echo "==================================================================="
echo "Configure Default Virtual Host Script"
echo "/etc/apache2/sites-available/000-default.conf"
echo "==================================================================="

echo ""
forbidden="Y"
read -e -i "$forbidden" -p "> Return '403 Forbidden' for requests handled by 000-default.conf (Y/n)? " input
forbidden="${input:-$forbidden}"
echo ""

SERVERNAME=`grep ServerName /etc/apache2/sites-available/000-default.conf | head -1 | awk '{print $2}'`

cat << EOF > /tmp/403-forbidden.tmp
	# Any request not matching a specific virtual host is handled
    # by the first virtual host configuration that matches i.e.
    # 000-default.conf. The server returns a 403 Forbidden status code for all
    # requests handled by 000-default.conf - except those specifically targeted
    # to the named server - using the RewriteRule below:
    # '^.*$' matches all URLs, '-' no changes are made to the URL,
    # '[F]' a 403 status code is returned.
    # Source: http://serverfault.com/questions/114931/how-to-disable-default-virtualhost-in-apache2
    <IfModule mod_rewrite.c>
		RewriteEngine on
		RewriteCond %{HTTP_HOST} !$SERVERNAME\$ [NC]
		RewriteRule ^.*$ - [F]
    </IfModule>
EOF

if ! [[ $forbidden =~ [A-Z] && $forbidden == "Y" ]]; then
	
	if grep -q "# Any request" /etc/apache2/sites-available/000-default.conf; then
		# There are 2 occurrences of '# Any request...' an they have to be replaced separately hence the following command has to be run twice. 
		sudo perl -i -p0e 's/# Any request.*?<\/IfModule>/# 403 FORBIDDEN PLACEHOLDER/s' /etc/apache2/sites-available/000-default.conf
		sudo perl -i -p0e 's/# Any request.*?<\/IfModule>/# 403 FORBIDDEN PLACEHOLDER/s' /etc/apache2/sites-available/000-default.conf
	fi
	
	#if ! grep -q "#<IfModule mod_rewrite.c>" /etc/apache2/sites-available/000-default.conf; then
    #	sudo sed -i 's/<IfModule mod_rewrite.c>/#<IfModule mod_rewrite.c>/g' /etc/apache2/sites-available/000-default.conf
	#fi
	#if ! grep -q "#RewriteCond %{HTTP_HOST}" /etc/apache2/sites-available/000-default.conf; then
    #	sudo sed -i 's/RewriteCond %{HTTP_HOST}/#RewriteCond %{HTTP_HOST}/g' /etc/apache2/sites-available/000-default.conf
	#fi
	#if ! grep -q "#RewriteEngine on" /etc/apache2/sites-available/000-default.conf; then
    #	sudo sed -i 's/RewriteEngine on/#RewriteEngine on/g' /etc/apache2/sites-available/000-default.conf
	#fi
	#if ! grep -q "#RewriteRule \^\.\*\$ - \[F\]" /etc/apache2/sites-available/000-default.conf; then
    #	sudo sed -i 's/RewriteRule \^\.\*\$ - \[F\]/#RewriteRule \^\.\*\$ - \[F\]/g' /etc/apache2/sites-available/000-default.conf
	#fi
	#if ! grep -q "#</IfModule>" /etc/apache2/sites-available/000-default.conf; then
    #	sudo sed -i 's/<\/IfModule>/#<\/IfModule>/g' /etc/apache2/sites-available/000-default.conf
	#fi
elif [[ $forbidden =~ [A-Z] && $forbidden == "Y" ]]; then
	
	if grep -q "# 403 FORBIDDEN PLACEHOLDER" /etc/apache2/sites-available/000-default.conf; then
		sudo sed -e '/# 403 FORBIDDEN PLACEHOLDER/ {' -e 'r /tmp/403-forbidden.tmp' -e 'd' -e'}' -i /etc/apache2/sites-available/000-default.conf
	fi

	#if grep -q "#<IfModule mod_rewrite.c>" /etc/apache2/sites-available/000-default.conf; then
    #	sudo sed -i 's/#<IfModule mod_rewrite.c>/<IfModule mod_rewrite.c>/g' /etc/apache2/sites-available/000-default.conf
	#fi
	#if grep -q "#RewriteCond %{HTTP_HOST}" /etc/apache2/sites-available/000-default.conf; then
    #	sudo sed -i 's/#RewriteCond %{HTTP_HOST}/RewriteCond %{HTTP_HOST}/g' /etc/apache2/sites-available/000-default.conf
	#fi
	#if grep -q "#RewriteEngine on" /etc/apache2/sites-available/000-default.conf; then
    #	sudo sed -i 's/#RewriteEngine on/RewriteEngine on/g' /etc/apache2/sites-available/000-default.conf
	#fi
	#if grep -q "#RewriteRule \^\.\*\$ - \[F\]" /etc/apache2/sites-available/000-default.conf; then
    #	sudo sed -i 's/#RewriteRule \^\.\*\$ - \[F\]/RewriteRule \^\.\*\$ - \[F\]/g' /etc/apache2/sites-available/000-default.conf
	#fi
	#if grep -q "#</IfModule>" /etc/apache2/sites-available/000-default.conf; then
    #	sudo sed -i 's/#<\/IfModule>/<\/IfModule>/g' /etc/apache2/sites-available/000-default.conf
	#fi
	
	# Enable mod_rewrite
	F="/etc/apache2/mods-enabled/rewrite.load"
	if [ ! -f "$F" ]; then
		sudo a2enmod rewrite
	fi
	
fi

sudo systemctl reload apache2

