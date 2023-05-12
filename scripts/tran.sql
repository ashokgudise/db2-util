select case (ai.appl_status)
	when 3 then 'Executing'
	when 4 then 'Wait on User'
	when 5 then 'Lock Wait'
	when 7 then 'Rolling Back'
	else 'Other '||substr(char(appl_status),1,2)
	end as "Status",
	substr(ai.auth_id,1,10) as "Authid",
	substr(ai.appl_name,1,15) as "Appl Name",
	int(ap.UOW_LOG_SPACE_USED/1024/1024) as "Log Used (M)", 
	int(ap.appl_idle_time/60) as "Idle for (min)", 
	ap.appl_con_time as "Connected Since"
from db2$mon_db db, db2$mon_appl ap, db2$mon_appl_info ai
where ai.agent_id = db.APPL_ID_OLDEST_XACT 
and ap.agent_id = ai.agent_id;
