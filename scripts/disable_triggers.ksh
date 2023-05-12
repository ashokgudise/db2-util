#!/usr/bin/ksh
################################################################################
#                                                                              #
#      Title:        Disable triggers                                          #
#                                                                              #
#      Author:       Ralph Button                                              #
#      Language:     Korn Shell                                                #
#      Purpose:      This script will disable triggers                         #
#      Instructions: Only the instance owner can execute the script name       #
#                    at the command line.   This script will generate a return #
#                    code of 0 if successful.                                  #
#                                                                              #
################################################################################
#   The command set -vx allows you to debug in verbose mode.  To utilize remove
#   the # sign in front of the command.  Be sure to remove the command line at
#   the end of the application for set +vx to turn verbose off when the
#   application ends.
################################################################################

## set -x

################################################################################
# Determine the name of the server.
################################################################################

ServerName=`hostname`

################################################################################
#   Initialize variables.
################################################################################

SQLCODE=0
RC=0
Node=0

################################################################################
#   Check to make sure the correct parameters were passed.
################################################################################
USAGE="\n USAGE: disable_triggers.ksh [database] \n  accepts name of database"
USAGE2="\n\"system\" The only option you have to include with this command \n database\n "
if [ $# -lt 1 ]
then
   if [ $# -eq 0 ]
   then
      echo $USAGE
      exit
   else
      if [ $1 = -? ]
      then
         echo $USAGE2
         exit
      else
         echo $USAGE
         exit
      fi
   fi
   echo $USAGE
   exit
fi

if [ $1 = -? ]
then
   echo $USAGE2
   exit
fi

typeset -u DATABASE=$1

################################################################################
#   Identify current instance name.
################################################################################

instance=db2inst1

################################################################################
#   Export all defined variables.
################################################################################

set -a

################################################################################
#   Begin the main logic of the program.
################################################################################


#############################################################################
#   Connect to the database.
#############################################################################
RC=0
db2 terminate;
export DB2NODE=0
SQLCODE=0
SQLCODE=`db2 -ec +o "connect to $DATABASE"`;

if [ $SQLCODE -ne 0 ]
then
   echo "Error: Connecting to Database $DATABASE" 
   echo "Error: SQLCODE =" $SQLCODE 
   exit 5
else
   echo "Info: Connected to Database $DATABASE" 
fi

db2 "CALL trigtool.disable_trigger('WSCOMUSR','CIVI_ATTR')";
db2 "CALL trigtool.disable_trigger('WSCOMUSR','CIVD_ATTR')";
db2 "CALL trigtool.disable_trigger('WSCOMUSR','CIVU_ATTR')";

db2 "CALL trigtool.disable_trigger('WSCOMUSR','CIVI_ATTRVAL')";
db2 "CALL trigtool.disable_trigger('WSCOMUSR','CIVU_ATTRVAL')";

db2 "CALL trigtool.disable_trigger('WSCOMUSR','CIVI_ATTVALDSC')";
db2 "CALL trigtool.disable_trigger('WSCOMUSR','CIVU_ATTVALDSC')";

db2 "CALL trigtool.show_disabled_triggers()";

db2 terminate;

exit 0