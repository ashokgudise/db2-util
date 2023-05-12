#!/bin/bash
    . /home/db2inst1/sqllib/db2profile
DB_NAME=AUTH
DB_USER=$2
DB_PASSWORD=$4

echo "Connect to database $DB_NAME" >> /dev/null
db2 "connect to $DB_NAME user $DB_USER  using $DB_PASSWORD" >> /dev/null
db2 "set schema WSCOMUSR" >> /dev/null
db2 -x "select count(1) from staglog where stgprocessed = 0 with ur"|read line
echo "STAGLOG Unprocessed Record Count" : $line

db2 "connect reset" > /dev/null
db2 "terminate" > /dev/null
