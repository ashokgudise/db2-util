SELECT Substr(a.tabschema, 1, 10)                             AS SCHEMA,
       --Unique(Substr(a.tabname, 1, 30))                       AS table,
       Decimal(Float(a.data_object_l_size) / ( 1024 ), 9, 2)  AS
       data_spaceinuse_mb,
       Decimal(Float(a.index_object_l_size) / ( 1024 ), 9, 2) AS
       indexspaceinuse_mb,
       Substr(s.card, 1, 10)                                  AS
       number_of_records,
       Substr(b.tbsp_name, 1, 15)                             TABLESPACE,
       Decimal(Float(b.tbsp_total_size_kb) / ( 1024 ), 9, 2)  AS tbspTotSz_MB,
       Decimal(Float(b.tbsp_free_size_kb) / ( 1024 ), 9, 2)   AS tbspcfreesz_MB,
       Substr(b.tbsp_utilization_percent, 1, 4)               AS TBSP_UTLZ_PCNT
FROM   sysibmadm.admintabinfo a,
       sysibmadm.tbsp_utilization b,
       syscat.tables s
WHERE  a.tabschema = s.tabschema
       AND a.tabname = s.tabname
       AND a.tabschema = 'WSCOMUSR'
       AND s.TYPE = 'T'
       AND s.tbspaceid = B.tbsp_id
ORDER  BY 3 desc
FETCH first 10 ROWS only
WITH UR ;
