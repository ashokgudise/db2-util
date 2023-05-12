#!/bin/ksh
##if [[ $# -ne 1 ]]
##then
##  echo "You Need to Supply the Database Name."
##  echo "Syntax:  $0  dbname "
##  exit 1
##fi

##DBNAME=$1
DBNAME=LIVE
typeset -u DBNAME

RDATE=`date +%Y%m%d%H%M%S`
INST=`whoami`
typeset -u INST
LOGLOC=/db2shared/db2scripts/QBSCRIPTS/LOGS/CHECKLOG
ERRORFILE=${LOGLOC}/HlthLogErr_${DBNAME}_$RDATE.LOG
RPTSQL=${LOGLOC}/MonSQLLog_${DBNAME}_$RDATE.LOG
RPTSnap=${LOGLOC}/SnapLog_${DBNAME}_$RDATE.LOG
DIAGFILE=${LOGLOC}/Diaglog_${DBNAME}_$RDATE.LOG
DBFILE="${LOGLOC}/dbszlogfile_${INST}_${DBNAME}_$RDATE"
RETENTION=30
SERVERIP=`hostname --ip-address`
HENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
HOSTNAME=`hostname`
typeset -u HOSTNAME
DBL=`db2ls|tail -1|awk '{print $2}'`
OSL=`cat /etc/redhat-release`
LOGFILE=${LOGLOC}/HlthLog_${DBNAME}_$RDATE.LOG
DAY=`date '+%A'`  # Set variable DAY equal to day of week
DATE=`date '+%x'` # Set variable DATE equal to date representation
TIME=`date '+%T'` # Set variable TIME equal to time representation
TEAMMAIL="eCommDBA@dcsg.com"

##if [[ $# -ne 1 ]]
##then
##  echo "You Need to Supply the Database Name."
##  echo "Syntax:  $0  dbname "
##  exit 1
##fi

. $HOME/sqllib/db2profile >/dev/null 2>&1


## DBFOUND=$(db2 list database directory |grep "Database alias"|cut -d'=' -f2|grep -cwi "$DBNAME")


##if [[ $DBFOUND -lt 1 ]]
##then
##   echo "The database $DBNAME was not found.Please verify database name  and reissue command" 
##   exit 4
##fi

##db2 connect to $1 > /dev/null
db2 connect to $DBNAME > /dev/null
    if [[ $? -ne 0 ]]
then
        echo "Failure to make a connection to $1" >> $LOGFILE
    fi

DBSIZEHIST=${LOGLOC}/DBsizehist_${DBNAME}_$RDATE.LOG

################################################

echo "********************************************************************************" >> $LOGFILE

echo "                DATABASE -  DAILY -  HEALTH -  REPORT FOR $DBNAME" >> $LOGFILE
echo " " >> $LOGFILE
echo "            REPORT DATE   :  $DATE $TIME" >> $LOGFILE
echo "            HOSTNAME      :  $HOSTNAME" >> $LOGFILE
echo "            SERVERIP      :  $SERVERIP" >> $LOGFILE
echo "            ENVIRONMENT   :  $HENVIRONMENT" >> $LOGFILE
echo "            DATABASE NAME :  $DBNAME" >> $LOGFILE
echo "            INSTANCE NAME :  $INST" >> $LOGFILE
echo "            DATABASE LEVEL:  $DBL" >> $LOGFILE
echo "            OS LEVEL      :  $OSL" >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE

echo "********************************************************************************" >> $LOGFILE
echo "SECTION A: OS STATS" >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE


echo "[ OS UPTIME ]" >> $LOGFILE
OS_UPTIME=`uptime|awk '{print $3" "$4}'`
OS_UPTIME1=`uptime|awk '{print $5}'|awk -F, '{print $1}'`
echo "$OS_UPTIME $OS_UPTIME1 hrs" >> $LOGFILE

echo " " >> $LOGFILE
echo "[ CURRENT CPU USAGE ]" >> $LOGFILE

ccpu1=`sar|tail -3|head -1|awk '{print $4}'`
ccpu2=`sar|tail -3|head -1|awk '{print $6}'`
ccpu3=`sar|tail -3|head -1|awk '{print $7}'`
ccpu4=`sar|tail -3|head -1|awk '{print $9}'`


echo "%user = $ccpu1, %system = $ccpu2, %iowait = $ccpu3, %idle = $ccpu4" >> $LOGFILE

echo " " >> $LOGFILE
echo "[ AVG CPU UTILIZATION ] " >> $LOGFILE

acpu1=`iostat -c |tail -2|awk '{print $1}'`
acpu2=`iostat -c |tail -2|awk '{print $3}'`
acpu3=`iostat -c |tail -2|awk '{print $6}'`

echo "%user = $acpu1, %system = $acpu2, %idle = $acpu3" >> $LOGFILE

echo " " >> $LOGFILE
echo "[ PHYSICAL MEMORY(KB) ] " >> $LOGFILE

cat /proc/meminfo   |head -2 >> $LOGFILE

echo " " >> $LOGFILE
echo "[ SWAP SPACE ] " >> $LOGFILE

swapon -s >> $LOGFILE

echo " " >> $LOGFILE
echo "[ DEFUNCT PROCESSES ]" >> $LOGFILE
echo " " >> $LOGFILE

DEFPRS=`ps -aef|grep defunct|grep -v grep|wc -l`

if [[ $DEFPRS -gt 0 ]]
 then
    echo "# Of Defunct Processes = $DEFPRS" >> $LOGFILE
    ps -aef|grep defunct|grep -v grep >> $LOGFILE
 else
    echo "  No Defunct or Zombie Process Found " >> $LOGFILE
fi

echo " " >> $LOGFILE

#echo " [ ENVIRONMENT SYSTEM RESOURCES ] "  >> $LOGFILE

#db2 "select substr(name, 1, 20) name, substr(value, 1, 10) value, substr(unit,1, 10)unit from sysibmadm.env_sys_resources"|egrep 'CPU|MEMORY'  >> $LOGFILE

################################################
echo "********************************************************************************" >> $LOGFILE
echo "SECTION B: DATABASE STATS " >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE

echo "[ DATABASE UPTIME ] " >> $LOGFILE

DBM_UPTIME=`db2pd -`
echo "  $DBM_UPTIME" >> $LOGFILE

echo " " >> $LOGFILE

echo "   [ DATABASE  SIZE ] " >> $LOGFILE


db2  "CALL GET_DBSIZE_INFO(?, ?, ?, 0)" > ${DBFILE}

  CSZE=`cat $DBFILE|tail -3|head -1 |awk '{print $4}'`
  ASZE=`cat $DBFILE|tail -6|head -1 |awk '{print $4}'`

  CSZE_GB=`expr $CSZE \/ 1024 \/ 1024 \/ 1024`
  ASZE_GB=`expr $ASZE \/ 1024 \/ 1024 \/ 1024`
  ASZE_MB=`expr $ASZE \/ 1024 \/ 1024`

  echo " " >> ${LOGFILE}
  echo "DATABASESIZE(MB)      : $ASZE_MB"  >> ${LOGFILE}
  echo "DATABASESIZE(GB)      : $ASZE_GB"  >> ${LOGFILE}
  echo "DATABASECAPACITY(GB)  : $CSZE_GB"  >> ${LOGFILE}

CHECKDATE=`date +'%d'`

if
 [ "$CHECKDATE" -eq 05 ];then
echo " The database size at  `date +'%c'` was  $ASZE_GB " >> $DBSIZEHIST
#echo " The database size at  `date +'%c'` was:  $ASZE_GB  GB"
#echo "database size is only saved on 5th day of every month for growth trending purposes"
fi

if [[ "$CHECKDATE" -eq 28 ]] && [[ -s ${DBSIZEHIST} ]];then

echo " HERE IS THE DATABASE SIZE HISTORY : `cat $DBSIZEHIST ` "
else
echo "no size history thus far" > /dev/null
fi


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo " " >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE
echo "[ DATABASE LOG SPACE ] " >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE
echo " " >> ${LOGFILE}
LSP=`db2 get snapshot for database on $DBNAME|grep 'Log space available to the database'|awk '{print $8}'`
LSP=`expr $LSP \/ 1024 \/ 1024`
echo "Available Log Space (MB): $LSP " >> $LOGFILE

ULSP=`db2 get snapshot for database on $DBNAME|grep 'Log space used by the database' |awk '{print $9}'`
ULSP=`expr $ULSP \/ 1024 \/ 1024`
echo "Used Log Space (MB): $ULSP " >> $LOGFILE

echo " " >> $LOGFILE
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE
echo "SECTION C:  TOTAL MEMORY BEING USED BY DATABASE ( GB ) " >> $LOGFILE
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE
echo " " >> $LOGFILE

db2 "select SUM(MEMORY_POOL_USED)/1073741824  as TOT_MEMORY_USED_GB  from table(MON_GET_MEMORY_POOL(null,null,-2)) as t with ur" >> $LOGFILE

echo " " >> $LOGFILE
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE
#echo "SECTION D:  APPLICATIONS CONSUMING THE MOST CPU " >> $LOGFILE
#echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE

#db2 "SELECT CHAR(BB.APPL_NAME , 20) AS APPL_NAME , AA.AGENT_ID , CHAR(BB.PRIMARY_AUTH_ID , 10) AS AUTH_ID , CHAR (BB.CLIENT_NNAME , 28) AS CLNT_HOSTNAME , AGENT_USR_CPU_TIME_S , AGENT_SYS_CPU_TIME_S FROM SYSIBMADM.SNAPAPPL AA , SYSIBMADM.SNAPAPPL_INFO AS BB WHERE AA.AGENT_ID = BB.AGENT_ID ORDER BY AGENT_USR_CPU_TIME_S DESC , AGENT_SYS_CPU_TIME_S , 'SHOW HIGHEST CPU CONSUMERS' FETCH FIRST 10 ROWS ONLY FOR READ ONLY WITH UR">>$LOGFILE

#echo " " >> $LOGFILE

################################################
echo "********************************************************************************" >> $LOGFILE

echo "SECTION E: DATABASE BACKUP STATUS" >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE
echo "[ LAST BACKUP STATUS ] " >> $LOGFILE

#db2 -tf History_Backup.sql|head -5 >> $LOGFILE

db2 -t "select case when sqlcode is null then 'SUCCESSFUL' else 'FAILED' end as "BackUpStatus", case(operationType) when 'F' then 'Offline Full' when 'N' then 'Online Full' when 'I' then 'Offline Incremental' when 'O' then 'Online Incremental' when 'D' then 'Offline Delta' when 'E' then 'Online Delta' else '?' end as "BackupType", date(timestamp(end_time)) as "DayCompleted", time(timestamp(start_time)) as "TimeStarted", time(timestamp(end_time)) as "TimeCompleted" ,timestampdiff(4,char(timestamp(end_time)-timestamp(start_time))) as "ElapsedTime_Min" from SYSIBMADM.db_history where operation = 'B' group by start_time,end_time,operationType,sqlcode order by date(timestamp(end_time))desc fetch first 1 row only with ur"|head -5 >> $LOGFILE

################################################

echo "********************************************************************************" >> $LOGFILE

echo "SECTION F: DIAGLOG ERRORS" >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE
echo "[ SEVERE ERRORS FOUND IN DIAGNOSTIC LOG ]" >> $LOGFILE

SCNT=(`db2diag -gi level=severe -H 1d|grep 'LEVEL: Severe'|wc -l`)

if [[ $SCNT -gt 0 ]]
 then
    echo "------SEVERE ERRORS FOUND IN DIAGLOG WITHIN LAST 1 DAY------ " >> ${DIAGFILE}
    db2diag -gi "level=severe" -H 1d >> $DIAGFILE
    echo "$SCNT Severe Errors Found In Diaglog. More information can be found in $DIAGFILE" >> $LOGFILE
 else
    echo "  No Severe Errors Found In Diaglog" >> $LOGFILE
fi
echo " " >> $LOGFILE
echo "[ REGULAR  ERRORS FOUND IN DIAGNOSTIC LOG ]" >> $LOGFILE

ECNT=(`db2diag -gi level=error -H 1d|grep 'LEVEL: Error'|wc -l`)

if [[ $ECNT -gt 0 ]]
 then
    echo "------REGULAR  ERRORS FOUND IN DIAGLOG WITHIN LAST 1 DAY------ " >> ${DIAGFILE}
    db2diag -gi "level=error" -H 1d >> $DIAGFILE
echo " " >> $LOGFILE
    echo "$ECNT Regular  Errors were Found In Diaglog. More information can be found in $DIAGFILE" >> $LOGFILE
 else
    echo "  No Normal Errors Found In Diaglog" >> $LOGFILE
fi

################################################

echo "********************************************************************************" >> $LOGFILE

echo "SECTION G: DATABASE FILE SYSTEMS" >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE
STOR_PATH=`db2 -x "select DBPARTITIONNUM, substr(TYPE,1,20)type, substr(PATH,1,40)path from SYSIBMADM.DBPATHS with ur"|grep DB_STORAGE_PATH|awk '{print $3}'`
echo " " >> $LOGFILE
echo "[ SPACE REPORT  FOR DATABASE STORAGE PATH ($STOR_PATH) ]" >> $LOGFILE
FSP=`df -h $STOR_PATH|tail -1|awk '{print $3}'`
TSP=`df -h $STOR_PATH|tail -1|awk '{print $1}'`
UPC=`df -k $STOR_PATH|tail -1|awk '{print $4 }'`
echo "  TOTAL SPACE  ALLOCATED IS : $TSP" >> $LOGFILE
echo "  FREE  SPACE  AVAILABLE IS : $FSP" >> $LOGFILE
echo "  PERCENTAGE   USED      IS : $UPC" >> $LOGFILE 
echo " " >> $LOGFILE
DFILE=`db2 get dbm cfg|grep DIAGPATH|head -1|awk '{print $7}'`
echo " " >> $LOGFILE
echo "[ SPACE REPORT  FOR DIAGNOSTIC LOG DIRECTORY ($DFILE) ]" >> $LOGFILE
FSP=`df -h $DFILE|tail -1|awk '{print $3}'`
TSP=`df -h $DFILE|tail -1|awk '{print $1}'`
UPC=`df -k $DFILE|tail -1|awk '{print $4 }'`
echo "  TOTAL SPACE  ALLOCATED IS : $TSP" >> $LOGFILE
echo "  FREE  SPACE  AVAILABLE IS : $FSP" >> $LOGFILE
echo "  PERCENTAGE   USED      IS : $UPC" >> $LOGFILE
echo " " >> $LOGFILE
echo "[ SPACE REPORT FOR INSTANCE HOME DIRECTORY ($HOME) ]" >> $LOGFILE
FSP=`df -h $HOME|tail -1|awk '{print $3}'`
TSP=`df -h $HOME|tail -1|awk '{print $1}'`
UPC=`df -k $HOME|tail -1|awk '{print $4 }'`
echo "  TOTAL SPACE  ALLOCATED IS : $TSP" >> $LOGFILE
echo "  FREE  SPACE  AVAILABLE IS : $FSP" >> $LOGFILE
echo "  PERCENTAGE   USED      IS : $UPC" >> $LOGFILE
ACFILE=`db2 get db cfg for $DBNAME|grep 'Path to log files'|awk '{print $6}'`
echo " " >> $LOGFILE
echo "[ SPACE REPORT  FOR ACTIVE LOG PATH  ($ACFILE) ]" >> $LOGFILE
FSP=`df -h $ACFILE|tail -1|awk '{print $3}'`
TSP=`df -h $ACFILE|tail -1|awk '{print $1}'`
UPC=`df -k $ACFILE|tail -1|awk '{print $4 }'`
echo "  TOTAL SPACE  ALLOCATED IS : $TSP" >> $LOGFILE
echo "  FREE  SPACE  AVAILABLE IS : $FSP" >> $LOGFILE
echo "  PERCENTAGE   USED      IS : $UPC" >> $LOGFILE
ARFILE=`db2 get db cfg for $DBNAME|grep LOGARCHMETH1|awk '{print $7}'|cut -c 6-40`
echo " " >> $LOGFILE
echo "[ SPACE REPORT FOR  ARCHIVE LOG DIRECTOORY ($ARFILE) ] " >> $LOGFILE
FSP=`df -h $ARFILE|tail -1|awk '{print $3}'`
TSP=`df -h $ARFILE|tail -1|awk '{print $1}'`
UPC=`df -k $ARFILE|tail -1|awk '{print $4 }'`
echo "  TOTAL SPACE  ALLOCATED IS : $TSP" >> $LOGFILE
echo "  FREE  SPACE  AVAILABLE IS : $FSP" >> $LOGFILE
echo "  PERCENTAGE   USED      IS : $UPC" >> $LOGFILE

################################################
echo "********************************************************************************" >> $LOGFILE

echo "SECTION H:INVALID OBJECTS IN THE DATABASE" >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE
echo "[ LIST OF OBJECTS IN THE DATABASE IDENTIFIED AS INVALID ]" >> $LOGFILE

INVLD_TAB_NCT=`db2 -x "select  SUBSTR(TABSCHEMA,1,15) AS "OBJECT_SCHEMA", SUBSTR(TABNAME,1,25) AS "OBJECT_NAME", SUBSTR(DEFINER,1,25) AS "OBJECT_CREATOR", CASE (TYPE) WHEN 'A' THEN 'ALIAS' WHEN 'G' THEN 'CREATED_TEMPORARY_TABLE' WHEN 'H' THEN 'HIERARCHY_TABLE' WHEN 'L' THEN 'DETACHED_TABLE' WHEN 'N' THEN 'NICKNAME' WHEN 'S' THEN 'MATERIALIZED_QUERY_TABLE' WHEN 'T' THEN 'TABLE_UNTYPED' WHEN 'U' THEN 'TYPED_TABLE' WHEN 'V' THEN 'VIEW_UNTYPED' WHEN 'W' THEN 'TYPED_VIEW' END AS "OBJECT_TYPE", CAST(CREATE_TIME AS CHAR (32)) AS "CREATE_TIME", CASE(STATUS) WHEN 'X' THEN 'INVALID' END AS STATUS, SUBSTR(REMARKS,1,25) AS REMARKS FROM SYSCAT.TABLES WHERE STATUS = 'X' UNION SELECT SUBSTR(TRIGSCHEMA,1,15) AS "OBJECT_SCHEMA", SUBSTR(TRIGNAME,1,25) AS "OBJECT_NAME", SUBSTR(DEFINER,1,25) AS "OBJECT_CREATOR", 'TRIGGER ' AS "OBJECT_TYPE", CAST (CREATE_TIME AS CHAR (32)) AS "CREATE_TIME", CASE(VALID) WHEN 'X' THEN 'INVALID' WHEN 'N' THEN 'INVALID' END AS STATUS, SUBSTR(REMARKS,1,25) AS REMARKS FROM SYSCAT.TRIGGERS WHERE VALID = 'N' OR VALID = 'X' UNION SELECT SUBSTR(PROCSCHEMA,1,15) AS "OBJECT_SCHEMA", SUBSTR(PROCNAME,1,25) AS "OBJECT_NAME", SUBSTR(DEFINER,1,25) AS "OBJECT_CREATOR", 'PROCEDURE ' AS "OBJECT_TYPE", CAST (CREATE_TIME AS CHAR (32)) AS "CREATE_TIME", CASE(VALID) WHEN 'X' THEN 'INVALID' WHEN 'N' THEN 'INVALID' END AS STATUS, SUBSTR(REMARKS,1,25) FROM SYSCAT.PROCEDURES WHERE VALID = 'N' OR VALID = 'X' UNION SELECT SUBSTR(PKGSCHEMA,1,15) AS "OBJECT_SCHEMA", SUBSTR(PKGNAME,1,25) AS "OBJECT_NAME", SUBSTR(DEFINER,1,25) AS "OBJECT_CREATOR", 'PACKAGE ' AS "OBJECT_TYPE", 'N / A' AS "CREATE_TIME", CASE(VALID) WHEN 'X' THEN 'INVALID' WHEN 'N' THEN 'INVALID' END AS STATUS, SUBSTR(REMARKS,1,25) AS REMARKS FROM SYSCAT.PACKAGES WHERE VALID = 'N' OR VALID = 'X' ORDER BY 1, 2, 3, 4, 5 FOR READ ONLY WITH UR"|wc -l`

if [[ $INVLD_TAB_NCT -gt 0 ]]
then

db2 "select  SUBSTR(TABSCHEMA,1,15) AS "OBJECT_SCHEMA", SUBSTR(TABNAME,1,25) AS "OBJECT_NAME", SUBSTR(DEFINER,1,25) AS "OBJECT_CREATOR", CASE (TYPE) WHEN 'A' THEN 'ALIAS' WHEN 'G' THEN 'CREATED_TEMPORARY_TABLE' WHEN 'H' THEN 'HIERARCHY_TABLE' WHEN 'L' THEN 'DETACHED_TABLE' WHEN 'N' THEN 'NICKNAME' WHEN 'S' THEN 'MATERIALIZED_QUERY_TABLE' WHEN 'T' THEN 'TABLE_UNTYPED' WHEN 'U' THEN 'TYPED_TABLE' WHEN 'V' THEN 'VIEW_UNTYPED' WHEN 'W' THEN 'TYPED_VIEW' END AS "OBJECT_TYPE", CAST(CREATE_TIME AS CHAR (32)) AS "CREATE_TIME", CASE(STATUS) WHEN 'X' THEN 'INVALID' END AS STATUS, SUBSTR(REMARKS,1,25) AS REMARKS FROM SYSCAT.TABLES WHERE STATUS = 'X' UNION SELECT SUBSTR(TRIGSCHEMA,1,15) AS "OBJECT_SCHEMA", SUBSTR(TRIGNAME,1,25) AS "OBJECT_NAME", SUBSTR(DEFINER,1,25) AS "OBJECT_CREATOR", 'TRIGGER ' AS "OBJECT_TYPE", CAST (CREATE_TIME AS CHAR (32)) AS "CREATE_TIME", CASE(VALID) WHEN 'X' THEN 'INVALID' WHEN 'N' THEN 'INVALID' END AS STATUS, SUBSTR(REMARKS,1,25) AS REMARKS FROM SYSCAT.TRIGGERS WHERE VALID = 'N' OR VALID = 'X' UNION SELECT SUBSTR(PROCSCHEMA,1,15) AS "OBJECT_SCHEMA", SUBSTR(PROCNAME,1,25) AS "OBJECT_NAME", SUBSTR(DEFINER,1,25) AS "OBJECT_CREATOR", 'PROCEDURE ' AS "OBJECT_TYPE", CAST (CREATE_TIME AS CHAR (32)) AS "CREATE_TIME", CASE(VALID) WHEN 'X' THEN 'INVALID' WHEN 'N' THEN 'INVALID' END AS STATUS, SUBSTR(REMARKS,1,25) FROM SYSCAT.PROCEDURES WHERE VALID = 'N' OR VALID = 'X' UNION SELECT SUBSTR(PKGSCHEMA,1,15) AS "OBJECT_SCHEMA", SUBSTR(PKGNAME,1,25) AS "OBJECT_NAME", SUBSTR(DEFINER,1,25) AS "OBJECT_CREATOR", 'PACKAGE ' AS "OBJECT_TYPE", 'N / A' AS "CREATE_TIME", CASE(VALID) WHEN 'X' THEN 'INVALID' WHEN 'N' THEN 'INVALID' END AS STATUS, SUBSTR(REMARKS,1,25) AS REMARKS FROM SYSCAT.PACKAGES WHERE VALID = 'N' OR VALID = 'X' ORDER BY 1, 2, 3, 4, 5 FOR READ ONLY WITH UR"|grep -v record  >> $LOGFILE

else
echo " " >> $LOGFILE
echo " No Invalid Objects were found in the database " >> $LOGFILE
fi
####################################################
echo "********************************************************************************" >> $LOGFILE

echo "SECTION I: NORMAL TABLES WHICH ARE INACCESSIBLE" >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE
echo "[ LIST OF TABLES SHOWING AS NORMAL BUT INACCESSIBLE ]"  >> $LOGFILE
echo " " >> $LOGFILE
BADTABLE_CNT=`db2 -x  "select substr(tabschema,1,10) schema, substr(tabname,1,30) tablename, available from SYSIBMADM.ADMINTABINFO where AVAILABLE <> 'Y' with ur "|wc -l`
if [[ $BADTABLE_CNT -gt 0 ]]
then
db2 "select substr(tabschema,1,10) schema, substr(tabname,1,30) tablename, available from SYSIBMADM.ADMINTABINFO where AVAILABLE <> 'Y' with ur " >> $LOGFILE 
else
echo " " >> $LOGFILE
echo " No Table was found inaccessible or unavailable " >> $LOGFILE
fi
#######################################################################
echo "********************************************************************************" >> $LOGFILE

echo "SECTION J: TABLES SHOWING AS REORG PENDING" >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE
echo "[ LIST OF TABLES IN REORG PENDING STATE ]"  >> $LOGFILE
echo " " >> $LOGFILE
REORG_PEND_CNT=`db2 -x "SELECT TABSCHEMA, TABNAME, NUM_REORG_REC_ALTERS, REORG_PENDING FROM SYSIBMADM.ADMINTABINFO where REORG_PENDING ='Y' with ur "|wc -l`
if [[ $REORG_PEND_CNT -gt 0 ]]
then
db2 "SELECT TABSCHEMA, TABNAME, NUM_REORG_REC_ALTERS, REORG_PENDING FROM SYSIBMADM.ADMINTABINFO where REORG_PENDING ='Y' with ur " >> $LOGFILE
else
echo " " >> $LOGFILE
echo " No Table was found to be in reorg pending state " >> $LOGFILE
fi
echo "********************************************************************************" >> $LOGFILE

echo "SECTION K:DATABASE PERF STATS" >> $LOGFILE
echo "********************************************************************************" >> $LOGFILE

echo "[ QUERIES RUNNING FOR MORE THAN 60 MINS ]" >> $LOGFILE
echo " " >> $LOGFILE

db2 -x "select application_handle, application_name, session_auth_id, elapsed_time_sec, total_cpu_time, total_rows_modified, total_rows_read, total_rows_returned from sysibmadm.mon_current_uow where elapsed_time_sec > 3600 and WORKLOAD_OCCURRENCE_STATE like '%EXEC%' with ur" > $RPTSQL

if [[ $? -eq 0 ]]
 then
 n=0
  for sn_id in `cat $RPTSQL |sed 's/^ *//' | cut -d' ' -f1`
   do
       echo "#################################################################" >> $RPTSnap
       echo " Snapshot for job $sn_id " >> $RPTSnap
       echo "#################################################################" >> $RPTSnap
       db2 get snapshot for application agentid $sn_id >> $RPTSnap
       echo " " >> $RPTSnap
       n=`expr $n + 1`
   done
       echo "  There are $n long running jobs found.More information can be found in $RPTSnap"  >> $LOGFILE
else
       echo  "  No long running jobs  detected " >> $LOGFILE
fi

echo " " >> $LOGFILE

echo "**************************************************************************************" >> $LOGFILE
echo "[ SECTION L : TABLESPACE UTILIZATION ] " >> $LOGFILE
echo "***************************************************************************************" >> $LOGFILE

echo " " >> $LOGFILE
db2 "select unique(substr(TBSP_NAME,1,24)) as tbspname ,TBSP_TYPE, substr(TBSP_STATE,1,15) state, TBSP_TOTAL_SIZE_KB as tot_sz_KB,TBSP_UTILIZATION_PERCENT as util_pct,TBSP_LAST_RESIZE_TIME as last_resize_time from SYSIBMADM.TBSP_UTILIZATION order by TBSP_TYPE with ur" >> $LOGFILE

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE
echo "SECTION M:  CHECK HIGH WATER MARK INFORMATION FOR TABLESPACES  " >> $LOGFILE
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE
echo " " >> $LOGFILE


db2 "select unique(substr(tbsp_name,1,14))ts_name,tbsp_total_pages as total_pages,tbsp_used_pages as used_pages,tbsp_page_top as high_water_mark,reclaimable_space_enabled from table (MON_GET_TABLESPACE (NULL,-1)) as ts where tbsp_name not like ('SYS%') and tbsp_type='DMS' with ur" >> $LOGFILE

##echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE
##echo "SECTION N:  CREATE ALTER STATEMENTS  FOR REDUCING TABLESPACES WITH HWM ABOVE 10% OF USED PAGES  " >> $LOGFILE
##echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE
##echo " " >> $LOGFILE

##db2 " select 'alter tablespace ',substr(tbsp_name,1,18),' reduce max;' from table (mon_get_tablespace('',-2)) as zzz where  tbsp_used_pages + tbsp_pending_free_pages < ( tbsp_page_top * 90 / 100 ) and tbsp_content_type in ('ANY','LARGE') and tbsp_using_auto_storage = 1 and tbsp_auto_resize_enabled = 1 and tbsp_state = 'NORMAL' and reclaimable_space_enabled = 1   and tbsp_type = 'DMS' with ur" >> $LOGFILE

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE
echo "SECTION O:  10 LARGEST TABLES WITH CORRESPONDING  INDEXES  & ROWS STATS " >> $LOGFILE
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE

db2 "select substr(a.TABSCHEMA,1,10) as schema,unique(substr(a.TABNAME,1,30)) as table, decimal(float(a.DATA_OBJECT_L_SIZE)/ ( 1024 ),9,2) as data_spaceinuse_mb, decimal(float(a.INDEX_OBJECT_L_SIZE)/ ( 1024 ),9,2) as indexspaceinuse_mb, substr(s.card,1,10) as number_of_records,substr(b.TBSP_NAME,1,15)tablespace,decimal(float(b.TBSP_TOTAL_SIZE_KB)/ ( 1024 ),9,2) as tbspTotSz_MB,decimal(float(b.TBSP_FREE_SIZE_KB)/ ( 1024 ),9,2) as tbspcfreesz_MB, substr(b.TBSP_UTILIZATION_PERCENT,1,4) as TBSP_UTLZ_PCNT  from sysibmadm.admintabinfo a, SYSIBMADM.TBSP_UTILIZATION b, syscat.tables s where a.TABSCHEMA=s.TABSCHEMA and a.TABNAME=s.TABNAME and a.TABSCHEMA='WSCOMUSR' and s.type='T' and s.tbspaceid = B.tbsp_id   order by 3  desc fetch first 10 rows only with ur">>$LOGFILE

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE
echo "SECTION P:  CHECK PRIVILEGES FOR USERS AND GROUPS" >> $LOGFILE
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE

db2  "select  distinct substr(grantee,1,30)grantee,granteetype,alterauth,deleteauth,insertauth,selectauth,updateauth from syscat.tabauth" >> $LOGFILE
db2  "SELECT distinct substr(grantee,1,30)grantee,granteetype,dbadmauth,createtabauth,bindaddauth,connectauth,DATAACCESSAUTH,ACCESSCTRLAUTH FROM SYSCAT.DBAUTH" >> $LOGFILE

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE
echo "The DATAACCESS authority allows the holder to: Select, insert, update, delete,load data and execute any package." >> $LOGFILE
echo " " >> $LOGFILE
echo " As a best practice, immediately revoke the implicit privileges granted to PUBLIC after the creation of a new database" >> $LOGFILE


echo " " >> $LOGFILE

db2 connect reset >  /dev/null

echo "DIAGNOSTIC CHECK COMPLETED!"

cat $LOGFILE | mailx -s  "Daily Health Report For $DBNAME in $HENVIRONMENT" "$TEAMMAIL"
cat $LOGFILE 

#_________________________________________________

find ${LOGLOC} -name "HlthLogErr_*" -type f -mtime +${RETENTION}  -exec rm -f {} \;
find ${LOGLOC} -name "MonSQLLog_*" -type f -mtime +${RETENTION}  -exec rm -f {} \;
find ${LOGLOC} -name "SnapLog_*"  -type f -mtime +${RETENTION}  -exec rm -f {} \;
find ${LOGLOC} -name "dbszlogfile_*" -type f -mtime +${RETENTION}  -exec rm -f {} \;
find ${LOGLOC} -name "Diaglog_*"  -type f  -mtime  +${RETENTION}  -exec rm -f {} \;
exit 0

