#!/bin/bash
set -u

INST=`whoami`
TEAMMAIL="dba@dcsg.com"
RDATE=`date +%m-%d-%y-%H:%M:%S`
SERVER=$(hostname)
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
LOGLOC=/data02/db2scripts/QBSCRIPTS/reports/REORG
STARTDATE=`date +"%A %Y-%m-%d %r"`
RPTRETENTION=2

. $HOME/sqllib/db2profile >/dev/null 2>&1

for DBNAME in `db2 list database directory | awk '{FS="\n";RS=""} /Indirect/ {print $2}' | awk '{print $4}'`; do

echo "Current Database is $DBNAME"

ERRORFILE="${LOGLOC}/Reorg_Err_${INST}_${DBNAME}_${RDATE}"
RPTFILE="${LOGLOC}/ReorgLog_${INST}_${DBNAME}_${RDATE}"
INDX_FLAGGED_MSG="${LOGLOC}/flagged_indexes_${INST}_${DBNAME}_${RDATE}"
TBLS_FLAGGED_MSG="${LOGLOC}/flagged_tables_${INST}_${DBNAME}_${RDATE}"

echo "********************************************************************************" > $RPTFILE

echo "                 $DBNAME DATABASE -  DAILY -  ONLINE TABLE/INDEX REORG -  REPORT " >>   $RPTFILE
echo " " >> $RPTFILE
echo "            REPORT DATE   :  $RDATE" >>  $RPTFILE
echo "            HOSTNAME      :  $HOSTNAME" >>  $RPTFILE
echo "            SERVERIP      :  $SERVERIP" >>  $RPTFILE
echo "            ENVIRONMENT   :  $ENVIRONMENT" >> $RPTFILE
echo "            DATABASE NAME :  $DBNAME" >>  $RPTFILE
echo "            INSTANCE NAME :  $INST" >>  $RPTFILE
echo "********************************************************************************" >> $RPTFILE
echo " " >> $RPTFILE

db2 connect to $DBNAME > /dev/null

db2 "CALL REORGCHK_TB_STATS('T','ALL')" > /dev/null ## returns a result set containing table statistics that indicate whether or not there is a need for reorganization - data is session persistent

db2 -x "SELECT * FROM SESSION.TB_STATS WHERE REORG LIKE '%*%'" |grep -v SYSIBM| grep -v TI_ | awk '{print "REORG TABLE" " " $1"."$2 " " "INPLACE ALLOW WRITE ACCESS NOTRUNCATE TABLE;"}' > ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_Reorg_Tables_Inplace.sql1 
     sort -u ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_Reorg_Tables_Inplace.sql1 > ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_Reorg_Tables_Inplace.sql

db2 "CALL REORGCHK_IX_STATS('T','ALL')" > /dev/null   ## returns a session-wide result set containing index statistics that indicate whether or not there is a need for reorganization

db2 -x "SELECT * FROM SESSION.IX_STATS WHERE REORG LIKE '%*%'" |grep -v SYSIBM| grep -v TI_ |awk '{print "REORG INDEXES ALL FOR TABLE" " " $1"."$2 " " "ALLOW WRITE ACCESS;"}' > ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_Reorg_Indexes.sql1
     sort -u ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_Reorg_Indexes.sql1 > ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_Reorg_Indexes.sql
	 
if [[ ! -s  ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_Reorg_Tables_Inplace.sql ]]; then
   echo "No table selected for  reorg today $STARTDATE - $SERVER:$INST:$DBNAME " > ${TBLS_FLAGGED_MSG}
   mailx -s "No tables  were marked for reorg for  INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $STARTDATE " ${TEAMMAIL} < ${TBLS_FLAGGED_MSG}

else echo "Online Table Reorg started for qualified tables for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER  on $STARTDATE " >>$RPTFILE
db2 -tvf  ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_Reorg_Tables_Inplace.sql  -z ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_online_table_reorg.out

if [[ $? -ne 0 ]]
 then
echo "The error code was $? " >> $ERRORFILE
 echo "Error occured performing Inplace Table  Reorg for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $STARTDATE" >> $ERRORFILE
  mailx -s "Inplace table reorg failed for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $STARTDATE" ${TEAMMAIL} < $ERRORFILE
fi
ENDDATE=`date +"%A %Y-%m-%d %r"`
echo "Online Table  Reorg completed for selected tables for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $ENDDATE" >>$RPTFILE
fi
echo " " >> $RPTFILE
if [[ ! -s  ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_Reorg_Indexes.sql ]]; then
   echo "No index was selected for reorg today $STARTDATE - $SERVER:$INST:$DBNAME  " > ${INDX_FLAGGED_MSG}
   mailx -s "No Indexes were marked for reorg for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $STARTDATE " ${TEAMMAIL} < ${INDX_FLAGGED_MSG}

else echo "Online Index Reorg started for qualified indexes for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER  on $STARTDATE " >>$RPTFILE
db2 -tvf  ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_Reorg_Indexes.sql  -z ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_online_index_reorg.txt

if [[ $? -ne 0 ]]
then
echo "The error code was $? " >> $ERRORFILE
echo "Error occured performing Online Index  Reorg for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $STARTDATE" >> $ERRORFILE
  mailx -s "Index  reorg failed for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $STARTDATE" ${TEAMMAIL} < $ERRORFILE
fi
ENDDATE=`date +"%A %Y-%m-%d %r"`
echo " Online Index Reorg completed for qualified indexes for INSTANCE:$INST -  DATABASE:$DBNAME -  SERVER:$SERVER on $ENDDATE" >>$RPTFILE
 mailx -s "Online Table and Index Reorg completed for   INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $STARTDATE" ${TEAMMAIL} < $RPTFILE
fi

find ${LOGLOC}  -name "ReorgLog_*" -type f  -mtime $RPTRETENTION  -exec rm -f {} \;
find ${LOGLOC}  -name "flagged_indexes_*" -type f  -mtime $RPTRETENTION  -exec rm -f {} \;
find ${LOGLOC}  -name "flagged_tables_*" -type f -mtime $RPTRETENTION  -exec rm -f {} \;
find ${LOGLOC}  -name "Reorg_Err_*" -type f  -mtime $RPTRETENTION  -exec rm -f {} \;
find ${LOGLOC}  -name "online_table_reorg.out" -type f -mtime $RPTRETENTION  -exec rm -f {} \;

db2 connect reset > /dev/null

done

exit

