#!/bin/bash

# This script checks the domains certification (listed in a file and
# specified -f CLI switch). Format example:
#	example.com:443
#	www.example.eu:443
#
# Empty lines and lines starts with # will be ignored.
#
# Options:
#	-f Specify the domain list file
#	-v verbose output (prints all domain's exact expire date)
#	-d $day shows the domains will be expired within $days (default: 20)
#	-a list all domains with expire ignoring the -d option
#
# Example:
#	Show the domain that will be expired within 40 days
#	./certcheck.sh -f cert_domains.list -d 40
#
# If you want to get notified about the expiration, you might want to combine
# this command with the other script `mailme.sh`
#

notify_from_days=20

# source: https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
for i in "$@"
do
case $i in

	-f|--file)
	file="$2"
	shift
	shift
	;;

	-d|--nodify-days)
	notify_from_days="$2"
	shift
	shift
	;;

	-v)
	cert_check_verbose="yes"
	shift
	;;

	-a)
	cert_show_all="yes"
	shift
	;;
	*)
	# unknown option
	;;
esac
done

if [ -z "$file" ]; then
	echo "No file specified."
	echo "Usage ./certcheck.sh -f cert_domain_file"
	echo -e "Cert domain file contains lines like these:\nexample.com:443\nwww.example.eu:443"
	exit 1
fi

if ! [ -f "$file" ]; then
	echo "Specified file $file doesn't exists"
	exit 2
fi

#define a map (or hash): https://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash
declare -A expires

time_now=$(date +%s)

while IFS= read -r line
do
	# if line is valid and not commented out with starting '#'
	if [ ${#line} -gt 1 ] && ! [[ "$line" =~ ^[[:space:]]*# ]] ; then
		# part of the line before ':'
		domain=$(echo $line | grep -oP '.*(?=:)')
		till=$(echo | openssl s_client -servername $domain -connect $line 2>/dev/null | openssl x509 -noout -dates | grep -oP '(?<=notAfter=).*')
		till_uts=$(date --date="$till" +%s)
		remaining_days=$((($till_uts - $time_now)/84600))
		if [ -n "$cert_check_verbose" ]; then
			echo $remaining_days $line "expires at" $till
		fi
		expires["$remaining_days"]+="\t$line\n"
		#echo $line "expires at" $till $remaining_days "days remaining"
	fi
done < $file

#sort the keys by numeric ascending order
while IFS= read -rd '' key; do
    sorted+=( "$key" )
done < <(printf '%s\0' "${!expires[@]}" | sort -n -z)

#if show all requested
#walk the ascending order
for key in "${sorted[@]}"
do
	if [ -n "$cert_show_all" ] || [ $notify_from_days -gt $key ] ; then
		echo "Expires in $key day(s)"
		echo -e "${expires[$key]}"
	fi
done
