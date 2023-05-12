SELECT count(CATENTRY.CATENTRY_ID)

                                                                                                                FROM CATENTRY
                                                                                                                                                               INNER JOIN TI_CATENTRY_0 TI_CATENTRY ON (CATENTRY.CATENTRY_ID=TI_CATENTRY.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN STORECENT ON (CATENTRY.CATENTRY_ID=STORECENT.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN CATENTDESC ON (CATENTDESC.CATENTRY_ID=CATENTRY.CATENTRY_ID AND CATENTDESC.LANGUAGE_ID=-1)
                                                                                                                      LEFT OUTER JOIN CATENTSUBS ON (CATENTSUBS.CATENTRY_ID=CATENTRY.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_CEPUB_0 TI_CEPUB ON (CATENTRY.CATENTRY_ID=TI_CEPUB.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_DPGROUP_0 TI_DPGROUP ON (CATENTRY.CATENTRY_ID=TI_DPGROUP.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_DPGRPNAME_0_1 TI_DPGRPNAME ON (CATENTRY.CATENTRY_ID=TI_DPGRPNAME.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN XI_APGROUP_0 XI_APGROUP ON (CATENTRY.CATENTRY_ID=XI_APGROUP.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_PRODUCTSET_0 TI_PRODUCTSET ON (CATENTRY.CATENTRY_ID=TI_PRODUCTSET.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_OFFERPRICE_0 TI_OFFERPRICE ON (CATENTRY.CATENTRY_ID=TI_OFFERPRICE.CATENTRY_ID)
                                                                                                                                  LEFT OUTER JOIN XI_OFFER_0 XI_OFFER_0 ON (CATENTRY.CATENTRY_ID=XI_OFFER_0.CATENTRY_ID AND XI_OFFER_0.PRICETYPE='OFFERPRICE' AND XI_OFFER_0.SE_IDENTIFIER='dickssportinggoods')
                                                                                                                      LEFT OUTER JOIN TI_CNTRPRICE_0 TI_CNTRPRICE ON (CATENTRY.CATENTRY_ID=TI_CNTRPRICE.CATENTRY_ID)
                                                                                                                      
                                                                                                                      LEFT OUTER JOIN TI_DPCATENTRY_0 TI_DPCATENTRY ON (CATENTRY.CATENTRY_ID=TI_DPCATENTRY.CATENTRY_ID)
                                                                                                                                                LEFT OUTER JOIN TI_GROUPING_0 TI_GROUPING ON (CATENTRY.CATENTRY_ID=TI_GROUPING.CATENTRY_ID)
                                                                                                                                                LEFT OUTER JOIN TI_COMPONENTS_0 TI_COMPONENTS ON (CATENTRY.CATENTRY_ID=TI_COMPONENTS.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_DCCATENTRY_0 TI_DCCATENTRY ON (CATENTRY.CATENTRY_ID=TI_DCCATENTRY.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_CATALOG_0 TI_CATALOG ON (CATENTRY.CATENTRY_ID=TI_CATALOG.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_CATGPENREL_0 TI_CATGPENREL ON (CATENTRY.CATENTRY_ID=TI_CATGPENREL.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_ENTGRPPATH_0 TI_ENTGRPPATH ON (CATENTRY.CATENTRY_ID=TI_ENTGRPPATH.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_SEOURL_0_1 TI_SEOURL ON (CATENTRY.CATENTRY_ID=TI_SEOURL.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_CEDSOVR_0_1 TI_CATENTDESCOVR ON (CATENTRY.CATENTRY_ID=TI_CATENTDESCOVR.CATENTRY_ID)

                                                                                                                      LEFT OUTER JOIN TI_CASTB1_0_1 TI_CASTB1 ON (CATENTRY.CATENTRY_ID=TI_CASTB1.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_CAITB1_0_1 TI_CAITB1 ON (CATENTRY.CATENTRY_ID=TI_CAITB1.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_CAFTB1_0_1 TI_CAFTB1 ON (CATENTRY.CATENTRY_ID=TI_CAFTB1.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN TI_ATTR_0_1 TI_ATTR ON (CATENTRY.CATENTRY_ID=TI_ATTR.CATENTRY_ID)
                                                                                                                                  LEFT OUTER JOIN TI_ADATTR_0_1 TI_ADATTR ON (CATENTRY.CATENTRY_ID=TI_ADATTR.CATENTRY_ID)
                                                                                                                      
                                                                                                                      LEFT OUTER JOIN XI_BADGES_0 XI_BADGES ON (CATENTRY.CATENTRY_ID=XI_BADGES.CATENTRY_ID)

                                                                                                                                  LEFT OUTER JOIN XI_ATTR_0_1 XI_ATTR ON (CATENTRY.CATENTRY_ID=XI_ATTR.CATENTRY_ID)
                                                                                                                                  LEFT OUTER JOIN XI_CATENTRY_PROMO CATPROMO ON (CATENTRY.CATENTRY_ID= CATPROMO.CATENTRY_ID)
                                                                                                                      LEFT OUTER JOIN XI_SKUPRICE_0 SKUPRICE ON (CATENTRY.CATENTRY_ID= SKUPRICE.CATENTRY_ID AND SKUPRICE.SE_IDENTIFIER='ALL')
                                                                                                                                  LEFT OUTER JOIN XI_STYLEPRICE_ATTR_0 STYLEPRICE ON (CATENTRY.CATENTRY_ID= STYLEPRICE.CATENTRY_ID)
                                                                                                                                  LEFT OUTER JOIN XI_PRICEFACET_0 PRICEFACET ON (CATENTRY.CATENTRY_ID= PRICEFACET.CATENTRY_ID)
                                                                                                                                  LEFT OUTER JOIN XI_ATTR_COLOR_0_1 SKUCOLOR ON (CATENTRY.CATENTRY_ID= SKUCOLOR.CATENTRY_ID)

                                                                                                                                  LEFT OUTER JOIN XI_CEDSOVR_0_1 STYLEOVERRIDE ON (CATENTRY.CATENTRY_ID= STYLEOVERRIDE.CATENTRY_ID)
                                                                                                                                  LEFT OUTER JOIN XI_CEDSOVR_AUXDESC1_0_1 XI_CEDSOVR_AUXDESC1 on (CATENTRY.CATENTRY_ID = XI_CEDSOVR_AUXDESC1.CATENTRY_ID)
                                                                                                                                  LEFT OUTER JOIN XI_CEDSOVR_AUXDESC2_0_1 XI_CEDSOVR_AUXDESC2 on (CATENTRY.CATENTRY_ID = XI_CEDSOVR_AUXDESC2.CATENTRY_ID)
                                                                                                                                  LEFT OUTER JOIN XI_CATSEARCH_0 CATSEARCH ON (CATENTRY.CATENTRY_ID= CATSEARCH.CATENTRY_ID)

                                                                                                                WHERE  CATENTRY.CATENTTYPE_ID in ('ProductBean', 'ItemBean', 'PackageBean') ;

