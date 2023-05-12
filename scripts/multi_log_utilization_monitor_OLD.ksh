#!/bin/ksh

#DBNAME=$1
#typeset -u DBNAME

MAIL_ONLY="kwaku.boakye@dcsg.com Jonathan.quicquaro@dcsg.com"
MAIL_WITH_PAGER="kwaku.boakye@dcsg.com Jonathan.quicquaro@dcsg.com"
RDATE=`date +%m-%d-%y`
STARTDATE=`date +"%A %r %Y-%m-%d"`
DATE=`date +%m%d%Y%H%M`
INST=`whoami`
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
SCRIPTLOC=/data02/db2scripts/QBSCRIPTS
LOGLOC=/data02/db2scripts/QBSCRIPTS/LOGS/LOGUTLZ
ERRORFILE="${LOGLOC}/LogUtlz_Err__${INST}_${DBNAME}_$DATE"
LOGFILE="${LOGLOC}/LogUtlz__${INST}_${DBNAME}_$DATE"
MSG="${LOGLOC}/Message_Body_${INST}_${DBNAME}_${DATE}"
#BE=`db2 list db directory|grep -p ${DBNAME}|grep Comment|cut -c41-65`
RPT_RETENTION=$2
HOSTNM=`hostname`
LOWER_THRESH=70
UPPER_THRESH=85
IS_PAGER=Y

#Retention cleaning
find ${LOGLOC}  -name "LogU*" -mtime +2  -exec rm -f {} \; 2>/dev/null
#find ${LOGLOC}  -name "*" -mtime +2  -exec rm -f {} \; 2>/dev/null

 . $HOME/sqllib/db2profile >/dev/null 2>&1

#--------------------------------------------------------------------------------------------------------------

for DBNAME in `db2 list database directory | awk '{FS="\n";RS=""} /Indirect/ {print $2}' | awk '{print $4}'`;

do

echo "Current Database is $DBNAME"

LOWER_THRESH=70
UPPER_THRESH=85
#----------------------------------------------------------------------------------------------------------------

db2 connect to $DBNAME > /dev/null


#--------------------------------------------------------------------------------------------------------------
#                                      CLEAN UP PREVIOUS OUTPUTS
#--------------------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------------------

typeset -u HOSTNM

#----------------------------------------------------------------------------------------------------------------

LOGFILSZ_IN_MB=`db2 -x "SELECT integer(value * 4 )/1024 as Logfilsz_MB  FROM SYSIBMADM.DBCFG WHERE NAME ='logfilsiz'"`

TOT_NUM_SEC_LOG_FILES=`db2 -x "select integer(value) FROM SYSIBMADM.DBCFG WHERE NAME='logsecond'"`

#-------------- WHAT IS CURRENT LOG UTILIZATION PERCENTAGE --------------------------------------------------

PERCENT_UTIL=`db2 -x "select integer(LOG_UTILIZATION_PERCENT) from SYSIBMADM.LOG_UTILIZATION with ur"`



if [[  ${PERCENT_UTIL} -lt  ${LOWER_THRESH} ]]; then 

echo "Utilization for $DBNAME was at ${PERCENT_UTIL} and it is below ${LOWER_THRESH} on $DATE " >> $LOGFILE

#exit 1

else

db2 -tx  -r /data02/db2scripts/QBSCRIPTS/LOGS/LOGUTLZ/Attachment_${INST}_${DBNAME}_${DATE}.html<<@END_OF_STATEMENT
echo <HTML> ;
echo <HEAD> ;
echo <TITLE> ;
echo 'More information on Logs' ;
echo </TITLE> ;
echo </HEAD> ;
echo <BODY> ;
------------------- ENVIRONMENT INFORMATION--------------------
echo <P> ; 
 
echo <pre> ;
echo SNAPSHOT TIMESTAMP = $STARTDATE ;
echo <pre> ;

echo <pre> ;
echo INSTANCE = $INST ;
echo </pre> ;

echo <pre> ;
echo DATABASE NAME = $DBNAME ;
echo <pre> ;

echo <pre> ;
echo HOSTNAME = $HOSTNM ;
echo <pre> ;

echo <pre> ;
echo HOSTNAME = $SERVERIP ;
echo <pre> ;

echo <pre> ;
echo HOSTNAME = $ENVIRONMENT ;
echo <pre> ;

echo <P> ; 
 
--------------------- Detail Information about Log and offending Application ID ---------------


echo <TABLE BORDER=1> ;
echo <TR> ;
echo <TH>LOG_UTILZ_PCT</TH> ;
echo <TH>TOT_AMT_LOG_SPACE_USED_MB</TH> ;
echo <TH>AMT_LOG_SPACE_REMAINING_MB</TH> ;
echo <TH>NUM_SEC_LOG_FILES_IN_USE</TH> ;
echo <TH>NUM_SEC_LOG_FILES_REMAINING</TH> ;
echo <TH>OLDEST_TXN_ID</TH> ;
echo </TR> ;

SELECT '<TR>',
       '<TD>',
       lu.LOG_UTILIZATION_PERCENT as LOG_UTILz_PCT,
       '</TD>',
       '<TD>',
       integer(lu.total_log_used_kb / 1024) as Tot_Log_Used_Mb,
       '</TD>',
       '<TD>',
       integer(sdb.total_log_available /  1024 / 1024) as Tot_Logs_Remaining_Mb,
       '</TD>',
       '<TD>',
       integer(sdb.sec_logs_allocated) as Num_Sec_logs_currently_In_Use,
       '</TD>',
       '<TD>',
       integer(${TOT_NUM_SEC_LOG_FILES} - sdb.sec_logs_allocated) as Num_Sec_log_Files_Remaining,
       '</TD>',
       '<TD>',
        sdb.appl_id_oldest_xact as Oldest_Txn_id,
       '</TD>',
       '</TR>'
 FROM sysibmadm.log_utilization lu
 INNER JOIN sysibmadm.snapdb sdb   ON  lu.db_name = sdb.db_name
 AND lu.dbpartitionnum =sdb.dbpartitionnum  INNER JOIN sysibmadm.snapdetaillog sdl
 ON  lu.db_name = sdl.db_name  AND lu.dbpartitionnum= sdl.dbpartitionnum;

echo </TABLE>;


echo <P> ;



echo <TABLE BORDER=1> ;
echo <TR> ;
echo <TH>appl_id_oldest_xact</TH> ;
echo <TH>elapsed_time_min</TH> ;
echo <TH>appl_status</TH> ;
echo <TH>authid</TH> ;
echo <TH>stmt_text</TH> ;
echo </TR> ;

SELECT '<TR>',
       '<TD>',
       sdb.appl_id_oldest_xact,
       '</TD>',
       '<TD>',
       lr.elapsed_time_min,
       '</TD>',
       '<TD>',
       lr.appl_status,
       '</TD>',
       '<TD>',
       substr(lr.authid,1,10),
       '</TD>',
       '<TD>',
       substr(lr.stmt_text,1,60),
       '</TD>',
       '</TR>'
 from sysibmadm.long_running_sql lr,sysibmadm.snapdb sdb where  sdb.appl_id_oldest_xact=lr.agent_id ;

echo </TABLE>;

 
echo <P> ;


echo <TABLE BORDER=1> ;
echo <TR> ;
echo <TH>db_cfg_parameter</TH> ;
echo <TH>size_in_MB</TH> ;
echo </TR> ;

SELECT '<TR>',
       '<TD>',
       substr(name,1,12) as db_cfg_parameter,
       '</TD>',
       '<TD>',
       integer(value * ${LOGFILSZ_IN_MB}),
       '</TD>',
       '</TR>'
   FROM SYSIBMADM.DBCFG WHERE NAME IN ('logprimary','logsecond') ;

echo </TABLE>;

echo <P>;

echo <TABLE BORDER=1> ;
echo <TR> ;
echo <TH>db_cfg_parameter</TH> ;
echo <TH>value</TH> ;
echo </TR> ;

SELECT '<TR>',
       '<TD>',
       substr(name,1,12) as db_cfg_parameter,
       '</TD>',
       '<TD>',
       integer(value),
       '</TD>',
       '</TR>'
  FROM SYSIBMADM.DBCFG WHERE NAME IN ('logfilsiz','logprimary','logsecond') ;

echo </TABLE>;

echo </BODY>;
echo </HTML>;
@END_OF_STATEMENT


SEC_LOG_USED=`db2 get snapshot for database on $DBNAME|grep "Secondary logs allocated currently"|awk '{print $6}'`
SEC_LOG_ALLOC=`db2 get db cfg for $DBNAME|grep "Number of secondary log files"|awk '{print $8}'`


fi

## * * * If perc utilz is greater than the lower thresh(70) but lower than upper threshold (85), send out just the emai,but dont page out, else quit.

echo "The treshold for  Log Utilization Percentage has been breached." > $MSG
echo " $SEC_LOG_USED out of the $SEC_LOG_ALLOC allocated secondary logs have been used." >> $MSG
echo " Utilization Percentage for $DBNAME is currently ${PERCENT_UTIL}%.Please open the attached html file for details."  >> $MSG


if [[  ${PERCENT_UTIL} -gt   ${LOWER_THRESH} ]]   && [[ ${PERCENT_UTIL} -lt  ${UPPER_THRESH} ]];
then 

echo "Utilization for $DBNAME was at ${PERCENT_UTIL} and it was above ${LOWER_THRESH} but below ${UPPER_THRESH} on $DATE " >> $LOGFILE

mutt -s  "HIGH LOG UTILIZATION ALERT FOR $INST:$DBNAME ON $HOSTNM IN $ENVIRONMENT. THE CURRENT PERCENTAGE UTILIZATION IS $PERCENT_UTIL%" $MAIL_ONLY  < $MSG -a  /data02/db2scripts/QBSCRIPTS/LOGS/LOGUTLZ/Attachment_${INST}_${DBNAME}_${DATE}.html 


## cat $MSG; uuencode /data02/db2scripts/LOGS/LOGUTLZ/Attachment_${INST}_${DBNAME}_${DATE}.html  Log_Utilization_Rpt.html) |mail -s "HIGH LOG UTILIZATION ALERT FOR $INST:$DBNAME ON $HOSTNM. THE CURRENT PERCENTAGE UTILIZATION IS $PERCENT_UTIL%" $MAIL_ONLY

else
echo " A page  cannot be sent out yet" > /dev/null
fi
 
if [[  ${PERCENT_UTIL} -ge   ${UPPER_THRESH} ]]   &&  [[  ${IS_PAGER} = "Y"  ]] 

then 

echo "Utilization for $DBNAME was at ${PERCENT_UTIL} and it was above ${UPPER_THRESH} on $DATE " >> $LOGFILE


mutt -s  "HIGH LOG UTILIZATION ALERT FOR $INST:$DBNAME ON $HOSTNM IN $ENVIRONMENT. THE CURRENT PERCENTAGE UTILIZATION IS $PERCENT_UTIL%" $MAIL_WITH_PAGER  < $MSG -a  /data02/db2scripts/QBSCRIPTS/LOGS/LOGUTLZ/Attachment_${INST}_${DBNAME}_${DATE}.html

#(cat $MSG; uuencode /data02/db2scripts/LOGS/LOGUTLZ/Attachment_${INST}_${DBNAME}_${DATE}.html  Log_Utilization_Rpt.html) |mail -s "HIGH LOG UTILIZATION ALERT FOR $INST:$DBNAME ON $HOSTNM. THE CURRENT PERCENTAGE UTILIZATION IS $PERCENT_UTIL%" $MAIL_WITH_PAGER

else 
mutt -s  "HIGH LOG UTILIZATION ALERT FOR $INST:$DBNAME ON $HOSTNM IN $ENVIRONMENT. THE CURRENT PERCENTAGE UTILIZATION IS $PERCENT_UTIL%" $MAIL_ONLY  < $MSG -a  /data02/db2scripts/QBSCRIPTS/LOGS/LOGUTLZ/Attachment_${INST}_${DBNAME}_${DATE}.html

## (cat $MSG; uuencode /data02/db2scripts/LOGS/LOGUTLZ/Attachment_${INST}_${DBNAME}_${DATE}.html Log_Utilization_Rpt.html) |mail -s "HIGH LOG UTILIZATION ALERT FOR $INST:$DBNAME ON $HOSTNM. THE CURRENT PERCENTAGE UTILIZATION IS $PERCENT_UTIL%" $MAIL_ONLY

fi

done
exit 0



