#!/bin/bash

INST=`whoami`
RDATE=`date +%m.%d.%Y-%H.%M.%S`
STARTDATE=`date +"%A %Y-%m-%d %r"`
TEAMMAIL="eCommDBA@dcsg.com"
#TEAMMAIL="sampath.kasireddy@dcsg.com"
NOTIFY_DBA="Y"
SERVER=$(hostname)
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
LOGLOC="/db2shared/db2scripts/QBSCRIPTS/LOGS/BACKUP"
RPTRETENTION=2
BACKUP_DIR="/backup/DB2_Online_Backups"
tdate=`date +%m%d%Y`
## mkdir -p ${BACKUP_DIR}/$tdate
## BACKUP_PATH="${BACKUP_DIR}/$tdate"
BACKUP_PATH="${BACKUP_DIR}"

echo 'Moving older backup'

find /backup/Previous_Online_Backups/LIVE.0.db2inst1.DBPART* -type f |xargs rm -rf
OLD_BACKUP=`find /backup/DB2_Online_Backups/ -type f -name 'LIVE.*' -printf '%p\n'|sort |head -n 6`
mv $OLD_BACKUP /backup/Previous_Online_Backups/.


. $HOME/sqllib/db2profile >/dev/null 2>&1

for DBNAME in `db2 list database directory | awk '{FS="\n";RS=""} /Indirect/ {print $2}' | awk '{print $4}'`;

do

echo "Current Database is $DBNAME"

ERRORFILE="${LOGLOC}/Backup_Err_${INST}_${DBNAME}_$RDATE"
BKPRPT="${LOGLOC}/BackupLog_${INST}_${DBNAME}_$RDATE"
DBFILE="${LOGLOC}/dbszlogfile_${INST}_${DBNAME}_$RDATE"

echo "********************************************************************************" > $BKPRPT

echo "                 $DBNAME DATABASE -  DAILY -  BACKUP -  REPORT " >>  $BKPRPT
echo " " >> $BKPRPT
echo "            REPORT DATE   :  $RDATE" >>  $BKPRPT
echo "            HOSTNAME      :  $HOSTNAME" >>  $BKPRPT
echo "            SERVERIP      :  $SERVERIP" >>  $BKPRPT
echo "            ENVIRONMENT   :  $ENVIRONMENT" >>  $BKPRPT
echo "            DATABASE NAME :  $DBNAME" >>  $BKPRPT
echo "            INSTANCE NAME :  $INST" >>  $BKPRPT
echo "********************************************************************************" >>  $BKPRPT

HADR_DB_STATE=`db2 GET DB CONFIG FOR $DBNAME | grep -ie 'HADR database role' | awk -F'=' '{print $2}'`
# echo $HADR_DB_STATE
if [$HADR_DB_STATE = "STANDBY" ]
then
    exit 0
fi

db2 connect to $DBNAME > /dev/null


echo "backup db $DBNAME  online  to $BACKUP_PATH, $BACKUP_PATH, $BACKUP_PATH, $BACKUP_PATH, $BACKUP_PATH, $BACKUP_PATH with 15 buffers buffer 8192 parallelism 12 include logs without prompting;" > ${LOGLOC}/${DBNAME}_backup.sql
echo "select substr(comment,1,37)COMMAND,timestamp(start_time)START_TIME,timestamp(end_time)END_TIME,substr(location,1,60)location,timestampdiff(4,char(timestamp(end_time)-timestamp(start_time))) as \"Duration(min)\",case when sqlcode is null then 'SUCCESSFUL' else 'FAILED' end as \"BackUpStatus\" from sysibmadm.db_history where operation = 'B' and date(timestamp(end_time)) = current_date order by timestamp(end_time)desc fetch first 1 row only with ur;" > ${LOGLOC}/${DBNAME}_chkbackupstatus.sql

db2 -txf ${LOGLOC}/${DBNAME}_backup.sql  > /dev/null
chmod 644 /backup/DB2_Online_Backups/LIVE*

if [[ $? -ne 0 ]]
 then
  echo "Error occured performing backup for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER -SERVERIP:$SERVERIP on $STARTDATE" >> $ERRORFILE
  mail -s "backup  failed for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER - SERVERIP:$SERVERIP on $STARTDATE" ${TEAMMAIL} < $ERRORFILE
  exit 2
fi

ENDDATE=`date +"%A %Y-%m-%d %r"`

 db2 connect to $DBNAME  > /dev/null
db2 -tf ${LOGLOC}/${DBNAME}_chkbackupstatus.sql|grep -v selected >> ${BKPRPT}

                      echo " "  >> ${BKPRPT}

#---------------------- FETCH DATABASE SIZE ----------------------------------
                      echo " "  >> ${BKPRPT}
                      echo " "  >> ${BKPRPT}
echo " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> ${BKPRPT}
echo "                         DATABASE SIZE INFORMATION                                 " >> ${BKPRPT}
echo " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> ${BKPRPT}

#db2  "CALL GET_DBSIZE_INFO(?, ?, ?, 0)"|head -12|tail -6|awk '{print $4}' >> ${BKPRPT}
db2  "CALL GET_DBSIZE_INFO(?, ?, ?, 0)" > ${DBFILE}

  CSZE=`cat $DBFILE|tail -3|head -1 |awk '{print $4}'`
  ASZE=`cat $DBFILE|tail -6|head -1 |awk '{print $4}'`

  CSZE_MB=`expr $CSZE \/ 1024 \/ 1024`
  ASZE_GB=`expr $ASZE \/ 1024 \/ 1024 \/ 1024`
  ASZE_MB=`expr $ASZE \/ 1024 \/ 1024`

  echo " " >> ${BKPRPT}
  echo "DATABASESIZE(GB)      : $ASZE_GB"  >> ${BKPRPT}
  echo "DATABASESIZE(MB)      : $ASZE_MB"  >> ${BKPRPT}
           echo " "  >> ${BKPRPT}
  echo "DATABASECAPACITY(MB)  : $CSZE_MB"  >> ${BKPRPT}

# ------------------------ END OF DATABASE SIZE MODULE --------------------------

                   if [ "$NOTIFY_DBA" = "Y" ]
                     then
                                 mail -s "Backup Completed successfully for database $DBNAME on host $SERVER - SERVERIP:$SERVERIP at $ENDDATE" $TEAMMAIL < $BKPRPT

              else
                                echo "Backup completed successfully but no nofitication was sent out" > /dev/null
            fi

db2 connect reset > /dev/null
db2 terminate  > /dev/null

## the following three lines added for the rubrik backup program
rm  /backup/DB2_Online_Backups/enddate_*
now=$(date +"%A_%Y-%m-%d_%r" )
echo $now >  "/backup/DB2_Online_Backups/enddate_$now"
##


find ${LOGLOC}  -name "BackupLog*"  -type f  -mtime +$RPTRETENTION  -exec rm -f {} \;
find ${LOGLOC}  -name "Backup_Err*" -type f  -mtime +$RPTRETENTION  -exec rm -f {} \;
find ${LOGLOC}  -name "dbszlogfile*"  -type f  -mtime +$RPTRETENTION  -exec rm -f {} \;
find ${LOGLOC}  -name "*.sql"  -type f  -mtime +$RPTRETENTION  -exec rm -f {} \;

done
#------------------------------------------------------------------------------------------------------------------------
# ARCHIVE DB2 DIAGNOSTIC LOG. This is not related to the backup. Just a housekeeping Job, that can be done from any script
##db2diag -A > /dev/null
##logrotate /db2shared/db2scripts/QBSCRIPTS/logrotate.conf
exit

