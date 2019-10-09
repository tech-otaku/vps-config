DOMAIN=vps-mail
TLD=com

sudo mkdir -p /usr/share/nginx/$DOMAIN.$TLD/public_html

#echo "<h1 style='color: green;'>vps-mail.com</h1>" | sudo tee /usr/share/nginx/$DOMAIN.$TLD/public_html/index.html
echo "<?php phpinfo(); ?>" | sudo tee /usr/share/nginx/$DOMAIN.$TLD/public_html/info.php

sudo cp /home/steve/templates/-f-nginx-vhost-config-template.conf /etc/nginx/sites-available/$DOMAIN.$TLD

n=$(date "+%d/%m/%y at %H:%M:%S")
# The / separator replaced with ! in sed to avoid conflict with / in $n date
sudo sed -i 's!# Created on!# Created on '"$n"' by '"$0"'!g' /etc/nginx/sites-available/$DOMAIN.$TLD
sudo sed -i 's/EXAMPLE.COM/'"$DOMAIN"'.'"$TLD"'/g' /etc/nginx/sites-available/$DOMAIN.$TLD

sudo ln -s /etc/nginx/sites-available/$DOMAIN.$TLD /etc/nginx/sites-enabled/$DOMAIN.$TLD

sudo systemctl reload nginx