#!/bin/bash

SEVERE_FILE="/db2shared/db2scripts/QBSCRIPTS/LOGS/HEALTHLOG/Severe.txt"
CRITICAL_FILE="/db2shared/db2scripts/QBSCRIPTS/LOGS/HEALTHLOG/Critical.txt"
ERROR_FILE="/db2shared/db2scripts/QBSCRIPTS/LOGS/HEALTHLOG/Error.txt"

# generate log files
db2diag -n 0,1,2,3,5 -g "level=Severe" -H 1d > $SEVERE_FILE
db2diag -n 0,1,2,3,5 -g "level=Critical" -H 1d > $CRITICAL_FILE
db2diag -n 0,1,2,3,5 -g "level=Error" -H 1d > $ERROR_FILE

# count the errors by severity
SEVERE_COUNT=$(cat $SEVERE_FILE | grep 'LEVEL: Severe' | wc -l)
CRITICAL_COUNT=$(cat $CRITICAL_FILE | grep 'LEVEL: Critical' | wc -l)
ERROR_COUNT=$(cat $ERROR_FILE | grep 'LEVEL: Error' | wc -l)

# count the errors by node
ERROR0=$(cat $ERROR_FILE | grep 'HOSTNAME: dkhl5801.dcsgomni.com' | wc -l)
ERROR1=$(cat $ERROR_FILE | grep 'HOSTNAME: dkhl5802.dcsgomni.com' | wc -l)
ERROR2=$(cat $ERROR_FILE | grep 'HOSTNAME: dkhl5803.dcsgomni.com' | wc -l)
ERROR3=$(cat $ERROR_FILE | grep 'HOSTNAME: dkhl5804.dcsgomni.com' | wc -l)
ERROR5=$(cat $ERROR_FILE | grep 'HOSTNAME: dkhl5805.dcsgomni.com' | wc -l)

# count the Severity by node
SEVER0=$(cat $SEVERE_FILE | grep 'HOSTNAME: dkhl5801.dcsgomni.com' | wc -l)
SEVER1=$(cat $SEVERE_FILE | grep 'HOSTNAME: dkhl5802.dcsgomni.com' | wc -l)
SEVER2=$(cat $SEVERE_FILE | grep 'HOSTNAME: dkhl5803.dcsgomni.com' | wc -l)
SEVER3=$(cat $SEVERE_FILE | grep 'HOSTNAME: dkhl5804.dcsgomni.com' | wc -l)
SEVER5=$(cat $SEVERE_FILE | grep 'HOSTNAME: dkhl5805.dcsgomni.com' | wc -l)

# count the Severity by node
CRIC0=$(cat $CRITICAL_FILE | grep 'HOSTNAME: dkhl5801.dcsgomni.com' | wc -l)
CRIC1=$(cat $CRITICAL_FILE | grep 'HOSTNAME: dkhl5802.dcsgomni.com' | wc -l)
CRIC2=$(cat $CRITICAL_FILE | grep 'HOSTNAME: dkhl5803.dcsgomni.com' | wc -l)
CRIC3=$(cat $CRITICAL_FILE | grep 'HOSTNAME: dkhl5804.dcsgomni.com' | wc -l)
CRIC5=$(cat $CRITICAL_FILE | grep 'HOSTNAME: dkhl5805.dcsgomni.com' | wc -l)

# print output in box format
echo "+++++++++++++++++"
echo "| Severity Counts |"
echo "+++++++++++++++++"
printf "Server             \tSevere\tCritical\tError\n"
printf "$(hostname)\t$SEVERE_COUNT\t$CRITICAL_COUNT\t\t$ERROR_COUNT\n"

echo "+++++++++++++++++++++++"
echo "| Error count by Host |"
echo "+++++++++++++++++++++++"
printf "Node\tError\tSEVERE\tCRITICAL\n"
printf "NODE0\t$ERROR0\t$SEVER0\t$CRIC0\n"
printf "NODE1\t$ERROR1\t$SEVER1\t$CRIC1\n"
printf "NODE2\t$ERROR2\t$SEVER2\t$CRIC2\n"
printf "NODE3\t$ERROR3\t$SEVER3\t$CRIC3\n"
printf "NODE5\t$ERROR5\t$SEVER5\t$CRIC5\n"

# get the count of distinct messages and their repetition count from Error.txt
echo "+++++++++++++"
echo "| Error Counts |"
echo "+++++++++++++"
echo "Distinct Error Message Counts:"
cat $ERROR_FILE | awk -F'MESSAGE' '{print $2}' | sort | uniq -c | sort -nr | tail -n +2
cat $ERROR_FILE | awk -F'RETCODE' '{print $2}' | sort | uniq -c | sort -nr | tail -n +2

# get the count of distinct messages and their repetition count from Severe.txt
echo "+++++++++++++++++"
echo "| Severity Counts |"
echo "+++++++++++++++++"
echo "Distinct Severity Message Counts:"
cat $SEVERE_FILE | awk -F'MESSAGE' '{print $2}' | sort | uniq -c | sort -nr | tail -n +2
cat $SEVERE_FILE | awk -F'RETCODE' '{print $2}' | sort | uniq -c | sort -nr | tail -n +2

# get the count of distinct messages and their repetition count from Critical.txt
echo "+++++++++++++++++"
echo "| Critical Counts |"
echo "+++++++++++++++++"
echo "Distinct Critical Message Counts:"
cat $CRITICAL_FILE | awk -F'MESSAGE' '{print $2}' | sort | uniq -c | sort -nr | tail -n +2
cat $CRITICAL_FILE | awk -F'RETCODE' '{print $2}' | sort | uniq -c | sort -nr | tail -n +2
