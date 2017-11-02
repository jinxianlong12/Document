SELECT TMP.FACTORY, 
       TMP.WORKSHOP, 
       SUM(NVL(ORD.QTY, 0)) PLAN_QTY, 
       SUM(NVL(GOOD_QTY, 0)) PROD_QTY, 
       DECODE(NVL(SUM(ORD.QTY),0),0,0,100 * ROUND(NVL(SUM(GOOD_QTY),0) / SUM(ORD.QTY), 4)) AS RATE 
  FROM (SELECT CORD.FACTORY, 
               CORD.ORD_CMF_16 AS WORKSHOP, 
               CORD.LINE_ID, 
               CORD.ORDER_ID, 
               CORD.WORK_DATE 
          FROM CWIPORDSTS CORD 
         WHERE CORD.QTY > 0 
           AND CORD.ORD_STATUS_FLAG <> 'D' 
           AND CORD.WORK_DATE >= 
               DECODE(:W_DATE,'day',TO_CHAR(SYSDATE, 'YYYYMMDD'), 
                      'week',TO_CHAR(TRUNC(SYSDATE-1, 'D') + 1, 'YYYYMMDD'), 
                      'month',TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD'), 
                      TO_CHAR(SYSDATE, 'YYYYMMDD'))               
           AND CORD.WORK_DATE <= 
               DECODE(:W_DATE,'day',TO_CHAR(SYSDATE, 'YYYYMMDD'), 
                      'week',TO_CHAR(TRUNC(SYSDATE-1, 'D') + 7, 'YYYYMMDD'), 
                      'month',TO_CHAR(LAST_DAY(TRUNC(SYSDATE)), 'YYYYMMDD'),TO_CHAR(SYSDATE, 'YYYYMMDD'))               
           AND CORD.ORD_CMF_8 IN  ('DZ01THT', 'DX01ASS', 'SX01ASS', 'ZD01ASS', 'SQ01ASS')         
        UNION         
        SELECT MVD.FACTORY, 
               MVD.WORKSHOP, 
               MVD.LINE_ID, 
               MVD.ORDER_ID, 
               MVD.TRAN_DATE 
          FROM CSUMLOTMVD MVD 
          JOIN (SELECT * 
                 FROM MGCMTBLDAT GCM 
                WHERE GCM.TABLE_NAME = 'SUB_AREA') SGCM 
            ON SGCM.FACTORY = MVD.FACTORY AND SGCM.KEY_1 = MVD.LINE_ID 
         WHERE MVD.TRAN_DATE >= 
               DECODE(:W_DATE, 
                      'day', TO_CHAR(SYSDATE, 'YYYYMMDD'), 
                      'week',TO_CHAR(TRUNC(SYSDATE-1, 'D') + 1, 'YYYYMMDD'), 
                      'month', TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD'), TO_CHAR(SYSDATE, 'YYYYMMDD'))               
           AND MVD.TRAN_DATE <= 
               DECODE(:W_DATE,'day',TO_CHAR(SYSDATE, 'YYYYMMDD'), 
                      'week',TO_CHAR(TRUNC(SYSDATE-1, 'D') + 7, 'YYYYMMDD'), 
                      'month',TO_CHAR(LAST_DAY(TRUNC(SYSDATE)), 'YYYYMMDD'),TO_CHAR(SYSDATE, 'YYYYMMDD'))               
           AND SGCM.DATA_2 IN   ('DZ01THT', 'DX01ASS', 'SX01ASS', 'ZD01ASS', 'SQ01ASS')  ) TMP, 
       CWIPORDSTS ORD, 
       (SELECT MVD.FACTORY, 
               MVD.WORKSHOP, 
               MVD.LINE_ID, 
               MVD.ORDER_ID, 
               MVD.TRAN_DATE, 
               SUM(DECODE((SELECT FO.NEXT_OPER 
                            FROM MWIPFLWOPR FO 
                           WHERE FO.FACTORY = MVD.FACTORY 
                             AND FO.FLOW = MVD.FLOW 
                             AND FO.OPER = MVD.OPER), 
                          'END999', 
                          GOOD_QTY, 
                          0)) AS GOOD_QTY 
          FROM CSUMLOTMVD MVD 
         GROUP BY MVD.FACTORY, 
                  MVD.WORKSHOP, 
                  MVD.LINE_ID, 
                  MVD.ORDER_ID, 
                  MVD.TRAN_DATE) MVD 
 WHERE TMP.FACTORY = ORD.FACTORY(+) 
   AND TMP.WORKSHOP = ORD.ORD_CMF_16(+) 
   AND TMP.LINE_ID = ORD.LINE_ID(+) 
   AND TMP.ORDER_ID = ORD.ORDER_ID(+) 
   AND TMP.WORK_DATE = ORD.WORK_DATE(+)       
   AND TMP.FACTORY = MVD.FACTORY(+) 
   AND TMP.WORKSHOP = MVD.WORKSHOP(+) 
   AND TMP.LINE_ID = MVD.LINE_ID(+) 
   AND TMP.ORDER_ID = MVD.ORDER_ID(+) 
   AND TMP.WORK_DATE = MVD.TRAN_DATE(+) 
 GROUP BY TMP.FACTORY, TMP.WORKSHOP