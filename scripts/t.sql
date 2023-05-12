SELECT CATENTRY_ID_CHILD, MAX(CATENTRY_ID_PARENT) AS CATENTRY_ID_PARENT FROM WSCOMUSR.CATENTREL R, WSCOMUSR.TI_CATENTRY_0 C WHERE R.CATENTRY_ID_CHILD = C.CATENTRY_ID AND R.CATRELTYPE_ID IN ('PRODUCT_ITEM') GROUP BY CATENTRY_ID_CHILD HAVING COUNT(CATENTRY_ID_PARENT) = 1 UNION select cr.CATENTRY_ID_CHILD, max(cr.CATENTRY_ID_PARENT) AS CATENTRY_ID_PARENT from WSCOMUSR.TI_CATENTRY_0 c, WSCOMUSR.CATENTREL cr, WSCOMUSR.CATENTRY ca, WSCOMUSR.CATENTRYATTR cat, WSCOMUSR.ATTR at, WSCOMUSR.ATTRVAL atv where c.catentry_id = cr.catentry_id_child and cr.CATENTRY_ID_PARENT=ca.CATENTRY_ID and ca.CATENTTYPE_ID='BundleBean' and cr.CATENTRY_ID_CHILD = cat.CATENTRY_ID and cat.ATTR_ID = at.ATTR_ID and at.identifier = 'PrimaryParent' and cat.attr_id = atv.ATTR_ID and cat.ATTRVAL_ID = atv.ATTRVAL_ID and ca.PARTNUMBER = atv.IDENTIFIER group by cr.CATENTRY_ID_CHILD 


