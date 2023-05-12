#!/bin/bash

TEAMMAIL="eCommDBA@dcsg.com"
RDATE=`date +%m.%d.%Y-%H.%M.%S`
SERVER=$(hostname)
LOGLOC=/db2shared/db2scripts/QBSCRIPTS/reports/ARCHIVECLEANUP
STARTDATE=`date +"%A %Y-%m-%d %r"`
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
ARCHPRPT="${LOGLOC}/ARCHlog_${SERVERIP}_$RDATE"
ARCHIVELOGLOC=`db2 get db cfg for cve|grep LOGARCHMETH1|awk '{print $7}'|cut -c 6-40`
BACKUP_DIR="/backups/DB2_Online_Backups"
DIAG_PATH="/diagnostic"

BEFORECLEANUP=`df -hP /db2* /backup /diagnostic`


echo " Archive log location utilization before cleanup: $BEFORECLEANUP" > $ARCHPRPT
echo " " >>$ARCHPRPT

# DELETE ALL ARCHIVED LOGS OLDER THAN 2 DAYS
#find  "$ARCHIVELOGLOC"   -name "*.LOG" -mtime 1 -exec rm -f {} \;
#find /data03/db2logs/archivelog/CVE/db2inst1/CVE/NODE0000 -type f  -mtime +2 -exec  rm -f {} \;

# DELETE ALL BACKUPS DIRECTORIES  OLDER THAN 5 DAYS
#find "${BACKUP_DIR}" -type f -mtime 4 |xargs rm -f 


# DELETE ALL FILES IN THE DIAGNOSTIC LOG DIRECTORY  OLDER THAN 30 DAYS

find "${DIAG_PATH}"  -type f -mtime 30 |xargs rm -f


AFTERCLEANUP=`df -hP df -hP /db2* /backup /diagnostic`

echo " " >>$ARCHPRPT
echo "------------------------------------------------------------------------ " >> $ARCHPRPT
echo "Archive log location utilization after  cleanup: $AFTERCLEANUP" >> $ARCHPRPT

ENDDATE=`date +"%A %Y-%m-%d %r"`

##mailx -s " Archivelog location just got cleaned up on SERVER:$SERVER - $ENVIRONMENT - HOSTIP:$SERVERIP on $ENDDATE" ${TEAMMAIL} < ${ARCHPRPT}

exit

