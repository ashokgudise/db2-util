SELECT SUBSTR(HOST_NAME,1,8) AS HOST,
       SUBSTR(DB_NAME, 1,8) AS DBNAME,
       CURRENT_CF_GBP_SIZE,
       CONFIGURED_CF_GBP_SIZE,
       TARGET_CF_GBP_SIZE
   FROM TABLE( MON_GET_CF( 128 ) ) AS CAMETRICS;
