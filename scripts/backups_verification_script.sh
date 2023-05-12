#!/bin/bash

. $HOME/sqllib/db2profile >/dev/null 2>&1
#TEAMMAIL="eCommDBA@dcsg.com"
TEAMMAIL="ranjith.thopucharla@dcsg.com"
BACKUP_FOLDER="/backup/DB2_Online_Backups"
BACKUP_FILE_PATTERN="LIVE.0.db2inst1.DBPART000*"
BACKUP_VERIFICATION_FILE="backup_verification.out"
LATEST_BACKUP_TIMESTAMP=$(stat -c "%y" $BACKUP_FOLDER/$(ls -t $BACKUP_FOLDER | grep $BACKUP_FILE_PATTERN | head -1))

cd $BACKUP_FOLDER

# List all files matching the pattern and count them
BACKUP_FILES=($BACKUP_FOLDER/$BACKUP_FILE_PATTERN)
BACKUP_FILE_COUNT=${#BACKUP_FILES[@]}


# Verify that exactly 6 files are present
if [[ $BACKUP_FILE_COUNT -ne 6 ]]; then
  ERROR_MESSAGE="Error: Expected 6 backup files but found $BACKUP_FILE_COUNT"
  echo "$ERROR_MESSAGE"
  echo "$ERROR_MESSAGE" | mail -s "Backup verification failed" $TEAMMAIL
  exit 1
fi

# Strip the directory path from the file names
for ((i=0; i<$BACKUP_FILE_COUNT; i++)); do
  BACKUP_FILES[$i]=$(basename "${BACKUP_FILES[$i]}")
done

# Prepare db2ckbkp command with file names and output to file
DB2CKBKP_COMMAND="db2ckbkp -v ${BACKUP_FILES[*]}"
echo "Running command: $DB2CKBKP_COMMAND"
$DB2CKBKP_COMMAND > $BACKUP_VERIFICATION_FILE

# Print the last five lines of the output file
tail -n 5 $BACKUP_VERIFICATION_FILE

# Prepare email with backup file list and last five lines of output file
EMAIL_SUBJECT="Backup verification report ($LATEST_BACKUP_TIMESTAMP)"
EMAIL_BODY=$(printf "Backup files:\n%s\n\nLast five lines of output file:\n%s" "$(printf '%s\n' "${BACKUP_FILES[@]}")" "$(tail -n 5 $BACKUP_VERIFICATION_FILE)")

# Send email
echo "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" $TEAMMAIL

