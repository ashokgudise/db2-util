#!/bin/bash
set -u

INST=`whoami`
TEAMMAIL="eCommDBA@dcsg.com"
RDATE=`date +%m.%d.%Y-%H.%M.%S`
SERVER=$(hostname)
LOGLOC=/db2shared/db2scripts/QBSCRIPTS/reports/REBIND
STARTDATE=`date +"%A %Y-%m-%d %r"`
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
RPTRETENTION=2


. $HOME/sqllib/db2profile >/dev/null 2>&1

for DBNAME in `db2 list database directory | awk '{FS="\n";RS=""} /Indirect/ {print $2}' | awk '{print $4}'`;

do

echo "Current Database is $DBNAME"


done

exit 0
