echo " Connect to database"

/home/db2inst1/sqllib/bin/db2 connect to auth user wscomusr  using Moo5eK1ng 

echo "executing configuration promo catentry"



/home/db2inst1/sqllib/bin/db2 "update WSCOMUSR.calcode set published = 0 where CALCODE_ID in (
select cal.calcode_id from WSCOMUSR.calcode cal, WSCOMUSR.PX_PROMOTION promo where cal.published = 0 and promo.NAME = cal.CODE and PX_PROMOTION_ID in (select distinct(PX_PROMOTION_ID) from X_PROMO_CATENTRY )
)"

/home/db2inst1/sqllib/bin/db2 "update WSCOMUSR.calcode set published = 1 where published = 1 and  enddate >= current date"



/home/db2inst1/sqllib/bin/db2 terminate 
