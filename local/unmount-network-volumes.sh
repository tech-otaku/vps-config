#!/bin/bash
# Steve Ward: 2016-10-13

# USAGE: sudo /Users/steve/Dropbox/Digital\ Ocean/local/unmount-network-volumes.sh

if [ -d "/Volumes/steves-macbook-pro" ]; then
	sudo umount /Volumes/steves-macbook-pro
fi

if [ -d "/Volumes/steves-imac-24" ]; then
	sudo umount /Volumes/steves-imac-24
fi

if [ -d "/Volumes/steves-macbook" ]; then
	sudo umount /Volumes/steves-macbook
fi

sudo -k