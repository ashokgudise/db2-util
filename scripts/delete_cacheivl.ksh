#!/bin/ksh

. $HOME/sqllib/db2profile >/dev/null 2>&1

#for DBNAME in `db2 list database directory | awk '{FS="\n";RS=""} /Indirect/ {print $2}' | awk '{print $4}'`;

#do

#echo "Current Database is $DBNAME"


db2 connect to live > /dev/null


#TOTAL_NUM_TO_DELETE=`db2 -x "select count(INSERTTIME) count from wscomusr.cacheivl where INSERTTIME < (current date - 1 DAYS) with ur"`
TOTAL_NUM_TO_DELETE=`db2 -x "select count(INSERTTIME) count from wscomusr.cacheivl where INSERTTIME < (current timestamp - 1 HOURS) with ur"`

COMMITCOUNT=5000

DELETED=0

DB2STATUS=0



while [[ $DELETED -lt $TOTAL_NUM_TO_DELETE ]] && [[ $DBSTATUS -eq 0 ]]

do


#db2 "delete from  wscomusr.cacheivl where INSERTTIME in (select  INSERTTIME from wscomusr.cacheivl where INSERTTIME < (current date - 1 DAYS)  fetch first 50000  rows only with ur)"
db2 "delete from  wscomusr.cacheivl where INSERTTIME in (select  INSERTTIME from wscomusr.cacheivl where INSERTTIME < (current timestamp - 1 HOURS) fetch first 5000  rows only with ur)"

DB2STATUS=$?

DELETED=$DELETED+$COMMITCOUNT

done

db2 connect reset

exit

