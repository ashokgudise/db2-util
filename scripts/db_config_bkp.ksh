
#!/bin/bash

INST=`whoami`
RDATE=`date +%m.%d.%Y-%H.%M.%S`
STARTDATE=`date +"%A %Y-%m-%d %r"`
TEAMMAIL="eCommDBA@dcsg.com"
SERVER=$(hostname)
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
LOGLOC="/db2shared/db2scripts/QBSCRIPTS/LOGS/BACKUP"
RPTRETENTION=2
CFGBACKUP_DIR="/db2shared/db2scripts/QBSCRIPTS/reports/DB_DBM_CFG_BKP"
tdate=`date +%m%d%Y`
mkdir -p ${CFGBACKUP_DIR}/$tdate
CFGBACKUP_PATH="${CFGBACKUP_DIR}/$tdate"



. $HOME/sqllib/db2profile >/dev/null 2>&1

for DBNAME in `db2 list database directory | awk '{FS="\n";RS=""} /Indirect/ {print $2}' | awk '{print $4}'`;

do

echo "Current Database is $DBNAME" 

#CFGBKPRPT="${LOGLOC}/BackupLog_${INST}_${DBNAME}_$RDATE"

db2 connect to $DBNAME > /dev/null

cd $CFGBACKUP_PATH

 db2 "select substr(REG_VAR_NAME,1,20) REG_VAR_NAME, substr(REG_VAR_VALUE,1,40)EG_VAR_VALUE, IS_AGGREGATE, substr(AGGREGATE_NAME,1,20)AGGREGATE_NAME,level from SYSIBMADM.reg_variables" > $INST.$DBNAME.out

 db2 "select substr(NAME,1,30)NAME, substr(VALUE,1,60) VALUE, substr(VALUE_FLAGS,1,10)VALUE_FLAGS, substr(DEFERRED_VALUE_FLAGS,1,10)DEFERRED_VALUE_FLAGS from SYSIBMADM.dbcfg" >>$INST.$DBNAME.out 

 db2 "select substr(NAME,1,30)NAME, substr(VALUE,1,60) VALUE, substr(VALUE_FLAGS,1,10)VALUE_FLAGS, substr(DEFERRED_VALUE_FLAGS,1,10)DEFERRED_VALUE_FLAGS from SYSIBMADM.dbmcfg" >> $INST.$DBNAME.out

 db2 "select substr(B.bpname,1,15) bpname,substr(A.tbspace,1,15)tbspace,A.bufferpoolid, B.npages, B.pagesize from syscat.tablespaces A, syscat.bufferpools B  where A.bufferpoolid = B.bufferpoolid order by 1" >> $INST.$DBNAME.out

db2 connect reset > /dev/null
db2 terminate  > /dev/null

#find ${LOGLOC}  -name "BackupLog*"  -type f  -mtime +$RPTRETENTION  -exec rm -f {} \;
#find ${LOGLOC}  -name "Backup_Err*" -type f  -mtime +$RPTRETENTION  -exec rm -f {} \;
#find ${LOGLOC}  -name "dbszlogfile*"  -type f  -mtime +$RPTRETENTION  -exec rm -f {} \;
#find ${LOGLOC}  -name "*.sql"  -type f  -mtime +$RPTRETENTION  -exec rm -f {} \;

#find "$CFGBKPRPT"  -type f  -mtime +3  -exec rm -f {} \;
done

exit
