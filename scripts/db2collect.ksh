#!/bin/sh

# -------------------------------------------------------------------
#  Licensed Materials - Property of IBM
#
#  WebSphere Commerce
#
#  (c) Copyright International Business Machines Corporation. 2015
#      All rights reserved.
#
#  US Government Users Restricted Rights - Use, duplication or
#  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# -------------------------------------------------------------------
#  The script herein is provided to you "AS IS".
#
#  It has not been thoroughly tested under all conditions.  IBM,
#  therefore, cannot guarantee its reliability, serviceability or
#  functionality.
#
# ---------------------------------------------------------------------

# CHANGE HISTORY
# ---------------------------------------------------------------------
# 1.15 - Added export for transaction logs and HADR stats
# 1.14 - Changes to return all workloads and agents types. Now supported by
#        the report tool
# 1.13 - Added MAX_PKGCACHE_ROWS for package cache export for installations
#        that do not use parameter markers. Large exports can slowdown the tool
# 1.12 - Added buffer pool hit ratio exports
# 1.11 - Resolves issue with rounding of TOTAL_CPU_TIME_ML that could
#        cause the Performance section (package cache) not to show.
#

C_SCRIPT_NAME="db2report"
C_SCRIPT_PRODUCT="WCS"
C_SCRIPT_VERSION="1.15.4"

# Mustgather script for WebSphere Commerce DB2 Report Tool
# https://wcsupport.mybluemix.net/wcdb2/


# SCRIPT FLOW
# ---------------------------------------------------------------------
#
# Initial config collection
#
# environment
# db2set
# dbcfg
# dbmcfg
# db2level
# sysinfo
# tables
# indexes
# wcs site
#
# package cache (1)
#
# Loop for NUM_COLLECTIONS (5)
#  - workload
#  - lock wait
#  - agents
#  - connections
#  - current sql
#  - bufferpool hit ratios
#  - transaction logs
#  - hadr stats
#  - SLEEP (180)
#
# FINAL_SLEEP (0)
#
# package cache (2)
# Zip and end
#
# Estimated run time = 180 * (5-1) + 0 = 12 minutes
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# CONFIGURABLE PARAMETERS
# ---------------------------------------------------------------------

# Number of collections
# Most reports in the tool only display the last 7 collections
# To display more collections, run the script several times
NUM_COLLECTIONS=3

# Use SLEEP values above 60
SLEEP=120

# Final sleep. Can be used to give more time before the final pkgcache dump
FINAL_SLEEP=0

THISSCRIPT=/db2shared/db2scripts/QBSCRIPTS/db2collect2.sh

#########################################################

if [ "$#" -ne "1" ]
  then echo "Parameter required: DBNAME"; exit
fi

DBNAME=$1
cd /db2shared/db2scripts/QBSCRIPTS/db2collect2
SCRIPTLOGNAME=/db2shared/db2scripts/QBSCRIPTS/db2collect2/collect2.log
### SCRIPTLOGNAME=collect.log

FILELIST=

> $SCRIPTLOGNAME


C_SCRIPT_TZ=`date +"%Z"`
C_SCRIPT_START=`date +"%Y-%m-%d-%H.%M.%S"`


# assumes OS authentication
. /home/db2inst1/sqllib/db2profile

db2 connect to $DBNAME >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to connect to the database $DBNAME."
   exit
fi

db2 set current isolation ur

APROX_DURATION=$(( (($NUM_COLLECTIONS-1) * $SLEEP + $FINAL_SLEEP) / 60 ))

echo
echo "* ---------------------------------"
echo "* Database: $DBNAME"
echo "* ---------------------------------"
echo "* NUM_COLLECTIONS = $NUM_COLLECTIONS"
echo "* SLEEP           = $SLEEP"
echo "* FINAL_SLEEP     = $FINAL_SLEEP"
echo "* DURATION MINS   = $APROX_DURATION"
echo "* ---------------------------------"
echo

# Obtain current connection handle - can be used to exclude this connection from the reports
DB2_APP_HANDLE=`db2 -x "VALUES(application_id()) /* wcs_db2collect */"` 2>> $SCRIPTLOGNAME
if [ "$?" -ne "0" ]
then
   echo "Unable to read app handle"
   exit
fi

echo "* Exporting config data"
echo "* ---------------------------------"


#
# DB2 level
#
#
#
{ time db2 "EXPORT TO db2level.tmp OF DEL MODIFIED BY NOCHARDEL SELECT service_level FROM sysibmadm.env_inst_info /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to read db2 level"
   exit
fi

DB2_LEVEL=`cat db2level.tmp`

rm db2level.tmp

echo "* DB2 level: $DB2_LEVEL"

#
# current environment
#
#
#
echo "* Exporting current environment"
{ time db2 "EXPORT TO currenv.1.csv OF DEL SELECT CURRENT SERVER current_server, CURRENT USER current_user, CURRENT TIMEZONE current_timezone FROM sysibm.sysdummy1 /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to export currenv"
   exit
fi

FILELIST="$FILELIST currenv.1.csv"

#
# db2set
#
# http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0022350.html
#
echo "* Exporting db2set"
{ time db2 "EXPORT TO db2set.1.csv OF DEL SELECT dbpartitionnum, reg_var_name, reg_var_value, is_aggregate, aggregate_name, level FROM sysibmadm.reg_variables /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to export db2set"
   exit
fi

FILELIST="$FILELIST db2set.1.csv"

#
# dbcfg
#
# http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0022028.html
#
echo "* Exporting dbcfg"
{ time db2 "EXPORT TO dbcfg.1.csv OF DEL SELECT dbpartitionnum, name, DECODE( value_flags, 'NONE', value, value_flags || '(' || value || ')'  ) || DECODE( value, deferred_value, '', ( ' - DEFERRED VALUE: ' || DECODE( deferred_value_flags , 'NONE', deferred_value, deferred_value_flags || '(' || deferred_value || ')'  )) ) value FROM sysibmadm.dbcfg /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to export dbcfg"
   exit
fi

FILELIST="$FILELIST dbcfg.1.csv"

#
# dbm cfg
#
# http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0022029.html
#
echo "* Exporting dbmcfg"
{ time db2 "EXPORT TO dbmcfg.1.csv OF DEL SELECT name, DECODE( value_flags, 'NONE', value, value_flags || '(' || value || ')'  ) || DECODE( value, deferred_value, '', ( ' - DEFERRED VALUE: ' || DECODE( deferred_value_flags , 'NONE', deferred_value, deferred_value_flags || '(' || deferred_value || ')'  )) ) value FROM sysibmadm.dbmcfg /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to export dbm cfg"
   exit
fi

FILELIST="$FILELIST dbmcfg.1.csv"

#
# Instance info
#
# http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0022040.html
#
echo "* Exporting instance info"
{ time db2 "EXPORT TO instinfo.1.csv OF DEL SELECT inst_name, num_dbpartitions, service_level FROM sysibmadm.env_inst_info /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to export instance info"
   exit
fi

FILELIST="$FILELIST instinfo.1.csv"

#
# System info
#
# http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0022039.html
#
echo "* Exporting system info"
{ time db2 "EXPORT TO sysinfo.1.csv OF DEL SELECT host_name, total_cpus, configured_cpus, total_memory, os_name || ' ' || os_version || '.' || os_release os_full_version FROM sysibmadm.env_sys_info /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to export system info"
   exit
fi

FILELIST="$FILELIST sysinfo.1.csv"

#
# Tables
#
# http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.ref.doc/doc/r0001063.html
#
echo "* Exporting tables"
{ time db2 "EXPORT TO tables.1.csv OF DEL modified by timestampformat=\"YYYY-MM-DD HH:MM:SS\" SELECT tabschema, tabname, type, status, create_time, alter_time, stats_time, tableid, tbspace, card, DECODE( volatile, 'C', 'YES','NO') volatile FROM syscat.tables WHERE tabschema NOT LIKE 'SYS%' /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to export tables"
   exit
fi

FILELIST="$FILELIST tables.1.csv"

#
# Indexes
#
# http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.ref.doc/doc/r0001047.html
#
echo "* Exporting indexes"
{ time db2 "EXPORT TO indexes.1.csv OF DEL modified by timestampformat=\"YYYY-MM-DD HH:MM:SS\" SELECT indschema, indname, tabschema, tabname, uniquerule, create_time, stats_time, colnames FROM syscat.indexes WHERE tabschema NOT LIKE 'SYS%' /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to export indexes"
   exit
fi

FILELIST="$FILELIST indexes.1.csv"

#
# Find out WCS schema
#
{ time db2 "EXPORT TO schema.tmp OF DEL SELECT RTRIM(tabschema) FROM syscat.tables WHERE tabname='SITE' AND type = 'T' FETCH FIRST ROW ONLY /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to read schema"
   exit
fi

WCS_SCHEMA=`cat schema.tmp`

rm schema.tmp

echo "* WCS schema: $WCS_SCHEMA"

#
# wcs.site
#
# http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.ref.doc/doc/r0001047.html
#
echo "* Exporting WCS $WCS_SCHEMA.SITE table"
{ time db2 "EXPORT TO site.1.csv OF DEL SELECT databasevendor, edition, version, release, mod, fixpack, compname FROM $WCS_SCHEMA.site /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to export wcs site"
   exit
fi


FILELIST="$FILELIST site.1.csv"


# NUM_COLLECTIONS
LOOPS=$(($NUM_COLLECTIONS+1))

SNAP_TIME=`date +"%Y-%m-%d-%H.%M.%S"`
SNAP_TIME_COL="TIMESTAMP('"$SNAP_TIME"') snapshot_time"


# Max number of pkgcache rows to return
# This is for when there are queries without parameter markers that can fill up the package cache and slowdown the tool
MAX_PKGCACHE_ROWS=30000

#
# Package cache - Intial
#
# http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0055017.html
#
echo "* Exporting package cache"

# Only include SQLs that had activity within the past hour
MODIFIED_WITHIN=60

{ time db2 "EXPORT TO pkgcache.1.$SNAP_TIME.csv OF DEL MODIFIED BY TIMESTAMPFORMAT=\"YYYY-MM-DD HH:MM:SS\" SELECT $SNAP_TIME_COL, pkg.member, pkg.section_type, pkg.insert_timestamp, HEX(pkg.executable_id) executable_id, pkg.package_schema, pkg.package_name, pkg.package_version_id, pkg.section_number, pkg.effective_isolation, pkg.num_executions, pkg.num_exec_with_metrics, pkg.prep_time, pkg.total_act_time, pkg.total_act_wait_time, pkg.total_cpu_time, CAST((pkg.total_cpu_time/1000) AS BIGINT) total_cpu_time_ml, pkg.pool_read_time, pkg.pool_write_time, pkg.direct_read_time, pkg.direct_write_time, pkg.lock_wait_time, pkg.total_section_sort_time, pkg.total_section_sort_proc_time, pkg.total_section_sorts, pkg.lock_escals, pkg.lock_waits, pkg.rows_modified, pkg.rows_read, pkg.rows_returned, pkg.direct_reads, pkg.direct_read_reqs, pkg.direct_writes, pkg.direct_write_reqs, pkg.pool_data_l_reads, pkg.pool_temp_data_l_reads, pkg.pool_xda_l_reads, pkg.pool_temp_xda_l_reads, pkg.pool_index_l_reads, pkg.pool_temp_index_l_reads, pkg.pool_data_p_reads, pkg.pool_temp_data_p_reads, pkg.pool_xda_p_reads, pkg.pool_temp_xda_p_reads, pkg.pool_index_p_reads, pkg.pool_temp_index_p_reads, pkg.pool_data_writes, pkg.pool_xda_writes, pkg.pool_index_writes, pkg.total_sorts, pkg.post_threshold_sorts, pkg.post_shrthreshold_sorts, pkg.sort_overflows, pkg.wlm_queue_time_total, pkg.wlm_queue_assignments_total, pkg.deadlocks, pkg.fcm_recv_volume, pkg.fcm_recvs_total, pkg.fcm_send_volume, pkg.fcm_sends_total, pkg.fcm_recv_wait_time, pkg.fcm_send_wait_time, pkg.lock_timeouts, pkg.log_buffer_wait_time, pkg.num_log_buffer_full, pkg.log_disk_wait_time, pkg.log_disk_waits_total, pkg.last_metrics_update, pkg.num_coord_exec, pkg.num_coord_exec_with_metrics, pkg.valid, pkg.total_routine_time, pkg.total_routine_invocations, pkg.routine_id, pkg.stmt_type_id, pkg.query_cost_estimate, pkg.stmt_pkg_cache_id, pkg.coord_stmt_exec_time, pkg.stmt_exec_time, pkg.total_section_time, pkg.total_section_proc_time, pkg.total_routine_non_sect_time, pkg.total_routine_non_sect_proc_time, CAST(RTRIM(SUBSTR(pkg.stmt_text,1,10000)) AS VARCHAR(10000)) stmt_text FROM TABLE(mon_get_pkg_cache_stmt(NULL, NULL, '<modified_within>$MODIFIED_WITHIN</modified_within>', -1) ) AS pkg FETCH FIRST $MAX_PKGCACHE_ROWS ROWS ONLY /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
if [ "$?" -ne "0" ]
then
   echo "Unable to export package cache"
   exit
fi

FILELIST="$FILELIST pkgcache.1.$SNAP_TIME.csv"

# Look for message SQL3105N  The Export utility has finished exporting "624" rows.

ROWS_EXPORTED=`awk -F '"' '/SQL3105N/ { a=$2 } END { print a }' $SCRIPTLOGNAME`

echo "* Rows exported from package cache: $ROWS_EXPORTED"

if [ "$MAX_PKGCACHE_ROWS" -eq "$ROWS_EXPORTED" ]
then
   echo ""
   echo "*** Rows exported from package cache ($ROWS_EXPORTED) matches the MAX_PKGCACHE_ROWS setting"
   echo "*** Export could be truncated"
   echo "*** Consider adding 'ORDER BY pkg.stmt_exec_time' prior to 'FETCH FIRST' to the pkgcache export statements"
   echo "*** to ensure the most time consuming queries are included."
   echo ""
fi

l=1
while [ $l -lt $LOOPS ]
do

  if [ "$l" -ne "1" ]
  then
    # sleep and collect again
    echo
    echo "* Sleeping for $SLEEP seconds...."
    sleep $SLEEP

    SNAP_TIME=`date +"%Y-%m-%d-%H.%M.%S"`
    SNAP_TIME_COL="TIMESTAMP('"$SNAP_TIME"') snapshot_time"
  fi

  echo
  echo "* Collection $l of $NUM_COLLECTIONS"
  echo "* ---------------------------------"

  #
  # Workload
  #
  # http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0053940.html
  #
  echo "* Exporting workload"
	{ time db2 "EXPORT TO workload.1.$SNAP_TIME.csv OF DEL MODIFIED BY TIMESTAMPFORMAT=\"YYYY-MM-DD HH:MM:SS\" SELECT $SNAP_TIME_COL, workload_name, workload_id, member, act_aborted_total, act_completed_total, act_rejected_total, agent_wait_time, agent_waits_total, pool_data_l_reads, pool_index_l_reads, pool_temp_data_l_reads, pool_temp_index_l_reads, pool_temp_xda_l_reads, pool_xda_l_reads, pool_data_p_reads, pool_index_p_reads, pool_temp_data_p_reads, pool_temp_index_p_reads, pool_temp_xda_p_reads, pool_xda_p_reads, pool_data_writes, pool_index_writes, pool_xda_writes, pool_read_time, pool_write_time, client_idle_wait_time, deadlocks, direct_reads, direct_read_time, direct_writes, direct_write_time, direct_read_reqs, direct_write_reqs, fcm_recv_volume, fcm_recvs_total, fcm_send_volume, fcm_sends_total, fcm_recv_wait_time, fcm_send_wait_time, ipc_recv_volume, ipc_recv_wait_time, ipc_recvs_total, ipc_send_volume, ipc_send_wait_time, ipc_sends_total, lock_escals, lock_timeouts, lock_wait_time, lock_waits, log_buffer_wait_time, num_log_buffer_full, log_disk_wait_time, log_disk_waits_total, rqsts_completed_total, rows_modified, rows_read, rows_returned, tcpip_recv_volume, tcpip_send_volume, tcpip_recv_wait_time, tcpip_recvs_total, tcpip_send_wait_time, tcpip_sends_total, total_app_rqst_time, total_rqst_time, wlm_queue_time_total, wlm_queue_assignments_total, total_cpu_time, CAST((total_cpu_time/1000) AS BIGINT) total_cpu_time_ml,  total_wait_time, app_rqsts_completed_total, total_section_sort_time, total_section_sort_proc_time, total_section_sorts, total_sorts, post_threshold_sorts, post_shrthreshold_sorts, sort_overflows, total_compile_time, total_compile_proc_time, total_compilations, total_implicit_compile_time, total_implicit_compile_proc_time, total_implicit_compilations, total_section_time, total_section_proc_time, total_app_section_executions, total_act_time, total_act_wait_time, act_rqsts_total, total_routine_time, total_routine_invocations, total_commit_time, total_commit_proc_time, total_app_commits, int_commits, total_rollback_time, total_rollback_proc_time, total_app_rollbacks, int_rollbacks, total_runstats_time, total_runstats_proc_time, total_runstats, total_reorg_time, total_reorg_proc_time, total_reorgs, total_load_time, total_load_proc_time, total_loads, cat_cache_inserts, cat_cache_lookups, pkg_cache_inserts, pkg_cache_lookups, thresh_violations, num_lw_thresh_exceeded FROM TABLE(mon_get_workload('',-1)) AS w /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
  if [ "$?" -ne "0" ]
  then
     echo "Unable to export workload"
     exit
  fi

  FILELIST="$FILELIST workload.1.$SNAP_TIME.csv"


  #
  # Lock waits
  #
  # http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0022018.html
  #
  echo "* Exporting lock waits"
  { time db2 "EXPORT TO lockwait.1.$SNAP_TIME.csv OF DEL MODIFIED BY TIMESTAMPFORMAT=\"YYYY-MM-DD HH:MM:SS\" SELECT $SNAP_TIME_COL, lock_name, lock_object_type, lock_wait_elapsed_time, RTRIM(tabschema), tabname, data_partition_id, lock_mode, lock_current_mode, lock_mode_requested, req_application_handle, req_agent_tid, req_member, req_application_name, RTRIM(req_userid),  CAST(RTRIM(SUBSTR(req_stmt_text, 1, 10000)) AS VARCHAR(10000)) req_stmt_text, hld_application_handle, hld_member, hld_application_name, hld_userid, CAST(RTRIM(SUBSTR(hld_current_stmt_text, 1, 10000)) AS VARCHAR(10000)) hld_current_stmt_text FROM sysibmadm.mon_lockwaits /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
  if [ "$?" -ne "0" ]
  then
     echo "Unable to export lock waits"
     exit
  fi

  FILELIST="$FILELIST lockwait.1.$SNAP_TIME.csv"

  #
  # Agents
  #
  # http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0052915.html
  #
  echo "* Exporting agents"
  { time db2 "EXPORT TO agents.2.$SNAP_TIME.csv OF DEL MODIFIED BY TIMESTAMPFORMAT=\"YYYY-MM-DD HH:MM:SS\" SELECT $SNAP_TIME_COL, service_superclass_name, service_subclass_name, application_handle, dbpartitionnum, entity, uow_id, activity_id, event_type, event_object, event_state, request_type, application_id FROM TABLE(WLM_GET_SERVICE_CLASS_AGENTS(CAST(NULL AS VARCHAR(128)),CAST(NULL AS VARCHAR(128)),CAST(NULL AS BIGINT),-1)) /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
  if [ "$?" -ne "0" ]
  then
     echo "Unable to export agents"
     exit
  fi

  FILELIST="$FILELIST agents.2.$SNAP_TIME.csv"

  #
  # Connections
  #
  # http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0053938.html
  #
  echo "* Exporting connections"
  { time db2 "EXPORT TO connections.1.$SNAP_TIME.csv OF DEL MODIFIED BY TIMESTAMPFORMAT=\"YYYY-MM-DD HH:MM:SS\" SELECT $SNAP_TIME_COL, application_handle, application_name, application_id, member, client_wrkstnname, client_acctng, client_userid, client_applname, client_pid, client_platform, client_protocol, system_auth_id, session_auth_id, connection_start_time, client_idle_wait_time FROM TABLE(MON_GET_CONNECTION(cast(NULL as bigint), -1)) AS t /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
  if [ "$?" -ne "0" ]
  then
     echo "Unable to export connections"
     exit
  fi

  FILELIST="$FILELIST connections.1.$SNAP_TIME.csv"

  #
  # Current SQL
  #
  # http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0056511.html
  #
  echo "* Exporting current sql"
  { time db2 "EXPORT TO currsql.1.$SNAP_TIME.csv OF DEL MODIFIED BY TIMESTAMPFORMAT=\"YYYY-MM-DD HH:MM:SS\" SELECT $SNAP_TIME_COL, coord_member, application_handle, application_name, session_auth_id, client_applname, elapsed_time_sec, activity_state, activity_type, total_cpu_time, rows_read, rows_returned, query_cost_estimate, direct_reads, direct_writes, CAST(RTRIM(SUBSTR(stmt_text, 1, 10000)) AS VARCHAR(10000)) stmt_text FROM sysibmadm.mon_current_sql /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
  if [ "$?" -ne "0" ]
  then
     echo "Unable to export current sql"
     exit
  fi

  FILELIST="$FILELIST currsql.1.$SNAP_TIME.csv"

  #
  # bp ratios
  #
  # http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0053942.html
  #
  echo "* Exporting bp ratios"
  { time db2 "EXPORT TO bpratio.1.$SNAP_TIME.csv OF DEL MODIFIED BY TIMESTAMPFORMAT=\"YYYY-MM-DD HH:MM:SS\" WITH bpmetrics AS ( SELECT member, bp_name, pool_data_l_reads + pool_temp_data_l_reads + pool_index_l_reads + pool_temp_index_l_reads + pool_xda_l_reads + pool_temp_xda_l_reads as logical_reads, pool_data_p_reads + pool_temp_data_p_reads + pool_index_p_reads + pool_temp_index_p_reads + pool_xda_p_reads + pool_temp_xda_p_reads as physical_reads FROM TABLE(MON_GET_BUFFERPOOL('',-1)) AS metrics ) SELECT $SNAP_TIME_COL, member, bp_name, logical_reads, physical_reads, CASE WHEN logical_reads > 0 THEN DEC((1 - (FLOAT(physical_reads) / FLOAT(logical_reads))) * 100,5,2) ELSE NULL END AS hit_ratio FROM bpmetrics /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
  if [ "$?" -ne "0" ]
  then
     echo "Unable to export bp ratios"
     exit
  fi

  FILELIST="$FILELIST bpratio.1.$SNAP_TIME.csv"

  #
  # MON_GET_TRANSACTION_LOG table function - Get log information
  #
  # https://www.ibm.com/support/knowledgecenter/SSEPGG_10.5.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0059253.html
  #
  echo "* Exporting transaction logs stats"
  { time db2 "EXPORT TO tranlogs.1.$SNAP_TIME.csv OF DEL MODIFIED BY TIMESTAMPFORMAT=\"YYYY-MM-DD HH:MM:SS\" SELECT $SNAP_TIME_COL,member,total_log_available,total_log_used,sec_log_used_top,tot_log_used_top,sec_logs_allocated,log_reads,log_read_time,log_writes,log_write_time,num_log_write_io,num_log_read_io,num_log_part_page_io,num_log_buffer_full,num_log_data_found_in_buffer,applid_holding_oldest_xact,log_to_redo_for_recovery,log_held_by_dirty_pages,first_active_log,last_active_log,current_active_log,current_archive_log,cur_commit_disk_log_reads,cur_commit_total_log_reads,cur_commit_log_buff_log_reads,archive_method1_status,method1_next_log_to_archive,method1_first_failure,archive_method2_status,method2_next_log_to_archive,method2_first_failure,log_chain_id,current_lso,current_lsn,oldest_tx_lsn,num_logs_avail_for_rename,num_indoubt_trans,log_hadr_wait_time,log_hadr_waits_total FROM TABLE(MON_GET_TRANSACTION_LOG(-1)) AS tranlogs /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
  if [ "$?" -eq "0" ]
  then
     FILELIST="$FILELIST tranlogs.1.$SNAP_TIME.csv"
  else
     echo "Unable to export transaction logs stats (DB 10.1+ is required)"
  fi

  if [ "$DB2_LEVEL" != "DB2 v10.5.0.4" ]
  then

    #
    # MON_GET_HADR table function - Returns high availability disaster recovery (HADR) monitoring information
    #
    # https://www.ibm.com/support/knowledgecenter/SSEPGG_10.5.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0059275.html
    #
    echo "* Exporting HADR stats"
    { time db2 "EXPORT TO hadr.2.$SNAP_TIME.csv OF DEL MODIFIED BY TIMESTAMPFORMAT=\"YYYY-MM-DD HH:MM:SS\" SELECT $SNAP_TIME_COL,hadr_role,replay_type,hadr_syncmode,standby_id,log_stream_id,hadr_state,primary_member_host,primary_instance,primary_member,standby_member_host,standby_instance,standby_member,hadr_connect_status,hadr_connect_status_time,heartbeat_interval,hadr_timeout,time_since_last_recv,peer_wait_limit,log_hadr_wait_cur,log_hadr_wait_time,log_hadr_waits_total,sock_send_buf_requested,sock_send_buf_actual,sock_recv_buf_requested,sock_recv_buf_actual,primary_log_file,primary_log_page,primary_log_pos,primary_log_time,standby_log_file,standby_log_page,standby_log_pos,standby_log_time,hadr_log_gap,standby_replay_log_file,standby_replay_log_page,standby_replay_log_pos,standby_replay_log_time,standby_recv_replay_gap,standby_replay_delay,standby_recv_buf_size,standby_recv_buf_percent,standby_spool_limit,peer_window,peer_window_end,takeover_app_remaining_primary,takeover_app_remaining_standby,reads_on_standby_enabled,standby_replay_only_window_active,standby_replay_only_window_start,standby_replay_only_window_tran_count FROM TABLE(MON_GET_HADR(-1)) AS hadr /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
    if [ "$?" -eq "0" ]
    then
       FILELIST="$FILELIST hadr.2.$SNAP_TIME.csv"
    else
       echo "Unable to export hadr stats (DB 10.1+ is required)"
    fi

  else
    echo "DB2 level matches v10.5.0.4. Skipping MON_GET_HADR call due to http://www-01.ibm.com/support/docview.wss?uid=swg1IT04151"
  fi

  l=`expr $l + 1`

done

if [ "$FINAL_SLEEP" -ne "0" ]
then
  echo "* Sleeping for $FINAL_SLEEP seconds (final)...."
  sleep $FINAL_SLEEP
fi

SNAP_TIME=`date +"%Y-%m-%d-%H.%M.%S"`
SNAP_TIME_COL="TIMESTAMP('"$SNAP_TIME"') snapshot_time"

#
# Package cache - final
#
# http://www.ibm.com/support/knowledgecenter/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0055017.html
#

if [ $NUM_COLLECTIONS -gt 1 ]
then

  echo
  echo "* Exporting package cache (final)"

  # Capture SQLs modified within the delta. 5 minute buffer to account for execution time
  MODIFIED_WITHIN=$(( ($APROX_DURATION) + 5 ))

	{ time db2 "EXPORT TO pkgcache.1.$SNAP_TIME.csv OF DEL MODIFIED BY TIMESTAMPFORMAT=\"YYYY-MM-DD HH:MM:SS\" SELECT $SNAP_TIME_COL, pkg.member, pkg.section_type, pkg.insert_timestamp, HEX(pkg.executable_id) executable_id, pkg.package_schema, pkg.package_name, pkg.package_version_id, pkg.section_number, pkg.effective_isolation, pkg.num_executions, pkg.num_exec_with_metrics, pkg.prep_time, pkg.total_act_time, pkg.total_act_wait_time, pkg.total_cpu_time, CAST((pkg.total_cpu_time/1000) AS BIGINT) total_cpu_time_ml, pkg.pool_read_time, pkg.pool_write_time, pkg.direct_read_time, pkg.direct_write_time, pkg.lock_wait_time, pkg.total_section_sort_time, pkg.total_section_sort_proc_time, pkg.total_section_sorts, pkg.lock_escals, pkg.lock_waits, pkg.rows_modified, pkg.rows_read, pkg.rows_returned, pkg.direct_reads, pkg.direct_read_reqs, pkg.direct_writes, pkg.direct_write_reqs, pkg.pool_data_l_reads, pkg.pool_temp_data_l_reads, pkg.pool_xda_l_reads, pkg.pool_temp_xda_l_reads, pkg.pool_index_l_reads, pkg.pool_temp_index_l_reads, pkg.pool_data_p_reads, pkg.pool_temp_data_p_reads, pkg.pool_xda_p_reads, pkg.pool_temp_xda_p_reads, pkg.pool_index_p_reads, pkg.pool_temp_index_p_reads, pkg.pool_data_writes, pkg.pool_xda_writes, pkg.pool_index_writes, pkg.total_sorts, pkg.post_threshold_sorts, pkg.post_shrthreshold_sorts, pkg.sort_overflows, pkg.wlm_queue_time_total, pkg.wlm_queue_assignments_total, pkg.deadlocks, pkg.fcm_recv_volume, pkg.fcm_recvs_total, pkg.fcm_send_volume, pkg.fcm_sends_total, pkg.fcm_recv_wait_time, pkg.fcm_send_wait_time, pkg.lock_timeouts, pkg.log_buffer_wait_time, pkg.num_log_buffer_full, pkg.log_disk_wait_time, pkg.log_disk_waits_total, pkg.last_metrics_update, pkg.num_coord_exec, pkg.num_coord_exec_with_metrics, pkg.valid, pkg.total_routine_time, pkg.total_routine_invocations, pkg.routine_id, pkg.stmt_type_id, pkg.query_cost_estimate, pkg.stmt_pkg_cache_id, pkg.coord_stmt_exec_time, pkg.stmt_exec_time, pkg.total_section_time, pkg.total_section_proc_time, pkg.total_routine_non_sect_time, pkg.total_routine_non_sect_proc_time, CAST(RTRIM(SUBSTR(pkg.stmt_text,1,10000)) AS VARCHAR(10000)) stmt_text FROM TABLE(mon_get_pkg_cache_stmt(NULL, NULL, '<modified_within>$MODIFIED_WITHIN</modified_within>', -1) ) AS pkg FETCH FIRST $MAX_PKGCACHE_ROWS ROWS ONLY /* wcs_db2collect */" ; } >> $SCRIPTLOGNAME 2>&1
  if [ "$?" -ne "0" ]
  then
     echo "Unable to export package cache"
     exit
  fi

  # Look for message SQL3105N  The Export utility has finished exporting "624" rows.

  ROWS_EXPORTED=`awk -F '"' '/SQL3105N/ { a=$2 } END { print a }' $SCRIPTLOGNAME`

  echo "* Rows exported from package cache: $ROWS_EXPORTED"

  if [ "$MAX_PKGCACHE_ROWS" -eq "$ROWS_EXPORTED" ]
  then
     echo ""
     echo "*** Rows exported from package cache ($ROWS_EXPORTED) matches the MAX_PKGCACHE_ROWS setting"
     echo "*** Export could be truncated"
     echo "*** Consider adding 'ORDER BY pkg.stmt_exec_time' prior to 'FETCH FIRST' to the pkgcache export statements"
     echo "*** to ensure the most time consuming queries are included."
     echo ""
  fi

  FILELIST="$FILELIST pkgcache.1.$SNAP_TIME.csv"
fi


C_SCRIPT_END=`date +"%Y-%m-%d-%H.%M.%S"`

echo "script.name="$C_SCRIPT_NAME               > collection2.properties
echo "script.product="$C_SCRIPT_PRODUCT         >> collection2.properties
echo "script.version="$C_SCRIPT_VERSION         >> collection2.properties
echo "script.tz="$C_SCRIPT_TZ                   >> collection2.properties
echo "script.start="$C_SCRIPT_START             >> collection2.properties
echo "script.end="$C_SCRIPT_END                 >> collection2.properties
echo "script.num_collections="$NUM_COLLECTIONS  >> collection2.properties
echo "script.sleep="$SLEEP                      >> collection2.properties
echo "script.user="$USER                        >> collection2.properties
echo "script.db2.app_handle="$DB2_APP_HANDLE    >> collection2.properties
echo "script.db2.db.name="$DBNAME               >> collection2.properties
echo "script.db2.wcs.schema="$WCS_SCHEMA        >> collection2.properties


FILELIST="$FILELIST collection2.properties"

echo
echo "* ---------------------------------"
echo "* Compressing"
echo "* ---------------------------------"

cp $THISSCRIPT /db2shared/db2scripts/QBSCRIPTS/db2collect2/mustgather2.script

FILELIST="$FILELIST mustgather2.script"

# add log to the zip
FILELIST="$FILELIST $SCRIPTLOGNAME"

# Look for zip
which zip > /dev/null 2>&1
if [ "$?" -eq "0" ]
then

    OUTFILE=db2collect.$C_SCRIPT_END.zip

    echo "script.zipfile="$OUTFILE     >> collection2.properties

    zip $OUTFILE $FILELIST
    if [ "$?" -eq "0" ]
    then
      echo "* File $OUTFILE created."
      rm $FILELIST
    else
      echo "Unable to zip $OUTFILE $FILELIST db2collect2.sh"
    fi

else

    OUTFILE=db2collect2.$C_SCRIPT_END.tar.gz

    echo "script.zipfile="$OUTFILE     >> collection2.properties

    tar -cvf - $FILELIST | gzip > $OUTFILE
    if [ "$?" -eq "0" ]
    then
      echo "* File $OUTFILE created."
      rm $FILELIST
    else
      echo "Unable to tar $OUTFILE $FILELIST db2collect2.sh"
    fi

fi

echo "* ---------------------------------"
echo "* Done."


