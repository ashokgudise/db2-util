
#!/bin/ksh

DBNAME=$1
typeset -u DBNAME
INST=`whoami`
typeset -u INST
HOSTNM=`hostname`
TEAMMAIL="eCommDBA@dcsg.com"
RDATE=`date +%Y%m%d%H%M%S`
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
LOGLOC="/db2shared/db2scripts/QBSCRIPTS/LOGS/HADRLOGS"
ERRORFILE="/db2shared/db2scripts/QBSCRIPTS/LOGS/HADRLOGS/HADRstatusErr_$DBNAME_$RDATE"

RETENTION=4


#--------------------------------------------------------------------------------------

if [[ $# -ne 1 ]]
then
  echo "You Need to Supply the Database Name."
  echo "Syntax:  $0  dbname "
  exit 1
fi

. $HOME/sqllib/db2profile >/dev/null 2>&1


DBFOUND=$(db2 list database directory |grep "Database alias"|cut -d'=' -f2|grep -cwi "$DBNAME")


if [[ $DBFOUND -lt 1 ]]
then
   echo "The database $DBNAME was not found.Please verify database name  and reissue command"
   exit 4
fi

echo "********************************************************************************" > $ERRORFILE
echo "                  HADR   DIAGNOSTIC REPORT " >>  $ERRORFILE
echo "-------------------------------------------------------------------------- " >> $ERRORFILE
echo " " >> $$ERRORFILE
echo "            REPORT DATE   :  $RDATE" >>  $ERRORFILE
echo "            DATABASE NAME :  $DBNAME" >>  $ERRORFILE
echo "            ENVIRONMENT   :  $ENVIRONMENT" >>  $ERRORFILE
echo "            SERVERIP      :  $SERVERIP" >>  $ERRORFILE
echo "            HOSTNAME      :  $HOSTNM" >>  $ERRORFILE

echo "********************************************************************************" >>  $ERRORFILE

#----------------------------------------------------------------------------------------------

HADR_STATUS=`db2pd -db $DBNAME -hadr|egrep -i "Standard|connected"|wc -l`

if [[ $HADR_STATUS -eq 0 ]]
#if [[ $HADR_STATUS -ne 0 ]] --- just for testing purposes

then

   echo " " >> $ERRORFILE
   echo "------------------------------------- DATABASE SNAPSHOT SHOWING HADR INFORMATION  ------------------------------------- " >> $ERRORFILE
   echo " " >> $ERRORFILE
   db2 get snapshot for DB on $DBNAME|egrep "(Role|State|Connection status|Heartbeats missed|Primary log position|Standby log position|Log gap)" >> $ERRORFILE

   echo " " >> $ERRORFILE

   echo "------------------------------------- DB2PD OUTPUT SHOWING HADR STATUS ------------------------------------- " >> $ERRORFILE
   echo " " >> $ERRORFILE
   db2pd -db $DBNAME -hadr >> $ERRORFILE

   echo " " >> $ERRORFILE
   echo "------------------------------------- SCRUBBING DIAGNOSTIC LOG FOR HADR ACTIVITIES  ------------------------------------- " >> $ERRORFILE
   echo " " >> $ERRORFILE

   db2diag -gi "funcname:=hdr" -fmt "%{tsmonth}-%{tsday}-%{tshour}.%{tsmin}.%{tssec} %{process} %{changeevent}\t %{message}"|tail -20  >> $ERRORFILE


   mailx -s "HADR is in questionable state when last checked from   $ENVIRONMENT  on $SERVERIP at  " $TEAMMAIL < $ERRORFILE

fi

#find ${ERRORFILE} -name "HADRstatusErr*"  -type f  -mtime +3  -exec rm -f {} \;
find /db2shared/db2scripts/QBSCRIPTS/LOGS/HADRLOGS -name "HADRstatusErr*"  -type f  -mtime +1  -exec rm -f {} \;
### rm ./*ERRORFILE
exit

