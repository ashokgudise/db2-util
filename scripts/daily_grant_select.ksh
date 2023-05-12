#!/bin/bash
set -u 

if [[ $# -ne 1 ]]
then
  echo "You Need to Supply the DB Group Name."
  echo "Syntax:  $0  DBGROUP "
  exit 1
fi

set -x
DBGROUP=$1

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

db2 -x "select tabname from syscat.tables where tabschema='WSCOMUSR' with ur" | awk '{print $1}' > tables.txt
while read LINE; do
  db2 "grant select on table wscomusr.${LINE} to group $DBGROUP"
done < tables.txt
rm tables.txt
db2 terminate
exit 0
