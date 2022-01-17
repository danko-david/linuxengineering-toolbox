#!/bin/bash

#
# Users can add command in ~/on_system_startup.sh to run after system boot.
# Alternatively, you can define systemd user services: https://www.unixsysadmin.com/systemd-user-services/
#

INCLUDE_ROOT=true
MIN_UID=1000
MAX_UID=65500

START_FILE_NAME="on_system_startup.sh"

while IFS= read -r line
do
	USER=$(echo $line | awk -F':' '{ print $1}')
	ID=$(echo $line | awk -F':' '{ print $3}')
	HOME=$(echo $line | awk -F':' '{ print $6}')

	if
	(
		([ 0 == $ID ] && [ "true" == $INCLUDE_ROOT ]) || ([ $MIN_UID -le $ID ] && [ $ID -le $MAX_UID ])
	); then
		#does it have startup file
		SF="$HOME/$START_FILE_NAME"
		if [[ -x $SF ]]; then
			cd $HOME
			sudo -u $USER bash -c $SF > /dev/null &
		fi
	fi

done < /etc/passwd

