WITH SMT_TEMP AS(
                    select
                          'SMT'                      AS T_TYPE,
                          C.DATA_2                   AS GRP,
                          H.ORDER_ID                  ,
                          H.MAT_ID                    ,
                          COUNT(DISTINCT H.LOT_ID)   AS PROD_QTY
                    from(
                            select /*+INDEX(H CWIPLOTMVH_IDX_3)*/
                                    H.FACTORY,
                                    H.MAT_ID ,
                                    H.ORDER_ID ,
                                    H.LOT_ID
                              from CWIPLOTMVH H
                                LEFT OUTER JOIN (SELECT * FROM  MGCMTBLDAT WHERE FACTORY = 'RCM1' AND TABLE_NAME = 'SUB_AREA' AND DATA_10 = 'DG') A
                                  ON A.FACTORY = H.FACTORY AND A.KEY_1 = H.LINE_ID
                                LEFT JOIN MWIPMATDEF D
                                  ON H.FACTORY = D.FACTORY    AND H.MAT_ID = D.MAT_ID
                              where H.TRAN_TIME >= '20180627'||'080000'
                                AND H.TRAN_TIME <  to_char(to_date('20180627','yyyymmdd')+1,'yyyyMMdd')||'080000'
                                AND (CASE WHEN H.BOARD_SIDE IN ( 'S',' ') AND H.TRAN_CODE IN ('END', 'COLLECT_DFT')
                                            THEN 1
                                          WHEN H.BOARD_SIDE IN ( 'T','B') AND H.TRAN_CODE IN ('CREATE','END', 'COLLECT_DFT')
                                            THEN 1
                                      END )  = 1
                                AND H.ORDER_ID = NVL (TRIM (' '),H.ORDER_ID)
                                AND H.OLD_OPER = '120070'
                                AND NVL(A.KEY_1,' ') != ' '
                                AND H.HIST_DEL_FLAG = ' '
                                AND H.FACTORY = NVL(trim('RCM1'),H.FACTORY)
                                AND H.LINE_ID = '100050'
                                AND H.MAT_ID = NVL(TRIM(' '), H.MAT_ID)
                         ) H
                    LEFT OUTER JOIN MWIPMATDEF D
                      ON H.FACTORY = D.FACTORY    AND H.MAT_ID = D.MAT_ID
                    LEFT OUTER JOIN (SELECT DISTINCT FACTORY,KEY_1,DATA_1,DATA_2 FROM MGCMTBLDAT WHERE TABLE_NAME = 'PRODUCT_GRP') C
                      ON C.FACTORY = H.FACTORY    AND C.KEY_1 = D.MAT_CMF_1
                    WHERE 1=1
                    AND D.MAT_CMF_1 = '20'
                    group by C.DATA_2,H.ORDER_ID,H.MAT_ID
                    ),
HD_TEMP AS(
            select
                  '后段'                     AS T_TYPE,
                  C.DATA_2                   AS GRP,
                  H.ORDER_ID                  ,
                  H.MAT_ID                    ,
                  COUNT(DISTINCT H.LOT_ID)   AS PROD_QTY
            from(
                    select /*+INDEX(H CWIPLOTMVH_IDX_3)*/
                            H.FACTORY,
                            H.MAT_ID ,
                            H.ORDER_ID ,
                            H.LOT_ID
                      from CWIPLOTMVH H
                        LEFT OUTER JOIN (SELECT * FROM  MGCMTBLDAT WHERE FACTORY = 'RCM1' AND TABLE_NAME = 'SUB_AREA' AND DATA_10 = 'DG') A
                          ON A.FACTORY = H.FACTORY AND A.KEY_1 = H.LINE_ID
                        LEFT JOIN MWIPMATDEF D
                          ON H.FACTORY = D.FACTORY    AND H.MAT_ID = D.MAT_ID
                      where H.TRAN_TIME >= '20180627'||'080000'
                        AND H.TRAN_TIME <  to_char(to_date('20180627','yyyymmdd')+1,'yyyyMMdd')||'080000'
                        AND H.TRAN_CODE IN ('END','COLLECT_DFT')
                        AND H.ORDER_ID = NVL (TRIM (' '),H.ORDER_ID)
                        AND H.OLD_OPER = '180010'
                        AND NVL(A.KEY_1,' ') != ' '
                        AND H.HIST_DEL_FLAG = ' '
                        AND H.FACTORY = NVL(trim('RCM1'),H.FACTORY)
                        AND H.LINE_ID = '100050'
                        AND H.MAT_ID = NVL(TRIM(' '), H.MAT_ID)
                 ) H
            LEFT OUTER JOIN MWIPMATDEF D
              ON H.FACTORY = D.FACTORY    AND H.MAT_ID = D.MAT_ID
            LEFT OUTER JOIN (SELECT DISTINCT FACTORY,KEY_1,DATA_1,DATA_2 FROM MGCMTBLDAT WHERE TABLE_NAME = 'PRODUCT_GRP') C
              ON C.FACTORY = H.FACTORY    AND C.KEY_1 = D.MAT_CMF_1
            WHERE D.MAT_TYPE = (CASE WHEN H.MAT_ID IN ('1103-00036','1103-00046') THEN D.MAT_TYPE ELSE 'ZERT' END)
            AND D.MAT_CMF_1 = '20'
            group by C.DATA_2,H.ORDER_ID,H.MAT_ID
          )
SELECT S.T_TYPE,S.GRP,S.ORDER_ID ,S.MAT_ID,S.PROD_QTY from SMT_TEMP S
UNION ALL
SELECT H.T_TYPE,H.GRP,H.ORDER_ID ,H.MAT_ID,H.PROD_QTY from HD_TEMP H
ORDER BY 1,2,3
