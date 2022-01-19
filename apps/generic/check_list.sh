#!/bin/bash

# Reads the list file and feed to the checker script as arguments.
# Similar to this:
# `cat $2 | grep -v "^#" | grep -vP "^$" | xargs -n $n $1`
# But without hard-coded argument numbers ($n)


if [ ! -f "$1" ]; then
	echo "No check script specified."
	echo "Usage ./check_list.sh checker_script.sh check.list"
	exit 1
fi


if [ -z "$2" ]; then
	echo "No file specified."
	echo "Usage ./check_list.sh checker_script.sh check.list"
	exit 2
fi

prog=$(readlink -f $1)

while IFS= read -r line
do
	# if line is valid and not commented out with starting '#'
	if [ ${#line} -gt 1 ] && ! [[ "$line" =~ ^[[:space:]]*# ]] ; then
		args=$(cut -f1 <<< $line)
		$prog $args
	fi
done < $2

