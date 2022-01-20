#!/bin/bash

# This script checks the domains certification (listed in a file and
# specified -f CLI switch). Format example (source and destination separated
# with tabs):
#http://example.com/	https://www.example.com/
#https://example.com/	https://www.example.com/
#
# Empty lines and lines starts with # will be ignored.
#
# Options:
#	-f Specify the redirection list file
#	-a prints all redirect regardless if it passes or fails
#
# Example:
#	./redirect_check.sh -f redirects.list
#
# If you want to get notified about the expiration, you might want to combine
# this command with the other script like `mailme.sh`
#

# source: https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
for i in "$@"
do
case $i in

	-f|--file)
	file="$2"
	shift
	shift
	;;

	-a)
	redirect_show_all="yes"
	shift
	;;
	*)
	# unknown option
#	echo "Unknown option: "$i
#	exit 1
	;;
esac
done

if [ -z "$file" ]; then
	echo "No file specified."
	echo "Usage ./redirect_check.sh -f redirect_map_file"
	echo -e "Redirect map file contains lines like this (source and destination separated with tabs):\nhttp://example.com/	https://www.example.com/\nhttps://example.com/	https://www.example.com/"
	exit 2
fi

if ! [ -f "$file" ]; then
	echo "Specified file $file doesn't exists"
	exit 3
fi

while IFS= read -r line
do
	# if line is valid and not commented out with starting '#'
	if [ ${#line} -gt 1 ] && ! [[ "$line" =~ ^[[:space:]]*# ]] ; then
		# part of the line before ':'
		from=$(grep -oP '.*(?=\t)' <<< "$line")
		to=$(grep -oP '(?<=\t).*' <<< "$line")
		
		dst=$(curl -Ik $from 2> /dev/null | tr '\r\n' '\n' | grep -oP "(?<=Location: ).*")
		
		if [ "$to" != "$dst" ]; then
			echo "Redirection failed \`"$from"\` expected: \`"$to"\`, actual: \`"$dst"\`";
		elif [ -n "$redirect_show_all" ]; then
			echo "Redirection passed \`"$from"\` to: \`"$to"\`";
		fi
	fi
done < $file

