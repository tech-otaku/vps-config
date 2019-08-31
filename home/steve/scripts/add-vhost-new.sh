#!/bin/bash
# Steve Ward: 2016-03-09	Modified: 2019-08-23

# USAGE: add-vhost.sh <domain> [<tld>]
# ALIAS: vhost-add <domain> [<tld>]
# CODE: /home/steve/scripts/add-vhost.sh
# If <tld> is not supplied a tld of 'com' is assumed i.e. add-vhost.sh tech-otaku or add-vhost.sh steveward me.uk

# SOURCE: https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-14-04-lts

clear

# Make sure root is not running this script
if [[ $EUID -eq 0 ]]; then
   echo "ERROR:This script must NOT be run as root." 1>&2
   exit 1
fi

if [ -z $1 ]; then
    echo 'ERROR: No virtual host name was specified.'
    exit 1
fi

DOMAIN="${1}"

if [ -z "${2}"]; then
	TLD="com"
else 
	TLD="${2}"
fi

if [[ "${DOMAIN}" == *"techotaku" && ! "${DOMAIN}" =~ ^techotaku && "${TLD}" == "com" ]]; then
	echo "ERROR: Sub-domains cannot be used with 'techotaku.com'."
    exit 1
fi

ROOT_DIR="/var/www/${DOMAIN}.${TLD}"
DOCUMENT_ROOT="${ROOT_DIR}/public_html"
POOL=minerva
TEMPLATES=/home/steve/templates
PHP_VERSION=$(php --version | awk '/^PHP/ {print $2}' | cut -d '.' -f 1-2)

if [ -d "${DOCUMENT_ROOT}" ]; then
  	echo "ERROR: The directory '${DOCUMENT_ROOT}' already exists."
    exit 1
fi

echo "==================================================================="
echo "Create Virtual Host Script for domain '${DOMAIN}.${TLD}'"
echo "Installation directory: ${ROOT_DIR}/"
echo "==================================================================="

case "${DOMAIN}.${TLD}" in
	barrieward.com)
        POOL="apollo"
        WWW="Y"
        PROTECT="n"
        ;;
    demo.barrieward.com)
        POOL="cupid"
        WWW="n"
        PROTECT="n"
        ;;
    patchpeters.com)
        POOL="diana"
        WWW="Y"
        PROTECT="n"
        ;;
    demo.patchpeters.com)
        POOL="fortuna"
        WWW="n"
        PROTECT="n"
        ;;
    steveward.me.uk)
        POOL="juno"
        WWW="Y"
        PROTECT="Y"
        ;;
    demo.steveward.me.uk)
        POOL="mars"
        WWW="n"
        PROTECT="n"
        ;;
    techotaku.com)
        POOL="minerva"
        WWW="Y"
        PROTECT="n"
        ;;
    demo.techotaku.com)
        POOL="nox"
        WWW="n"
        PROTECT="n"
        ;;
    forms.tech-otaku.com)
        POOL="pluto"
        WWW="n"
        PROTECT="Y"
        ;;
    tech-otaku.com)
        POOL="saturn"
        WWW="Y"
        PROTECT="Y"
        ;;
    *)
esac

read -e -i "${POOL}" -p "> PHP-FPM Pool to use: " input
POOL="${input:-$POOL}"
#echo ""

SSL="Y"
read -e -i "${SSL}" -p "> Configure for SSL (Y/n) ? " input
SSL="${input:-$SSL}"

read -e -i "${WWW}" -p "> Does this domain have a www prefix (Y/n) ? " input
WWW="${input:-$WWW}"

if [[ $WWW == "Y" ]]; then
	FORCE="Y"
	read -e -i "${FORCE}" -p "> Redirect non-www requests to 'www.' (Y/n) ? " input
	FORCE="${input:-$FORCE}"
	#echo ""
else
	FORCE="n"
fi

FORWARD="N"
if [[ "${DOMAIN}" == "techotaku" ]]; then
	FORWARD="Y"
	read -e -i "${FORWARD}" -p "> Forward '${DOMAIN}.${TLD}' to 'tech-otaku.com' (Y/n) ? " input
	FORWARD="${input:-$FORWARD}"
fi

read -e -i "${PROTECT}" -p "> Prevent future deletion of this virtual host (Y/n) ? " input
PROTECT="${input:-$PROTECT}"

# 												  				/var/www												drwxr-xr-x [755] root [0]:root [0]

sudo mkdir "${ROOT_DIR}"										# /var/www/$DOMAIN.$TLD									drwxr-xr-x [755] root [0]:root [0]
sudo chown -R "${USER}":www-data "${ROOT_DIR}"					# /var/www/$DOMAIN.$TLD									drwxr-xr-x [755] steve [1000]:www-data [33]
mkdir "${DOCUMENT_ROOT}"										# /var/www/$DOMAIN.$TLD/public_html						drwxrwxr-x [775] steve [1000]:steve [1000]



cp "${TEMPLATES}/index.html" "${DOCUMENT_ROOT}/index.html"		# /var/www/$DOMAIN.$TLD/public_html/index.html			-rw-r--r-- [644] steve [1000]:steve [1000]

VER=$(echo "FAC-"$(echo $(date +%a)$(date +%Y%m%d%H%M%S)$(date +%Z) | perl -ne 'print lc'))

sed -i 's/REPLACE WITH TITLE/'"${DOMAIN}"'.'"${TLD}"' | Coming Soon/g' "${DOCUMENT_ROOT}/index.html"
sed -i 's/REPLACE WITH DOMAIN/'"${DOMAIN}"'.'"${TLD}"'/g' "${DOCUMENT_ROOT}/index.html"
sed -i 's/REPLACE WITH TAG LINE/The future home of something new/g' "${DOCUMENT_ROOT}/index.html"
sed -i 's/REPLACE WITH VERSION/'"${VER}"'/g' "${DOCUMENT_ROOT}/index.html"

cp "${TEMPLATES}/error.php" "${DOCUMENT_ROOT}/error.php"
cp "${TEMPLATES}/info.php" "${DOCUMENT_ROOT}/info.php"

if [[ $SSL == "Y" ]]; then
	if [[ $WWW == "Y" ]]; then
		if [[ $FORCE == "Y" ]]; then
			sudo cp /home/steve/templates/php-fpm/-a-vhost-config-template-ssl-www-force.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
		else
			sudo cp /home/steve/templates/php-fpm/-b-vhost-config-template-ssl-www.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
		fi
	else
		sudo cp /home/steve/templates/php-fpm/-c-vhost-config-template-ssl.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
	fi
else
	if [[ $WWW == "Y" ]]; then
		if [[ $FORCE == "Y" ]]; then
			sudo cp /home/steve/templates/php-fpm/-d-vhost-config-template-www-force.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
		else
			sudo cp /home/steve/templates/php-fpm/-e-vhost-config-template-www.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
		fi
	else
		sudo cp /home/steve/templates/php-fpm/-f-vhost-config-template.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
	fi
fi

CREATED=$(date "+%d/%m/%y at %H:%M:%S")

sudo sed -i 's/EXAMPLE.COM/'"${DOMAIN}"'.'"${TLD}"'/g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
sudo sed -i 's/POOL/'"${POOL}"'/g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
sudo sed -i 's!# Created on!# Created on '"${CREATED}"' by '"$0"'!g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"		# The / separator replaced with ! in sed to avoid conflict with / in $CREATED date


if [[ $PROTECT == "Y" ]]; then
	touch "${ROOT_DIR}/.prevent-deletion"
fi


# 7. CREATE .HTACCESS FILES, CONFIGURE HTTP AUTHENTICATION & OVERRIDE MASTER PHP SETTINGS

# Enable .htaccess Overrides
if grep -q "#AllowOverride All" "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"; then
	sudo sed -i 's/#AllowOverride All/AllowOverride All/g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
fi

tee "${DOCUMENT_ROOT}/.htaccess" <<HEREDOC
# PROTECT INFO.PHP - [Added by $0]
<Files info.php>
	AuthType Basic
	AuthName "Hackers are not welcome here!"
	AuthGroupFile /dev/null
	AuthBasicProvider dbm
	AuthDBMUserFile $ROOT_DIR/.htdbm
	Require user chiaki
</Files>

HEREDOC


cp -r /home/steve/.htpasswds/.htdbm "${ROOT_DIR}/.htdbm"

if [[ "${DOMAIN}" == "techotaku" && "${FORWARD}" == "Y" ]]; then

tee /tmp/HereFile <<HEREDOC
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# IMPORTANT: Like all other virtual host configurations on this
	# server all requests on http:// [:80] are redirected to
	# https:// [:443]. However, unlike those other virtual host
	# configurations, ALL REQUESTS ON HTTPS:// [:443] - REDIRECTED
	# OR OTHERWISE - ARE FORWARDED TO THE DOMAIN TECH-OTAKU.COM
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

	# FORWARD ALL REQUESTS TO 'HTTPS://WWW.TECH-OTAKU.COM'
HEREDOC

	sudo sed -i "/# Redirect non-www requests to 'www.'/ {
	   r /tmp/HereFile
	   d
	   }" "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
   
	rm /tmp/HereFile

	sudo sed -i '/RewriteCond %{HTTP_HOST} !\^www\\./d' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"

	sudo sed -i 's/https:\/\/www.%{HTTP_HOST}%{REQUEST_URI}/https:\/\/www.tech-otaku.com%{REQUEST_URI}/' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
	
	rm "${DOCUMENT_ROOT}/error.php"
	rm "${DOCUMENT_ROOT}/info.php"
	rm "${DOCUMENT_ROOT}/.htaccess"
	rm "${ROOT_DIR}/.htdbm"
	
	
fi

sudo chown -R $POOL:www-data "${ROOT_DIR}"
sudo find "${ROOT_DIR}"/. -type d -exec chmod 750 {} +
sudo find "${ROOT_DIR}"/. -type f -exec chmod 640 {} +

sudo a2ensite "${DOMAIN}.${TLD}.conf"

echo "Restarting Apache"
sudo systemctl restart apache2

echo "Restarting PHP-FPM"
sudo systemctl restart php"${PHP_VERSION}"-fpm

echo ""
echo "IMPORTANT: '${DOCUMENT_ROOT}/info.php' is protected by HTTP Authentication."
echo "Username: chiaki"
echo ""

if [[ $SSL == "Y" ]]; then
	echo ""
	echo "WARNING: This virtual host has been configured to rewrite all requests to HTTPS."
	echo "To avoid a redirect loop ensure ${DOMAIN}.${TLD} is paused – not active – on Cloudflare."
	echo ""
fi

if [ ! -f "/etc/php/${PHP_VERSION}/fpm/pool.d/${POOL}.conf" ]; then
	echo ""
	echo "WARNING: The pool '/etc/php/${PHP_VERSION}/fpm/pool.d/${POOL}.conf' does not exist and needs"
	echo "to be created in order for this virtual host to function correctly."
	echo ""
fi
