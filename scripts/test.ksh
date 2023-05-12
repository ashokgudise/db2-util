ls -l `find /backup/DB2_Online_Backups/ -type f -name 'LIVE.*' -printf '%p\n'|sort |head -n 6`

