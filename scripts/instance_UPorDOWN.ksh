#!/bin/ksh
#----------------------------------------------------------
# Purpose:To check Instance availability
# If the instance is not running
# check how long the server has been up
# Send a notification to the team that the  instance is down
# The script is scheduled to run every 5mins in cron
#----------------------------------------------------------
#---------------------------------------------------------
# Usage: Scriptname <instance>
#--------------------------------------------------------

set -u 
INSTNAME=$1
 
if [[ $# -ne 1 ]]
then
  echo "You Need to Supply the Instance Name."
  echo "Syntax:  $0 instance  "
  exit 1
fi
 
 
. $HOME/sqllib/db2profile > /dev/null 2>&1
 
INSTCNT=$(whoami|grep $INSTNAME|wc -l)
 
if [[ $INSTCNT -lt 1 ]]
then
echo "The instance $INSTNAME is not valid.Please resubmit command with the current instance name"
exit 4
fi
 
 
TEAMMAIL="eCommDBA@dcsg.com"
RDATE=`date +%m-%d-%y`
STARTDATE=`date +"%A %r %Y-%m-%d"`
SCRIPTLOC=/db2shared/db2scripts/QBSCRIPTS
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
RPTLOC="${SCRIPTLOC}/LOGS/HEALTHLOG"
UPORDWN="${RPTLOC}/InstUpDown.rpt_${INSTNAME}_$RDATE"
#BE=`db2 list db directory|grep Comment|cut -c41-65`
RPT_RETENTION=2
HOSTNM=`hostname`

#++++++++++++++++++++++++++++++++++++++++++++++++ CHECKING FILESYSTEM UTILIZATION. ADDED ON MARCH 31, 2015 +++++++++++
THRESHOLD=80


#mail client
MAIL=/bin/mail

EMAIL=""

# store all disk info here

for line in $(df -hP | egrep '^/dev/' | awk '{ print $6 "_:_" $5 }'|grep -vE 'boot|control')
do

        part=$(echo "$line" | awk -F"_:_" '{ print $1 }')
        part_usage=$(echo "$line" | awk -F"_:_" '{ print $2 }' | cut -d'%' -f1 )

        if [ $part_usage -ge $THRESHOLD -a -z "$EMAIL" ];
        then
                EMAIL="$(date): Filesystem Threshold  Alert on  $HOSTNM\n"
                EMAIL="$EMAIL\n$part ($part_usage%) has breached the  (Threshold = $THRESHOLD%)"

        elif [ $part_usage -ge $THRESHOLD ];
        then
                EMAIL="$EMAIL\n$part ($part_usage%) has breached the  (Threshold = $THRESHOLD%)"
        fi
done

if [ -n "$EMAIL" ];
then
        echo -e "$EMAIL" | $MAIL -s "ATTENCION DBAs! - FILESYSTEM ALERT!: One or more of your filesystems has breached the "$THRESHOLD%" threshold on $SERVERIP - $ENVIRONMENT" "$TEAMMAIL"
fi
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

EMAIL=""

ENGINE_COUNT=`ps -ef | grep $INSTNAME| grep db2sysc | grep -v grep | wc -l`

if [[ $ENGINE_COUNT -gt 0 ]]
then
echo "The instance is alive and kicking.Will check back in 5 mins.See ya!" > /dev/null
exit 0
else
echo "The db2sysc process for $INSTNAME is missing which  implies the  $INSTNAME is down!" > $UPORDWN
OS_UPTIME=`uptime|awk '{print $3" "$4" " $5 "hrs"}'`
echo "Report Timestamp:  $STARTDATE"  >> $UPORDWN
echo " " >> $UPORDWN
echo "Server Availability: The server $HOSTNM has been up and running for $OS_UPTIME " >> $UPORDWN
mailx -s "The $INSTNAME INSTANCE ON $HOSTNM WITH IP ADDRESS $SERVERIP IN $ENVIRONMENT IS DOWN!" ${TEAMMAIL}<${UPORDWN}
fi

exit
