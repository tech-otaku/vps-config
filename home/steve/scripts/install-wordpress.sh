#!/bin/bash
# Steve Ward: 2016-09-23

# USAGE: sudo bash /home/steve/scripts/install-wordpress.sh <domain.tld>
# ALIAS: wp-install <domain.tld>
# SOURCE: User input based on https://gist.github.com/bgallagh3r/2853221 AND http://stackoverflow.com/questions/2642585/read-a-variable-in-bash-with-a-default-value
# SOURCE: WordPress install based on https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lamp-on-ubuntu-16-04

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

# Check if WordPress is already installed in directory by - if so, exit.
if [ -d "$DOCUMENT_ROOT/wp-admin" ]; then
  	echo "ERROR: Looks like WordPress is already installed in "${DOCUMENT_ROOT}". Run 'remove-wordpress.sh' first."
    exit 1
fi

echo "==================================================================="
echo "WordPress Install Script for domain $1"
echo "Installation directory: $DOCUMENT_ROOT/"
echo "==================================================================="



# 1. GET USER INPUT

fperm=640	# All Files
dperm=750	# All directories
hperm=640	# .htacces, .htdbm, .htpasswds, .user.ini
wperm=750	# wp-content directory and sub-directories
xperm=640	# wp-config
owner=`grep "AddHandler php7-fcgi-" /etc/apache2/sites-available/$1.conf | cut -d '-' -f 3 | cut -d ' ' -f1`
group=www-data

read -e -p "> Database Name: " dbname
read -e -p "> Database User: " dbuser
read -s -p "> Database Password: " dbpass

echo ""

dbhost="localhost"
read -e -i "$dbhost" -p "> Database Host: " input
dbhost="${input:-$dbhost}"

tprefix="wp_"
read -e -i "$tprefix" -p "> Table Prefix: " input
tprefix="${input:-$tprefix}"

move="Y"
read -e -i "$move" -p "> Move wp-config.php to directory $DIRECTORY? (Y/n) " input
move="${input:-$move}"
echo ""

#owner="steve"
read -e -i "$owner" -p "> Set ownership to: " input
owner="${input:-$owner}"

#echo "N.B. Setting ownership to a group other than 'www-data' may render your WordPress site inaccessible!"
#group="www-data"
read -e -i "$group" -p "> Set group to ('www-data' recommended): " input
group="${input:-$group}"
echo ""

echo "N.B. Setting permissions to those other than recommended below may render your WordPress site inaccessible!"
#fperm="644"
read -e -i "$fperm" -p "> Set file permissions to ($fperm recommended): " input
fperm="${input:-$fperm}"

#dperm="755"
read -e -i "$dperm" -p "> Set directory permissions to ($dperm recommended): " input
dperm="${input:-$dperm}"

#wperm="755"
read -e -i "$wperm" -p "> Set permissions on /wp-content/ and sub-directories to ($wperm recommended): " input
wperm="${input:-$wperm}"

#hperm="640"
read -e -i "$hperm" -p "> Set permissions on .htaccess/.htdbm/.user.ini to ($hperm recommended): " input
hperm="${input:-$hperm}"

#xperm="640"
read -e -i "$xperm" -p "> Set permissions on wp-config.php to ($xperm recommended): " input
xperm="${input:-$xperm}"

httpauth="tomoka"
read -e -i "$httpauth" -p "> Set username for HTTP Auth [chiaki|kiyoka|miyuki|michiyo|tomoka] to: " input
httpauth="${input:-$httpauth}"

httpauthstorage="database"
read -e -i "$httpauthstorage" -p "> Set password storage method for HTTP Auth [text|database] to: " input
httpauthstorage="${input:-$httpauthstorage}"

php_memory_limit="64M"
read -e -i "$php_memory_limit" -p "> Set memory_limit in php.ini to ($php_memory_limit recommended): " input
php_memory_limit="${input:-$php_memory_limit}"

php_max_execution_time="180"
read -e -i "$php_max_execution_time" -p "> Set max_execution_time in php.ini to ($php_max_execution_time recommended): " input
php_max_execution_time="${input:-$php_max_execution_time}"

php_max_input_time="600"
read -e -i "$php_max_input_time" -p "> Set max_input_time in php.ini to ($php_max_input_time recommended): " input
php_max_input_time="${input:-$php_max_input_time}"

php_post_max_size="128M"
read -e -i "$php_post_max_size" -p "> Set post_max_size in php.ini to ($php_post_max_size recommended): " input
php_post_max_size="${input:-$php_post_max_size}"

php_upload_max_filesize="256M"
read -e -i "$php_upload_max_filesize" -p "> Set upload_max_filesize in php.ini to ($php_upload_max_filesize recommended): " input
php_upload_max_filesize="${input:-$php_upload_max_filesize}"


update="n"
read -e -i "$update" -p "> Check for system updates before installing WordPress? (Y/n) " input
update="${input:-$update}"
echo ""

if [ -z "$owner" ]; then
	read -e -p "> ERROR: Ownership cannot be blank. Set ownership to [if left blank, script will terminate]: " owner
	if [ -z "$owner" ]; then
		echo "Installation cancelled"
		exit 1
	fi
fi


# 2. DISPLAY USER INPUT

echo ""
echo "Install Details:"
echo "Database Name: $dbname"
echo "Database User: $dbuser"
#echo "Database Password: $dbpass"
echo "Database Host: $dbhost"
echo "Table Prefix: $tprefix"
echo "Move wp-config.php to $DIRECTORY/: $move"
echo "Set owner to: $owner"
echo "Set group to: $group"
echo "Set file permissions to: $fperm"
echo "Set directory permissions to: $dperm"
echo "Set permissions on .htaccess/.user.ini to: $hperm"
echo "Set permissions on wp-config.php to: $xperm"
echo "Set username for HTTP Auth to: $httpauth"
echo "Set password storage method for HTTP Auth to: $httpauthstorage"
echo "Set memory_limit in php.ini to: $php_memory_limit"
echo "Set max_execution_time in php.ini to: $php_max_execution_time"
echo "Set max_input_time in php.ini to: $php_max_input_time"
echo "Set post_max_size in php.ini to: $php_post_max_size"
echo "Set upload_max_filesize in php.ini to: $php_upload_max_filesize"
echo "Check for system updates before installing WordPress: $update"
echo ""

read -e -p "> Run install? (Y/n) " run
if ! [[ $run =~ [A-Z] && $run == "Y" ]]; then
#if [ "$run" == n ] ; then
	echo "Installation cancelled"
	exit 1
fi



# 3. CHECK FOR SYSTEM UPDATES

if [[ $update =~ [A-Z] && $update == "Y" ]]; then
#if [ "$update" == y ] ; then
	sudo apt-get update
	sudo apt-get install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc
	sudo systemctl restart apache2
fi



# 4. DOWNLOAD & UNZIP LATEST WORDPRESS INSTALL

F="/tmp/latest.tar.gz"
if [ -f "$F" ]
then
	sudo rm $F
fi

F="/tmp/google-authenticator.0.48.zip"
if [ -f "$F" ]
then
	sudo rm $F
fi

D="/tmp/wordpress"
if [ -d "$D" ]
then
	sudo rm -rf $D
fi

D="/tmp/google-authenticator"
if [ -d "$D" ]
then
	sudo rm -rf $D
fi


cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzf latest.tar.gz

curl -O https://downloads.wordpress.org/plugin/google-authenticator.0.48.zip
unzip google-authenticator.0.48.zip
sudo cp -r /tmp/google-authenticator/ /tmp/wordpress/wp-content/plugins/google-authenticator

cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
rm /tmp/wordpress/wp-config-sample.php
mkdir /tmp/wordpress/wp-content/languages
mkdir /tmp/wordpress/wp-content/upgrade
mkdir /tmp/wordpress/wp-content/uploads

sudo cp -a /tmp/wordpress/. $DOCUMENT_ROOT



# 5. SET FILE & FOLDER PERMISSIONS FOR WORDPRESS FILES

# On Ubuntu WordPress runs as 'www-data' (33)
# User 'steve' (1000) is added to the 'www-data' group when the user is created by add-user-steve.sh
# The Ownership and Group of all WordPress files and folders in the document root directory ($DOCUMENT_ROOT) and sub-directories are set to 'steve:www-data' respectively
# The recommended permissions for all WordPress files is '644' [-rw-r--r--] with the exception of wp-config.php - '640' [-rw-r-----] and .htaccess files - '664' [-rw-rw-r--]
# The recommended permissions for all WordPress folders is '755' [-rwxr-xr-x] with the exception of the wp-content directory and it's sub-directories which are set to '775' [-rwxrwxr-x] to allow WordPress to create files and folders in these directories

# The Ownership/Group/Permissions of files and folders WordPress creates in the wp-content directory and it's sub-directories are set to -
#		Sub-directory of	Owner:Group				Folder Permissions		File Permissions
#       languages/          www-data:www-data       755 [-rwxr-xr-x]        644 [-rw-r--r--]
#		plugins/			www-data:www-data		755 [-rwxr-xr-x]		644 [-rw-r--r--]
#		themes/				www-data:www-data		755 [-rwxr-xr-x]		644 [-rw-r--r--]
#		uploads/ 			www-data:www-data 		775 [-rwxrwxr-x]		??? [-?????????]



sudo chown -R steve:$group $DIRECTORY		# Owner is changed to $user at the end of the script once all permissions have been set
#sudo find $DIRECTORY -type d -exec chmod g+s {} \;
#sudo chmod g+w $DIRECTORY/wp-content
#sudo chmod -R g+w $DIRECTORY/wp-content/themes
#sudo chmod -R g+w $DIRECTORY/wp-content/plugins


if [ -f $DOCUMENT_ROOT/index.php ]; then chmod $fperm $DOCUMENT_ROOT/index.php; fi
if [ -f $DOCUMENT_ROOT/license.txt ]; then chmod $fperm $DOCUMENT_ROOT/license.txt; fi
if [ -f $DOCUMENT_ROOT/readme.html ]; then chmod $fperm $DOCUMENT_ROOT/readme.html; fi
if [ -f $DOCUMENT_ROOT/wp-activate.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-activate.php; fi
if [ -f $DOCUMENT_ROOT/wp-blog-header.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-blog-header.php; fi
if [ -f $DOCUMENT_ROOT/wp-comments-post.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-comments-post.php; fi
if [ -f $DOCUMENT_ROOT/wp-config-sample.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-config-sample.php; fi
if [ -f $DOCUMENT_ROOT/wp-cron.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-cron.php; fi
if [ -f $DOCUMENT_ROOT/wp-links-opml.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-links-opml.php; fi
if [ -f $DOCUMENT_ROOT/wp-load.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-load.php; fi
if [ -f $DOCUMENT_ROOT/wp-login.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-login.php; fi
if [ -f $DOCUMENT_ROOT/wp-mail.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-mail.php; fi
if [ -f $DOCUMENT_ROOT/wp-settings.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-settings.php; fi
if [ -f $DOCUMENT_ROOT/wp-signup.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-signup.php; fi
if [ -f $DOCUMENT_ROOT/wp-trackback.php ]; then chmod $fperm $DOCUMENT_ROOT/wp-trackback.php; fi
if [ -f $DOCUMENT_ROOT/xmlrpc.php ]; then chmod $fperm $DOCUMENT_ROOT/xmlrpc.php; fi

if [ -d $DOCUMENT_ROOT/wp-admin/ ]; then find $DOCUMENT_ROOT/wp-admin/.  -type d -print0 | xargs -0 chmod $dperm; fi
if [ -d $DOCUMENT_ROOT/wp-admin/ ]; then find $DOCUMENT_ROOT/wp-admin/.  -type f -print0 | xargs -0 chmod $fperm; fi

if [ -d $DOCUMENT_ROOT/wp-content/ ]; then find $DOCUMENT_ROOT/wp-content/.  -type d -print0 | xargs -0 chmod $wperm; fi
if [ -d $DOCUMENT_ROOT/wp-content/ ]; then find $DOCUMENT_ROOT/wp-content/.  -type f -print0 | xargs -0 chmod $fperm; fi

if [ -d $DOCUMENT_ROOT/wp-includes/ ]; then find $DOCUMENT_ROOT/wp-includes/.  -type d -print0 | xargs -0 chmod $dperm; fi
if [ -d $DOCUMENT_ROOT/wp-includes/ ]; then find $DOCUMENT_ROOT/wp-includes/.  -type f -print0 | xargs -0 chmod $fperm; fi

#if [ -d $DOCUMENT_ROOT/wp-content/ ]; then chmod 775 $DOCUMENT_ROOT/wp-content; fi
#if [ -d $DOCUMENT_ROOT/wp-content/ ]; then chmod 775 $DOCUMENT_ROOT/wp-content/upgrade; fi
#if [ -d $DOCUMENT_ROOT/wp-content/ ]; then chmod 775 $DOCUMENT_ROOT/wp-content/uploads; fi
#if [ -d $DOCUMENT_ROOT/wp-content/ ]; then chmod 775 $DOCUMENT_ROOT/wp-content/themes; fi
#if [ -d $DOCUMENT_ROOT/wp-content/ ]; then chmod 775 $DOCUMENT_ROOT/wp-content/plugins; fi




# 6. CUSTOMISE WP-CONFIG.php

sudo cp $DOCUMENT_ROOT/wp-config.php $DIRECTORY/wp-config.bak

cat << EOF > /tmp/wp-config.tmp
define('WP_DEBUG', false);

/**
 * CUSTOM CONFIGURATION OPTIONS
 * This code block added by invoking 'sudo bash $0'
 */

    /** Enable Jetpack Development Mode */
    //define('JETPACK_DEV_DEBUG', true);

    // Define blog address and site address
    define('WP_HOME', 'protocol_here://url_here');		// Source: http://digwp.com/2010/08/pimp-your-wp-config-php/
    define('WP_SITEURL', 'protocol_here://url_here');

    // Disable the theme and plugin editor
    define('DISALLOW_FILE_EDIT', true); 				// Source: http://wp.tutsplus.com/tutorials/security/imposing-ssl-and-other-tips-for-impenetrable-wp-security/

    // Increase post autosave to 5 minutes
    define('AUTOSAVE_INTERVAL', 300 );					// Source: http://wp.tutsplus.com/tutorials/security/imposing-ssl-and-other-tips-for-impenetrable-wp-security/

    // Disable the post-revisioning feature
    define('WP_POST_REVISIONS', false);					// Source: http://www.wpbeginner.com/wp-tutorials/how-to-disable-post-revisions-in-wordpress-and-reduce-database-size/

    // Disable custom HTML								// This also stops plugins from working that allow php to be run in a text widget e.g. wp-exec-php
    define('DISALLOW_UNFILTERED_HTML', true );			// Source: http://www.inkthemes.com/guide-to-secure-your-wordpress-like-a-security-professional/06/

    // Force filesystem method to direct				// Prevents WordPress from asking for FTP credentials when installing themes from disk
    define('FS_METHOD', 'direct');						// Source: http://stackoverflow.com/questions/17922644/wordpress-asking-for-my-ftp-credentials-to-install-plugins

/*
 * END: CUSTOM CONFIGURATION OPTIONS
 **/
EOF


sed -e '/define('\''WP_DEBUG'\'', false);/ {' -e 'r /tmp/wp-config.tmp' -e 'd' -e'}' -i $DOCUMENT_ROOT/wp-config.php

rm /tmp/wp-config.tmp

protocol=`grep -m 1 "RewriteRule ^.*$ https://" /etc/apache2/sites-available/$1.conf | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 3 | cut -d ':' -f 1`
if [ "$protocol" != "https" ]; then
	protocol="http"
fi

echo "Protocol is $protocol"

www=`grep -m 1 "ServerAlias www." /etc/apache2/sites-available/$1.conf | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 2 | cut -d '.' -f 1`
if [ "$www" == "www" ]; then
	www+='.'
fi

sudo perl -pi -e "s/database_name_here/$dbname/g" $DOCUMENT_ROOT/wp-config.php
sudo perl -pi -e "s/username_here/$dbuser/g" $DOCUMENT_ROOT/wp-config.php
sudo perl -pi -e "s/password_here/$dbpass/g" $DOCUMENT_ROOT/wp-config.php
sudo perl -pi -e "s/localhost/$dbhost/g" $DOCUMENT_ROOT/wp-config.php
sudo perl -pi -e "s/table_prefix  = 'wp_'/table_prefix  = '$tprefix'"/g $DOCUMENT_ROOT/wp-config.php
sudo perl -pi -e "s/protocol_here/$protocol/g" $DOCUMENT_ROOT/wp-config.php
sudo perl -pi -e "s/url_here/$www$1/g" $DOCUMENT_ROOT/wp-config.php

# WP Salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' $DOCUMENT_ROOT/wp-config.php

if [ -f $DOCUMENT_ROOT/wp-config.php ]; then chmod $xperm $DOCUMENT_ROOT/wp-config.php; fi

if [[ $move =~ [A-Z] && $move == "Y" ]]; then
#if [ "$move" == y ] ; then
	sudo mv $DOCUMENT_ROOT/wp-config.php $DIRECTORY
fi



# 7. CREATE .HTACCESS FILES, CONFIGURE HTTP AUTHENTICATION & OVERRIDE MASTER PHP SETTINGS

# Enable .htaccess Overrides
if grep -q "#AllowOverride All" /etc/apache2/sites-available/$1.conf; then
	sudo sed -i 's/#AllowOverride All/AllowOverride All/g' /etc/apache2/sites-available/$1.conf
	#echo "Allowing .htaccess overrides..."
fi

if [ "$httpauthstorage" == text ]; then
	BasicProvider="AuthBasicProvider file"
	UserFile="AuthUserFile $DIRECTORY/.htpasswd"
else
	BasicProvider="AuthBasicProvider dbm"
	UserFile="AuthDBMUserFile $DIRECTORY/.htdbm"
fi

cat > $DOCUMENT_ROOT/.htaccess <<HEREDOC
# STOP APACHE FROM SERVING WP-CONFIG.PHP - [Added by $0]
<files wp-config.php>
	Order Deny,Allow
	Deny from all
</files>

# STOP APACHE FROM SERVING .HT* FILES - [Added by $0]
<Files ~ "^\.ht">
	Order Deny,Allow
	Deny from all
</Files>

# BLOCK THE INCLUDE-ONLY FILES - [Added by $0]
RewriteEngine On
RewriteBase /
RewriteRule ^wp-admin/includes/ - [F,L]
RewriteRule !^wp-includes/ - [S=3]
RewriteRule ^wp-includes/[^/]+\.php$ - [F,L]
RewriteRule ^wp-includes/js/tinymce/langs/.+\.php - [F,L]
RewriteRule ^wp-includes/theme-compat/ - [F,L]

# PROTECT FROM SQL INJECTION - [Added by $0]
Options +FollowSymLinks
RewriteEngine On
RewriteCond %{QUERY_STRING} (\<|%3C).*script.*(\>|%3E) [NC,OR]
RewriteCond %{QUERY_STRING} GLOBALS(=|\[|\%[0-9A-Z]{0,2}) [OR]
RewriteCond %{QUERY_STRING} _REQUEST(=|\[|\%[0-9A-Z]{0,2})
RewriteRule ^(.*)$ index.php [F,L]

# PROTECT WP-LOGIN.PHP - [Added by $0]
<Files wp-login.php>
	AuthType Basic
	AuthName "Hackers are not welcome here!"
	AuthGroupFile /dev/null
	$BasicProvider
	$UserFile
	Require user $httpauth
</Files>

HEREDOC

#sudo chown $user:$group $DOCUMENT_ROOT/.htaccess
chmod $hperm $DOCUMENT_ROOT/.htaccess


cat > $DOCUMENT_ROOT/wp-admin/.htaccess <<HEREDOC
# [Added by $0]
AuthType Basic
AuthName "Hackers are not welcome here!"
AuthGroupFile /dev/null
$BasicProvider
$UserFile
Require user $httpauth
HEREDOC

#sudo chown $user:$group $DOCUMENT_ROOT/wp-admin/.htaccess
chmod $hperm $DOCUMENT_ROOT/wp-admin/.htaccess


cat > $DOCUMENT_ROOT/.user.ini <<HEREDOC
;[Added by $0]
memory_limit = $php_memory_limit
max_execution_time = $php_max_execution_time
max_input_time = $php_max_input_time
post_max_size = $php_post_max_size
upload_max_filesize = $php_upload_max_filesize
HEREDOC

#sudo chown $user:$group $DOCUMENT_ROOT/.user.ini
chmod $hperm $DOCUMENT_ROOT/.user.ini

#if ! grep -q "# STOP APACHE FROM SERVING WP-CONFIG.PHP" $DOCUMENT_ROOT/.htaccess; then
#cat >> $DOCUMENT_ROOT/.htaccess <<HEREDOC
#HEREDOC
#fi

if [ "$httpauthstorage" == text ]; then
    F=".htpasswd"
else
    F=".htdbm"
fi

sudo cp -r /home/steve/templates/.htpasswds/$F $DIRECTORY/$F
#sudo chown $user:$group $DIRECTORY/$F
sudo chmod $fperm $DIRECTORY/$F

sudo chown -R $owner:$group $DIRECTORY
sudo find $DIRECTORY -type d -exec chmod g+s {} \;

# Give user 'steve' full access to /var/www/$1.$TLD/ and all its files and sub-directories to allow correct use in ForkLift
sudo setfacl -R -m user:steve:rwx $DIRECTORY

# 8. PHP CONFIGURATION

# Source: https://www.elegantthemes.com/blog/tips-tricks/is-the-wordpress-upload-limit-giving-you-trouble-heres-how-to-change-it

#sudo perl -pi -e "s/memory_limit = 128M/memory_limit = 64M/g" /etc/php/7.0/apache2/php.ini
#sudo perl -pi -e "s/upload_max_filesize = 2M/upload_max_filesize = 64M/g" /etc/php/7.0/apache2/php.ini
#sudo perl -pi -e "s/post_max_size = 8M/post_max_size = 64M/g" /etc/php/7.0/apache2/php.ini
#sudo perl -pi -e "s/max_execution_time = 30/max_execution_time = 300/g" /etc/php/7.0/apache2/php.ini

# Source: http://www.templatemonster.com/help/wordpress-troubleshooter-how-to-deal-with-are-you-sure-you-want-to-do-this-error-2.html

#sudo perl -pi -e "s/^\s?(memory_limit)\s?=.*$/\1 = $php_memory_limit/g" /etc/php/7.0/apache2/php.ini
#sudo perl -pi -e "s/^\s?(max_execution_time)\s?=.*$/\1 = $php_max_execution_time/g" /etc/php/7.0/apache2/php.ini
#sudo perl -pi -e "s/^\s?(max_input_time)\s?=.*$/\1 = $php_max_input_time/g" /etc/php/7.0/apache2/php.ini
#sudo perl -pi -e "s/^\s?(post_max_size)\s?=.*$/\1 = $php_post_max_size/g" /etc/php/7.0/apache2/php.ini
#sudo perl -pi -e "s/^\s?(upload_max_filesize)\s?=.*$/\1 = $php_upload_max_filesize/g" /etc/php/7.0/apache2/php.ini


# 9. ENABLE APACHE MODULES

# Enable mod_rewrite
F="/etc/apache2/mods-enabled/rewrite.load"
if [ ! -f "$F" ]; then
	sudo a2enmod rewrite
fi

# Enable authz_groupfile - required for AuthGroupFile directive
F="/etc/apache2/mods-enabled/authz_groupfile.load"
if [ ! -f "$F" ]; then
	sudo a2enmod authz_groupfile
fi

# Enable authn_dbm - required for AuthDBMUserFile directive [if AuthBasicProvider directive is 'dbm']
F="/etc/apache2/mods-enabled/authn_dbm.load"
if [ ! -f "$F" ]; then
	sudo a2enmod authn_dbm
fi

# Enable authz_dbm  - required for AuthDBMUserFile directive [if AuthBasicProvider directive is 'dbm']
F="/etc/apache2/mods-enabled/authz_dbm.load"
if [ ! -f "$F" ]; then
	sudo a2enmod authz_dbm
fi

sudo systemctl restart apache2

echo "WordPress has been successfully installed in $DOCUMENT_ROOT/"
