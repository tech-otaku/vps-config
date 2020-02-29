#!/usr/bin/env bash

# USAGE: /home/steve/scripts/telnet-mail-server.sh <ip address>

# Using telnet, this script attempts to connect to the mail server at the given IP address on port 143 (imap/dovecot) 
# and port 587 (smtp/postfix). If no connection can be established on either port, the mail server at the given IP 
# address is likely down and an email is sent notifying the user. Separate emails are sent for port 143 and port 587.  
#
# This script is executed every 5 minutes by a cron job that belongs to 'steve' on the server '94.130.177.167'. This
# server was chosen as it is (should be) up 24/7 unlike a local machine that may be off or in sleep mode for long
# periods of time.
#
#
# NOTE 1: '\x1dclose\x0d' mimics the '^]', 'close' and 'carriage return' of telnet's command mode. '\x1d' is the
# ASCII control character for '^]' and '\x0d' is the ASCII control character for '^M' (carriage return). 
# See http://donsnotes.com/tech/charsets/ascii.html  
#
#
# NOTE 2: Emails are sent using curl and Gmail's SMTP server. Both the sender (steve.techotaku) and recipient
# (steve.patchpeters) are Gmail accounts. The sender account must authenticate with Gmail's SMTP server using an
# App Password - see https://support.google.com/accounts/answer/185833?hl=en. Turning-on access to less secure apps
# may also need to be turned on - see https://support.google.com/a/answer/6260879?hl=en  
#
# NOTE 3: Instead of using --user "username:passsword", the --netrc option is used. This requires a file named 
# .netrc containing 'machine smtp.gmail.com login steve.techotaku@gmail.com password <password>' exists in 
# /home/steve/.  

# IMAP (dovecot)
	PORT=143

	# See NOTE 1
	echo -e '\x1dclose\x0d' | /usr/bin/telnet $1 $PORT

	RETVAL=$(echo $?)

	if [[ $RETVAL -eq 1 ]]; then
		# See NOTE 2
		curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
			--mail-from 'steve.techotaku@gmail.com' \
			--mail-rcpt 'steve.patchpeters@gmail.com' \
			--netrc "smtp.gmail.com" \
			-T <(echo -e "From: steve.techotaku <steve.techotaku@gmail.com>\nTo: <steve.patchpeters@gmail.com>\nSubject: Mail Server Down [:$PORT]\n\nTelnet attempted to connect to the IMAP (dovecot) server at mail.tech-otaku.net at $1 on port $PORT, but the connection was refused.")
	fi


# SMTP (postfix)
	PORT=587

	# See NOTE 1
	echo -e '\x1dclose\x0d' | /usr/bin/telnet $1 $PORT

	RETVAL=$(echo $?)

	if [[ $RETVAL -eq 1 ]]; then
		# See NOTE 2
		curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
			--mail-from 'steve.techotaku@gmail.com' \
			--mail-rcpt 'steve.patchpeters@gmail.com' \
			--netrc "smtp.gmail.com" \
			-T <(echo -e "From: steve.techotaku <steve.techotaku@gmail.com>\nTo: <steve.patchpeters@gmail.com>\nSubject: Mail Server Down [:$PORT]\n\nTelnet attempted to connect to the SMTP (postfix) server at mail.tech-otaku.net at $1 on port $PORT, but the connection was refused.")
	fi




