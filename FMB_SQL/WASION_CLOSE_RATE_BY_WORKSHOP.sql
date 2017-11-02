SELECT WORKSHOP, SUM (PLAN_COUNT) AS PLAN_COUNT, SEQ, 
         SUM (REAL_COUNT)  AS REAL_COUNT, 
         100 * ROUND (SUM (REAL_COUNT) / SUM (PLAN_COUNT), 4)  AS CLOSED_RATE 
    FROM (SELECT ORD.FACTORY, ORD.MAT_ID, MAT.MAT_DESC, SHOP.DATA_1 AS WORKSHOP, 
                 ORD.PLAN_COUNT, REAL_COUNT, SEQ, 
                 100 * ROUND (REAL_COUNT / PLAN_COUNT, 4) AS CLOSED_RATE 
            FROM (  SELECT FACTORY, MAT_ID, CMF_34 AS WORKSHOP, 
                           COUNT (ORDER_STATUS_FLAG) AS PLAN_COUNT, 
                           SUM (DECODE (ORDER_STATUS_FLAG, 'C', 1, 0)) AS REAL_COUNT, 
                           DECODE (CMF_34,  'DZ01', 1,  'DX01', 2,  'SX01', 3,  'ZD01', 4,  'SQ01', 5) AS SEQ 
                      FROM CWIPORDORG ORG 
                     WHERE     ORG.FACTORY = 'WASION' 
                           AND ORG.PLAN_END_TIME >= 
                                  DECODE ( 
                                     :W_DATE, 
                                     'day', TO_CHAR (SYSDATE, 'YYYYMMDD'), 
                                     'week', TO_CHAR (TRUNC (SYSDATE, 'D') + 1, 
                                                      'YYYYMMDD'), 
                                     'month', TO_CHAR (TRUNC (SYSDATE, 'MM'), 
                                                       'YYYYMMDD'),TO_CHAR (SYSDATE, 'YYYYMMDD')) 
                           AND ORG.PLAN_END_TIME <= 
                                  DECODE ( 
                                     :W_DATE, 
                                     'day', TO_CHAR (SYSDATE, 'YYYYMMDD'), 
                                     'week', TO_CHAR (TRUNC (SYSDATE, 'D') + 7, 
                                                      'YYYYMMDD'), 
                                     'month', TO_CHAR ( 
                                                 LAST_DAY (TRUNC (SYSDATE)), 
                                                 'YYYYMMDD'),TO_CHAR (SYSDATE, 'YYYYMMDD')) 
                  GROUP BY FACTORY, MAT_ID, CMF_34) ORD, 
                 MWIPMATDEF MAT, 
                 MGCMTBLDAT SHOP 
           WHERE     ORD.FACTORY = MAT.FACTORY 
                 AND ORD.MAT_ID = MAT.MAT_ID 
                 AND ORD.FACTORY = SHOP.FACTORY 
                 AND ORD.WORKSHOP = SHOP.KEY_1 
                 AND MAT.MAT_VER = 1 
                 AND SHOP.TABLE_NAME = 'WORKSHOP') 
GROUP BY WORKSHOP, SEQ 
ORDER BY SEQ