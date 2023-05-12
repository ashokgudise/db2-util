#!/bin/bash
set -u

INST=`whoami`
TEAMMAIL="kwaku.boakye@dcsg.com Jonathan.quicquaro@dcsg.com"
RDATE=`date +%m.%d.%Y-%H.%M.%S`
SERVER=$(hostname)
LOGLOC=/data02/db2scripts/QBSCRIPTS/reports/REBIND
STARTDATE=`date +"%A %Y-%m-%d %r"`
SERVERIP=`hostname --ip-address`
ENVIRONMENT=`db2 list db directory |grep Comment|awk '{print $3 " " $4}'`
RPTRETENTION=2


. $HOME/sqllib/db2profile >/dev/null 2>&1

for DBNAME in `db2 list database directory | awk '{FS="\n";RS=""} /Indirect/ {print $2}' | awk '{print $4}'`;

do

echo "Current Database is $DBNAME"

echo "********************************************************************************" > ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
echo " "
echo "                  $DBNAME DATABASE -  DAILY -  REBIND  -  REPORT " >> ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
echo " "
echo " START DATE:    $STARTDATE" >>${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
echo " INSTANCE NAME: $INST " >> ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out 
echo " DATABASE NAME: $DBNAME " >> ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
echo " ENVIRONMENT   :$ENVIRONMENT" >> ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
echo " SERVER NAME:   $SERVER " >>  ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
echo " SERVER IP:     $SERVERIP " >>  ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
echo "********************************************************************************" >> ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out

ERRORFILE="${LOGLOC}/RebindErr_${INST}_${DBNAME}_${RDATE}"
RBRPT="${LOGLOC}/RebindLog_${INST}_${DBNAME}_${RDATE}"

db2 connect to $DBNAME > /dev/null 

STATSPROGRESS=`db2 list utilities|grep RUNSTATS|awk '{print $3}'|wc -l`
while [[ $STATSPROGRESS -ne 0 ]]
do
echo "Runstats is still running.Will check back in an 30 minutes  time" >$RBRPT
sleep 1800
STATSPROGRESS=`db2 list utilities|grep RUNSTATS|awk '{print $3}'|wc -l`
done

echo "Starting Rebind at $STARTDATE"  >>$RBRPT


 
db2 "select 'rebind '||substr(pkgschema,1,6)||'.'||pkgname||';' from syscat.packages where pkgschema='NULLID'"|db2 +p -tv >> ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
db2 "select 'rebind '||pkgschema||'.'||pkgname||';' from syscat.packages where pkgschema='NULLIDR1'"|db2 +p -tv >> ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
db2 "select 'rebind '||pkgschema||'.'||pkgname||';' from syscat.packages where pkgschema='NULLIDRA'"|db2 +p -tv >> ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
db2 "select 'rebind '||pkgschema||'.'||pkgname||';' from syscat.packages where pkgschema='SYSIBMADM'"|db2 +p -tv >> ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
db2 "rebind sysibmadm.P1002212194"
db2 "rebind wscomusr.P1173926866"
db2 "rebind nullidr1.syslh100"
db2 "rebind nullid.AOTMH01"
db2 "rebind nullidra.syslh100"
db2 "select 'rebind '||pkgschema||'.'||pkgname||';' from syscat.packages where pkgschema='WSCOMUSR'"|db2 +p -tv >> ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
#if [[ $? -ne 0 ]]
# then
#  echo "Error occured performing rebind  for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $STARTDATE" >> $ERRORFILE
#  mailx -s "rebind  failed for INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER on $STARTDATE" ${TEAMMAIL} < $ERRORFILE
#else

ENDDATE=`date +"%A %Y-%m-%d %r"`

echo " You may check the list of packages that were rebound in the file: $RBRPT " >> ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out

mailx -s " Rebind completed successfully INSTANCE:$INST - DATABASE:$DBNAME - SERVER:$SERVER - HOSTIP:$SERVERIP on $ENDDATE" ${TEAMMAIL} < ${LOGLOC}/${INST}_${DBNAME}_${RDATE}.out
#fi

db2 terminate > /dev/null

find ${LOGLOC}  -name "RebindLog_${INST}*"   -type f -mtime +$RPTRETENTION  -exec rm -f {} \;
find ${LOGLOC}  -name "RebindErr_${INST}*"   -type f -mtime +$RPTRETENTION  -exec rm -f {} \;
find ${LOGLOC}  -name "*.out"  -type f -mtime +$RPTRETENTION  -exec rm -f {} \;

db2 connect reset > /dev/null

done

exit 0
