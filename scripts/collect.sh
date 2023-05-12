##==========================
#!/bin/ksh
# Check the usage
if [ $# -ne 1 ];then
        echo "usage $0 <dbname>"
        exit 1
fi
DB=$1
DIR=`date +%Y%m%d_%H%M`
mkdir -p $DIR

db2 connect to $DB

db2 update monitor switches using bufferpool on lock on sort on statement on table on timestamp on uow on

for i in 1 2 3 4 5 6
do
ds=`date +%Y%m%d_%H%M%S`
echo "Taking db2pd/snapshot outputs - round $i."

ls -ltR /db2data1 > ls_ltr_data1.$ds
ls -ltR /db2data2 > ls_ltr_data2.$ds
df -h > df.$ds

db2pd -edus -file $DIR/db2pd.edus.$ds > /dev/null 2>&1
db2pd -agents -file $DIR/db2pd.agents.$ds > /dev/null 2>&1
db2pd -latches -file $DIR/db2pd.latches.$ds > /dev/null 2>&1
db2pd -db $DB -appl -trans -locks -wlocks -file $DIR/db2pd.appl.tran.locks.wlocks.$ds > /dev/null 2>&1
db2pd -db $DB -apinfo -file $DIR/db2pd.apinfo.$ds > /dev/null 2>&1
db2pd -db $DB -tablespace -file $DIR/db2pd.tablespace.$ds > /dev/null 2>&1
db2pd -db $DB -tcbstat -file $DIR/db2pd.tcbstat.$ds > /dev/null 2>&1

db2 list utilities show detail > $DIR/util.$ds

db2 get snapshot for applications on $DB > $DIR/app.snap.$ds
db2 get snapshot for database on $DB > $DIR/db.snap.$ds
db2 get snapshot for tablespaces on $DB > $DIR/tbsp.snap.$ds
db2 get snapshot for tables on $DB > $DIR/table.snap.$ds
db2 get snapshot for bufferpools on $DB > $DIR/bp.snap.$ds
db2 get snapshot for locks on $DB > $DIR/locks.snap.$ds

db2 "call monreport.lockwait" > $DIR/mon_lockwait.$ds
db2 "call monreport.currentsql" > $DIR/mon_cursql.$ds

#echo "Taking db2 stacks"
db2pd -stack all

sleep 60

done

db2 get snapshot for dynamic sql on $DB > $DIR/dyn.$ds
db2pd -db $DB -dyn -file $DIR/db2pd.dyn.$ds > /dev/null 2>&1

db2 terminate
##==========================

