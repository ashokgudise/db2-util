#!/bin/bash
. /home/db2inst1/sqllib/db2profile

RDATE=`date +%m-%d-%y-%H:%M:%S`
LOGLOC=/db2shared/db2scripts/QBSCRIPTS/reports/MON_LOG/
LOGFILE="${LOGLOC}MON_DBLOG_${RDATE}"
LOGPERCENTFILE="${LOGLOC}LOG_PERCENT${RDATE}"
DB=LIVE
DB_USER=$2
DB_PASSWORD=$4
MAX_LOG_PERCENT=50

echo `date` > $LOGFILE
db2 -x "connect to $LIVE_DB user $DB_USER using $DB_PASSWORD" >> $LOGFILE
db2 -x "connect to $DB " >> $LOGFILE
db2 -x "set schema WSCOMUSR" >> $LOGFILE

db2 -x "SELECT CASE (TOTAL_LOG_AVAILABLE) WHEN -1 THEN DEC(-1,5,2) ELSE DEC(100 * (FLOAT(TOTAL_LOG_USED)/FLOAT(TOTAL_LOG_USED + TOTAL_LOG_AVAILABLE)), 5,2) END LOG_UTILIZATION_PERCENT from TABLE(SYSPROC.MON_GET_TRANSACTION_LOG(-2))" > $LOGPERCENTFILE

while read line
do
        echo $line >> $LOGFILE
        result=`echo "if ( $line > $MAX_LOG_PERCENT) 1" | bc`
        if [[ "$result" = 1 ]]; then
                echo " The $DB DB has exceeded log utilization. The current LOG UTILIZATION is : $line"
        exit 0
        else
                echo "The current log utilization is $line percent"
        fi

done < $LOGPERCENTFILE

