#!/bin/bash

# Change to the directory containing the backup files
cd /backup/DB2_Online_Backups

# Loop through each number from 1 to 6
for i in {1..6}
do
  # Find the backup file ending in the current number and store its name in a variable
  file=$(find . -type f -name "*00$i")

  # Pass the file name as an argument to the db2ckbkp command
  set -- "$@" "$file"
done

# Run the db2ckbkp command with the newly renamed backup files
db2ckbkp -v "$@"

