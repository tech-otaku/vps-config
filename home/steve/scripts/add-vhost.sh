#!/usr/bin/env bash
# Steve Ward: 2019-09-29

# USAGE: sudo add-vhost.sh <domain> [<tld>]
# NOTE: If <tld> is not supplied a tld of 'com' is assumed i.e. add-vhost.sh tech-otaku or add-vhost.sh steveward me.uk
# ALIAS: vhost-add <domain> [<tld>]
# CODE: /home/steve/scripts/add-vhost.sh

# TREE: Files and directories below marked '-*-' are created/modified by this script.
#
# |--- etc/
#      |--- apache2/
#           |--- sites-available/
#                |-*- domain.tld.conf				0644 root:root
#
# |--- home/
#      |--- user/
#           |--- www/	
#                |-*- domain.tld/					0755 root:www-data
#                     |-*- public_html/				2750 user:www-data
#                          |-*- error.php			0640 user:www-data 
#                          |-*- index.html			0640 user:www-data
#                          |-*- info.php			0640 user:www-data
#                     |-*- .htdbm					0440 user:www-data
#                     |-*- .prevent_deletion		0400 root:root

clear

# Exit if root is not running this script.
if [ $EUID -ne 0  ]; then
   printf "ERROR: This script must be run as root.\n" 1>&2
   exit 1
fi

# Exit if no domain name was specified.
if [ -z "${1}" ]; then
    printf "ERROR: No domain name was specified.\n"
    exit 1
fi

# Exit if the configuration file doesn't exist.
if [ ! -f "/home/steve/config/vhost-config.json" ]; then
	printf "ERROR: Can't find the configuration file '/home/steve/config/vhost-config.json'.\n"
	exit 1
fi

DOMAIN="${1}"

if [ -z "${2}" ]; then
	TLD="com"
else 
	TLD="${2}"
fi

# Exit if an apache .conf file for the domain already exists.
if [ -f "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf" ]; then
  	printf "ERROR: It looks like a virtual host already exists for domain '${DOMAIN}.${TLD}'.\n"
	exit
fi

# Exit if the configuration file doesn't contain configuration data for the domain.
grep -q '"'$DOMAIN.$TLD'"' /home/steve/config/vhost-config.json
if [ $? -ne 0 ]; then
	printf "ERROR: No configuration data found for domain '$DOMAIN.$TLD'.\n"
	exit 1
fi

# Exit if attempting to configure a virtual host for a sub-domain of 'techotaku.com'.
if [[ "${DOMAIN}" == *"techotaku" && ! "${DOMAIN}" =~ ^techotaku && "${TLD}" == "com" ]]; then
	printf "ERROR: Sub-domains cannot be configured for domain 'techotaku.com'.\n"
    exit 1
fi

# Get global default values from the configuration file.
CONFIG_ONLY=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['defaults']['config_only'])")
CREATE_ERROR=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['defaults']['create_error'])")
CREATE_INFO=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['defaults']['create_info'])")
FORCE_WWW=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['defaults']['force_www'])")
GROUP=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['defaults']['group'])")
PROTECT=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['defaults']['protect'])")
PROTECT_INFO=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['defaults']['protect_info'])")
SSL=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['defaults']['ssl'])")

# Get domain-specific values from the configuration file.
AUTH_USER=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['domain']['$DOMAIN.$TLD']['auth_user'])")
IGNORE_HTACCESS=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['domain']['$DOMAIN.$TLD']['ignore_htaccess'])")
OWNER=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['domain']['$DOMAIN.$TLD']['owner'])")
POOL=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['domain']['$DOMAIN.$TLD']['pool'])")
ROOT_DIR=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['domain']['$DOMAIN.$TLD']['root_dir'])")
WWW=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['domain']['$DOMAIN.$TLD']['www'])")
CERT_NAME=$(cat /home/steve/config/vhost-config.json | python3 -c "import sys, json; print(json.load(sys.stdin)['domain']['$DOMAIN.$TLD']['cert_name'])")

DOCUMENT_ROOT=$ROOT_DIR/public_html

# Exit if the user associated with the domain doesn't exist.
if [ $(grep -c "^${OWNER}:" /etc/passwd) -eq 0 ]; then
	printf "ERROR: The user '${OWNER}' associated with the domain '$DOMAIN.$TLD' doesn't exist.\n"
fi

# Exit if the user's 'www' directory doesn't exist.
if [ ! -d "/home/${OWNER}/www" ]; then
	printf "ERROR: The directory '/home/${OWNER}/www' associated with the domain '$DOMAIN.$TLD' doesn't exist.\n"
	exit 1
fi

# Exit if PHP-FPM pool associated with the user doesn't exist.
if [ ! -f "/etc/php/7.4/fpm/pool.d/${POOL}.conf" ]; then
	printf "ERROR: The PHP-FPM pool '${POOL}' associated with the domain '$DOMAIN.$TLD' doesn't exist.\n"
	exit 1
fi

printf "====================================== CONFIGURE VIRTUAL HOST =====================================\n"
printf "Create virtual host for domain '${DOMAIN}.${TLD}'\n"
printf "Configuration directory: ${ROOT_DIR}/\n"
printf "===================================================================================================\n"

read -e -i "${POOL}" -p "> PHP-FPM Pool to use: " input
POOL="${input:-$POOL}"

read -e -i "${SSL}" -p "> Configure for SSL (Y/n) ? " input
SSL="${input:-$SSL}"

if [[ $SSL == "Y" ]]; then
	read -e -i "${CERT_NAME}" -p "> SSL Certificate to use: " input
	CERT_NAME="${input:-$CERT_NAME}"
fi

read -e -i "${WWW}" -p "> Does this domain have a www prefix (Y/n) ? " input
WWW="${input:-$WWW}"

#FORCE="n"
if [[ $WWW == "Y" ]]; then
	#FORCE="Y"
	read -e -i "${FORCE_WWW}" -p "> Redirect non-www requests to 'www.' (Y/n) ? " input
	FORCE_WWW="${input:-$FORCE_WWW}"
fi

read -e -i "${IGNORE_HTACCESS}" -p "> Ignore '.htaccess' files (Y/n) ? " input
IGNORE_HTACCESS="${input:-$IGNORE_HTACCESS}"

read -e -i "${CREATE_INFO}" -p "> Create info.php [f]ull|[p]art|[m]ove|[n]one ? " input
CREATE_INFO="${input:-$CREATE_INFO}"

#PROTECT_INFO="n"
if [[ ! $CREATE_INFO == "n" ]]; then
	#PROTECT_INFO="Y"
	read -e -i "${PROTECT_INFO}" -p "> Protect info.php with HTTP Auth (Y/n) ? " input
	PROTECT_INFO="${input:-$PROTECT_INFO}"
else
	PROTECT_INFO="n"
fi


read -e -i "${CREATE_ERROR}" -p "> Create error.php (Y/n) ? " input
CREATE_ERROR="${input:-$CREATE_ERROR}"

FORWARD="N"
if [[ "${DOMAIN}" == "techotaku" ]]; then
	FORWARD="Y"
	read -e -i "${FORWARD}" -p "> Forward '${DOMAIN}.${TLD}' to 'tech-otaku.com' (Y/n) ? " input
	FORWARD="${input:-$FORWARD}"
fi

read -e -i "${PROTECT}" -p "> Prevent future deletion of this virtual host (Y/n) ? " input
PROTECT="${input:-$PROTECT}"


clear

printf "====================================== CONFIGURATION DETAILS ======================================\n"
printf "Virtual host:                      ${DOMAIN}.${TLD}\n"
printf "Root directory:                    ${ROOT_DIR}\n"
printf "Document Root:                     ${DOCUMENT_ROOT}\n"
printf "PHP-FPM Pool:                      ${POOL}\n"
printf "Configure for SSL:                 " && [[ $SSL == 'Y' ]] && printf "Yes\n" || printf "No\n"
[[ $SSL == "Y" ]] && printf "SSL Certificate Name:              %s\n" ${CERT_NAME} 
printf "Has 'www' prefix:                  " && [[ $WWW == 'Y' ]] && printf "Yes\n" || printf "No\n"
[[ $WWW == "Y" ]] && printf "Redirect non-www to 'www':         " && ( [[ $FORCE_WWW == 'Y' ]] && printf "Yes\n" || printf "No\n" )
printf "Ignore '.htaccess' files:          " && [[ $IGNORE_HTACCESS == 'Y' ]] && printf "Yes\n" || printf "No\n"
printf "Create 'info.php':                 ${CREATE_INFO}\n"
[[ ! $CREATE_INFO == "n" ]] && printf "Protect 'info.php' with HTTP Auth: " && ( [[ $PROTECT_INFO == 'Y' ]] && printf "Yes (user is '${AUTH_USER}')\n" || printf "No\n" )
printf "Create 'error.php':                " && [[ $CREATE_ERROR == 'Y' ]] && printf "Yes\n" || printf "No\n"
printf "Protected from deletion:           " && [[ $PROTECT == 'Y' ]] && printf "Yes\n" || printf "No\n"
printf "Owner:                             ${OWNER}\n"
printf "Group:                             ${GROUP}\n\n"

CONT="n"
read -e -i "${CONT}" -p "> Continue with configuration (Y/n) ? " input
CONT="${input:-$CONT}"
if [[ $CONT == "n" ]]; then
#if [ "$run" == n ] ; then
	echo "INFORMATION: Configuration of virtual host '${DOMAIN}.${TLD}' cancelled."
	exit 1
fi

TEMPLATES=/home/steve/templates
PHP_VERSION=$(php --version | awk '/^PHP/ {print $2}' | cut -d '.' -f 1-2)

mkdir -p "${ROOT_DIR}"										
mkdir "${DOCUMENT_ROOT}"

# PROTECT VIRTUAL HOST CONFIG FROM DELETION
[[ "${PROTECT}" == "Y" ]] && touch "${ROOT_DIR}/.prevent-deletion"


# ERROR.PHP
[[ "${CREATE_ERROR}" == 'Y' ]] && cp "${TEMPLATES}/error-template.php" "${DOCUMENT_ROOT}/error.php"


# INFO.PHP
case "${CREATE_INFO}" in
	"f")
        cp "${TEMPLATES}/info/info-full.php" "${DOCUMENT_ROOT}/info.php"
        ;;
    "p")
        cp "${TEMPLATES}/info/info-part.php" "${DOCUMENT_ROOT}/info.php"
        ;;
    "m")
        cp "${TEMPLATES}/info/info-move.php" "${DOCUMENT_ROOT}/info.php"
        ;;
	*)
esac


# PROTECT INFO.PHP WITH HTTP AUTH
[[ "${PROTECT_INFO}" == "Y" ]] && cp -r /home/steve/.htpasswds/.htdbm "${ROOT_DIR}/.htdbm"


# INDEX.HTML
cp "${TEMPLATES}/index-template.html" "${DOCUMENT_ROOT}/index.html"		

VER=$(echo "FAC-"$(echo $(date +%a)$(date +%Y%m%d%H%M%S)$(date +%Z) | perl -ne 'print lc'))

sed -i 's/_TITLE_/'"${DOMAIN}"'.'"${TLD}"' | Coming Soon/g' "${DOCUMENT_ROOT}/index.html"
sed -i 's/_DOMAIN_/'"${DOMAIN}"'.'"${TLD}"'/g' "${DOCUMENT_ROOT}/index.html"
sed -i 's/_TAG_LINE_/The future home of something new/g' "${DOCUMENT_ROOT}/index.html"
sed -i 's/_VERSION_/'"${VER}"'/g' "${DOCUMENT_ROOT}/index.html"


# DOMAIN.TLD.CONF
if [[ $SSL == "Y" ]]; then
	if [[ $WWW == "Y" ]]; then
		if [[ $FORCE_WWW == "Y" ]]; then
			cp ${TEMPLATES}/php-fpm/-a-vhost-config-template-ssl-www-force.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
		else
			cp ${TEMPLATES}/php-fpm/-b-vhost-config-template-ssl-www.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
		fi
	else
		cp ${TEMPLATES}/php-fpm/-c-vhost-config-template-ssl.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
	fi
else
	if [[ $WWW == "Y" ]]; then
		if [[ $FORCE_WWW == "Y" ]]; then
			cp ${TEMPLATES}/php-fpm/-d-vhost-config-template-www-force.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
		else
			cp ${TEMPLATES}/php-fpm/-e-vhost-config-template-www.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
		fi
	else
		cp ${TEMPLATES}/php-fpm/-f-vhost-config-template.conf "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
	fi
fi

if [[ "${PROTECT_INFO}" == 'Y' ]]; then
	sed -i "/### BEGIN GENERATED .HTACCESS DIRECTIVES \[DO NOT DELETE THIS LINE\]/,/### END GENERATED .HTACCESS DIRECTIVES \[DO NOT DELETE THIS LINE\]/ { /### BEGIN GENERATED .HTACCESS DIRECTIVES \[DO NOT DELETE THIS LINE\]/{p; r ${TEMPLATES}/htaccess/non-wp-htaccess.conf
        }; /### END GENERATED .HTACCESS DIRECTIVES \[DO NOT DELETE THIS LINE\]/p; d }"  "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
fi

GENERATED=$(date "+%d/%m/%y at %H:%M:%S")

sed -i 's!_GENERATED_!'"${GENERATED}"'!g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
sed -i 's!_TEMPLATE_DIRECTORY_!'"${TEMPLATES}"'!g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
sed -i 's!_DOMAIN_!'"${DOMAIN}"'!g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
sed -i 's!_TLD_!'"${TLD}"'!g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"

DIRECTIVE_VALUE="None"
if [[ "${IGNORE_HTACCESS}" == 'n' ]]; then
	DIRECTIVE_VALUE="All"
fi 
sed -i 's!_ALLOWOVERRIDE_!'"AllowOverride ${DIRECTIVE_VALUE}"'!g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
sed -i 's!_ALLOWOVERRIDELIST_!'"AllowOverrideList ${DIRECTIVE_VALUE}"'!g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"

sed -i 's/_POOL_/'"${POOL}"'/g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
sed -i 's!_DOCUMENT_ROOT_!'"${DOCUMENT_ROOT}"'!g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
sed -i 's!_ROOT_DIRECTORY_!'"${ROOT_DIR}"'!g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
sed -i 's/_AUTH_USER_/'"${AUTH_USER}"'/g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
sed -i 's/_CERT_NAME_/'"${CERT_NAME}"'/g' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"


# FOR DOMAIN TECHOTAKU.COM
if [[ "${DOMAIN}" == "techotaku" && "${FORWARD}" == "Y" ]]; then

	sed -i "/# Redirect non-www requests to 'www.'/ {
	   r ${TEMPLATES}/forward-domain-techotaku.conf
	   d
	   }" "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
   
	sed -i '/RewriteCond %{HTTP_HOST} !\^www\\./d' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"

	sed -i 's/https:\/\/www.%{HTTP_HOST}%{REQUEST_URI}/https:\/\/www.tech-otaku.com%{REQUEST_URI}/' "/etc/apache2/sites-available/${DOMAIN}.${TLD}.conf"
	
	[ -f "${ROOT_DIR}/.htdbm" ] && rm "${ROOT_DIR}/.htdbm"
	[ -f "${DOCUMENT_ROOT}/error.php" ] && rm "${DOCUMENT_ROOT}/error.php"
	#[ -f "${DOCUMENT_ROOT}/index.html" ] && rm "${DOCUMENT_ROOT}/index.html"
	[ -f "${DOCUMENT_ROOT}/info.php" ] && rm "${DOCUMENT_ROOT}/info.php"
	[ -f "${DOCUMENT_ROOT}/.htaccess" ] && rm "${DOCUMENT_ROOT}/.htaccess"
	
	echo "<!-- Generated on $GENERATED -->" > "${DOCUMENT_ROOT}/index.html"
	
fi

#if [[ "${DOMAIN}.${TLD}" == *"barrieward.com" ]]; then
	chown root:"${GROUP}" "${ROOT_DIR}"
	chmod 755 "${ROOT_DIR}"
	if [ -f "${ROOT_DIR}/.htdbm" ]; then
		chown "${OWNER}":"${GROUP}" "${ROOT_DIR}/.htdbm"
		chmod 440 "${ROOT_DIR}/.htdbm"
	fi
	if [ -f "${ROOT_DIR}/.prevent-deletion" ]; then
		chown root:root "${ROOT_DIR}/.prevent-deletion"
		chmod 400 "${ROOT_DIR}/.prevent-deletion"
	fi
	find "${DOCUMENT_ROOT}"/. -type d -exec chmod 750 {} +
	find "${DOCUMENT_ROOT}"/. -type f -exec chmod 640 {} +
	chown -R "${OWNER}":"${GROUP}" "${DOCUMENT_ROOT}"
	chmod g+s "${DOCUMENT_ROOT}"
	#setfacl -Rdm g:www-data:rx "${DOCUMENT_ROOT}"
	setfacl -Rdm g:"${GROUP}":rx "${DOCUMENT_ROOT}"
#fi

printf "INFORMATION: Enabling domain '${DOMAIN}.${TLD}'\n"
a2ensite "${DOMAIN}.${TLD}.conf"

printf "INFORMATION: Restarting Apache\n"
systemctl restart apache2

printf "INFORMATION: Restarting php${PHP_VERSION}-fpm\n"
systemctl restart php"${PHP_VERSION}"-fpm

#echo ""
#echo "IMPORTANT: '${DOCUMENT_ROOT}/info.php' is protected by HTTP Authentication."
#echo "Username: chiaki"
#echo ""

if [[ $SSL == "Y" ]]; then
    cat << EOF
    
WARNING: This virtual host has been configured to rewrite all requests to HTTPS. To avoid a
redirect loop ensure that if Cloudflare is enabled for the zone record (site) that includes
${DOMAIN}.${TLD}, the SSL/TLS encryption mode is set to Full (strict)."
See https://community.cloudflare.com/t/community-tip-fixing-err-too-many-redirects/42335
EOF
fi

if [ ! -f "/etc/php/${PHP_VERSION}/fpm/pool.d/${POOL}.conf" ]; then
cat << EOF
    
WARNING: The pool '/etc/php/${PHP_VERSION}/fpm/pool.d/${POOL}.conf' does not exist and needs
to be created in order for this virtual host to function correctly.
EOF
fi
