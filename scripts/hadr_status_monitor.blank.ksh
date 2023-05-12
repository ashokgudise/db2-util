#!/bin/ksh
#------------------------------------------------------------------------------------
# This is a blank script
#----------------------------------------------------------------------------------

DBNAME=$1
typeset -u DBNAME
if [[ $# -ne 1 ]]
then
  echo "You Need to Supply the Database Name."
  echo "Syntax:  $0  dbname "
  exit 1
fi
exit 0

