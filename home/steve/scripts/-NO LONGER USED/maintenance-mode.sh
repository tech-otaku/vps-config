#!/bin/bash
# Steve Ward: 2017-03-14

# USAGE: sudo bash /home/steve/templates/configure-default-vhost.sh 

clear

# Check if domain name was passed as parameter - if not, exit.
if [ "$1" == "" ]; then
	echo 'ERROR: No domain  name was specified.'
	exit 1
fi

DIRECTORY="/var/www/$1"
DOCUMENT_ROOT="$DIRECTORY/public_html"

# Check if directory for domain name exits - if not, exit.
if [ ! -d "$DIRECTORY" ]; then
  	echo "ERROR: The directory "${DIRECTORY}" doesn't exist."
    exit 1
fi

echo ""
maintenancemode="Y"
read -e -i "$maintenancemode" -p "> Put '$1' into Maintenance Mode (Y/n)? " input
maintenancemode="${input:-$maintenancemode}"

#if ! [[ $maintenancemode =~ [A-Z] && $maintenancemode == "Y" ]]; then
	
	if grep -q "# Maintenance Mode" /etc/apache2/sites-available/$1.conf; then
		sudo perl -i -p0e 's/# Maintenance Mode.*?<\/IfModule>/# MAINTENANCE MODE PLACEHOLDER/s' /etc/apache2/sites-available/$1.conf
	fi
	
#elif [[ $maintenancemode =~ [A-Z] && $maintenancemode == "Y" ]]; then

if [[ $maintenancemode =~ [A-Z] && $maintenancemode == "Y" ]]; then

	ip=""
	read -e -i "$ip" -p "> Enter IP Address: " input
	ip="${input:-$ip}"

	page=""
	read -e -i "$page" -p "> Enter page to re-direct to: " input
	page="${input:-$page}"

	FORMATTEDIP=`echo $ip | sed 's/\./\\\./g'`
	FORMATTEDPAGE=`echo $page | sed 's/\./\\\./g'`

	SERVERNAME=`grep ServerName /etc/apache2/sites-available/000-default.conf | head -1 | awk '{print $2}'`

cat << EOF > /tmp/maintenance-mode.tmp
	# Maintenance Mode - Rewrite all requests not matching IP address to temporary URL
	<IfModule mod_rewrite.c>
		RewriteEngine on
		RewriteCond %{REMOTE_ADDR} !^$FORMATTEDIP
		RewriteCond %{REQUEST_URI} !$FORMATTEDPAGE
		RewriteRule ^.*$ https://www.$1/$page [R=302,L]
	</IfModule>
EOF

	if grep -q "# MAINTENANCE MODE PLACEHOLDER" /etc/apache2/sites-available/$1.conf; then
		sudo sed -e '/# MAINTENANCE MODE PLACEHOLDER/ {' -e 'r /tmp/maintenance-mode.tmp' -e 'd' -e'}' -i /etc/apache2/sites-available/$1.conf
	fi
	
	
	# Enable mod_rewrite
	F="/etc/apache2/mods-enabled/rewrite.load"
	if [ ! -f "$F" ]; then
		sudo a2enmod rewrite
	fi
	
fi

sudo systemctl reload apache2

