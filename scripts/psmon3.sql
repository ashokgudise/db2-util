echo ********************************************************;
echo                                                         ;
echo  This script was generated:                             ;
echo                                                         ;
echo    by psmon3.pl                                           ;
echo                                                         ;
echo    for DB2 version 10.5                          ;
echo                                                         ;
echo    on Tue Jul 26 10:48:57 2016                                 ;
echo                                                         ;
echo  Changes to this script will be overwritten the next    ;
echo  time psmon3.pl is run.                                   ;
echo                                                         ;
echo  Report starts at string 'REPORT STARTS HERE'.          ;
echo                                                         ;
echo ********************************************************;
echo                                                         ;

drop table session.mon_get_transaction_log_start;
drop table session.mon_get_transaction_log_end;
drop table session.mon_get_transaction_log_diff;
declare global temporary table mon_get_transaction_log_start as ( select current timestamp ts,member, log_writes, log_write_time, num_log_write_io, num_log_part_page_io, num_log_buffer_full, log_reads, log_read_time, num_log_read_io, log_hadr_wait_time, log_hadr_waits_total from table (mon_get_transaction_log( -2) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_transaction_log_end like session.mon_get_transaction_log_start on commit preserve rows not logged ;
declare global temporary table mon_get_transaction_log_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, log_writes, log_write_time, num_log_write_io, num_log_part_page_io, num_log_buffer_full, log_reads, log_read_time, num_log_read_io, log_hadr_wait_time, log_hadr_waits_total from table (mon_get_transaction_log( -2) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_transaction_log_start on session.mon_get_transaction_log_start (member);
create index session.idx_mon_get_transaction_log_end on session.mon_get_transaction_log_end (member);
drop table session.mon_get_group_bufferpool_start;
drop table session.mon_get_group_bufferpool_end;
drop table session.mon_get_group_bufferpool_diff;
declare global temporary table mon_get_group_bufferpool_start as ( select current timestamp ts,member, num_gbp_full from table (mon_get_group_bufferpool( -2) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_group_bufferpool_end like session.mon_get_group_bufferpool_start on commit preserve rows not logged ;
declare global temporary table mon_get_group_bufferpool_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, num_gbp_full from table (mon_get_group_bufferpool( -2) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_group_bufferpool_start on session.mon_get_group_bufferpool_start (member);
create index session.idx_mon_get_group_bufferpool_end on session.mon_get_group_bufferpool_end (member);
drop table session.mon_get_workload_start;
drop table session.mon_get_workload_end;
drop table session.mon_get_workload_diff;
declare global temporary table mon_get_workload_start as ( select current timestamp ts,member, workload_name, act_completed_total, total_act_time, total_rqst_time, total_wait_time, lock_wait_time, lock_wait_time_global, total_extended_latch_wait_time, log_disk_wait_time, reclaim_wait_time, cf_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, tcpip_recv_wait_time, tcpip_send_wait_time, fcm_recv_wait_time, fcm_send_wait_time, total_cpu_time, total_compile_time, total_routine_time, total_section_sort_time, total_commit_time, total_runstats_time, total_reorg_time, total_load_time, total_app_commits, total_app_rollbacks, deadlocks, client_idle_wait_time, rows_modified, rows_read, rows_returned, pkg_cache_inserts, total_sorts, total_reorgs, total_loads, total_runstats, pool_data_l_reads, pool_data_p_reads, pool_index_l_reads, pool_index_p_reads, select_sql_stmts, uid_sql_stmts, rows_inserted, rows_updated from table (mon_get_workload( null, -2) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_workload_end like session.mon_get_workload_start on commit preserve rows not logged ;
declare global temporary table mon_get_workload_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, workload_name, act_completed_total, total_act_time, total_rqst_time, total_wait_time, lock_wait_time, lock_wait_time_global, total_extended_latch_wait_time, log_disk_wait_time, reclaim_wait_time, cf_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, tcpip_recv_wait_time, tcpip_send_wait_time, fcm_recv_wait_time, fcm_send_wait_time, total_cpu_time, total_compile_time, total_routine_time, total_section_sort_time, total_commit_time, total_runstats_time, total_reorg_time, total_load_time, total_app_commits, total_app_rollbacks, deadlocks, client_idle_wait_time, rows_modified, rows_read, rows_returned, pkg_cache_inserts, total_sorts, total_reorgs, total_loads, total_runstats, pool_data_l_reads, pool_data_p_reads, pool_index_l_reads, pool_index_p_reads, select_sql_stmts, uid_sql_stmts, rows_inserted, rows_updated from table (mon_get_workload( null, -2) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_workload_start on session.mon_get_workload_start (member, workload_name);
create index session.idx_mon_get_workload_end on session.mon_get_workload_end (member, workload_name);
drop table session.mon_get_cf_cmd_start;
drop table session.mon_get_cf_cmd_end;
drop table session.mon_get_cf_cmd_diff;
declare global temporary table mon_get_cf_cmd_start as ( select current timestamp ts,hostname, id, cf_cmd_name, total_cf_requests, total_cf_cmd_time_micro from table (mon_get_cf_cmd( null) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_cf_cmd_end like session.mon_get_cf_cmd_start on commit preserve rows not logged ;
declare global temporary table mon_get_cf_cmd_diff as ( select cast(null as integer) ts_delta, current timestamp ts,hostname, id, cf_cmd_name, total_cf_requests, total_cf_cmd_time_micro from table (mon_get_cf_cmd( null) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_cf_cmd_start on session.mon_get_cf_cmd_start (hostname, id, cf_cmd_name);
create index session.idx_mon_get_cf_cmd_end on session.mon_get_cf_cmd_end (hostname, id, cf_cmd_name);
drop table session.mon_get_page_access_info_start;
drop table session.mon_get_page_access_info_end;
drop table session.mon_get_page_access_info_diff;
declare global temporary table mon_get_page_access_info_start as ( select current timestamp ts,member, tabschema, tabname, objtype, data_partition_id, iid, page_reclaims_x, page_reclaims_s, reclaim_wait_time, spacemappage_page_reclaims_x, spacemappage_page_reclaims_s, spacemappage_reclaim_wait_time from table (mon_get_page_access_info( null, null, -2) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_page_access_info_end like session.mon_get_page_access_info_start on commit preserve rows not logged ;
declare global temporary table mon_get_page_access_info_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, tabschema, tabname, objtype, data_partition_id, iid, page_reclaims_x, page_reclaims_s, reclaim_wait_time, spacemappage_page_reclaims_x, spacemappage_page_reclaims_s, spacemappage_reclaim_wait_time from table (mon_get_page_access_info( null, null, -2) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_page_access_info_start on session.mon_get_page_access_info_start (member, tabschema, tabname, objtype, data_partition_id, iid);
create index session.idx_mon_get_page_access_info_end on session.mon_get_page_access_info_end (member, tabschema, tabname, objtype, data_partition_id, iid);
drop table session.mon_get_pkg_cache_stmt_start;
drop table session.mon_get_pkg_cache_stmt_end;
drop table session.mon_get_pkg_cache_stmt_diff;
declare global temporary table mon_get_pkg_cache_stmt_start as ( select current timestamp ts,member, executable_id, stmt_text, num_exec_with_metrics, total_act_time, total_act_wait_time, total_cpu_time, lock_wait_time, log_disk_wait_time, log_buffer_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, rows_modified, rows_read, rows_returned, total_sorts, sort_overflows, total_section_sort_time, pool_data_p_reads, pool_index_p_reads, pool_data_writes, pool_index_writes, pool_temp_data_p_reads, pool_temp_index_p_reads, direct_read_reqs, direct_write_reqs, cf_wait_time, reclaim_wait_time, total_extended_latch_wait_time, lock_wait_time_global, prefetch_wait_time, diaglog_write_wait_time from table (mon_get_pkg_cache_stmt( null, null, null, -2) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_pkg_cache_stmt_end like session.mon_get_pkg_cache_stmt_start on commit preserve rows not logged ;
declare global temporary table mon_get_pkg_cache_stmt_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, executable_id, stmt_text, num_exec_with_metrics, total_act_time, total_act_wait_time, total_cpu_time, lock_wait_time, log_disk_wait_time, log_buffer_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, rows_modified, rows_read, rows_returned, total_sorts, sort_overflows, total_section_sort_time, pool_data_p_reads, pool_index_p_reads, pool_data_writes, pool_index_writes, pool_temp_data_p_reads, pool_temp_index_p_reads, direct_read_reqs, direct_write_reqs, cf_wait_time, reclaim_wait_time, total_extended_latch_wait_time, lock_wait_time_global, prefetch_wait_time, diaglog_write_wait_time from table (mon_get_pkg_cache_stmt( null, null, null, -2) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_pkg_cache_stmt_start on session.mon_get_pkg_cache_stmt_start (member, executable_id);
create index session.idx_mon_get_pkg_cache_stmt_end on session.mon_get_pkg_cache_stmt_end (member, executable_id);
drop table session.mon_get_bufferpool_start;
drop table session.mon_get_bufferpool_end;
drop table session.mon_get_bufferpool_diff;
declare global temporary table mon_get_bufferpool_start as ( select current timestamp ts,member, bp_name, bp_cur_buffsz, pool_read_time, pool_data_l_reads, pool_data_p_reads, pool_data_writes, pool_async_data_writes, pool_data_lbp_pages_found, pool_async_data_lbp_pages_found, pool_temp_data_l_reads, pool_index_lbp_pages_found, pool_async_index_lbp_pages_found, pool_temp_index_l_reads, pool_write_time, pool_index_l_reads, pool_index_p_reads, pool_index_writes, pool_async_index_writes, pool_data_gbp_l_reads, pool_data_gbp_p_reads, pool_index_gbp_l_reads, pool_index_gbp_p_reads, pool_data_gbp_invalid_pages, pool_async_data_gbp_invalid_pages, pool_index_gbp_invalid_pages, pool_async_index_gbp_invalid_pages from table (mon_get_bufferpool( null, -2) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_bufferpool_end like session.mon_get_bufferpool_start on commit preserve rows not logged ;
declare global temporary table mon_get_bufferpool_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, bp_name, bp_cur_buffsz, pool_read_time, pool_data_l_reads, pool_data_p_reads, pool_data_writes, pool_async_data_writes, pool_data_lbp_pages_found, pool_async_data_lbp_pages_found, pool_temp_data_l_reads, pool_index_lbp_pages_found, pool_async_index_lbp_pages_found, pool_temp_index_l_reads, pool_write_time, pool_index_l_reads, pool_index_p_reads, pool_index_writes, pool_async_index_writes, pool_data_gbp_l_reads, pool_data_gbp_p_reads, pool_index_gbp_l_reads, pool_index_gbp_p_reads, pool_data_gbp_invalid_pages, pool_async_data_gbp_invalid_pages, pool_index_gbp_invalid_pages, pool_async_index_gbp_invalid_pages from table (mon_get_bufferpool( null, -2) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_bufferpool_start on session.mon_get_bufferpool_start (member, bp_name);
create index session.idx_mon_get_bufferpool_end on session.mon_get_bufferpool_end (member, bp_name);
drop table session.mon_get_connection_start;
drop table session.mon_get_connection_end;
drop table session.mon_get_connection_diff;
declare global temporary table mon_get_connection_start as ( select current timestamp ts,member, application_name, application_handle, client_applname, client_idle_wait_time, total_rqst_time, rqsts_completed_total, total_wait_time, lock_wait_time, log_disk_wait_time, log_buffer_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, total_section_sort_time, total_commit_time, total_runstats_time, total_reorg_time, total_load_time, total_app_commits, total_app_rollbacks, deadlocks, rows_modified, rows_read, rows_returned, total_sorts, total_reorgs, total_loads, total_runstats, pool_data_l_reads, pool_data_p_reads, pool_index_l_reads, pool_index_p_reads, cf_wait_time, reclaim_wait_time, total_extended_latch_wait_time, lock_wait_time_global from table (mon_get_connection( null, -2) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_connection_end like session.mon_get_connection_start on commit preserve rows not logged ;
declare global temporary table mon_get_connection_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, application_name, application_handle, client_applname, client_idle_wait_time, total_rqst_time, rqsts_completed_total, total_wait_time, lock_wait_time, log_disk_wait_time, log_buffer_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, total_section_sort_time, total_commit_time, total_runstats_time, total_reorg_time, total_load_time, total_app_commits, total_app_rollbacks, deadlocks, rows_modified, rows_read, rows_returned, total_sorts, total_reorgs, total_loads, total_runstats, pool_data_l_reads, pool_data_p_reads, pool_index_l_reads, pool_index_p_reads, cf_wait_time, reclaim_wait_time, total_extended_latch_wait_time, lock_wait_time_global from table (mon_get_connection( null, -2) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_connection_start on session.mon_get_connection_start (member, application_name, application_handle, client_applname);
create index session.idx_mon_get_connection_end on session.mon_get_connection_end (member, application_name, application_handle, client_applname);
drop table session.mon_get_table_start;
drop table session.mon_get_table_end;
drop table session.mon_get_table_diff;
declare global temporary table mon_get_table_start as ( select current timestamp ts,member, tabname, tabschema, data_partition_id, data_sharing_state_change_time, data_sharing_state, rows_read, rows_inserted, rows_updated, rows_deleted, overflow_accesses, overflow_creates, page_reorgs, direct_read_reqs, direct_write_reqs, object_data_p_reads, object_data_l_reads, data_sharing_remote_lockwait_count, data_sharing_remote_lockwait_time from table (mon_get_table( null, null, -2) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_table_end like session.mon_get_table_start on commit preserve rows not logged ;
declare global temporary table mon_get_table_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, tabname, tabschema, data_partition_id, data_sharing_state_change_time, data_sharing_state, rows_read, rows_inserted, rows_updated, rows_deleted, overflow_accesses, overflow_creates, page_reorgs, direct_read_reqs, direct_write_reqs, object_data_p_reads, object_data_l_reads, data_sharing_remote_lockwait_count, data_sharing_remote_lockwait_time from table (mon_get_table( null, null, -2) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_table_start on session.mon_get_table_start (member, tabname, tabschema, data_partition_id);
create index session.idx_mon_get_table_end on session.mon_get_table_end (member, tabname, tabschema, data_partition_id);
drop table session.mon_get_cf_wait_time_start;
drop table session.mon_get_cf_wait_time_end;
drop table session.mon_get_cf_wait_time_diff;
declare global temporary table mon_get_cf_wait_time_start as ( select current timestamp ts,member, hostname, id, cf_cmd_name, total_cf_requests, total_cf_wait_time_micro from table (mon_get_cf_wait_time( -2) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_cf_wait_time_end like session.mon_get_cf_wait_time_start on commit preserve rows not logged ;
declare global temporary table mon_get_cf_wait_time_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, hostname, id, cf_cmd_name, total_cf_requests, total_cf_wait_time_micro from table (mon_get_cf_wait_time( -2) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_cf_wait_time_start on session.mon_get_cf_wait_time_start (member, hostname, id, cf_cmd_name);
create index session.idx_mon_get_cf_wait_time_end on session.mon_get_cf_wait_time_end (member, hostname, id, cf_cmd_name);
drop table session.mon_get_tablespace_start;
drop table session.mon_get_tablespace_end;
drop table session.mon_get_tablespace_diff;
declare global temporary table mon_get_tablespace_start as ( select current timestamp ts,member, tbsp_name, tbsp_page_size, tbsp_id, tbsp_extent_size, tbsp_prefetch_size, fs_caching, pool_read_time, pool_write_time, pool_data_writes, pool_index_writes, pool_data_l_reads, pool_temp_data_l_reads, pool_async_data_reads, pool_data_p_reads, pool_async_index_reads, pool_index_l_reads, pool_temp_index_l_reads, pool_index_p_reads, unread_prefetch_pages, vectored_ios, pages_from_vectored_ios, block_ios, pages_from_block_ios, pool_data_lbp_pages_found, pool_index_lbp_pages_found, pool_async_data_lbp_pages_found, pool_async_index_lbp_pages_found, direct_read_reqs, direct_write_reqs, direct_read_time, direct_write_time, tbsp_used_pages, tbsp_page_top, pool_data_gbp_l_reads, pool_data_gbp_p_reads, pool_index_gbp_l_reads, pool_index_gbp_p_reads, pool_data_gbp_invalid_pages, pool_async_data_gbp_invalid_pages, pool_index_gbp_invalid_pages, pool_async_index_gbp_invalid_pages, pool_async_data_gbp_l_reads, pool_async_data_gbp_p_reads, pool_async_data_gbp_indep_pages_found_in_lbp, pool_async_index_gbp_l_reads, pool_async_index_gbp_p_reads, pool_async_index_gbp_indep_pages_found_in_lbp, prefetch_wait_time, prefetch_waits, skipped_prefetch_data_p_reads, skipped_prefetch_index_p_reads, skipped_prefetch_temp_data_p_reads, skipped_prefetch_temp_index_p_reads from table (mon_get_tablespace( null, -2) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_tablespace_end like session.mon_get_tablespace_start on commit preserve rows not logged ;
declare global temporary table mon_get_tablespace_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, tbsp_name, tbsp_page_size, tbsp_id, tbsp_extent_size, tbsp_prefetch_size, fs_caching, pool_read_time, pool_write_time, pool_data_writes, pool_index_writes, pool_data_l_reads, pool_temp_data_l_reads, pool_async_data_reads, pool_data_p_reads, pool_async_index_reads, pool_index_l_reads, pool_temp_index_l_reads, pool_index_p_reads, unread_prefetch_pages, vectored_ios, pages_from_vectored_ios, block_ios, pages_from_block_ios, pool_data_lbp_pages_found, pool_index_lbp_pages_found, pool_async_data_lbp_pages_found, pool_async_index_lbp_pages_found, direct_read_reqs, direct_write_reqs, direct_read_time, direct_write_time, tbsp_used_pages, tbsp_page_top, pool_data_gbp_l_reads, pool_data_gbp_p_reads, pool_index_gbp_l_reads, pool_index_gbp_p_reads, pool_data_gbp_invalid_pages, pool_async_data_gbp_invalid_pages, pool_index_gbp_invalid_pages, pool_async_index_gbp_invalid_pages, pool_async_data_gbp_l_reads, pool_async_data_gbp_p_reads, pool_async_data_gbp_indep_pages_found_in_lbp, pool_async_index_gbp_l_reads, pool_async_index_gbp_p_reads, pool_async_index_gbp_indep_pages_found_in_lbp, prefetch_wait_time, prefetch_waits, skipped_prefetch_data_p_reads, skipped_prefetch_index_p_reads, skipped_prefetch_temp_data_p_reads, skipped_prefetch_temp_index_p_reads from table (mon_get_tablespace( null, -2) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_tablespace_start on session.mon_get_tablespace_start (member, tbsp_name);
create index session.idx_mon_get_tablespace_end on session.mon_get_tablespace_end (member, tbsp_name);
drop table session.mon_get_extended_latch_wait_start;
drop table session.mon_get_extended_latch_wait_end;
drop table session.mon_get_extended_latch_wait_diff;
declare global temporary table mon_get_extended_latch_wait_start as ( select current timestamp ts,member, latch_name, total_extended_latch_wait_time, total_extended_latch_waits from table (mon_get_extended_latch_wait( -2) ) ) with no data on commit preserve rows not logged ;
declare global temporary table mon_get_extended_latch_wait_end like session.mon_get_extended_latch_wait_start on commit preserve rows not logged ;
declare global temporary table mon_get_extended_latch_wait_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, latch_name, total_extended_latch_wait_time, total_extended_latch_waits from table (mon_get_extended_latch_wait( -2) ) ) with no data on commit preserve rows not logged ;
create index session.idx_mon_get_extended_latch_wait_start on session.mon_get_extended_latch_wait_start (member, latch_name);
create index session.idx_mon_get_extended_latch_wait_end on session.mon_get_extended_latch_wait_end (member, latch_name);

drop table session.mon_current_sql_start;
drop table session.mon_current_sql_end;

declare global temporary table mon_current_sql_start as
( select 
    current timestamp ts,
    coord_member,
    application_handle,
    elapsed_time_sec,
    substr(activity_state, 1, 12) as activity_state,
    total_cpu_time,
    rows_read,
    translate(substr(stmt_text,1,200),' ',chr(10)) as stmt_text
  from
    sysibmadm.mon_current_sql
) with no data on commit preserve rows not logged;

declare global temporary table mon_current_sql_end like session.mon_current_sql_start on commit preserve rows not logged;

insert into session.mon_get_transaction_log_start select current timestamp,member, log_writes, log_write_time, num_log_write_io, num_log_part_page_io, num_log_buffer_full, log_reads, log_read_time, num_log_read_io, log_hadr_wait_time, log_hadr_waits_total from table (mon_get_transaction_log( -2) );
insert into session.mon_get_group_bufferpool_start select current timestamp,member, num_gbp_full from table (mon_get_group_bufferpool( -2) );
insert into session.mon_get_cf_cmd_start select current timestamp,hostname, id, cf_cmd_name, total_cf_requests, total_cf_cmd_time_micro from table (mon_get_cf_cmd( null) );
insert into session.mon_get_workload_start select current timestamp,member, workload_name, act_completed_total, total_act_time, total_rqst_time, total_wait_time, lock_wait_time, lock_wait_time_global, total_extended_latch_wait_time, log_disk_wait_time, reclaim_wait_time, cf_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, tcpip_recv_wait_time, tcpip_send_wait_time, fcm_recv_wait_time, fcm_send_wait_time, total_cpu_time, total_compile_time, total_routine_time, total_section_sort_time, total_commit_time, total_runstats_time, total_reorg_time, total_load_time, total_app_commits, total_app_rollbacks, deadlocks, client_idle_wait_time, rows_modified, rows_read, rows_returned, pkg_cache_inserts, total_sorts, total_reorgs, total_loads, total_runstats, pool_data_l_reads, pool_data_p_reads, pool_index_l_reads, pool_index_p_reads, select_sql_stmts, uid_sql_stmts, rows_inserted, rows_updated from table (mon_get_workload( null, -2) );
insert into session.mon_get_page_access_info_start select current timestamp,member, tabschema, tabname, objtype, data_partition_id, iid, page_reclaims_x, page_reclaims_s, reclaim_wait_time, spacemappage_page_reclaims_x, spacemappage_page_reclaims_s, spacemappage_reclaim_wait_time from table (mon_get_page_access_info( null, null, -2) );
insert into session.mon_get_pkg_cache_stmt_start select current timestamp,member, executable_id, stmt_text, num_exec_with_metrics, total_act_time, total_act_wait_time, total_cpu_time, lock_wait_time, log_disk_wait_time, log_buffer_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, rows_modified, rows_read, rows_returned, total_sorts, sort_overflows, total_section_sort_time, pool_data_p_reads, pool_index_p_reads, pool_data_writes, pool_index_writes, pool_temp_data_p_reads, pool_temp_index_p_reads, direct_read_reqs, direct_write_reqs, cf_wait_time, reclaim_wait_time, total_extended_latch_wait_time, lock_wait_time_global, prefetch_wait_time, diaglog_write_wait_time from table (mon_get_pkg_cache_stmt( null, null, null, -2) ) order by total_act_time desc;
insert into session.mon_get_table_start select current timestamp,member, tabname, tabschema, data_partition_id, data_sharing_state_change_time, data_sharing_state, rows_read, rows_inserted, rows_updated, rows_deleted, overflow_accesses, overflow_creates, page_reorgs, direct_read_reqs, direct_write_reqs, object_data_p_reads, object_data_l_reads, data_sharing_remote_lockwait_count, data_sharing_remote_lockwait_time from table (mon_get_table( null, null, -2) );
insert into session.mon_get_bufferpool_start select current timestamp,member, bp_name, bp_cur_buffsz, pool_read_time, pool_data_l_reads, pool_data_p_reads, pool_data_writes, pool_async_data_writes, pool_data_lbp_pages_found, pool_async_data_lbp_pages_found, pool_temp_data_l_reads, pool_index_lbp_pages_found, pool_async_index_lbp_pages_found, pool_temp_index_l_reads, pool_write_time, pool_index_l_reads, pool_index_p_reads, pool_index_writes, pool_async_index_writes, pool_data_gbp_l_reads, pool_data_gbp_p_reads, pool_index_gbp_l_reads, pool_index_gbp_p_reads, pool_data_gbp_invalid_pages, pool_async_data_gbp_invalid_pages, pool_index_gbp_invalid_pages, pool_async_index_gbp_invalid_pages from table (mon_get_bufferpool( null, -2) );
insert into session.mon_get_connection_start select current timestamp,member, application_name, application_handle, client_applname, client_idle_wait_time, total_rqst_time, rqsts_completed_total, total_wait_time, lock_wait_time, log_disk_wait_time, log_buffer_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, total_section_sort_time, total_commit_time, total_runstats_time, total_reorg_time, total_load_time, total_app_commits, total_app_rollbacks, deadlocks, rows_modified, rows_read, rows_returned, total_sorts, total_reorgs, total_loads, total_runstats, pool_data_l_reads, pool_data_p_reads, pool_index_l_reads, pool_index_p_reads, cf_wait_time, reclaim_wait_time, total_extended_latch_wait_time, lock_wait_time_global from table (mon_get_connection( null, -2) );
insert into session.mon_get_cf_wait_time_start select current timestamp,member, hostname, id, cf_cmd_name, total_cf_requests, total_cf_wait_time_micro from table (mon_get_cf_wait_time( -2) );
insert into session.mon_get_tablespace_start select current timestamp,member, tbsp_name, tbsp_page_size, tbsp_id, tbsp_extent_size, tbsp_prefetch_size, fs_caching, pool_read_time, pool_write_time, pool_data_writes, pool_index_writes, pool_data_l_reads, pool_temp_data_l_reads, pool_async_data_reads, pool_data_p_reads, pool_async_index_reads, pool_index_l_reads, pool_temp_index_l_reads, pool_index_p_reads, unread_prefetch_pages, vectored_ios, pages_from_vectored_ios, block_ios, pages_from_block_ios, pool_data_lbp_pages_found, pool_index_lbp_pages_found, pool_async_data_lbp_pages_found, pool_async_index_lbp_pages_found, direct_read_reqs, direct_write_reqs, direct_read_time, direct_write_time, tbsp_used_pages, tbsp_page_top, pool_data_gbp_l_reads, pool_data_gbp_p_reads, pool_index_gbp_l_reads, pool_index_gbp_p_reads, pool_data_gbp_invalid_pages, pool_async_data_gbp_invalid_pages, pool_index_gbp_invalid_pages, pool_async_index_gbp_invalid_pages, pool_async_data_gbp_l_reads, pool_async_data_gbp_p_reads, pool_async_data_gbp_indep_pages_found_in_lbp, pool_async_index_gbp_l_reads, pool_async_index_gbp_p_reads, pool_async_index_gbp_indep_pages_found_in_lbp, prefetch_wait_time, prefetch_waits, skipped_prefetch_data_p_reads, skipped_prefetch_index_p_reads, skipped_prefetch_temp_data_p_reads, skipped_prefetch_temp_index_p_reads from table (mon_get_tablespace( null, -2) );
insert into session.mon_get_extended_latch_wait_start select current timestamp,member, latch_name, total_extended_latch_wait_time, total_extended_latch_waits from table (mon_get_extended_latch_wait( -2) );

insert into session.mon_current_sql_start
  select
    current timestamp,
    coord_member,
    application_handle handle,
    elapsed_time_sec,
    substr(activity_state, 1, 12),
    total_cpu_time,
    rows_read,
    translate(substr(stmt_text,1,200),' ',chr(10)) as stmt_text
  from
    sysibmadm.mon_current_sql;

select current timestamp as monitor_start_time from sysibm.sysdummy1;
! vmstat 1 30;
select current timestamp as monitor_end_time from sysibm.sysdummy1;
insert into session.mon_get_transaction_log_end select current timestamp,member, log_writes, log_write_time, num_log_write_io, num_log_part_page_io, num_log_buffer_full, log_reads, log_read_time, num_log_read_io, log_hadr_wait_time, log_hadr_waits_total from table (mon_get_transaction_log( -2) );
insert into session.mon_get_group_bufferpool_end select current timestamp,member, num_gbp_full from table (mon_get_group_bufferpool( -2) );
insert into session.mon_get_cf_cmd_end select current timestamp,hostname, id, cf_cmd_name, total_cf_requests, total_cf_cmd_time_micro from table (mon_get_cf_cmd( null) );
insert into session.mon_get_workload_end select current timestamp,member, workload_name, act_completed_total, total_act_time, total_rqst_time, total_wait_time, lock_wait_time, lock_wait_time_global, total_extended_latch_wait_time, log_disk_wait_time, reclaim_wait_time, cf_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, tcpip_recv_wait_time, tcpip_send_wait_time, fcm_recv_wait_time, fcm_send_wait_time, total_cpu_time, total_compile_time, total_routine_time, total_section_sort_time, total_commit_time, total_runstats_time, total_reorg_time, total_load_time, total_app_commits, total_app_rollbacks, deadlocks, client_idle_wait_time, rows_modified, rows_read, rows_returned, pkg_cache_inserts, total_sorts, total_reorgs, total_loads, total_runstats, pool_data_l_reads, pool_data_p_reads, pool_index_l_reads, pool_index_p_reads, select_sql_stmts, uid_sql_stmts, rows_inserted, rows_updated from table (mon_get_workload( null, -2) );
insert into session.mon_get_page_access_info_end select current timestamp,member, tabschema, tabname, objtype, data_partition_id, iid, page_reclaims_x, page_reclaims_s, reclaim_wait_time, spacemappage_page_reclaims_x, spacemappage_page_reclaims_s, spacemappage_reclaim_wait_time from table (mon_get_page_access_info( null, null, -2) );
insert into session.mon_get_pkg_cache_stmt_end select current timestamp,member, executable_id, stmt_text, num_exec_with_metrics, total_act_time, total_act_wait_time, total_cpu_time, lock_wait_time, log_disk_wait_time, log_buffer_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, rows_modified, rows_read, rows_returned, total_sorts, sort_overflows, total_section_sort_time, pool_data_p_reads, pool_index_p_reads, pool_data_writes, pool_index_writes, pool_temp_data_p_reads, pool_temp_index_p_reads, direct_read_reqs, direct_write_reqs, cf_wait_time, reclaim_wait_time, total_extended_latch_wait_time, lock_wait_time_global, prefetch_wait_time, diaglog_write_wait_time from table (mon_get_pkg_cache_stmt( null, null, null, -2) ) order by total_act_time desc;
insert into session.mon_get_table_end select current timestamp,member, tabname, tabschema, data_partition_id, data_sharing_state_change_time, data_sharing_state, rows_read, rows_inserted, rows_updated, rows_deleted, overflow_accesses, overflow_creates, page_reorgs, direct_read_reqs, direct_write_reqs, object_data_p_reads, object_data_l_reads, data_sharing_remote_lockwait_count, data_sharing_remote_lockwait_time from table (mon_get_table( null, null, -2) );
insert into session.mon_get_connection_end select current timestamp,member, application_name, application_handle, client_applname, client_idle_wait_time, total_rqst_time, rqsts_completed_total, total_wait_time, lock_wait_time, log_disk_wait_time, log_buffer_wait_time, pool_write_time, pool_read_time, direct_write_time, direct_read_time, total_section_sort_time, total_commit_time, total_runstats_time, total_reorg_time, total_load_time, total_app_commits, total_app_rollbacks, deadlocks, rows_modified, rows_read, rows_returned, total_sorts, total_reorgs, total_loads, total_runstats, pool_data_l_reads, pool_data_p_reads, pool_index_l_reads, pool_index_p_reads, cf_wait_time, reclaim_wait_time, total_extended_latch_wait_time, lock_wait_time_global from table (mon_get_connection( null, -2) );
insert into session.mon_get_bufferpool_end select current timestamp,member, bp_name, bp_cur_buffsz, pool_read_time, pool_data_l_reads, pool_data_p_reads, pool_data_writes, pool_async_data_writes, pool_data_lbp_pages_found, pool_async_data_lbp_pages_found, pool_temp_data_l_reads, pool_index_lbp_pages_found, pool_async_index_lbp_pages_found, pool_temp_index_l_reads, pool_write_time, pool_index_l_reads, pool_index_p_reads, pool_index_writes, pool_async_index_writes, pool_data_gbp_l_reads, pool_data_gbp_p_reads, pool_index_gbp_l_reads, pool_index_gbp_p_reads, pool_data_gbp_invalid_pages, pool_async_data_gbp_invalid_pages, pool_index_gbp_invalid_pages, pool_async_index_gbp_invalid_pages from table (mon_get_bufferpool( null, -2) );
insert into session.mon_get_cf_wait_time_end select current timestamp,member, hostname, id, cf_cmd_name, total_cf_requests, total_cf_wait_time_micro from table (mon_get_cf_wait_time( -2) );
insert into session.mon_get_tablespace_end select current timestamp,member, tbsp_name, tbsp_page_size, tbsp_id, tbsp_extent_size, tbsp_prefetch_size, fs_caching, pool_read_time, pool_write_time, pool_data_writes, pool_index_writes, pool_data_l_reads, pool_temp_data_l_reads, pool_async_data_reads, pool_data_p_reads, pool_async_index_reads, pool_index_l_reads, pool_temp_index_l_reads, pool_index_p_reads, unread_prefetch_pages, vectored_ios, pages_from_vectored_ios, block_ios, pages_from_block_ios, pool_data_lbp_pages_found, pool_index_lbp_pages_found, pool_async_data_lbp_pages_found, pool_async_index_lbp_pages_found, direct_read_reqs, direct_write_reqs, direct_read_time, direct_write_time, tbsp_used_pages, tbsp_page_top, pool_data_gbp_l_reads, pool_data_gbp_p_reads, pool_index_gbp_l_reads, pool_index_gbp_p_reads, pool_data_gbp_invalid_pages, pool_async_data_gbp_invalid_pages, pool_index_gbp_invalid_pages, pool_async_index_gbp_invalid_pages, pool_async_data_gbp_l_reads, pool_async_data_gbp_p_reads, pool_async_data_gbp_indep_pages_found_in_lbp, pool_async_index_gbp_l_reads, pool_async_index_gbp_p_reads, pool_async_index_gbp_indep_pages_found_in_lbp, prefetch_wait_time, prefetch_waits, skipped_prefetch_data_p_reads, skipped_prefetch_index_p_reads, skipped_prefetch_temp_data_p_reads, skipped_prefetch_temp_index_p_reads from table (mon_get_tablespace( null, -2) );
insert into session.mon_get_extended_latch_wait_end select current timestamp,member, latch_name, total_extended_latch_wait_time, total_extended_latch_waits from table (mon_get_extended_latch_wait( -2) );

insert into session.mon_current_sql_end
  select
    current timestamp,
    coord_member,
    application_handle handle,
    elapsed_time_sec,
    substr(activity_state, 1, 12),
    total_cpu_time,
    rows_read,
    translate(substr(stmt_text,1,200),' ',chr(10)) as stmt_text
  from
    sysibmadm.mon_current_sql;

insert into session.mon_get_transaction_log_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.member, e.log_writes - s.log_writes as log_writes, e.log_write_time - s.log_write_time as log_write_time, e.num_log_write_io - s.num_log_write_io as num_log_write_io, e.num_log_part_page_io - s.num_log_part_page_io as num_log_part_page_io, e.num_log_buffer_full - s.num_log_buffer_full as num_log_buffer_full, e.log_reads - s.log_reads as log_reads, e.log_read_time - s.log_read_time as log_read_time, e.num_log_read_io - s.num_log_read_io as num_log_read_io, e.log_hadr_wait_time - s.log_hadr_wait_time as log_hadr_wait_time, e.log_hadr_waits_total - s.log_hadr_waits_total as log_hadr_waits_total from session.mon_get_transaction_log_start s, session.mon_get_transaction_log_end e where (s.member = e.member or (s.member is NULL and e.member is NULL));
insert into session.mon_get_transaction_log_diff select null, e.ts,e.member, e.log_writes, e.log_write_time, e.num_log_write_io, e.num_log_part_page_io, e.num_log_buffer_full, e.log_reads, e.log_read_time, e.num_log_read_io, e.log_hadr_wait_time, e.log_hadr_waits_total from session.mon_get_transaction_log_end e where not exists ( select null from session.mon_get_transaction_log_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) );
update session.mon_get_transaction_log_diff set ts_delta = (select max(ts_delta) from session.mon_get_transaction_log_diff) where ts_delta is null;
insert into session.mon_get_group_bufferpool_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.member, e.num_gbp_full - s.num_gbp_full as num_gbp_full from session.mon_get_group_bufferpool_start s, session.mon_get_group_bufferpool_end e where (s.member = e.member or (s.member is NULL and e.member is NULL));
insert into session.mon_get_group_bufferpool_diff select null, e.ts,e.member, e.num_gbp_full from session.mon_get_group_bufferpool_end e where not exists ( select null from session.mon_get_group_bufferpool_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) );
update session.mon_get_group_bufferpool_diff set ts_delta = (select max(ts_delta) from session.mon_get_group_bufferpool_diff) where ts_delta is null;
insert into session.mon_get_workload_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.member, s.workload_name, e.act_completed_total - s.act_completed_total as act_completed_total, e.total_act_time - s.total_act_time as total_act_time, e.total_rqst_time - s.total_rqst_time as total_rqst_time, e.total_wait_time - s.total_wait_time as total_wait_time, e.lock_wait_time - s.lock_wait_time as lock_wait_time, e.lock_wait_time_global - s.lock_wait_time_global as lock_wait_time_global, e.total_extended_latch_wait_time - s.total_extended_latch_wait_time as total_extended_latch_wait_time, e.log_disk_wait_time - s.log_disk_wait_time as log_disk_wait_time, e.reclaim_wait_time - s.reclaim_wait_time as reclaim_wait_time, e.cf_wait_time - s.cf_wait_time as cf_wait_time, e.pool_write_time - s.pool_write_time as pool_write_time, e.pool_read_time - s.pool_read_time as pool_read_time, e.direct_write_time - s.direct_write_time as direct_write_time, e.direct_read_time - s.direct_read_time as direct_read_time, e.tcpip_recv_wait_time - s.tcpip_recv_wait_time as tcpip_recv_wait_time, e.tcpip_send_wait_time - s.tcpip_send_wait_time as tcpip_send_wait_time, e.fcm_recv_wait_time - s.fcm_recv_wait_time as fcm_recv_wait_time, e.fcm_send_wait_time - s.fcm_send_wait_time as fcm_send_wait_time, e.total_cpu_time - s.total_cpu_time as total_cpu_time, e.total_compile_time - s.total_compile_time as total_compile_time, e.total_routine_time - s.total_routine_time as total_routine_time, e.total_section_sort_time - s.total_section_sort_time as total_section_sort_time, e.total_commit_time - s.total_commit_time as total_commit_time, e.total_runstats_time - s.total_runstats_time as total_runstats_time, e.total_reorg_time - s.total_reorg_time as total_reorg_time, e.total_load_time - s.total_load_time as total_load_time, e.total_app_commits - s.total_app_commits as total_app_commits, e.total_app_rollbacks - s.total_app_rollbacks as total_app_rollbacks, e.deadlocks - s.deadlocks as deadlocks, e.client_idle_wait_time - s.client_idle_wait_time as client_idle_wait_time, e.rows_modified - s.rows_modified as rows_modified, e.rows_read - s.rows_read as rows_read, e.rows_returned - s.rows_returned as rows_returned, e.pkg_cache_inserts - s.pkg_cache_inserts as pkg_cache_inserts, e.total_sorts - s.total_sorts as total_sorts, e.total_reorgs - s.total_reorgs as total_reorgs, e.total_loads - s.total_loads as total_loads, e.total_runstats - s.total_runstats as total_runstats, e.pool_data_l_reads - s.pool_data_l_reads as pool_data_l_reads, e.pool_data_p_reads - s.pool_data_p_reads as pool_data_p_reads, e.pool_index_l_reads - s.pool_index_l_reads as pool_index_l_reads, e.pool_index_p_reads - s.pool_index_p_reads as pool_index_p_reads, e.select_sql_stmts - s.select_sql_stmts as select_sql_stmts, e.uid_sql_stmts - s.uid_sql_stmts as uid_sql_stmts, e.rows_inserted - s.rows_inserted as rows_inserted, e.rows_updated - s.rows_updated as rows_updated from session.mon_get_workload_start s, session.mon_get_workload_end e where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.workload_name = e.workload_name or (s.workload_name is NULL and e.workload_name is NULL));
insert into session.mon_get_workload_diff select null, e.ts,e.member, e.workload_name, e.act_completed_total, e.total_act_time, e.total_rqst_time, e.total_wait_time, e.lock_wait_time, e.lock_wait_time_global, e.total_extended_latch_wait_time, e.log_disk_wait_time, e.reclaim_wait_time, e.cf_wait_time, e.pool_write_time, e.pool_read_time, e.direct_write_time, e.direct_read_time, e.tcpip_recv_wait_time, e.tcpip_send_wait_time, e.fcm_recv_wait_time, e.fcm_send_wait_time, e.total_cpu_time, e.total_compile_time, e.total_routine_time, e.total_section_sort_time, e.total_commit_time, e.total_runstats_time, e.total_reorg_time, e.total_load_time, e.total_app_commits, e.total_app_rollbacks, e.deadlocks, e.client_idle_wait_time, e.rows_modified, e.rows_read, e.rows_returned, e.pkg_cache_inserts, e.total_sorts, e.total_reorgs, e.total_loads, e.total_runstats, e.pool_data_l_reads, e.pool_data_p_reads, e.pool_index_l_reads, e.pool_index_p_reads, e.select_sql_stmts, e.uid_sql_stmts, e.rows_inserted, e.rows_updated from session.mon_get_workload_end e where not exists ( select null from session.mon_get_workload_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.workload_name = e.workload_name or (s.workload_name is NULL and e.workload_name is NULL)) );
update session.mon_get_workload_diff set ts_delta = (select max(ts_delta) from session.mon_get_workload_diff) where ts_delta is null;
insert into session.mon_get_cf_cmd_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.hostname, s.id, s.cf_cmd_name, e.total_cf_requests - s.total_cf_requests as total_cf_requests, e.total_cf_cmd_time_micro - s.total_cf_cmd_time_micro as total_cf_cmd_time_micro from session.mon_get_cf_cmd_start s, session.mon_get_cf_cmd_end e where (s.hostname = e.hostname or (s.hostname is NULL and e.hostname is NULL)) and (s.id = e.id or (s.id is NULL and e.id is NULL)) and (s.cf_cmd_name = e.cf_cmd_name or (s.cf_cmd_name is NULL and e.cf_cmd_name is NULL));
insert into session.mon_get_cf_cmd_diff select null, e.ts,e.hostname, e.id, e.cf_cmd_name, e.total_cf_requests, e.total_cf_cmd_time_micro from session.mon_get_cf_cmd_end e where not exists ( select null from session.mon_get_cf_cmd_start s where (s.hostname = e.hostname or (s.hostname is NULL and e.hostname is NULL)) and (s.id = e.id or (s.id is NULL and e.id is NULL)) and (s.cf_cmd_name = e.cf_cmd_name or (s.cf_cmd_name is NULL and e.cf_cmd_name is NULL)) );
update session.mon_get_cf_cmd_diff set ts_delta = (select max(ts_delta) from session.mon_get_cf_cmd_diff) where ts_delta is null;
insert into session.mon_get_page_access_info_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.member, s.tabschema, s.tabname, s.objtype, s.data_partition_id, s.iid, e.page_reclaims_x - s.page_reclaims_x as page_reclaims_x, e.page_reclaims_s - s.page_reclaims_s as page_reclaims_s, e.reclaim_wait_time - s.reclaim_wait_time as reclaim_wait_time, e.spacemappage_page_reclaims_x - s.spacemappage_page_reclaims_x as spacemappage_page_reclaims_x, e.spacemappage_page_reclaims_s - s.spacemappage_page_reclaims_s as spacemappage_page_reclaims_s, e.spacemappage_reclaim_wait_time - s.spacemappage_reclaim_wait_time as spacemappage_reclaim_wait_time from session.mon_get_page_access_info_start s, session.mon_get_page_access_info_end e where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.tabschema = e.tabschema or (s.tabschema is NULL and e.tabschema is NULL)) and (s.tabname = e.tabname or (s.tabname is NULL and e.tabname is NULL)) and (s.objtype = e.objtype or (s.objtype is NULL and e.objtype is NULL)) and (s.data_partition_id = e.data_partition_id or (s.data_partition_id is NULL and e.data_partition_id is NULL)) and (s.iid = e.iid or (s.iid is NULL and e.iid is NULL));
insert into session.mon_get_page_access_info_diff select null, e.ts,e.member, e.tabschema, e.tabname, e.objtype, e.data_partition_id, e.iid, e.page_reclaims_x, e.page_reclaims_s, e.reclaim_wait_time, e.spacemappage_page_reclaims_x, e.spacemappage_page_reclaims_s, e.spacemappage_reclaim_wait_time from session.mon_get_page_access_info_end e where not exists ( select null from session.mon_get_page_access_info_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.tabschema = e.tabschema or (s.tabschema is NULL and e.tabschema is NULL)) and (s.tabname = e.tabname or (s.tabname is NULL and e.tabname is NULL)) and (s.objtype = e.objtype or (s.objtype is NULL and e.objtype is NULL)) and (s.data_partition_id = e.data_partition_id or (s.data_partition_id is NULL and e.data_partition_id is NULL)) and (s.iid = e.iid or (s.iid is NULL and e.iid is NULL)) );
update session.mon_get_page_access_info_diff set ts_delta = (select max(ts_delta) from session.mon_get_page_access_info_diff) where ts_delta is null;
insert into session.mon_get_pkg_cache_stmt_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.member, s.executable_id, s.stmt_text, e.num_exec_with_metrics - s.num_exec_with_metrics as num_exec_with_metrics, e.total_act_time - s.total_act_time as total_act_time, e.total_act_wait_time - s.total_act_wait_time as total_act_wait_time, e.total_cpu_time - s.total_cpu_time as total_cpu_time, e.lock_wait_time - s.lock_wait_time as lock_wait_time, e.log_disk_wait_time - s.log_disk_wait_time as log_disk_wait_time, e.log_buffer_wait_time - s.log_buffer_wait_time as log_buffer_wait_time, e.pool_write_time - s.pool_write_time as pool_write_time, e.pool_read_time - s.pool_read_time as pool_read_time, e.direct_write_time - s.direct_write_time as direct_write_time, e.direct_read_time - s.direct_read_time as direct_read_time, e.rows_modified - s.rows_modified as rows_modified, e.rows_read - s.rows_read as rows_read, e.rows_returned - s.rows_returned as rows_returned, e.total_sorts - s.total_sorts as total_sorts, e.sort_overflows - s.sort_overflows as sort_overflows, e.total_section_sort_time - s.total_section_sort_time as total_section_sort_time, e.pool_data_p_reads - s.pool_data_p_reads as pool_data_p_reads, e.pool_index_p_reads - s.pool_index_p_reads as pool_index_p_reads, e.pool_data_writes - s.pool_data_writes as pool_data_writes, e.pool_index_writes - s.pool_index_writes as pool_index_writes, e.pool_temp_data_p_reads - s.pool_temp_data_p_reads as pool_temp_data_p_reads, e.pool_temp_index_p_reads - s.pool_temp_index_p_reads as pool_temp_index_p_reads, e.direct_read_reqs - s.direct_read_reqs as direct_read_reqs, e.direct_write_reqs - s.direct_write_reqs as direct_write_reqs, e.cf_wait_time - s.cf_wait_time as cf_wait_time, e.reclaim_wait_time - s.reclaim_wait_time as reclaim_wait_time, e.total_extended_latch_wait_time - s.total_extended_latch_wait_time as total_extended_latch_wait_time, e.lock_wait_time_global - s.lock_wait_time_global as lock_wait_time_global, e.prefetch_wait_time - s.prefetch_wait_time as prefetch_wait_time, e.diaglog_write_wait_time - s.diaglog_write_wait_time as diaglog_write_wait_time from session.mon_get_pkg_cache_stmt_start s, session.mon_get_pkg_cache_stmt_end e where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.executable_id = e.executable_id or (s.executable_id is NULL and e.executable_id is NULL));
insert into session.mon_get_pkg_cache_stmt_diff select null, e.ts,e.member, e.executable_id, e.stmt_text, e.num_exec_with_metrics, e.total_act_time, e.total_act_wait_time, e.total_cpu_time, e.lock_wait_time, e.log_disk_wait_time, e.log_buffer_wait_time, e.pool_write_time, e.pool_read_time, e.direct_write_time, e.direct_read_time, e.rows_modified, e.rows_read, e.rows_returned, e.total_sorts, e.sort_overflows, e.total_section_sort_time, e.pool_data_p_reads, e.pool_index_p_reads, e.pool_data_writes, e.pool_index_writes, e.pool_temp_data_p_reads, e.pool_temp_index_p_reads, e.direct_read_reqs, e.direct_write_reqs, e.cf_wait_time, e.reclaim_wait_time, e.total_extended_latch_wait_time, e.lock_wait_time_global, e.prefetch_wait_time, e.diaglog_write_wait_time from session.mon_get_pkg_cache_stmt_end e where not exists ( select null from session.mon_get_pkg_cache_stmt_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.executable_id = e.executable_id or (s.executable_id is NULL and e.executable_id is NULL)) );
update session.mon_get_pkg_cache_stmt_diff set ts_delta = (select max(ts_delta) from session.mon_get_pkg_cache_stmt_diff) where ts_delta is null;
insert into session.mon_get_bufferpool_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.member, s.bp_name, s.bp_cur_buffsz, e.pool_read_time - s.pool_read_time as pool_read_time, e.pool_data_l_reads - s.pool_data_l_reads as pool_data_l_reads, e.pool_data_p_reads - s.pool_data_p_reads as pool_data_p_reads, e.pool_data_writes - s.pool_data_writes as pool_data_writes, e.pool_async_data_writes - s.pool_async_data_writes as pool_async_data_writes, e.pool_data_lbp_pages_found - s.pool_data_lbp_pages_found as pool_data_lbp_pages_found, e.pool_async_data_lbp_pages_found - s.pool_async_data_lbp_pages_found as pool_async_data_lbp_pages_found, e.pool_temp_data_l_reads - s.pool_temp_data_l_reads as pool_temp_data_l_reads, e.pool_index_lbp_pages_found - s.pool_index_lbp_pages_found as pool_index_lbp_pages_found, e.pool_async_index_lbp_pages_found - s.pool_async_index_lbp_pages_found as pool_async_index_lbp_pages_found, e.pool_temp_index_l_reads - s.pool_temp_index_l_reads as pool_temp_index_l_reads, e.pool_write_time - s.pool_write_time as pool_write_time, e.pool_index_l_reads - s.pool_index_l_reads as pool_index_l_reads, e.pool_index_p_reads - s.pool_index_p_reads as pool_index_p_reads, e.pool_index_writes - s.pool_index_writes as pool_index_writes, e.pool_async_index_writes - s.pool_async_index_writes as pool_async_index_writes, e.pool_data_gbp_l_reads - s.pool_data_gbp_l_reads as pool_data_gbp_l_reads, e.pool_data_gbp_p_reads - s.pool_data_gbp_p_reads as pool_data_gbp_p_reads, e.pool_index_gbp_l_reads - s.pool_index_gbp_l_reads as pool_index_gbp_l_reads, e.pool_index_gbp_p_reads - s.pool_index_gbp_p_reads as pool_index_gbp_p_reads, e.pool_data_gbp_invalid_pages - s.pool_data_gbp_invalid_pages as pool_data_gbp_invalid_pages, e.pool_async_data_gbp_invalid_pages - s.pool_async_data_gbp_invalid_pages as pool_async_data_gbp_invalid_pages, e.pool_index_gbp_invalid_pages - s.pool_index_gbp_invalid_pages as pool_index_gbp_invalid_pages, e.pool_async_index_gbp_invalid_pages - s.pool_async_index_gbp_invalid_pages as pool_async_index_gbp_invalid_pages from session.mon_get_bufferpool_start s, session.mon_get_bufferpool_end e where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.bp_name = e.bp_name or (s.bp_name is NULL and e.bp_name is NULL));
insert into session.mon_get_bufferpool_diff select null, e.ts,e.member, e.bp_name, e.bp_cur_buffsz, e.pool_read_time, e.pool_data_l_reads, e.pool_data_p_reads, e.pool_data_writes, e.pool_async_data_writes, e.pool_data_lbp_pages_found, e.pool_async_data_lbp_pages_found, e.pool_temp_data_l_reads, e.pool_index_lbp_pages_found, e.pool_async_index_lbp_pages_found, e.pool_temp_index_l_reads, e.pool_write_time, e.pool_index_l_reads, e.pool_index_p_reads, e.pool_index_writes, e.pool_async_index_writes, e.pool_data_gbp_l_reads, e.pool_data_gbp_p_reads, e.pool_index_gbp_l_reads, e.pool_index_gbp_p_reads, e.pool_data_gbp_invalid_pages, e.pool_async_data_gbp_invalid_pages, e.pool_index_gbp_invalid_pages, e.pool_async_index_gbp_invalid_pages from session.mon_get_bufferpool_end e where not exists ( select null from session.mon_get_bufferpool_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.bp_name = e.bp_name or (s.bp_name is NULL and e.bp_name is NULL)) );
update session.mon_get_bufferpool_diff set ts_delta = (select max(ts_delta) from session.mon_get_bufferpool_diff) where ts_delta is null;
insert into session.mon_get_connection_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.member, s.application_name, s.application_handle, s.client_applname, e.client_idle_wait_time - s.client_idle_wait_time as client_idle_wait_time, e.total_rqst_time - s.total_rqst_time as total_rqst_time, e.rqsts_completed_total - s.rqsts_completed_total as rqsts_completed_total, e.total_wait_time - s.total_wait_time as total_wait_time, e.lock_wait_time - s.lock_wait_time as lock_wait_time, e.log_disk_wait_time - s.log_disk_wait_time as log_disk_wait_time, e.log_buffer_wait_time - s.log_buffer_wait_time as log_buffer_wait_time, e.pool_write_time - s.pool_write_time as pool_write_time, e.pool_read_time - s.pool_read_time as pool_read_time, e.direct_write_time - s.direct_write_time as direct_write_time, e.direct_read_time - s.direct_read_time as direct_read_time, e.total_section_sort_time - s.total_section_sort_time as total_section_sort_time, e.total_commit_time - s.total_commit_time as total_commit_time, e.total_runstats_time - s.total_runstats_time as total_runstats_time, e.total_reorg_time - s.total_reorg_time as total_reorg_time, e.total_load_time - s.total_load_time as total_load_time, e.total_app_commits - s.total_app_commits as total_app_commits, e.total_app_rollbacks - s.total_app_rollbacks as total_app_rollbacks, e.deadlocks - s.deadlocks as deadlocks, e.rows_modified - s.rows_modified as rows_modified, e.rows_read - s.rows_read as rows_read, e.rows_returned - s.rows_returned as rows_returned, e.total_sorts - s.total_sorts as total_sorts, e.total_reorgs - s.total_reorgs as total_reorgs, e.total_loads - s.total_loads as total_loads, e.total_runstats - s.total_runstats as total_runstats, e.pool_data_l_reads - s.pool_data_l_reads as pool_data_l_reads, e.pool_data_p_reads - s.pool_data_p_reads as pool_data_p_reads, e.pool_index_l_reads - s.pool_index_l_reads as pool_index_l_reads, e.pool_index_p_reads - s.pool_index_p_reads as pool_index_p_reads, e.cf_wait_time - s.cf_wait_time as cf_wait_time, e.reclaim_wait_time - s.reclaim_wait_time as reclaim_wait_time, e.total_extended_latch_wait_time - s.total_extended_latch_wait_time as total_extended_latch_wait_time, e.lock_wait_time_global - s.lock_wait_time_global as lock_wait_time_global from session.mon_get_connection_start s, session.mon_get_connection_end e where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.application_name = e.application_name or (s.application_name is NULL and e.application_name is NULL)) and (s.application_handle = e.application_handle or (s.application_handle is NULL and e.application_handle is NULL)) and (s.client_applname = e.client_applname or (s.client_applname is NULL and e.client_applname is NULL));
insert into session.mon_get_connection_diff select null, e.ts,e.member, e.application_name, e.application_handle, e.client_applname, e.client_idle_wait_time, e.total_rqst_time, e.rqsts_completed_total, e.total_wait_time, e.lock_wait_time, e.log_disk_wait_time, e.log_buffer_wait_time, e.pool_write_time, e.pool_read_time, e.direct_write_time, e.direct_read_time, e.total_section_sort_time, e.total_commit_time, e.total_runstats_time, e.total_reorg_time, e.total_load_time, e.total_app_commits, e.total_app_rollbacks, e.deadlocks, e.rows_modified, e.rows_read, e.rows_returned, e.total_sorts, e.total_reorgs, e.total_loads, e.total_runstats, e.pool_data_l_reads, e.pool_data_p_reads, e.pool_index_l_reads, e.pool_index_p_reads, e.cf_wait_time, e.reclaim_wait_time, e.total_extended_latch_wait_time, e.lock_wait_time_global from session.mon_get_connection_end e where not exists ( select null from session.mon_get_connection_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.application_name = e.application_name or (s.application_name is NULL and e.application_name is NULL)) and (s.application_handle = e.application_handle or (s.application_handle is NULL and e.application_handle is NULL)) and (s.client_applname = e.client_applname or (s.client_applname is NULL and e.client_applname is NULL)) );
update session.mon_get_connection_diff set ts_delta = (select max(ts_delta) from session.mon_get_connection_diff) where ts_delta is null;
insert into session.mon_get_table_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.member, s.tabname, s.tabschema, s.data_partition_id, s.data_sharing_state_change_time, s.data_sharing_state, e.rows_read - s.rows_read as rows_read, e.rows_inserted - s.rows_inserted as rows_inserted, e.rows_updated - s.rows_updated as rows_updated, e.rows_deleted - s.rows_deleted as rows_deleted, e.overflow_accesses - s.overflow_accesses as overflow_accesses, e.overflow_creates - s.overflow_creates as overflow_creates, e.page_reorgs - s.page_reorgs as page_reorgs, e.direct_read_reqs - s.direct_read_reqs as direct_read_reqs, e.direct_write_reqs - s.direct_write_reqs as direct_write_reqs, e.object_data_p_reads - s.object_data_p_reads as object_data_p_reads, e.object_data_l_reads - s.object_data_l_reads as object_data_l_reads, e.data_sharing_remote_lockwait_count - s.data_sharing_remote_lockwait_count as data_sharing_remote_lockwait_count, e.data_sharing_remote_lockwait_time - s.data_sharing_remote_lockwait_time as data_sharing_remote_lockwait_time from session.mon_get_table_start s, session.mon_get_table_end e where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.tabname = e.tabname or (s.tabname is NULL and e.tabname is NULL)) and (s.tabschema = e.tabschema or (s.tabschema is NULL and e.tabschema is NULL)) and (s.data_partition_id = e.data_partition_id or (s.data_partition_id is NULL and e.data_partition_id is NULL));
insert into session.mon_get_table_diff select null, e.ts,e.member, e.tabname, e.tabschema, e.data_partition_id, e.data_sharing_state_change_time, e.data_sharing_state, e.rows_read, e.rows_inserted, e.rows_updated, e.rows_deleted, e.overflow_accesses, e.overflow_creates, e.page_reorgs, e.direct_read_reqs, e.direct_write_reqs, e.object_data_p_reads, e.object_data_l_reads, e.data_sharing_remote_lockwait_count, e.data_sharing_remote_lockwait_time from session.mon_get_table_end e where not exists ( select null from session.mon_get_table_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.tabname = e.tabname or (s.tabname is NULL and e.tabname is NULL)) and (s.tabschema = e.tabschema or (s.tabschema is NULL and e.tabschema is NULL)) and (s.data_partition_id = e.data_partition_id or (s.data_partition_id is NULL and e.data_partition_id is NULL)) );
update session.mon_get_table_diff set ts_delta = (select max(ts_delta) from session.mon_get_table_diff) where ts_delta is null;
insert into session.mon_get_cf_wait_time_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.member, s.hostname, s.id, s.cf_cmd_name, e.total_cf_requests - s.total_cf_requests as total_cf_requests, e.total_cf_wait_time_micro - s.total_cf_wait_time_micro as total_cf_wait_time_micro from session.mon_get_cf_wait_time_start s, session.mon_get_cf_wait_time_end e where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.hostname = e.hostname or (s.hostname is NULL and e.hostname is NULL)) and (s.id = e.id or (s.id is NULL and e.id is NULL)) and (s.cf_cmd_name = e.cf_cmd_name or (s.cf_cmd_name is NULL and e.cf_cmd_name is NULL));
insert into session.mon_get_cf_wait_time_diff select null, e.ts,e.member, e.hostname, e.id, e.cf_cmd_name, e.total_cf_requests, e.total_cf_wait_time_micro from session.mon_get_cf_wait_time_end e where not exists ( select null from session.mon_get_cf_wait_time_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.hostname = e.hostname or (s.hostname is NULL and e.hostname is NULL)) and (s.id = e.id or (s.id is NULL and e.id is NULL)) and (s.cf_cmd_name = e.cf_cmd_name or (s.cf_cmd_name is NULL and e.cf_cmd_name is NULL)) );
update session.mon_get_cf_wait_time_diff set ts_delta = (select max(ts_delta) from session.mon_get_cf_wait_time_diff) where ts_delta is null;
insert into session.mon_get_tablespace_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.member, s.tbsp_name, s.tbsp_page_size, s.tbsp_id, s.tbsp_extent_size, s.tbsp_prefetch_size, s.fs_caching, e.pool_read_time - s.pool_read_time as pool_read_time, e.pool_write_time - s.pool_write_time as pool_write_time, e.pool_data_writes - s.pool_data_writes as pool_data_writes, e.pool_index_writes - s.pool_index_writes as pool_index_writes, e.pool_data_l_reads - s.pool_data_l_reads as pool_data_l_reads, e.pool_temp_data_l_reads - s.pool_temp_data_l_reads as pool_temp_data_l_reads, e.pool_async_data_reads - s.pool_async_data_reads as pool_async_data_reads, e.pool_data_p_reads - s.pool_data_p_reads as pool_data_p_reads, e.pool_async_index_reads - s.pool_async_index_reads as pool_async_index_reads, e.pool_index_l_reads - s.pool_index_l_reads as pool_index_l_reads, e.pool_temp_index_l_reads - s.pool_temp_index_l_reads as pool_temp_index_l_reads, e.pool_index_p_reads - s.pool_index_p_reads as pool_index_p_reads, e.unread_prefetch_pages - s.unread_prefetch_pages as unread_prefetch_pages, e.vectored_ios - s.vectored_ios as vectored_ios, e.pages_from_vectored_ios - s.pages_from_vectored_ios as pages_from_vectored_ios, e.block_ios - s.block_ios as block_ios, e.pages_from_block_ios - s.pages_from_block_ios as pages_from_block_ios, e.pool_data_lbp_pages_found - s.pool_data_lbp_pages_found as pool_data_lbp_pages_found, e.pool_index_lbp_pages_found - s.pool_index_lbp_pages_found as pool_index_lbp_pages_found, e.pool_async_data_lbp_pages_found - s.pool_async_data_lbp_pages_found as pool_async_data_lbp_pages_found, e.pool_async_index_lbp_pages_found - s.pool_async_index_lbp_pages_found as pool_async_index_lbp_pages_found, e.direct_read_reqs - s.direct_read_reqs as direct_read_reqs, e.direct_write_reqs - s.direct_write_reqs as direct_write_reqs, e.direct_read_time - s.direct_read_time as direct_read_time, e.direct_write_time - s.direct_write_time as direct_write_time, e.tbsp_used_pages - s.tbsp_used_pages as tbsp_used_pages, e.tbsp_page_top - s.tbsp_page_top as tbsp_page_top, e.pool_data_gbp_l_reads - s.pool_data_gbp_l_reads as pool_data_gbp_l_reads, e.pool_data_gbp_p_reads - s.pool_data_gbp_p_reads as pool_data_gbp_p_reads, e.pool_index_gbp_l_reads - s.pool_index_gbp_l_reads as pool_index_gbp_l_reads, e.pool_index_gbp_p_reads - s.pool_index_gbp_p_reads as pool_index_gbp_p_reads, e.pool_data_gbp_invalid_pages - s.pool_data_gbp_invalid_pages as pool_data_gbp_invalid_pages, e.pool_async_data_gbp_invalid_pages - s.pool_async_data_gbp_invalid_pages as pool_async_data_gbp_invalid_pages, e.pool_index_gbp_invalid_pages - s.pool_index_gbp_invalid_pages as pool_index_gbp_invalid_pages, e.pool_async_index_gbp_invalid_pages - s.pool_async_index_gbp_invalid_pages as pool_async_index_gbp_invalid_pages, e.pool_async_data_gbp_l_reads - s.pool_async_data_gbp_l_reads as pool_async_data_gbp_l_reads, e.pool_async_data_gbp_p_reads - s.pool_async_data_gbp_p_reads as pool_async_data_gbp_p_reads, e.pool_async_data_gbp_indep_pages_found_in_lbp - s.pool_async_data_gbp_indep_pages_found_in_lbp as pool_async_data_gbp_indep_pages_found_in_lbp, e.pool_async_index_gbp_l_reads - s.pool_async_index_gbp_l_reads as pool_async_index_gbp_l_reads, e.pool_async_index_gbp_p_reads - s.pool_async_index_gbp_p_reads as pool_async_index_gbp_p_reads, e.pool_async_index_gbp_indep_pages_found_in_lbp - s.pool_async_index_gbp_indep_pages_found_in_lbp as pool_async_index_gbp_indep_pages_found_in_lbp, e.prefetch_wait_time - s.prefetch_wait_time as prefetch_wait_time, e.prefetch_waits - s.prefetch_waits as prefetch_waits, e.skipped_prefetch_data_p_reads - s.skipped_prefetch_data_p_reads as skipped_prefetch_data_p_reads, e.skipped_prefetch_index_p_reads - s.skipped_prefetch_index_p_reads as skipped_prefetch_index_p_reads, e.skipped_prefetch_temp_data_p_reads - s.skipped_prefetch_temp_data_p_reads as skipped_prefetch_temp_data_p_reads, e.skipped_prefetch_temp_index_p_reads - s.skipped_prefetch_temp_index_p_reads as skipped_prefetch_temp_index_p_reads from session.mon_get_tablespace_start s, session.mon_get_tablespace_end e where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.tbsp_name = e.tbsp_name or (s.tbsp_name is NULL and e.tbsp_name is NULL));
insert into session.mon_get_tablespace_diff select null, e.ts,e.member, e.tbsp_name, e.tbsp_page_size, e.tbsp_id, e.tbsp_extent_size, e.tbsp_prefetch_size, e.fs_caching, e.pool_read_time, e.pool_write_time, e.pool_data_writes, e.pool_index_writes, e.pool_data_l_reads, e.pool_temp_data_l_reads, e.pool_async_data_reads, e.pool_data_p_reads, e.pool_async_index_reads, e.pool_index_l_reads, e.pool_temp_index_l_reads, e.pool_index_p_reads, e.unread_prefetch_pages, e.vectored_ios, e.pages_from_vectored_ios, e.block_ios, e.pages_from_block_ios, e.pool_data_lbp_pages_found, e.pool_index_lbp_pages_found, e.pool_async_data_lbp_pages_found, e.pool_async_index_lbp_pages_found, e.direct_read_reqs, e.direct_write_reqs, e.direct_read_time, e.direct_write_time, e.tbsp_used_pages, e.tbsp_page_top, e.pool_data_gbp_l_reads, e.pool_data_gbp_p_reads, e.pool_index_gbp_l_reads, e.pool_index_gbp_p_reads, e.pool_data_gbp_invalid_pages, e.pool_async_data_gbp_invalid_pages, e.pool_index_gbp_invalid_pages, e.pool_async_index_gbp_invalid_pages, e.pool_async_data_gbp_l_reads, e.pool_async_data_gbp_p_reads, e.pool_async_data_gbp_indep_pages_found_in_lbp, e.pool_async_index_gbp_l_reads, e.pool_async_index_gbp_p_reads, e.pool_async_index_gbp_indep_pages_found_in_lbp, e.prefetch_wait_time, e.prefetch_waits, e.skipped_prefetch_data_p_reads, e.skipped_prefetch_index_p_reads, e.skipped_prefetch_temp_data_p_reads, e.skipped_prefetch_temp_index_p_reads from session.mon_get_tablespace_end e where not exists ( select null from session.mon_get_tablespace_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.tbsp_name = e.tbsp_name or (s.tbsp_name is NULL and e.tbsp_name is NULL)) );
update session.mon_get_tablespace_diff set ts_delta = (select max(ts_delta) from session.mon_get_tablespace_diff) where ts_delta is null;
insert into session.mon_get_extended_latch_wait_diff select timestampdiff(2,e.ts-s.ts), e.ts,s.member, s.latch_name, e.total_extended_latch_wait_time - s.total_extended_latch_wait_time as total_extended_latch_wait_time, e.total_extended_latch_waits - s.total_extended_latch_waits as total_extended_latch_waits from session.mon_get_extended_latch_wait_start s, session.mon_get_extended_latch_wait_end e where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.latch_name = e.latch_name or (s.latch_name is NULL and e.latch_name is NULL));
insert into session.mon_get_extended_latch_wait_diff select null, e.ts,e.member, e.latch_name, e.total_extended_latch_wait_time, e.total_extended_latch_waits from session.mon_get_extended_latch_wait_end e where not exists ( select null from session.mon_get_extended_latch_wait_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.latch_name = e.latch_name or (s.latch_name is NULL and e.latch_name is NULL)) );
update session.mon_get_extended_latch_wait_diff set ts_delta = (select max(ts_delta) from session.mon_get_extended_latch_wait_diff) where ts_delta is null;
set current schema session;

echo REPORT STARTS HERE;
echo;

echo ===================================== ;
echo  Current executing SQL (1st capture)  ;
echo ===================================== ;
echo;

select 
  ts,
  coord_member,
  integer(application_handle) handle,
  integer(elapsed_time_sec) elapsed_s,
  substr(activity_state,1,12) state,
  total_cpu_time,
  rows_read,
  stmt_text
from 
  mon_current_sql_start
order by 
  elapsed_time_sec desc;

echo ===================================== ;
echo  Current executing SQL (2nd capture)  ;
echo ===================================== ;
echo;

select 
  ts,
  coord_member,
  integer(application_handle) handle,
  integer(elapsed_time_sec) elapsed_s,
  substr(activity_state,1,12) state,
  total_cpu_time,
  rows_read,
  translate(substr(stmt_text,1,200),' ',chr(10)) as stmt_text
from 
  mon_current_sql_end
order by 
  elapsed_time_sec desc;

echo =================== ;
echo  Current utilities  ;
echo =================== ;
echo;

list utilities show detail;


echo ====================================== ;
echo  Throughput metrics at database level  ;
echo ====================================== ;
echo;

select
   min(ts_delta) ts_delta,
   member,
   decimal((sum(act_completed_total) / float(min(ts_delta))), 10, 1) as act_per_s,
   decimal((sum(total_app_commits) / float(min(ts_delta))), 10, 1) as cmt_per_s,
   decimal((sum(total_app_rollbacks) / float(min(ts_delta))), 10, 1) as rb_per_s,
   decimal((sum(deadlocks) / float(min(ts_delta))), 10, 1) as ddlck_per_s,


   decimal((sum(select_sql_stmts) / float(min(ts_delta))), 10, 1) as sel_p_s,
   decimal((sum(uid_sql_stmts) / float(min(ts_delta))), 10, 1) as uid_p_s,
   decimal((sum(rows_inserted) / float(min(ts_delta))), 10, 1) as rows_ins_p_s,
   decimal((sum(rows_updated) / float(min(ts_delta))), 10, 1) as rows_upd_p_s,


   decimal((sum(rows_returned) / float(min(ts_delta))), 10, 1) as rows_ret_p_s,
   decimal((sum(rows_modified) / float(min(ts_delta))), 10, 1) as rows_ins_p_s,
   decimal((sum(pkg_cache_inserts) / float(min(ts_delta))), 10, 1) as pkg_cache_ins_p_s,
   decimal((sum(pool_data_p_reads + pool_index_p_reads) / float(min(ts_delta))) , 10, 1) as p_rd_per_s
from
   mon_get_workload_diff
where
	ts_delta > 0
group by 
   member
order by
   member asc;

echo ============================== ;
echo  Wait times at database level  ;
echo ============================== ;
echo;

select
   w.member,
   integer(sum(total_rqst_time)) as total_rqst_tm,
   integer(sum(total_wait_time)) as total_wait_tm,
   decimal(avg(idle_rqst_ratio), 10, 2)  as idle_rqst_ratio,
   decimal((sum(total_wait_time) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_rqst_wait,
   decimal((sum(lock_wait_time) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_lock,
   decimal((sum(lock_wait_time_global) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_glb_lock,   
   decimal((sum(total_extended_latch_wait_time) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_ltch,
   decimal((sum(log_disk_wait_time) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_log_dsk,
   decimal((sum(reclaim_wait_time) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_rclm,
   decimal((sum(cf_wait_time) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_cf,
   decimal((sum(pool_read_time) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_pool_r,
   decimal((sum(direct_read_time) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_dir_r,
   decimal((sum(direct_write_time) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_dir_w,
   decimal((sum(FCM_RECV_WAIT_TIME) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_fcm_r,
   decimal((sum(FCM_SEND_WAIT_TIME) / float(sum(total_rqst_time))) * 100, 5, 2) as pct_fcm_s
from
   mon_get_workload_diff w,
   (  select
         member,
         decimal(float(sum(client_idle_wait_time)) / sum(total_rqst_time), 10, 2) as idle_rqst_ratio
      from
         mon_get_connection_diff
      where
         rqsts_completed_total > 0
      group by
         member
   ) c
where
   w.member = c.member
group by
   w.member
order by
   w.member asc;


echo ====================================== ;
echo  Top SQL statements by execution time  ;
echo ====================================== ;
echo;

select
   member,
   num_exec_with_metrics,
   total_act_time,
   decimal(total_act_time / double(num_exec_with_metrics), 10, 2) as avg_act_time,
   total_cpu_time,
   decimal(total_cpu_time / double(num_exec_with_metrics), 15, 2) as avg_cpu_time,
   decimal( (total_act_time / double(total_total_act_time)) * 100, 5, 2 ) as pct_total_act_time,
   decimal( (total_act_wait_time / double(total_act_time)) * 100, 5, 2 ) as pct_wait_time,
   translate(substr(stmt_text,1,200),' ',chr(10)) as stmt_text
from
	mon_get_pkg_cache_stmt_diff,
  (  select
        sum(total_act_time) as total_total_act_time
     from
        mon_get_pkg_cache_stmt_diff   )
where
	total_act_time <> 0
order by
	total_act_time desc
fetch first 100 rows only;

echo ============================================================== ;
echo  Wait time breakdown for top SQL statements by execution time  ;
echo ============================================================== ;
echo;

select
   member,
   decimal((total_act_wait_time / double(total_act_time)) * 100, 5, 2) as pct_wait,
   decimal((log_disk_wait_time / double(total_act_time)) * 100, 5, 2) as pct_log_disk,
   decimal((log_buffer_wait_time/double(total_act_time)) * 100, 5, 2) as pct_log_buff,
   decimal((lock_wait_time / double(total_act_time)) * 100, 5, 2) as pct_lock,


   decimal((lock_wait_time_global / double(total_act_time)) * 100, 5, 2) as pct_glb_lock,
   decimal((total_extended_latch_wait_time / double(total_act_time)) * 100, 5, 2) as pct_latch,
   decimal((reclaim_wait_time / double(total_act_time)) * 100, 5, 2) as pct_reclaim,
   decimal((cf_wait_time / double(total_act_time)) * 100, 5, 2) as pct_cf,
   decimal((prefetch_wait_time / double(total_act_time)) * 100, 5, 2) as pct_prefetch,
   decimal((diaglog_write_wait_time / double(total_act_time)) * 100, 5, 2) as pct_diag_write,


   decimal((pool_write_time / double(total_act_time)) * 100, 5, 2) as pct_pool_write,
   decimal((pool_read_time / double(total_act_time)) * 100, 5, 2) as pct_pool_read,
   decimal((direct_write_time / double(total_act_time)) * 100, 5, 2) as pct_direct_write,
   decimal((direct_read_time / double(total_act_time)) * 100, 5, 2) as pct_direct_read,
   translate(substr(stmt_text,1,200),' ',chr(10)) as stmt_text
from
	mon_get_pkg_cache_stmt_diff
where
	total_act_time <> 0
order by
	total_act_time desc
fetch first 100 rows only;

echo ========================================== ;
echo  Top SQL statements by time spent waiting  ;
echo ========================================== ;
echo;

select
   member,
   decimal((total_act_wait_time / double(total_act_time)) * 100, 5, 2) as pct_wait,
   decimal((log_disk_wait_time / double(total_act_time)) * 100, 5, 2) as pct_log_disk,
   decimal((log_buffer_wait_time/double(total_act_time)) * 100, 5, 2) as pct_log_buff,
   decimal((lock_wait_time / double(total_act_time)) * 100, 5, 2) as pct_lock,


   decimal((lock_wait_time_global / double(total_act_time)) * 100, 5, 2) as pct_glb_lock,
   decimal((total_extended_latch_wait_time / double(total_act_time)) * 100, 5, 2) as pct_latch,
   decimal((reclaim_wait_time / double(total_act_time)) * 100, 5, 2) as pct_reclaim,
   decimal((cf_wait_time / double(total_act_time)) * 100, 5, 2) as pct_cf,
   decimal((prefetch_wait_time / double(total_act_time)) * 100, 5, 2) as pct_prefetch,
   decimal((diaglog_write_wait_time / double(total_act_time)) * 100, 5, 2) as pct_diag_write,


   decimal((pool_write_time / double(total_act_time)) * 100, 5, 2) as pct_pool_write,
   decimal((pool_read_time / double(total_act_time)) * 100, 5, 2) as pct_pool_read,
   decimal((direct_write_time / double(total_act_time)) * 100, 5, 2) as pct_direct_write,
   decimal((direct_read_time / double(total_act_time)) * 100, 5, 2) as pct_direct_read,
   translate(substr(stmt_text,1,200),' ',chr(10)) as stmt_text
from
	mon_get_pkg_cache_stmt_diff
where
	total_act_wait_time <> 0
order by
	total_act_wait_time desc
fetch first 100 rows only;

echo ================================= ;
echo  IO statistics per SQL statement  ;
echo ================================= ;
echo;

select
   member,
   num_exec_with_metrics,
   pool_data_p_reads as d_rds,
   pool_data_writes as d_wrts,
   pool_index_p_reads as i_rds,
   pool_index_writes as i_wrts,
   pool_temp_data_p_reads as td_rds,
   pool_temp_index_p_reads ti_rds,
   direct_read_reqs,
   direct_write_reqs,
   translate(substr(stmt_text,1,200),' ',chr(10)) as stmt_text
from
	mon_get_pkg_cache_stmt_diff,
  (  select
        sum(total_act_time) as total_total_act_time
     from
        mon_get_pkg_cache_stmt_diff   )
where
	total_act_time <> 0
order by
	total_act_time desc
fetch first 100 rows only;

echo ======================================== ;
echo  Row level statistics per SQL statement  ;
echo ======================================== ;
echo;

select
  member,
	num_exec_with_metrics,
	rows_modified,
	rows_read,
	rows_returned,
   translate(substr(stmt_text,1,200),' ',chr(10)) as stmt_text
from
	mon_get_pkg_cache_stmt_diff
where
	total_act_time <> 0
order by
	total_act_time desc
fetch first 100 rows only;

echo =================================== ;
echo  Sort statistics per SQL statement  ;
echo =================================== ;
echo;

select
  member,
	decimal((total_section_sort_time / double(total_act_time)) * 100, 5, 2) as pct_sort_time,
	total_sorts,
	sort_overflows,
   translate(substr(stmt_text,1,200),' ',chr(10)) as stmt_text
from
	mon_get_pkg_cache_stmt_diff
where
	total_act_time <> 0
order by
	total_act_time desc
fetch first 100 rows only;


echo ========================== ;
echo  Database log write times  ;
echo ========================== ;
echo;

select
   member,
   log_writes,
   num_log_write_io,
   case when ts_delta > 0
      then decimal( double(num_log_write_io) / ts_delta, 10, 4 )
      else null
   end as log_write_io_per_s,
   log_write_time,
   case when num_log_write_io > 0
      then decimal( double(log_write_time) / num_log_write_io, 10, 4 )
      else null
   end as log_write_time_per_io_ms,
   num_log_buffer_full
from
   mon_get_transaction_log_diff
order by
   member asc;

echo ========================= ;
echo  Database log read times  ;
echo ========================= ;
echo;

select
   member,
   log_reads,
   num_log_read_io,
   case when ts_delta > 0
      then decimal( double(num_log_read_io) / ts_delta, 10, 4 )
      else null
   end as log_read_io_per_s,
   log_read_time,
   case when num_log_read_io > 0
      then decimal( double(log_read_time) / num_log_read_io, 10, 4 )
      else null
   end as log_read_time_per_io_ms
from
   mon_get_transaction_log_diff
order by
   member asc;

echo =============================== ;
echo  Other database log statistics  ;
echo =============================== ;
echo;

select
   member,
   num_log_write_io,
   num_log_part_page_io,
   case when num_log_part_page_io > 0
      then decimal( double(num_log_part_page_io) / num_log_write_io, 10, 4 )
      else null
   end as log_part_page_ratio,
   case when log_hadr_waits_total > 0
      then decimal( double(log_hadr_wait_time) / log_hadr_waits_total, 10, 4 )
      else null
   end as avg_log_hadr_wait_time
from
   mon_get_transaction_log_diff
order by
   member asc;


echo =============================== ;
echo  Disk read and write I/O times  ;
echo =============================== ;
echo;

select
   member,
   varchar(tbsp_name,20) as tbsp_name,

   -- Reads

   pool_data_p_reads + pool_index_p_reads as num_reads,
   case when (pool_data_p_reads + pool_index_p_reads) > 0
      then decimal( pool_read_time / double(pool_data_p_reads + pool_index_p_reads), 5, 2 )
      else null
   end as avg_read_time,

   direct_read_reqs,
   case when direct_read_reqs > 0
      then decimal( direct_read_time / direct_read_reqs, 5, 2 )
      else null
   end as avg_drct_read_time,

   -- Writes

   pool_data_writes + pool_index_writes as num_writes,
   case when (pool_data_writes + pool_index_writes) > 0
      then decimal( pool_write_time / double(pool_data_writes + pool_index_writes), 5, 2 )
      else null
   end as avg_write_time,

   direct_write_reqs,
   case when direct_write_reqs > 0
      then decimal( direct_write_time / direct_write_reqs, 5, 2 )
      else null
   end as avg_drct_write_time
from
   mon_get_tablespace_diff
where
   (pool_data_p_reads + pool_index_p_reads + direct_read_reqs + pool_data_writes + pool_index_writes + direct_write_reqs) > 0
order by
   (pool_data_p_reads + pool_index_p_reads + direct_read_reqs + pool_data_writes + pool_index_writes + direct_write_reqs) desc;


echo ==================== ;
echo  Latch wait metrics  ;
echo ==================== ;
echo;

select
   member,
   varchar(latch_name,60) as latch_name,
   total_extended_latch_wait_time as total_extended_latch_wait_time_ms,
   total_extended_latch_waits,
   decimal( double(total_extended_latch_wait_time) / total_extended_latch_waits, 10, 2 ) as time_per_latch_wait_ms
from
   mon_get_extended_latch_wait_diff
where
  total_extended_latch_waits > 0
order by
   total_extended_latch_wait_time desc;


echo ======================= ;
echo  Locks being waited on  ;
echo ======================= ;
echo;

select
	lock_wait_start_time,
	(select substr(tbspace,1,40) from syscat.tablespaces where tbspaceid = tbsp_id) tbspace,
	(select substr(tabname,1,40) from syscat.tables where tab_file_id = tableid and tbspaceid = tbsp_id) tabname,
	substr(lock_object_type,1,12) lock_obj_type,
  lock_mode,
  lock_mode_requested lock_mode_req,
	lock_status,
	req_member,
	hld_member
from
	table(mon_get_appl_lockwait(null,-2))
order by
	lock_wait_start_time asc;

echo ============================= ;
echo  Various table level metrics  ;
echo ============================= ;
echo;

select
  member,
  substr(tabname,1,40) as tabname,
  data_partition_id,
  rows_read,
  rows_inserted,
  rows_updated,
  rows_deleted,
  overflow_accesses,
  overflow_creates,
  page_reorgs,

  direct_read_reqs,
  direct_write_reqs,
  object_data_p_reads,
  case when (object_data_l_reads) > 0
    then decimal(float(object_data_l_reads - object_data_p_reads) / (object_data_l_reads) * 100, 5, 2)
    else null
  end as table_hr,


  overflow_accesses,
  overflow_creates,
  page_reorgs
from
  mon_get_table_diff
where
  rows_read + rows_inserted + rows_updated + rows_deleted + page_reorgs > 0
order by
  tabname asc;


echo ====================== ;
echo  Data sharing metrics  ;
echo ====================== ;
echo;

select
  member,
  substr(tabname,1,40) as tabname,
  data_partition_id as data_part_id,
  data_sharing_state_change_time,
  data_sharing_state,
  data_sharing_remote_lockwait_count,
  data_sharing_remote_lockwait_time
from
  mon_get_table_diff
where
  rows_read + rows_inserted + rows_updated + rows_deleted + page_reorgs > 0
  and data_sharing_state_change_time is not null
order by
  tabname asc;


echo ================== ;
echo  Size of database  ;
echo ================== ;
echo;

select
	member,
	decimal( sum( double(tbsp_used_pages) * tbsp_page_size ) / 1024 / 1024, 10, 2 ) as db_mb_used
from
	table( mon_get_tablespace(null, -2) )
group by
	member
order by
	member asc;

echo ======================= ;
echo  Tablespace properties  ;
echo ======================= ;
echo;

select
  member,
  varchar(tbsp_name, 30) as tbsp_name,
  tbsp_page_size,
  tbsp_used_pages,
  decimal( (double(tbsp_used_pages) * tbsp_page_size) / 1024 / 1024, 10, 2 ) as tbsp_mb_used,
  decimal( (double(tbsp_page_top) * tbsp_page_size) / 1024 / 1024, 10, 2) as tbsp_mb_hwm,
  tbsp_extent_size,
  case fs_caching when 2 then 'Default off' when 1 then 'Explicit off' else 'Explicit on' end fs_caching,
  tbsp_prefetch_size
from
	mon_get_tablespace_end
order by
	member asc, tbsp_used_pages desc;

echo =========================================== ;
echo  Tablespace usage over monitoring interval  ;
echo =========================================== ;
echo;

select
  member,
  varchar(tbsp_name, 30) as tbsp_name,
  tbsp_used_pages,
  decimal( (double(tbsp_used_pages) * tbsp_page_size) / 1024 / 1024, 10, 2 ) as tbsp_mb_used
from
	mon_get_tablespace_diff
where 
	tbsp_used_pages > 0
order by
	member asc, tbsp_used_pages desc;

echo ===================================== ;
echo  Bufferpool statistics by tablespace  ;
echo ===================================== ;
echo;

select
   member,
   varchar(tbsp_name,20) as tbsp_name,

   -- Data pages

   pool_data_l_reads as data_l_reads,
   pool_data_p_reads as data_p_reads,
   case when (pool_data_l_reads) > 1000
      then decimal(float(pool_data_l_reads-(pool_data_p_reads-pool_async_data_reads))/(pool_data_l_reads)*100,5,2)
      else null
   end as data_hr,
   case when (pool_data_l_reads) > 1000
      then
         decimal((pool_data_lbp_pages_found - pool_async_data_lbp_pages_found - pool_temp_data_l_reads) / float(pool_data_l_reads) * 100, 5, 2)
      else 0
   end as data_lbp_hr,

   -- Index pages

   pool_index_l_reads as index_l_reads,
   pool_index_p_reads as index_p_reads,
   case when (pool_index_l_reads) > 1000
      then decimal(float(pool_index_l_reads-(pool_index_p_reads-pool_async_index_reads))/(pool_index_l_reads)*100,5,2)
      else null
   end as index_hr,
   case when (pool_index_l_reads) > 1000
      then
         decimal((pool_index_lbp_pages_found - pool_async_index_lbp_pages_found - pool_temp_index_l_reads) / float(pool_index_l_reads) * 100, 5, 2)
      else 0
   end as index_lbp_hr
from
   mon_get_tablespace_diff
where
   (pool_data_l_reads) > 0 or (pool_index_l_reads) > 0
order by
   pool_read_time desc;


echo =========================================== ;
echo  Group Bufferpool statistics by tablespace  ; 
echo =========================================== ;
echo;

select
   member,
   varchar(tbsp_name,20) as tbsp_name,

   -- Data pages

   case when pool_data_gbp_l_reads > 0
      then decimal( (double(pool_data_gbp_l_reads - pool_data_gbp_p_reads) / pool_data_gbp_l_reads) * 100, 5, 2 )
      else null
   end as data_gbp_hitratio,

   case when pool_data_l_reads > 0
      then decimal( (double(pool_data_lbp_pages_found - pool_async_data_lbp_pages_found) / pool_data_l_reads) * 100, 5, 2 )
      else null
   end as data_lbp_hitratio,

   case when pool_data_gbp_l_reads > 0
      then decimal( (double(pool_data_gbp_invalid_pages - pool_async_data_gbp_invalid_pages) / pool_data_gbp_l_reads) * 100, 5, 2 )
      else null
   end as pct_data_invalid,

   -- Index pages

   case when pool_index_gbp_l_reads > 0
      then decimal( (double(pool_index_gbp_l_reads - pool_index_gbp_p_reads) / pool_index_gbp_l_reads) * 100, 5, 2 )
      else null
   end as index_gbp_hitratio,

   case when pool_index_l_reads > 0
      then decimal( (double(pool_index_lbp_pages_found - pool_async_index_lbp_pages_found) / pool_index_l_reads) * 100, 5, 2 )
      else null
   end as index_lbp_hitratio,

   case when pool_index_gbp_l_reads > 0
      then decimal( (double(pool_index_gbp_invalid_pages - pool_async_index_gbp_invalid_pages) / pool_index_gbp_l_reads) * 100, 5, 2 )
      else null
   end as pct_index_invalid
from
   mon_get_tablespace_diff
where
   (pool_data_gbp_l_reads ) > 0 or (pool_index_gbp_l_reads ) > 0
order by
   (pool_data_gbp_l_reads + pool_data_gbp_p_reads + pool_index_gbp_l_reads + pool_index_gbp_p_reads) desc;


echo =================================== ;
echo  Tablespace prefetching statistics  ;
echo =================================== ;
echo;

select
  member,
  varchar(tbsp_name, 30) as tbsp_name,
  pool_async_data_reads,
  pool_data_p_reads,
  pool_async_index_reads,
  pool_index_p_reads,


  prefetch_wait_time,
  prefetch_waits,


  unread_prefetch_pages

from
	mon_get_tablespace_diff
where 
	pool_data_p_reads + pool_index_p_reads > 0
order by
	member asc, (pool_data_p_reads + pool_index_p_reads) desc;

select
  member,
  varchar(tbsp_name, 30) as tbsp_name,
  vectored_ios,
  pages_from_vectored_ios,
  block_ios,
  pages_from_block_ios
from
	mon_get_tablespace_diff
where
   vectored_ios + block_ios > 0
order by
	member asc, (vectored_ios + block_ios) desc;


echo ================================================================== ;
echo  Tablespace data page prefetching statistics for group bufferpool  ;
echo ================================================================== ;
echo;

select
  member,
  varchar(tbsp_name, 30) as tbsp_name,
  pool_async_data_gbp_l_reads,
  pool_async_data_gbp_p_reads,
  pool_async_data_lbp_pages_found,
  pool_async_data_gbp_invalid_pages,
  pool_async_data_gbp_indep_pages_found_in_lbp
from
	mon_get_tablespace_diff
where
   pool_async_data_gbp_l_reads > 0
order by
	member asc, pool_async_data_gbp_l_reads  desc;

echo =================================================================== ;
echo  Tablespace index page prefetching statistics for group bufferpool  ;
echo =================================================================== ;
echo;

select
  member,
  varchar(tbsp_name, 30) as tbsp_name,
  pool_async_index_gbp_l_reads,
  pool_async_index_gbp_p_reads,
  pool_async_index_lbp_pages_found,
  pool_async_index_gbp_invalid_pages,
  pool_async_index_gbp_indep_pages_found_in_lbp
from
	mon_get_tablespace_diff
where
   pool_async_index_gbp_l_reads > 0
order by
	member asc, pool_async_index_gbp_l_reads  desc;


echo ================================== ;
echo  Tablespace to bufferpool mapping  ;
echo ================================== ;
echo;

select
   varchar(tbspace,20) as tbsp_name,
   datatype,
   varchar(bpname,20) as bpname
from
   syscat.tablespaces t, syscat.bufferpools b
where
   t.bufferpoolid = b.bufferpoolid;

echo ================== ;
echo  Bufferpool sizes  ;
echo ================== ;
echo;

select
   member,
   varchar(bp_name,20) as bp_name,
   b.pagesize,
   mgb.bp_cur_buffsz as num_pages,
   decimal(double(b.pagesize) * mgb.bp_cur_buffsz / 1024 / 1024, 10, 2) as size_mb
from
   syscat.bufferpools b, mon_get_bufferpool_diff mgb
where
   b.bpname = mgb.bp_name
order by
   member;

echo ====================================== ;
echo  Bufferpool data and index hit ratios  ;
echo ====================================== ;
echo;

select
   member,
   varchar(bp_name,20) as bp_name,

   -- Data pages

   case when (pool_data_l_reads) > 0
      then
         decimal( ( double(pool_data_lbp_pages_found - pool_async_data_lbp_pages_found ) / (pool_data_l_reads + pool_temp_data_l_reads) ) * 100, 5, 2 )
      else 0
   end as data_lbp_hitratio,

   -- Index pages

   case when (pool_index_l_reads) > 0
      then
         decimal( ( double(pool_index_lbp_pages_found - pool_async_index_lbp_pages_found ) / (pool_index_l_reads + pool_temp_index_l_reads) ) * 100, 5, 2 )
      else 0
   end as index_lbp_hitratio
from
   mon_get_bufferpool_diff
where
   pool_data_l_reads > 0 or pool_index_l_reads > 0
order by
   (pool_data_l_reads + pool_index_l_reads) desc;

echo ============================ ;
echo  Bufferpool read statistics  ;
echo ============================ ;
echo;

select
   member,
   varchar(bp_name,20) as bp_name,
   pool_data_l_reads,
   pool_data_p_reads,
   pool_index_l_reads,
   pool_index_p_reads,
   pool_read_time,
   case when (pool_data_p_reads + pool_index_p_reads) > 0
      then decimal( pool_read_time / double(pool_data_p_reads + pool_index_p_reads), 5, 2 )
      else null
   end as avg_read_time
from
   mon_get_bufferpool_diff
where
   (pool_data_l_reads) > 0 or (pool_index_l_reads) > 0
order by
   (pool_data_l_reads + pool_index_l_reads) desc;

echo ============================= ;
echo  Bufferpool write statistics  ;
echo ============================= ;
echo;

select
   member,
   varchar(bp_name,20) as bp_name,
   pool_data_writes,
   pool_async_data_writes,
   pool_index_writes,
   pool_async_index_writes,
   pool_write_time,
   case when (pool_data_writes + pool_index_writes) > 0
      then decimal( pool_write_time / double(pool_data_writes + pool_index_writes), 5, 2 )
      else null
   end as avg_write_time
from
   mon_get_bufferpool_diff
where
   (pool_data_writes) > 0 or (pool_index_writes) > 0
order by
   (pool_data_writes + pool_index_writes) desc;


echo =========================================== ;
echo  Count of group bufferpool full conditions  ;
echo =========================================== ;
echo;

select
   member,
   num_gbp_full
from
   mon_get_group_bufferpool_diff
order by 
   member asc;

echo ============================================ ;
echo  Group bufferpool data and index hit ratios  ;
echo ============================================ ;
echo;

select
   member,
   varchar(bp_name,20) as bp_name,

   -- Data pages

   pool_data_gbp_l_reads,
   pool_data_gbp_p_reads,
   case when pool_data_gbp_l_reads > 0
      then decimal( ( double(pool_data_gbp_l_reads - pool_data_gbp_p_reads) / pool_data_gbp_l_reads ) * 100 , 5, 2 )
      else null
   end as data_gbp_hitratio,

   -- Index pages

   pool_index_gbp_l_reads,
   pool_index_gbp_p_reads,
   case when pool_index_gbp_l_reads > 0
      then decimal( ( double(pool_index_gbp_l_reads - pool_index_gbp_p_reads) / pool_index_gbp_l_reads ) * 100, 5, 2 )
      else null
   end as index_gbp_hitratio
from
   mon_get_bufferpool_diff
where
   (pool_data_gbp_l_reads ) > 0 or (pool_index_gbp_l_reads ) > 0
order by
   pool_read_time desc;

echo ========================================== ;
echo  Group bufferpool invalid page statistics  ;
echo ========================================== ;
echo;

select
   member,
   varchar(bp_name,20) as bp_name,

   -- Data pages

   case when pool_data_gbp_l_reads > 0
      then decimal( ( double(pool_data_gbp_invalid_pages - pool_async_data_gbp_invalid_pages) / pool_data_gbp_l_reads ) * 100, 5, 2 )
      else null
   end as pct_data_gbp_invalid,

   -- Index pages

   case when pool_index_gbp_l_reads > 0
      then decimal( ( double(pool_index_gbp_invalid_pages - pool_async_index_gbp_invalid_pages) / pool_index_gbp_l_reads ) * 100, 5, 2 )
      else null
   end as pct_index_gbp_invalid
from
   mon_get_bufferpool_diff
where
   (pool_data_gbp_l_reads) > 0 or (pool_index_gbp_l_reads) > 0
order by
   pool_read_time desc;

echo =============================================== ;
echo  Page reclaim metrics for index and data pages  ;
echo =============================================== ;
echo;

select
   member,
   varchar(tabschema,20) as tabschema,
   varchar(tabname,40) as tabname,
   varchar(objtype,10) as objtype,
   data_partition_id,
   iid,
   (page_reclaims_x + page_reclaims_s) as page_reclaims,
   reclaim_wait_time
from
   mon_get_page_access_info_diff
where
  reclaim_wait_time > 0
order by
   reclaim_wait_time desc;

echo ==================================== ;
echo  Page reclaim metrics for SMP pages  ;
echo ==================================== ;
echo;

select
   member,
   varchar(tabschema,20) as tabschema,
   varchar(tabname,40) as tabname,
   varchar(objtype,10) as objtype,
   data_partition_id,
   iid,
   (spacemappage_page_reclaims_x + spacemappage_page_reclaims_s) as smp_page_reclaims,
   spacemappage_reclaim_wait_time as smp_page_reclaim_wait_time
from
   mon_get_page_access_info_diff
where
  spacemappage_reclaim_wait_time > 0
order by
   spacemappage_reclaim_wait_time desc;

echo =================================================================== ;
echo  Round-trip CF command execution counts and average response times  ;
echo =================================================================== ;
echo;

select
   member,
   id,
   varchar(cf_cmd_name, 30) as cf_cmd_name,
   total_cf_requests,
   decimal( double(total_cf_wait_time_micro) / total_cf_requests, 15, 2 ) as avg_cf_request_time_micro
from
   mon_get_cf_wait_time_diff
where
   total_cf_requests > 0
order by
   id asc, total_cf_requests desc;

echo ================================================= ;
echo  Aggregate CF command execution counts by member  ;
echo ================================================= ;
echo;

select
   member,
   id,
   sum(total_cf_requests) as total_cf_requests
from
   mon_get_cf_wait_time_diff
group by
   member, id
order by
   member asc, id asc, total_cf_requests desc;

echo ========================================== ;
echo  Cluster wide CF command execution counts  ;
echo ========================================== ;
echo;

select
   id,
   sum(total_cf_requests) as total_cf_requests
from
   mon_get_cf_wait_time_diff
group by
   id
order by
   id asc, total_cf_requests desc;

echo ============================================================= ;
echo  CF-side command execution counts and average response times  ;
echo ============================================================= ;
echo;

select
   d.id,
   varchar(cf_cmd_name, 50) as cf_cmd_name,
   total_cf_requests,
   decimal( (total_cf_requests / double(total_total_cf_requests)) * 100, 5, 2 ) as pct_total_cf_cmd,
   decimal( double(total_cf_cmd_time_micro) / total_cf_requests, 15, 2 ) as avg_cf_request_time_micro
from
   mon_get_cf_cmd_diff as d,
   ( select id, sum(total_cf_requests) as total_total_cf_requests
     from mon_get_cf_cmd_diff
     group by id ) as c
where
   d.total_cf_requests > 0 and d.id = c.id
order by
   id asc, total_cf_requests desc;

echo ======================================== ;
echo  CF-side total command execution counts  ;
echo ======================================== ;
echo;

select
   id,
   sum(total_cf_requests) as total_cf_requests
from
   mon_get_cf_cmd_diff
group by
   id
order by
   id asc, total_cf_requests desc;


echo ================================ ;
echo  CF system resource information  ;
echo ================================ ;
echo;

select
   id,
   varchar(name, 30) as name,
   varchar(value, 50) as value,
   varchar(unit, 10) as unit
from
   sysibmadm.env_cf_sys_resources
order by
   id asc, name asc;


echo ================================ ;
echo  Wait times at connection level  ;
echo ================================ ;
echo;

select
   member,
   substr(application_name, 1, 20) as app_name,
   substr(client_applname, 1, 20) as client_name,
   application_handle,
   decimal((client_idle_wait_time / double(total_rqst_time)), 10, 2) as idle_rq_ratio,
   decimal((total_wait_time / double(total_rqst_time)) * 100, 5, 2) as pct_wt,
   decimal((log_buffer_wait_time / double(total_rqst_time)) * 100, 5, 2) as pct_logbuff_wt,
   decimal((log_disk_wait_time / double(total_rqst_time)) * 100, 5, 2) as pct_logdisk_wt,
   decimal((lock_wait_time / double(total_rqst_time)) * 100, 5, 2) as pct_lck_wt,


   decimal((lock_wait_time_global / double(total_rqst_time)) * 100, 5, 2) as pct_glb_lck_wt,
   decimal((total_extended_latch_wait_time / double(total_rqst_time)) * 100, 5, 2) as pct_latch_wt,
   decimal((cf_wait_time / double(total_rqst_time)) * 100, 5, 2) as pct_cf_wt,
   decimal((reclaim_wait_time / double(total_rqst_time)) * 100, 5, 2) as pct_reclaim_wt,


   decimal((pool_read_time / double(total_rqst_time)) * 100, 5, 2) as pct_pool_rd_time,
   decimal((pool_write_time / double(total_rqst_time)) * 100, 5, 2) as pct_pool_wr_time,
   decimal((total_commit_time / double(total_rqst_time)) * 100, 5, 2) as pct_commit_time,
   decimal((total_section_sort_time / double(total_rqst_time)) * 100, 5, 2) as pct_sort_time
from
   mon_get_connection_diff
where
   total_rqst_time <> 0
order by
   member asc, total_wait_time / double(total_rqst_time) desc;

echo ===================================== ;
echo  Various metrics at connection level  ;
echo ===================================== ;
echo;

select
   member,
   substr(application_name, 1, 20) as app_name,
   substr(client_applname, 1, 20) as client_name,
   application_handle,
   total_app_commits,
   total_app_rollbacks,
   deadlocks,
   rows_modified,
   rows_read,
   rows_returned,
   total_sorts
from
   mon_get_connection_diff
where
   total_rqst_time <> 0
order by
   member asc, total_wait_time / double(total_rqst_time) desc;

echo ================================================================= ;
echo  Physical and logical page reads and writes at connection level   ;
echo ================================================================= ;
echo ;
    
select
   member,
   substr(application_name, 1, 20) as app_name,
   substr(client_applname, 1, 20) as client_name,
   application_handle,
   total_app_commits,
   total_app_rollbacks,
   pool_data_l_reads,
   pool_data_p_reads,
   pool_index_l_reads,
   pool_index_p_reads
from
   mon_get_connection_diff
where
   total_rqst_time <> 0
order by
   member asc, total_wait_time / double(total_rqst_time) desc;


echo ================================ ;
echo  Workload balancing server list  ;
echo ================================ ;
echo ;

select
  member,
  cached_timestamp,
  substr(hostname, 1, 20) as hostname,
  port_number,
  ssl_port_number,
  priority
from
  table(mon_get_serverlist(-2))
order by
  member asc, priority desc;

echo ================================ ;
echo  DB2 registry variable settings  ;
echo ================================ ;
echo;

select
   member,
   varchar(reg_var_name, 50) as reg_var_name,
   varchar(reg_var_value, 50) as reg_var_value,
   level
from
   table(env_get_reg_variables(-2))
order by
  member desc;


echo ================================= ;
echo  Database memory set information  ;
echo ================================= ;
echo;

select
   member,
   varchar(memory_set_type, 20) as set_type,
   varchar(db_name, 20) as dbname,
   decimal( double(memory_set_used) / 1024, 10, 2 ) as memory_set_used_mb,
   decimal( double(memory_set_used_hwm) / 1024, 10, 2 ) as memory_set_used_hwm_mb
from
   table( mon_get_memory_set(null, null, -2) )
order by
   member asc, memory_set_used desc;

echo ========================= ;
echo  Memory pool information  ;
echo ========================= ;
echo;

select
   member,
   varchar(memory_pool_type, 20) as memory_pool_type,
   varchar(db_name,20) as db_name,
   decimal( double(memory_pool_used) / 1024, 10, 2 ) as memory_pool_used_mb,
   decimal( double(memory_pool_used_hwm) / 1024, 10, 2 ) as memory_pool_used_hwm_mb
from
   table( mon_get_memory_pool('database',null,-2) )
order by
   member asc, memory_pool_used desc;

echo ======================= ;
echo  Sequences information  ;
echo ======================= ;
echo;

select
   substr(seqschema,1,40) as seqschema,
   substr(seqname,1,40) as seqname,
   seqtype,
   cache,
   order
from
   syscat.sequences;

