#!/bin/bash
set -u 
#-----------------------------------------------------------------------------------------------
# Runstats is run after a reorg or index build to update the database statistics. 
# The optimizer uses the updated statistic to decide the best path to use for a database query
#--------------------------------------------------------------------------------------------------
# Usage: Enter the scriptname and database name
# Example  all_tables_runstats.ksh  sample
#-------------------------------------------------
if [[ $# -ne 1 ]]
then
  echo "You Need to Supply the Database Name."
  echo "Syntax:  $0  dbname "
  exit 1
fi

set -x
DBNAME=$1
INST=`whoami`
TEAMMAIL="eCommDBA@dcsg.com"
RDATE=`date +%m.%d.%Y-%H.%M.%S`
SERVER=$(hostname)
LOGLOC=/db2shared/db2scripts/QBSCRIPTS/reports/RUNSTATS
ERRORFILE="${LOGLOC}/Runstats_Err_${INST}_${DBNAME}_$RDATE"
RPTFILE="${LOGLOC}/RunstatsLog_${INST}_${DBNAME}_$RDATE"
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
#REORGSTATUSCHK="${LOGLOC}/reorgstillrunning_${INST}_${DBNAME}_$RDATE"
STARTDATE=`date +"%A %Y-%m-%d %r"`
RPTRETENTION=2

. $HOME/sqllib/db2profile >/dev/null 2>&1


DBFOUND=$(db2 list database directory |grep "Database alias"|cut -d'=' -f2|grep -cwi "$DBNAME")


if [[ $DBFOUND -lt 1 ]]
then
   echo "The database $1 was not found.Please verify database name  and reissue command"
   exit 4
fi


db2 connect to $DBNAME > /dev/null
            if [[ $? -ne 0 ]]
            then
               echo "Failure to make a connection to $DBNAME to perform a reorg" > $ERRORFILE
mailx -s "Database Connection failed for   $DBNAME  on $SERVER to perform a runstats" ${TEAMMAIL}<${ERRORFILE}
               exit 1
            fi




##------------- CHECK IF REORG IS STILL RUNNING.IF REORG IS STILL RUNNING, CHECK BACK IN 30MINS  TIME -------

REORGSTATUS=$(ps -eaf |grep "multiDB_online_table_index_reorg.ksh "|grep -v grep|wc -l)
while [[ $REORGSTATUS -ne 0 ]]
do
#echo "Reorg is still running.Will check back in 30 mins time" >$RPTFILE
sleep 1800
REORGSTATUS=$(ps -eaf |grep "multiDB_online_table_index_reorg.ksh "|grep -v grep|wc -l)
done

echo "********************************************************************************" > $RPTFILE

echo "                 $DBNAME DATABASE -  DAILY -  RUNSTATS -  REPORT " >>  $RPTFILE
echo " " >> $RPTFILE
echo "            REPORT DATE   :  $RDATE" >>  $RPTFILE
echo "            HOSTNAME      :  $HOSTNAME" >>  $RPTFILE
echo "            SERVERIP      :  $SERVERIP" >>  $RPTFILE
echo "            ENVIRONMENT   :  $ENVIRONMENT" >> $RPTFILE
echo "            DATABASE NAME :  $DBNAME" >>  $RPTFILE
echo "            INSTANCE NAME :  $INST" >>  $RPTFILE
echo "********************************************************************************" >> $RPTFILE
echo " " >> $RPTFILE

db2 -x "SELECT 'RUNSTATS ON TABLE '||RTRIM(TABSCHEMA)||'.'||TABNAME||' ON ALL COLUMNS WITH DISTRIBUTION AND DETAILED INDEXES ALL ALLOW WRITE ACCESS;' FROM SYSCAT.TABLES WHERE TYPE='T' " > ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_all_tables_runstats.sql

echo "Runstats started for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER  on $STARTDATE " >>$RPTFILE

db2 -tvf   ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_all_tables_runstats.sql  >  ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_all_tables_runstats.out


if [[ $? -ne 0 ]]
 then
   echo "The return code was $? ">> $ERRORFILE
  echo "Warnings or Errors  occured performing runstats for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $STARTDATE" >> $ERRORFILE
  grep -A 1 -B 1 SQL ${LOGLOC}/${INST}_${DBNAME}_${RDATE}_all_tables_runstats.out >> $ERRORFILE
  mailx -s "runstats output contain errors or  warning for some tables. Please verify.  $ENVIRONMENT for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $STARTDATE" ${TEAMMAIL} < $ERRORFILE
  echo $ERRORFILE
  fi

ENDDATE=`date +"%A %Y-%m-%d %r"`
echo "Runstats completed in $ENVIRONMENT  for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $ENDDATE" >>$RPTFILE
## mailx -s "runstats completed in $ENVIRONMENT  for INSTANCE:$INST - DATABASE:$DBNAME - SERVERIP:$SERVERIP on $STARTDATE" ${TEAMMAIL} < $RPTFILE

find ${LOGLOC}  -name "RunstatsLog_${INST}*"  -type f -mtime $RPTRETENTION  -exec rm -f {} \;
find ${LOGLOC}  -name "Runstats_Err_${INST}*" -type f -mtime $RPTRETENTION  -exec rm -f {} \;
find ${LOGLOC}  -name "*.out"  -type f -mtime $RPTRETENTION  -exec rm -f {} \;

db2 connect reset > /dev/null
db2 terminate > /dev/null

exit 0
