select substr(REFTABNAME,1,20) as PARENT ,substr(TABNAME,1,20) as CHILD from syscat.references where TABNAME in ('X_TOPSELLER')and TABSCHEMA='WSCOMUSR' order by PARENT;
select substr(REFTABNAME,1,20) as PARENT, substr(TABNAME,1,20) as CHILD from syscat.references where REFTABNAME in ('X_TOPSELLER')and TABSCHEMA='WSCOMUSR' order by PARENT;

