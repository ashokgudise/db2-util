#!/bin/bash

# Set recipient email address
###recipient="ranjith.thopucharla@dcsg.com"

# Execute commands and store output in a temporary file
temp_file=$(mktemp)
db2instance -list > $temp_file
/home/db2inst1/member_count.ksh >> $temp_file
/db2shared/db2scripts/QBSCRIPTS/script_diag_list.sh >> $temp_file
db2 connect to live >> $temp_file

db2 "SELECT SUBSTR(TO_CHAR(TO_TIMESTAMP(START_TIME, 'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS'),1,25) AS STARTTIME, SUBSTR(TO_CHAR(TO_TIMESTAMP(END_TIME, 'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS'),1,25) AS ENDTIME, SUBSTR(RTRIM(CHAR(TIMESTAMPDIFF(8,CHAR(TIMESTAMP(END_TIME) - TIMESTAMP(START_TIME))))) || ':'|| RTRIM(CHAR(MOD(INT(TIMESTAMPDIFF(4,CHAR(TIMESTAMP(END_TIME) - TIMESTAMP(START_TIME)))),60))),1,10) AS TOTAL_TIME, OPERATION, OPERATIONTYPE, SUBSTR(LOCATION,1,30) AS LOCATION FROM SYSIBMADM.DB_HISTORY WHERE OPERATION = 'B' AND SEQNUM = 1 AND DBPARTITIONNUM = 0 ORDER BY END_TIME DESC FETCH FIRST 1 ROW ONLY WITH UR" >> $temp_file
db2 "SELECT VARCHAR(TBSP_NAME,20), INT(TBSP_ID) AS ID, TBSP_TOTAL_PAGES AS TBSP_TOTAL_PAGES, TBSP_USABLE_PAGES AS TBSP_USABLE_PAGES, TBSP_USED_PAGES AS TBSP_USED_PAGES, TBSP_FREE_PAGES AS TBSP_FREE_PAGES, TBSP_PAGE_TOP TBSP_PAGE_TOP, TBSP_PENDING_FREE_PAGES FROM TABLE(SYSPROC.MON_GET_TABLESPACE('', -1)) ORDER BY TBSP_TOTAL_PAGES DESC with UR" >> $temp_file

# Send email with output file as attachment
#echo "Please find attached output of the commands." | mailx -s "Output of commands" -a "$temp_file" "$recipient"

db2 terminate >> $temp_file
cat "$temp_file"


# Delete temporary file and all emails
rm -f "$temp_file"
echo 'd *' | mailx >/dev/null 2>&1

exit 0
