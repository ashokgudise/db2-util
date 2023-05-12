db2 connect to live
db2 set schema wscomusr
:
db2 -x "select substr(tabname,1,35) from sysibmadm.ADMINTABCOMPRESSINFO where tabschema='WSCOMUSR' and compress_attr = 'N' " | grep -v TI_ | grep -v XI_ | awk '{print "alter table " $1  " compress yes adaptive;"}' > set_compress_on.sql

if [ ! -f set_compress_on.sql ]
then
        db2 terminate
        echo "       NO output file  "
        exit 5
elif
   [ ! -s set_compress_on.sql ]
   then
        db2 terminate
        echo "      EMPTY output file  "
        exit 5
fi

db2 -tvsmf set_compress_on.sql -z set_compress_on.out

db2 terminate
