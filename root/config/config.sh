#!/bin/bash

clear

echo '--> CONFIGURING.....'

tz="Europe/London"

echo '--> Suppressing the message "perl: warning: Setting locale failed.".....'
locale-gen en_US en_GB.UTF-8

echo '--> Installing curl.....'
apt-get install curl

#echo '--> Installing zip/unzip.....'
#apt-get install zip unzip

echo '--> Current date and time is '$(date "+%d/%m/%y %H:%M:%S")

echo '--> Setting time zone to '$tz '.....' 
timedatectl set-timezone $tz

echo '--> Current date and time is '$(date "+%d/%m/%y %H:%M:%S")

echo '--> Configuring nano.....'
sed -i 's/[# ]*set tabsize 8/set tabsize 4/g' /etc/nanorc

echo '--> CONFIGURATION COMPLETE.'