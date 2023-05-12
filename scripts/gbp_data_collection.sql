create schema session;
drop table session.mon_get_group_bufferpool_start;
drop table session.mon_get_group_bufferpool_end;
drop table session.mon_get_group_bufferpool_diff;

declare global temporary table session.mon_get_group_bufferpool_start as ( select current timestamp ts,member, num_gbp_full from table (mon_get_group_bufferpool( -2) ) ) with no data on commit preserve rows not logged;

declare global temporary table session.mon_get_group_bufferpool_end like session.mon_get_group_bufferpool_start on commit preserve rows not logged;

declare global temporary table session.mon_get_group_bufferpool_diff as ( select cast(null as integer) ts_delta,current timestamp ts,member, num_gbp_full from table (mon_get_group_bufferpool( -2) ) ) with no data on commit preserve rows not logged;

insert into session.mon_get_group_bufferpool_start select current timestamp,member, num_gbp_full from table (mon_get_group_bufferpool( -2) );

! sleep 60;

insert into session.mon_get_group_bufferpool_end select current timestamp,member, num_gbp_full from table (mon_get_group_bufferpool( -2) );

insert into session.mon_get_group_bufferpool_diff select timestampdiff(2,e.ts-s.ts),e.ts,s.member, e.num_gbp_full - s.num_gbp_full as num_gbp_full from session.mon_get_group_bufferpool_start s, session.mon_get_group_bufferpool_end e where (s.member = e.member or (s.member is NULL and e.member is NULL));

insert into session.mon_get_group_bufferpool_diff select null,e.* from session.mon_get_group_bufferpool_end e where not exists ( select null from session.mon_get_group_bufferpool_start s where (s.member = e.member or (s.member is NULL and e.member is NULL)) );

update session.mon_get_group_bufferpool_diff set ts_delta = (select max(ts_delta) from session.mon_get_group_bufferpool_diff) where ts_delta is null;

select member, num_gbp_full from session.mon_get_group_bufferpool_diff order by member asc;

