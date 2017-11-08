#!/bin/bash
#
# Daemon skeleton <Description>
#
# chkconfig: 2345 20 80
# description: <description>
# processname: <name>
# pidfile: <pid_file_location>

# read hat init script function library.
. /etc/init.d/functions

############################################
#
# Define the following constant variables
# to make this daemon script usable
#
############################################

# the command to execute (as a daemon)
CMD=''
# name of the daemon
NAME=""
# user
USR=""

if [ -z $CMD ]; then 
	echo "define command to execute!"
	exit 2
fi 

if [ -z $NAME ]; then 
	echo "define name of the daemon!"
	exit 3
fi 

if [ -z $USR ]; then 
	echo "define user which executes the daemon!"
	exit 4
fi

PIDFILE=/var/run/$NAME.pid
LOGFILE=/var/log/$NAME.log
#LOGFILEBAK=/var/log/$NAME.log.bak



start() {
		echo -n $"Starting $NAME: "
		if [ -e /var/lock/subsys/$NAME ]; then
			if [ -e $PIDFILE ] && [ -e /proc/$(cat $PIDFILE) ]; then
				echo -n $"$NAME is already running.";
				failure $"$NAME is already running.";
				echo
				return 1
			fi
		fi

		# backup current logfile before creating a new one
		# if [ -e $LOGFILE ]; then
			# mv $LOGFILE $LOGFILEBAK
		# fi

		touch $LOGFILE
		chown $USR $LOGFILE
		daemon --user=$USR --pidfile=$PIDFILE "$CMD >> $LOGFILE 2>&1 &"
		RETVAL=$?
		sleep 1
		pid=`ps aux | grep "$CMD" | grep -v grep | awk '{print $2}'`
		echo $pid > $PIDFILE
		echo
		[ $RETVAL -eq 0 ] && touch /var/lock/subsys/$NAME;
		return $RETVAL
}

stop() {
		echo -n $"Stopping $NAME: "
		if [ ! -e /var/lock/subsys/$NAME ]; then
			echo -n $"$NAME is not running."
			failure $"$NAME is not running."
			echo
			return 1;
		fi
		killproc -p $PIDFILE
		RETVAL=$?
		echo
		[ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/$NAME;
		return $RETVAL
}

rhstatus() {
		status -p $PIDFILE $NAME
}

restart() {
		stop
		start
}

case "$1" in
start)
		start
		;;
stop)
		stop
		;;
restart)
		restart
		;;
status)
		rhstatus
		;;
*)
		echo $"Usage: $0 {start|stop|status|restart}"
		exit 1
esac
