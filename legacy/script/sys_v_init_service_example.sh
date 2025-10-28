#!/bin/bash

# Dankó Dávid
set -e # exits when any command exits with non-zero

# Name of service, this is used to create a pid file for the service
# Replce with your service name, use C language variable friendly name.
NAME=my_service

# Location of the pid file. If the target process designed to run in daemon
# mode and creates a pid file for it's own, specify that path, otherwise
# let unchanged.

PIDFILE=/var/run/$NAME.pid

# path of the process to run
DAEMON=/bin/false

# options of the daemon process
DAEMON_OPTS=""

# user of the process we like to run in.
USER=UNIX_SYSTEM_USER

# group of the process we like to run in.
GROUP=UNIX_SYSTEM_GROUP

# The daemon's working directory.
WORKING_DIRECTORY=/

# Is the process deamonize itself for it's own.
# A traditional daemon process forks itself and also creates pid file for it's
# own. In this case modify to `false`
#
# If you like to run a non traditional process as daemon turn this to `true`.
# In this case we daemonize the process and create a pid file for it.
FORK=true

# You can also add extra envrionment variables before you start the service
export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"
 
case "$1" in
start)
echo -n "Starting service: "$NAME
if $FORK ; then
	start-stop-daemon --start --quiet --pidfile $PIDFILE -d $WORKING_DIRECTORY --chuid $USER:$GROUP --make-pidfile --background --exec $DAEMON -- $DAEMON_OPTS
else
	start-stop-daemon --start --quiet --pidfile $PIDFILE -d $WORKING_DIRECTORY --chuid $USER:$GROUP --exec $DAEMON -- $DAEMON_OPTS
fi
echo "" # in case when daemon process doesn't send new line before daemonize,
# This just makes `scriptfile start` looks not broken
;;
stop)
echo -n "Shutting down service: "$NAME

#we send shutdown signal
start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE
pid=$(cat $PIDFILE) 
dexe=$(readlink -f $DAEMON)
for (( i=0; i<=51; i++ )) 
do
	#retuns empty string when it doesn't run anymore 
	cexe=$(readlink -f /proc/$pid/exe || true)
	if [ "$cexe" != "$dexe" ]
	then
		break
	fi

	echo -en ". "

	# you can adjust number of retries here
	if [ "$i" == "51" ]
	then
		# run out of time... no mercy, killin' it.
		exit "Termination patience ran out. Killing process."
		kill -9 $pid
	fi

	sleep 0.3
done
echo ""
;;
restart)
echo "Restarting service: "$NAME
	$0 stop
	$0 start
echo "."
;;

# Usually when a daemon process gets a HUP signal it means that it should reload
# it's configuration. Non daemon processes might not install this singal handler
# that cause to terminate the process as a default action. In this case comment
# out this `reload` case.
#reload)
#echo -n "Reloading service: "$NAME
#start-stop-daemon --stop --signal HUP --quiet --pidfile $PIDFILE --exec $DAEMON
#echo "."
#;;

*)
echo "Usage: "$1" {start|stop|restart|reload}"
exit 1
esac
 
exit 0

