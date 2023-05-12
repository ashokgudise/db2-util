#!/bin/ksh


DBNAME=$1
typeset -u DBNAME
LONGAPP_IDLE_TIME=300
TOADAPP_IDLE_TIME=3600
INST=`whoami`
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
typeset -u INST
TEAMMAIL="eCommDBA@dcsg.com"
RDATE=`date +%m-%d-%y`
STARTDATE=`date +"%A %r %Y-%m-%d"`
HOSTNM=`hostname`


if [[ $# -ne 1 ]]
then
  echo "You Need to Supply the Database Name."
  echo "Syntax:  $0  dbname "
  exit 1
fi

. $HOME/sqllib/db2profile >/dev/null 2>&1

DBFOUND=$(db2 list database directory |grep "Database alias"|cut -d'=' -f2|grep -cwi "$DBNAME")

if [[ $DBFOUND -lt 1 ]]
then
   echo "The database $DBNAME you supplied was not found.Please verify database name  and reissue command"
   exit 2
fi



db2 connect to $1 > /dev/null
            if [[ $? -ne 0 ]]
            then
               echo "Connection to $1 failed !" > /dev/null
fi

echo "IF LONGAPP APPLICATION IS EXECUTING FOR MORE THAN 5 MINS AND THE AUTHID IS NOT DB2 INSTANCE KILL THE APPLICATIONS" > /dev/null

db2 -x "select substr(A.db_name,1,10)dbname,A.agent_id,substr(B.AUTHID,1,10)authid,A.appl_idle_time,A.locks_held,substr(B.appl_name,1,20)applname,B.appl_status from SYSIBMADM.SNAPAPPL A,SYSIBMADM.APPLICATIONS B where A.agent_id=B.agent_id and B.appl_name in ('db2jcc_application','java.exe') and B.appl_status='UOWEXEC' and B.authid<>'$INST' and A.appl_idle_time>$LONGAPP_IDLE_TIME"|awk '{print $2}' |while read REALAPPID
do
#db2 "force application ($REALAPPID)"
#mailx -s "Application $REALAPPID has been running longer than 5 mins on $SERVERIP - $ENVIRONMENT" ${TEAMMAIL}
done

echo "IF LONGAPP CONNECTION IS IDLE AND IT'S HOLDING A LOCK AND IT'S RUNNING FOR LONGER THAN 60  MINS KILL IT" > /dev/null

db2 -x "select substr(A.db_name,1,10)dbname,A.agent_id,substr(B.AUTHID,1,10)authid,A.appl_idle_time,A.locks_held,substr(B.appl_name,1,20)applname,B.appl_status from SYSIBMADM.SNAPAPPL A,SYSIBMADM.APPLICATIONS B where A.agent_id =B.agent_id and B.appl_name in ('Toad.exe','toad.exe') and B.appl_status = 'UOWWAIT' and A.locks_held>=0 and  B.authid<>'$INST' and A.appl_idle_time>$TOADAPP_IDLE_TIME"|awk '{print $2}' |while read TOADAPPID
do
db2 "force application ($TOADAPPID)"
mailx -s "Toad application with application $APPID has been running longer than 60 mins on $SERVERIP - $ENVIRONMENT so it was killed " ${TEAMMAIL}
done
db2 connect reset
exit

