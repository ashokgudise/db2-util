create schema session;
drop table session.mon_get_database_start;
drop table session.mon_get_database_end;
drop table session.mon_get_database_diff;

declare global temporary table session.mon_get_database_start as ( select current timestamp ts,member, total_rqst_time, cf_wait_time from table (mon_get_database( -2) ) ) with no data on commit preserve rows not logged;

declare global temporary table session.mon_get_database_end like session.mon_get_database_start 
	on commit preserve rows not logged;

declare global temporary table mon_get_database_diff as ( select cast(null as integer) ts_delta,current timestamp ts,member, total_rqst_time, cf_wait_time from table (mon_get_database( -2) ) ) with no data on commit preserve rows not logged;

insert into session.mon_get_database_start select current timestamp,member, total_rqst_time, cf_wait_time from table (mon_get_database( -2) );

! sleep 60;

insert into session.mon_get_database_end select current timestamp,member, total_rqst_time, cf_wait_time from table (mon_get_database( -2) );

insert into session.mon_get_database_diff select timestampdiff(2,e.ts-s.ts),e.ts,s.member, e.total_rqst_time - s.total_rqst_time as total_rqst_time, e.cf_wait_time - s.cf_wait_time as cf_wait_time from session.mon_get_database_start s, session.mon_get_database_end e where (s.member = e.member or (s.member is NULL and e.member is NULL));

insert into session.mon_get_database_diff select null,e.* from session.mon_get_database_end e where not exists ( select null from session.mon_get_database_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) );

update session.mon_get_database_diff set ts_delta = (select max(ts_delta) from session.mon_get_database_diff) where ts_delta is null;

select member, integer(total_rqst_time) as total_rqst_tm, decimal((cf_wait_time / float(total_rqst_time)) * 100, 5, 2) as pct_cf from session.mon_get_database_diff order by member asc;

