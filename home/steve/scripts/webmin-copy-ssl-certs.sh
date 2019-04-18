#!/bin/bash
# Steve Ward: 2017-08-04

# runs as root as part of root's crontab every Sunday at 4 a.m. (0 4 * * 0) to ensure
# any renewed SSL certificates are copied to the /etc/webmin directory to avoid certificate trust errors when
# logging-in to Webmin.

cp /etc/letsencrypt/live/000-default.net/privkey.pem /etc/webmin/privkey.pem; cp /etc/letsencrypt/live/000-default.net/cert.pem /etc/webmin/cert.pem; cp /etc/letsencrypt/live/000-default.net/chain.pem /etc/webmin/chain.pem; cp /etc/letsencrypt/live/000-default.net/fullchain.pem /etc/webmin/fullchain.pem; systemctl restart webmin.service