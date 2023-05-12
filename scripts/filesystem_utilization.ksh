#!/bin/bash

TEAMMAIL="eCommDBA@dcsg.com"
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
THRESHOLD=30

HOSTNAME=$(hostname)

 . $HOME/sqllib/db2profile >/dev/null 2>&1

#mail client
MAIL=/bin/mail

EMAIL=""

# store all disk info here

for line in $(df -hP | egrep '^/dev/' | awk '{ print $6 "_:_" $5 }'|grep -vE 'boot|control|usr')
do

	part=$(echo "$line" | awk -F"_:_" '{ print $1 }')
	part_usage=$(echo "$line" | awk -F"_:_" '{ print $2 }' | cut -d'%' -f1 )

	if [ $part_usage -ge $THRESHOLD -a -z "$EMAIL" ];
	then
		EMAIL="$(date): Filesystem Threshold  Alert on  $HOSTNAME\n"
		EMAIL="$EMAIL\n$part ($part_usage%) has breached the  (Threshold = $THRESHOLD%)"
		echo "$part ($part_usage%) has breached the  (Threshold = $THRESHOLD%)"
	elif [ $part_usage -ge $THRESHOLD ];
	then
		EMAIL="$EMAIL\n$part ($part_usage%) has breached the  (Threshold = $THRESHOLD%)"
		echo "$part ($part_usage%) has breached the  (Threshold = $THRESHOLD%)"
	fi
done 

if [ -n "$EMAIL" ];
then
	echo -e "$EMAIL" | $MAIL -s "ATTENTION DBAs! - FILESYSTEM ALERT!: One or more of your filesystems has breached the "$THRESHOLD%" threshold on $SERVERIP - $ENVIRONMENT" "$TEAMMAIL"
fi

