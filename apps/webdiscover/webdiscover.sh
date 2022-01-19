#!/bin/bash

FOUND_URL=()

function http_code
{
	curl -Lk --write-out '%{http_code}' --silent --output /dev/null $1
}

function poke_url
{
	hc=$(http_code $1)
	if [ "$hc" == "000" ]; then
		return
	fi

	if [ "$hc" != "404" ] && [ "$hc" != "403" ] ; then
		if [ "$2" != "" ]; then
			echo $2
		fi
		FOUND_URL+=($1)
	fi
}

function check_missing
{
	hc=$(http_code $1)
	if [ "$hc" == "404" ] ; then
		echo $2
	fi
}

function rootfile
{
	poke_url "$1/$2" "$2: Warning: Visible $2 file: $1/$2"
}

function url_service
{
	poke_url $1"/"$2 $1": "$3" service found at: "$1/$2
}

set -e
ip=$(resolveip -s $1)
set +e

fail404=$(http_code "http://$1/imsurethiswillbe404")
if [ "$fail404" == "200" ]; then
	echo "ERROR: $1:Wrong missing page management. 404 pages returns 200 status code. URL service poking is pointless because it will hit all test URLs. Exiting..."
	exit 1
fi

if [ -z ${WEBDISCOVER_SKIP_BASICS+x} ]; then
	if [ -z ${WEBDISCOVER_HTTPS_ONLY+x} ]; then
		poke_url "https://$1/" $1": HTTP service"
	fi

	if [ -z ${WEBDISCOVER_HTTP_ONLY+x} ]; then
		poke_url "http://$1/" $1": HTTPS service"
	fi
else
	if [ -z ${WEBDISCOVER_HTTPS_ONLY+x} ]; then
		poke_url "https://$1/"
	fi

	if [ -z ${WEBDISCOVER_HTTP_ONLY+x} ]; then
		poke_url "http://$1/"
	fi
fi

# TODO
# - warnings only
# - SEVERE only (accessable .git)
# - https check only
# - add more service from: apt-file search /etc/apache2/conf-available

SEARCH_PREFIX=()
if [  -z ${WEBDISCOVER_HTTP_ONLY+x} ]; then
	SEARCH_PREFIX+=("")
fi

if [  -z ${WEBDISCOVER_HTTPS_ONLY+x} ]; then
	SEARCH_PREFIX+=("s")
fi


for s in "${SEARCH_PREFIX[@]}"
do
	if [[ " ${FOUND_URL[@]} " =~ "http$s://"$1"/" ]]; then
		if [ ! -z ${WEBDISCOVER_SKIP_BASICS+x} ]; then
			poke_url "http$s://www.$1" $1": WWW subdomain http$s://www.$1/"
		fi

		poke_url "http$s://$ip/" $1": Warning: servicing HTTP$s page on ip address "$ip

		U="http$s://$1"

		poke_url $U"/.git" $1": Warning: unprotected .git folder: http$s://$1/.git"
		poke_url $U"/.git/HEAD" $1": Warning: accessible .git folder: http$s://$1/.git/HEAD"
		poke_url $U"/.env" $1": Warning: unprotected .env file: http$s://$1/.env"
		poke_url $U"/.well-known" $1": Warning: unprotected .well-known directory: http$s://$1/.well-known"

		url_service $U "phpmyadmin" "PhpMyAdmin"
		url_service $U "adminer" "Adminer"
		url_service $U "munin" "Munin"
		url_service $U "server-status" "Apache server status"

		rootfile $U "composer.json"
		rootfile $U "package.json"
		rootfile $U "pom.xml"

		url_service $U "roundcube" "Roundcube"
		url_service $U "rainloop" "Rainloop"

		url_service $U "zabbix" "Zabbix"
		url_service $U "webalizer" "Webalizer"

		check_missing "http$s://$1/robots.txt" $1": missing robots.txt: http$s://$1/robots.txt"
		if [ ! -z ${WEBDISCOVER_EXTENDED+x} ]; then

			poke_url $U"/wp-admin" $1": It's likely be a wordpress site: http$s://$1/wp-admin"
			url_service $U "admin" "Admin"

			url_service $U "berrynet-dashboard" "BerryNet dashboard"
                        url_service $U "cgit" "CGit web interface"

			url_service $U "stacks" "stacks-web"
			url_service $U "usemod-wiki" "usemod-wiki"
			url_service $U "phpliteadmin" "phpliteadmin"
			url_service $U "phppgadmin" "phppgadmin"
			url_service $U "homer" "homer-api"
			url_service $U "spip" "spip"
			url_service $U "emboss-explorer" "emboss-explorer.apache2"
			url_service $U ".well-known/acme-challenge/" "dehydrated"
			url_service $U "ch5m3d" "ch5m3d"
			url_service $U "bandwidthd" "bandwidthd"
			url_service $U "dump1090" "dump1090-mutability"
			url_service $U "jsxgraph" "jsxgraph"
			url_service $U "icingaweb2" "icingaweb2"
			url_service $U "icinga2-classicui" "icinga2-classicui"
			url_service $U "gitweb" "gitweb"
			url_service $U "ntpviz" "ntpsec-ntpviz"
			url_service $U "slbackup-php" "slbackup-php"
			url_service $U "wims" "wims"
			url_service $U "ceph-info" "ceph-info"
			url_service $U "mediawiki" "mediawiki"
			url_service $U "samba-images" "smb2www"
			url_service $U "smokeping" "smokeping"
			url_service $U "cortado" "cortado"
			url_service $U "xymon " "xymon"
			url_service $U "icinga" "icinga"
			url_service $U "movim/" "movim"
			url_service $U "lconline" "linkchecker-web"
			url_service $U "jsMath" "jsmath"
			url_service $U "shibboleth-sp" "shib"
			url_service $U "webapp" "kopano-webapp-apache2"
			url_service $U "nagios4" "nagios4-cgi"
			url_service $U "umegaya" "umegaya"
			url_service $U "umegaya" "umegaya"
			url_service $U "sitesummary" "sitesummary"
			url_service $U "lurker" "lurker"
			url_service $U "w3c-validator" "w3c-markup-validator"
			url_service $U "ocsreports" "ocsinventory-reports"
			url_service $U "download" "ocsinventory-reports"
			url_service $U "snmp" "ocsinventory-reports"
			url_service $U "horde" "php-horde"
			url_service $U "Microsoft-Server-ActiveSync" "php-horde"
			url_service $U "chemical-structures" "chemical-structures"
			url_service $U "Microsoft-Server-ActiveSync" "z-push"
			url_service $U "dwww" "dwww"
			url_service $U "iptotal" "iptotal"
			url_service $U "nagvis" "nagvis"
			url_service $U "mobyle" "mobyle"
			url_service $U "fgb2" "gbrowse"
			url_service $U "fgb2" "gbrowse"
			url_service $U "mgb2" "gbrowse"
			url_service $U "cgi-lurker" "lurker"
			url_service $U "x2gobroker" "x2gobroker-wsgi"
			url_service $U "pywps/wps.py" "pywps-wsgi"
			url_service $U "w3c-linkchecker" "w3c-linkchecker"
			url_service $U "bcfg2" "bcfg2"
			url_service $U "xymon-cgi" "xymon"
			url_service $U "cgi-bin" "serve-cgi-bin"
		fi
	fi
done

