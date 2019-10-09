DOMAIN=vps-mail
TLD=com

sudo rm /etc/nginx/sites-enabled/$DOMAIN.$TLD
sudo rm /etc/nginx/sites-available/$DOMAIN.$TLD
sudo rm -rf /usr/share/nginx/$DOMAIN.$TLD

sudo systemctl reload nginx