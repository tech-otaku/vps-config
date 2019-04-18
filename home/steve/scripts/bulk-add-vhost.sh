#!/bin/bash
# Steve Ward: 2016-09-24

# USAGE: bulk-add-vhost.sh
# Bulk creation of selected virtual hosts

#add-vhost.sh patchpeters
#echo '--> Virtual host for patchpeters.com created.....'
add-vhost.sh steveward me.uk
echo '--> Virtual host for steveward.me.uk created.....'
add-vhost.sh techotaku
echo '--> Virtual host for techotaku.com created.....'
add-vhost.sh demo.techotaku
echo '--> Virtual host for demo.techotaku.com created.....'
add-vhost.sh vps-mail
echo '--> Virtual host for vps-mail.com created.....'
add-vhost.sh demo.vps-mail
echo '--> Virtual host for demo.vps-mail.com created.....'

