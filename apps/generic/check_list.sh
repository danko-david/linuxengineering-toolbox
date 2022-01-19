#!/bin/bash

# Reads the list file and feed to the checker script as arguments.
# Usage: ./check_list.sh test.sh test.lst
#
# Similar to this:
# `cat $2 | grep -v "^#" | grep -vP "^$" | xargs -n $n $1`
# But without hard-coded argument numbers ($n)
# You can run all checks parallel if you specify CHECK_LIST_PARALLEL=1 in env like this:
# Usage: CHECK_LIST_PARALLEL=1 ./check_list.sh test.sh test.lst


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

function run
{
	# wait program exit and wtire all output at once
	OUT=$($prog $@)
	echo "$OUT"
}

while read -r line
do
	# if line is valid and not commented out with starting '#'
	if [ ${#line} -gt 0 ] && ! [[ "$line" =~ ^[[:space:]]*# ]] ; then
		args=$(cut -f1 <<< $line)

		if [ -z ${CHECK_LIST_PARALLEL+x} ];then
			$prog $args
		else
			run $args &
		fi
	fi
done < $2

wait
