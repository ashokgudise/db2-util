db2 connect to live ;
db2 set schema wscomusr ;
db2 alter tablespace TAB16K convert to large ;
db2 reorg indexes all for table CATENTDESC       ;
db2 reorg indexes all for table CATENTDESCOVR    ;
db2 reorg indexes all for table CATGRPDESC       ;
db2 reorg indexes all for table COLLIMGMAPAREA   ;
db2 reorg indexes all for table DMACTIVITY       ;
db2 reorg indexes all for table DMELETEMPLATE    ;
db2 reorg indexes all for table DMTRIGSND        ;
db2 reorg indexes all for table DMUSERBHVR       ;
db2 reorg indexes all for table FORUMMSG         ;
db2 reorg indexes all for table OICONFIG         ;
db2 reorg indexes all for table POIDESC          ;
db2 reorg indexes all for table PRELETEMPLATE    ;
db2 reorg indexes all for table PROCESSFILE      ;
db2 reorg indexes all for table PX_PROMOAUDIT    ;
db2 reorg indexes all for table PX_RWDOPTION     ;
db2 reorg indexes all for table SRCHCONFEXT      ;
db2 reorg indexes all for table STLOCDS          ;
db2 reorg indexes all for table TI_CATGRPREL_1   ;
db2 reorg indexes all for table TI_DPGROUP_1     ;
db2 reorg indexes all for table TI_PRODUCTSET_0  ;
db2 reorg indexes all for table UPLOADFILE       ;
db2 reorg indexes all for table X_PARES          ;
db2 terminate ;

