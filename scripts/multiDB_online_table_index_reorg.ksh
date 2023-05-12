#!/bin/bash
set -u

INST=`whoami`
TEAMMAIL="eCommDBA@dcsg.com"
RDATE=`date +%m.%d.%Y-%H.%M.%S`
SERVER=$(hostname)
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
LOGLOC=/db2shared/db2scripts/QBSCRIPTS/reports/REORG
STARTDATE=`date +"%A %Y-%m-%d %r"`
RPTRETENTION=2

. $HOME/sqllib/db2profile >/dev/null 2>&1


exit

