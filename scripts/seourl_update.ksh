#!/bin/bash
    . /home/db2inst1/sqllib/db2profile
DB_NAME=AUTH
DB_USER=$2
DB_PASSWORD=$4

RDATE=`date +%m-%d-%y-%H:%M:%S`
LOGLOC=/db2shared/db2scripts/QBSCRIPTS/reports/SEOURL/
LOGFILE="${LOGLOC}seourl_update_${RDATE}"
SQLFILE="${LOGLOC}seourlkeyword_update.sql"
SQLFILELOG="${LOGLOC}seourlkeyword_update.sql.log"


echo "Connect to database $DB_NAME" > $LOGFILE
db2 connect to $DB_NAME user $DB_USER  using $DB_PASSWORD
echo "SEOURL Update"

db2 "set schema WSCOMUSR"
db2 "export to ${LOGLOC}SEOURLKEYWORD.csv of del modified by chardel'' coldel, select * from SEOURLKEYWORD with ur"
db2 "call WSCOMUSR.UPDATE_SEOURLKEYWORD(0)"
db2 "call WSCOMUSR.UPDATE_SEOURLKEYWORD(1)"
db2 -x "select LOGS as SQL from X_SEO_KEYWORD" > ${SQLFILE}
db2 -tvf ${SQLFILE} > ${SQLFILELOG}
db2 -x "select count(*) FROM  (SELECT A.SEOURL_ID,A.SEOURLKEYWORD_ID, A.URLKEYWORD,TRIM(TRANSLATE(A.URLKEYWORD,'','ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-')) AS SPLCHARS ,B.TOKENVALUE, B.TOKENNAME ,A.STOREENT_ID , C.CATENTTYPE_ID , C.CATENTRY_ID , C.PARTNUMBER FROM SEOURLKEYWORD A, SEOURL B ,CATENTRY C WHERE A.SEOURL_ID = B.SEOURL_ID AND A.STATUS=1  AND B.TOKENVALUE = CHAR(C.CATENTRY_ID) AND C.CATENTTYPE_ID='ProductBean'    )  WHERE LENGTH(TRIM(SPLCHARS)) > 0"|read line
echo "Records Pending" : $line

db2 connect reset > /dev/null
db2 terminate  > /dev/null
