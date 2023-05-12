#!/bin/sh

dbName=$1
scriptRoot=`dirname $0`

if [ -z "$dbName" ]
then
   echo Specify a database to connect to!
   exit 1
fi

db2 -v connect to $dbName
##db2 -v create bufferpool psmonbp
##db2 -v  create user temporary tablespace psmontmptbsp bufferpool psmonbp
file=`date +%Y-%m-%d.%H:%M:%S`
db2 +c -tvf $scriptRoot/psmon3.sql > psmon3.$file
db2 -v commit work
##db2 -v drop tablespace psmontmptbsp
##db2 -v drop bufferpool psmonbp
db2 -v connect reset
db2 -v terminate
gzip psmon3.$file

