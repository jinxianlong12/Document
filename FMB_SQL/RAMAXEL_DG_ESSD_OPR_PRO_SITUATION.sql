WITH HD_PROD_OPER AS (
                        SELECT
                              A.T_TYPE,
                              A.OPER,
                              COUNT(DISTINCT A.LOT_ID) AS OPER_QTY,
                              SUM(NG) NG_QTY
                        FROM (
                              SELECT
                                    (SELECT DISTINCT DATA_8 FROM MGCMTBLDAT WHERE TABLE_NAME = 'SUB_AREA' AND FACTORY = A.FACTORY AND KEY_1 = A.LINE_ID) PLANT,
                                    C.DATA_2 T_TYPE,
                                    A.MAT_ID,
                                    A.ORDER_ID,
                                    A.TASK_ORDER,
                                    (CASE WHEN A.OLD_OPER IN ('140030','140050') THEN '999999' ELSE A.OLD_OPER END) OPER,
                                    A.LOT_ID,
                                    A.BOARD_SIDE,
                                    A.SHIFT_ID,
                                    (DECODE(A.TRAN_CODE,'COLLECT_DFT',1,0)) NG
                              FROM CWIPLOTMVH A
                              LEFT OUTER JOIN MWIPMATDEF B
                              ON A.FACTORY = B.FACTORY
                              AND A.MAT_ID = B.MAT_ID
                              LEFT OUTER JOIN ( select DISTINCT FACTORY,KEY_1,DATA_1,DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' ) C
                              ON C.FACTORY = B.FACTORY
                              AND C.KEY_1 = B.MAT_CMF_1
                              WHERE A.TRAN_TIME >= GETSHIFTDAY('FROM','080000')
                                AND A.TRAN_TIME < GETSHIFTDAY('TO','080000')
                                AND (CASE WHEN A.OLD_OPER = '120070' AND A.BOARD_SIDE IN ( 'S',' ') AND A.TRAN_CODE IN ('END', 'COLLECT_DFT')
                                          THEN 1
                                          WHEN A.OLD_OPER = '120070' AND A.BOARD_SIDE IN ( 'T','B') AND A.TRAN_CODE IN ('CREATE','END', 'COLLECT_DFT')
                                          THEN 1
                                          WHEN A.OLD_OPER <> '120070' AND A.TRAN_CODE IN ('END', 'COLLECT_DFT')  THEN 1
                                          ELSE 2
                                      END )  = 1
                                AND A.FACTORY = NVL(trim('RCM1'),A.FACTORY)
                                AND A.SEQ_NUM = 1
                                AND A.HIST_DEL_FLAG = ' '
                              ) A
                        WHERE A.PLANT = '东莞'
                        GROUP BY A.T_TYPE,A.OPER
                        ORDER BY A.OPER
                       ),
HD_PLAN_QTY AS (
                select T_TYPE,SUM(PLAN_ORD_QTY) PLAN_ORD_QTY from(
                      select (select DISTINCT DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = 'RCM1' AND KEY_1 = D.MAT_CMF_1) T_TYPE,
                              TO_CHAR(TO_DATE(P.WORK_DATE,'YYYYMMDD'),'YYYY-MM-DD') WORK_DATE,
                              P.PLAN_ORD_QTY,
                              P.ORD_CMF_1,
                              P.LINE_ID,
                              P.ORDER_ID
                      from CWIPORDPLN P
                        LEFT JOIN MWIPMATDEF D
                          ON P.FACTORY = D.FACTORY    AND P.MAT_ID = D.MAT_ID
                        LEFT OUTER JOIN CWIPORDDEF E
                         ON E.ORDER_ID = P.ORDER_ID AND E.PROD_ID = P.MAT_ID
                        LEFT OUTER JOIN MGCMTBLDAT F
                         ON F.TABLE_NAME = 'SUB_AREA' AND F.DATA_9 = E.CMF_5
                      where F.DATA_8 = '东莞'
                      AND P.DELETE_FLAG = ' '
                      AND D.MAT_CMF_1 IN(
                        select DISTINCT KEY_1 from MGCMTBLDAT
                        WHERE TABLE_NAME='PRODUCT_GRP'
                          AND FACTORY = 'RCM1'
                      )
                        and P.ORD_CMF_1 = 'PAK'
                        and P.WORK_DATE = (CASE WHEN SUBSTR(SYSDATE,9,6)>='080000' THEN TO_CHAR(SYSDATE,'YYYYMMDD') ELSE TO_CHAR(SYSDATE-1,'YYYYMMDD') END)
                        )
                    group by  T_TYPE
                ),
BASIC_TEMP AS (
                SELECT 1 SEQ,'企业级SSD' TYPE,1 OPER_SEQ,'999999' OPER FROM DUAL
                UNION ALL
                SELECT 1 SEQ,'企业级SSD' TYPE,2 OPER_SEQ,'140060' OPER FROM DUAL
                UNION ALL
                SELECT 1 SEQ,'企业级SSD' TYPE,3 OPER_SEQ,'140070' OPER FROM DUAL
                UNION ALL
                SELECT 1 SEQ,'企业级SSD' TYPE,4 OPER_SEQ,'140080' OPER FROM DUAL
                UNION ALL
                SELECT 1 SEQ,'企业级SSD' TYPE,5 OPER_SEQ,'140050' OPER FROM DUAL
                UNION ALL
                SELECT 1 SEQ,'企业级SSD' TYPE,6 OPER_SEQ,'140090' OPER FROM DUAL
                UNION ALL
                SELECT 1 SEQ,'企业级SSD' TYPE,7 OPER_SEQ,'140100' OPER FROM DUAL
                UNION ALL
                SELECT 1 SEQ,'企业级SSD' TYPE,8 OPER_SEQ,'150010' OPER FROM DUAL
                UNION ALL
                SELECT 1 SEQ,'企业级SSD' TYPE,9 OPER_SEQ,'160010' OPER FROM DUAL
                UNION ALL
                SELECT 1 SEQ,'企业级SSD' TYPE,10 OPER_SEQ,'180010' OPER FROM DUAL
               )
SELECT
      A.*,
      CASE WHEN A.OPER = '999999' THEN '单板装配' WHEN A.OPER = '140050' THEN '整机装配' ELSE B.OPER_DESC END AS OPER_DESC,
      NVL(C.OPER_QTY,'0') OPER_QTY,
      NVL(D.PLAN_ORD_QTY,'0') PLAN_ORD_QTY,
      DECODE(NVL(D.PLAN_ORD_QTY,'0'),0,'--',TO_CHAR(ROUND(TO_NUMBER(NVL(C.OPER_QTY,'0')/NVL(D.PLAN_ORD_QTY,'0'))*100,2),'FM9999999990.00')) AS PRD_RATE,
      DECODE(NVL(C.OPER_QTY,'0'),0,'--',TO_CHAR(ROUND(C.NG_QTY/TO_NUMBER(NVL(C.OPER_QTY,'0'))*1000000,0),'FM9999999990')) AS NG_PPM
FROM BASIC_TEMP A
LEFT OUTER JOIN MWIPOPRDEF B
ON A.OPER = B.OPER
AND B.FACTORY = 'RCM1'
LEFT OUTER JOIN HD_PROD_OPER C
ON A.TYPE = C.T_TYPE
AND A.OPER = C.OPER
LEFT OUTER JOIN HD_PLAN_QTY D
ON A.TYPE = D.T_TYPE
ORDER BY A.SEQ,A.OPER_SEQ
