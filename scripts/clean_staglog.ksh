db2 connect to auth
db2 set schema wscomusr
loop=60
let i=1;
while [ ${i} -le ${loop} ]
do
echo "Performing Staglog Delete Collection Loop ${i} "
`db2 "delete from staglog where stgrfnbr in (select stgrfnbr from staglog where stgprocessed = 1 fetch first 1000000 rows only)" `
`db2 commit`
let i=i+1;
done
exit 
