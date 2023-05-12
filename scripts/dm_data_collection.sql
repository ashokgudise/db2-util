create schema session;
drop table session.mon_get_pkg_cache_stmt_start;
drop table session.mon_get_pkg_cache_stmt_end;
drop table session.mon_get_pkg_cache_stmt_diff;
drop table session.mon_get_page_access_info_start;
drop table session.mon_get_page_access_info_end;
drop table session.mon_get_page_access_info_diff;

declare global temporary table session.mon_get_pkg_cache_stmt_start as ( select current timestamp ts, member, executable_id, stmt_text , total_act_time, total_act_wait_time, reclaim_wait_time from table (mon_get_pkg_cache_stmt( null, null, null, -2) ) ) with no data on commit preserve rows not logged;

declare global temporary table session.mon_get_pkg_cache_stmt_end like session.mon_get_pkg_cache_stmt_start on commit preserve rows not logged;

declare global temporary table session.mon_get_pkg_cache_stmt_diff as ( select cast(null as integer) ts_delta, current timestamp ts,member, executable_id, stmt_text, total_act_time, total_act_wait_time, reclaim_wait_time from table (mon_get_pkg_cache_stmt( null, null, null, -2) ) ) with no data on commit preserve rows not logged;

declare global temporary table session.mon_get_page_access_info_start as ( select current timestamp ts,member, tabschema, tabname, objtype, data_partition_id, iid, page_reclaims_x, page_reclaims_s, reclaim_wait_time from table (mon_get_page_access_info( null, null, -2) ) ) with no data on commit preserve rows not logged;

declare global temporary table session.mon_get_page_access_info_end like session.mon_get_page_access_info_start on commit preserve rows not logged;

declare global temporary table session.mon_get_page_access_info_diff as ( select cast(null as integer) ts_delta,current timestamp ts,member, tabschema, tabname, objtype, data_partition_id, iid, page_reclaims_x, page_reclaims_s, reclaim_wait_time from table (mon_get_page_access_info( null, null, -2) ) ) with no data on commit preserve rows not logged;

insert into session.mon_get_pkg_cache_stmt_start select current timestamp, member, executable_id, stmt_text, total_act_time, total_act_wait_time, reclaim_wait_time from table (mon_get_pkg_cache_stmt( null, null, null, -2) ) order by total_act_time desc fetch first 100 rows only;

insert into session.mon_get_page_access_info_start select current timestamp,member, tabschema, tabname, objtype, data_partition_id, iid, page_reclaims_x, page_reclaims_s, reclaim_wait_time from table (mon_get_page_access_info( null, null, -2) );

! sleep 60;

insert into session.mon_get_pkg_cache_stmt_end select current timestamp,member, executable_id, stmt_text, total_act_time, total_act_wait_time, reclaim_wait_time from table (mon_get_pkg_cache_stmt( null, null, null, -2) ) order by total_act_time desc fetch first 100 rows only;

insert into session.mon_get_pkg_cache_stmt_diff select timestampdiff(2,e.ts-s.ts), e.ts, s.member, s.executable_id, s.stmt_text,  e.total_act_time - s.total_act_time as total_act_time, e.total_act_wait_time - s.total_act_wait_time as total_act_wait_time, e.reclaim_wait_time - s.reclaim_wait_time as reclaim_wait_time from session.mon_get_pkg_cache_stmt_start s, session.mon_get_pkg_cache_stmt_end e where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.executable_id = e.executable_id or (s.executable_id is NULL and e.executable_id is NULL));

insert into session.mon_get_pkg_cache_stmt_diff select null,e.* from session.mon_get_pkg_cache_stmt_end e where not exists ( select null from session.mon_get_pkg_cache_stmt_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.executable_id = e.executable_id or (s.executable_id is NULL and e.executable_id is NULL)) );

update session.mon_get_pkg_cache_stmt_diff set ts_delta = (select max(ts_delta) from session.mon_get_pkg_cache_stmt_diff) where ts_delta is null;

insert into session.mon_get_page_access_info_end select current timestamp,member, tabschema, tabname, objtype, data_partition_id, iid, page_reclaims_x, page_reclaims_s, reclaim_wait_time from table (mon_get_page_access_info( null, null, -2) );

insert into session.mon_get_page_access_info_diff select timestampdiff(2,e.ts-s.ts),e.ts,s.member, s.tabschema, s.tabname, s.objtype, s.data_partition_id, s.iid, e.page_reclaims_x - s.page_reclaims_x as page_reclaims_x, e.page_reclaims_s - s.page_reclaims_s as page_reclaims_s, e.reclaim_wait_time - s.reclaim_wait_time as reclaim_wait_time from session.mon_get_page_access_info_start s, session.mon_get_page_access_info_end e where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.tabschema = e.tabschema or (s.tabschema is NULL and e.tabschema is NULL)) and (s.tabname = e.tabname or (s.tabname is NULL and e.tabname is NULL)) and (s.objtype = e.objtype or (s.objtype is NULL and e.objtype is NULL)) and (s.data_partition_id = e.data_partition_id or (s.data_partition_id is NULL and e.data_partition_id is NULL)) and (s.iid = e.iid or (s.iid is NULL and e.iid is NULL));

insert into session.mon_get_page_access_info_diff select null,e.* from session.mon_get_page_access_info_end e where not exists ( select null from session.mon_get_page_access_info_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) and (s.tabschema = e.tabschema or (s.tabschema is NULL and e.tabschema is NULL)) and (s.tabname = e.tabname or (s.tabname is NULL and e.tabname is NULL)) and (s.objtype = e.objtype or (s.objtype is NULL and e.objtype is NULL)) and (s.data_partition_id = e.data_partition_id or (s.data_partition_id is NULL and e.data_partition_id is NULL)) and (s.iid = e.iid or (s.iid is NULL and e.iid is NULL)) );

update session.mon_get_page_access_info_diff set ts_delta = (select max(ts_delta) from session.mon_get_page_access_info_diff) where ts_delta is null;

select member, decimal((reclaim_wait_time / double(total_act_time)) * 100, 5, 2) as pct_reclaim, substr(stmt_text,1,200) as stmt_text from session.mon_get_pkg_cache_stmt_diff where total_act_time <> 0 order by  total_act_time desc;

select member, varchar(tabschema,20) as tabschema, varchar(tabname,40) as tabname, varchar(objtype,10) as objtype, data_partition_id, iid, (page_reclaims_x + page_reclaims_s) as page_reclaims, reclaim_wait_time from session.mon_get_page_access_info_diff where reclaim_wait_time > 0 order by reclaim_wait_time desc;

