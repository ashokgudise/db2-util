now=$(date +"%A_%Y-%m-%d_%R" )
db2 connect to live

echo "  Member Priority: " `db2 -xiq "select varchar(hostname,30) as Hostname, priority as Priority from table (mon_get_serverlist(-1)) order by hostname" ` > "server_list_$now"
echo "Total DB2 connections: " `db2 list applications for db live global show detail | wc -l` >> "server_list_$now"
echo "  Member 0: " `db2 list applications for db live at Member 0 show detail | wc -l`  >> "server_list_$now"
echo "  Member 1: " `db2 list applications for db live at Member 1 show detail | wc -l`  >> "server_list_$now"
echo "  Member 2: " `db2 list applications for db live at Member 2 show detail | wc -l`  >> "server_list_$now"
echo "  Member 3: " `db2 list applications for db live at Member 3 show detail | wc -l`  >> "server_list_$now"
echo "  Member 5: " `db2 list applications for db live at Member 5 show detail | wc -l`  >> "server_list_$now"
db2 terminate
