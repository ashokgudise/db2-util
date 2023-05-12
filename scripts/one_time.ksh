db2 connect to live
db2 -x "select tabname from syscat.tables where tabschema='WSCOMUSR' with ur" | awk '{print $1}' > tables.txt
while read LINE; do
  db2 "grant select,insert,update,delete on table wscomusr.${LINE} to user wscomusr"
done < tables.txt
rm tables.txt
db2 terminate
