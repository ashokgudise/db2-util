set current schema = XYZ @

drop variable ALLOW_RESTRICTED @

create variable ALLOW_RESTRICTED smallint default 1 @
grant read,write on variable ALLOW_RESTRICTED to public @

drop procedure test_gv @

create procedure test_gv
language sql
begin
declare vcount smallint;
set vcount = 0;
set vcount  = (select count(*) from (select rolename FROM TABLE (SYSPROC.AUTH_LIST_ROLES_FOR_AUTHID(session_user,'U')) AS t  ) x where x.rolename='ALLOW_RESTRICTED') ;

if (vcount > 0) then SET XYZ.ALLOW_RESTRICTED = 1;
else SET XYZ.ALLOW_RESTRICTED = 0;
end if
;
end
@

grant execute on procedure XYZ.test_gv to public @

db2 update db cfg for testdb using connect_proc xyz.test_gv

create variable addr smallint default 1;
create variable bank smallint default 1;
create variable routing smallint default 1;
create variable id smallint default 1;

create procedure setgroup
language sql
begin
SET addr =  
  coalesce((select 1 from db2inst2.group_user where  userid = session_user and groupid = 'addr'), 0);
SET shop  =  
  coalesce((select 1 from db2inst2.group_user where  userid = session_user and groupid = 'shop'), 0);         
SET routing  =  
  coalesce((select 1 from db2inst2.group_user where  userid = session_user and groupid = 'routing'), 0);
SET id  =  
  coalesce((select 1 from db2inst2.group_user where  userid = session_user and groupid = 'id'), 0);         
end
@
