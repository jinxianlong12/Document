SELECT WORK_DATE ,AREA,MANAGER,PROD_SCORE,COM_SCORE,DFT_SCORE,MATCH_SCORE,SCORE ,ROW_NUMBER() OVER (PARTITION BY WORK_DATE ORDER BY WORK_DATE , SCORE DESC) NUM
FROM
(
SELECT SUBSTR(TO_CHAR(TO_DATE(WORK_DATE,'YYYY-MM-DD'),'YYYY-MM-DD'),6,10) WORK_DATE ,AREA,MANAGER,PROD_SCORE,COM_SCORE,DFT_SCORE,MATCH_SCORE,(PROD_SCORE + COM_SCORE + DFT_SCORE + MATCH_SCORE)SCORE FROM
(
SELECT P1.WORK_DATE, P1.AREA,
CASE WHEN P1.AREA IN('CSSD','ESSD') THEN '黎小宝'
     WHEN P1.AREA = 'MEM' THEN '邓传云'
     WHEN P1.AREA ='SDT' THEN '查达球'
     ELSE ' ' END MANAGER,
NVL(P2.PROD_RATE,0) PROD_RATE,
CASE WHEN P1.AREA IN('MEM','SDT') AND PROD_RATE > 100 THEN '12' --排产率得分
     WHEN P1.AREA IN('MEM','SDT') AND PROD_RATE >=98 AND PROD_RATE <=100 THEN '10'
     WHEN P1.AREA IN('MEM','SDT') AND PROD_RATE >=93 AND PROD_RATE <98   THEN '8'
     WHEN P1.AREA IN('MEM','SDT') AND PROD_RATE >=88 AND PROD_RATE <93   THEN '6'
     WHEN P1.AREA IN('MEM','SDT') AND PROD_RATE <88 THEN '0'
     WHEN P1.AREA IN('CSSD','ESSD') AND PROD_RATE > 100 THEN '12'
     WHEN P1.AREA IN('CSSD','ESSD') AND PROD_RATE >=95 AND PROD_RATE <=100 THEN '10'
     WHEN P1.AREA IN('CSSD','ESSD') AND PROD_RATE >=90 AND PROD_RATE <95 THEN '8'
     WHEN P1.AREA IN('CSSD','ESSD') AND PROD_RATE >=85 AND PROD_RATE <90 THEN '6'
     WHEN P1.AREA IN('CSSD','ESSD') AND PROD_RATE <85 THEN '0'
     ELSE '0' END PROD_SCORE,
     NVL(P3.COM_EFF,0) COM_EFF,
     CASE WHEN P1.AREA ='SDT' AND COM_EFF > 100 THEN '12' --综合效率得分
     WHEN P1.AREA ='SDT' AND COM_EFF >=91 AND COM_EFF <=100 THEN '10'
     WHEN P1.AREA ='SDT' AND COM_EFF >=85 AND COM_EFF <91   THEN '8'
     WHEN P1.AREA ='SDT' AND COM_EFF >=75 AND COM_EFF <85   THEN '6'
     WHEN P1.AREA ='SDT' AND COM_EFF <75 THEN '0'
     WHEN P1.AREA IN('CSSD','ESSD') AND COM_EFF > 93 THEN '12'
     WHEN P1.AREA IN('CSSD','ESSD') AND COM_EFF >=88 AND COM_EFF <=93 THEN '10'
     WHEN P1.AREA IN('CSSD','ESSD') AND COM_EFF >=75 AND COM_EFF <88 THEN '8'
     WHEN P1.AREA IN('CSSD','ESSD') AND COM_EFF >=70 AND COM_EFF <75 THEN '6'
     WHEN P1.AREA IN('CSSD','ESSD') AND COM_EFF <70 THEN '0'
     WHEN P1.AREA ='MEM' AND COM_EFF > 93 THEN '12'
     WHEN P1.AREA ='MEM' AND COM_EFF >=87 AND COM_EFF <=93 THEN '10'
     WHEN P1.AREA ='MEM' AND COM_EFF >=75 AND COM_EFF <87 THEN '8'
     WHEN P1.AREA ='MEM' AND COM_EFF >=70 AND COM_EFF <75 THEN '6'
     WHEN P1.AREA ='MEM' AND COM_EFF <70 THEN '0'
     ELSE '0' END COM_SCORE,
     NVL(P4.DFT_RATE,0) DFT_RATE,
  CASE WHEN P1.AREA IN('MEM','SDT') AND DFT_RATE > 99.4 THEN '12' --产品直通率得分
     WHEN P1.AREA ='MEM' AND DFT_RATE >=99.1 AND DFT_RATE <=99.4 THEN '10'
     WHEN P1.AREA ='MEM' AND DFT_RATE >=98.9 AND DFT_RATE <99.1   THEN '8'
     WHEN P1.AREA ='MEM' AND DFT_RATE >=98.5 AND DFT_RATE <98.9   THEN '6'
     WHEN P1.AREA ='MEM' AND DFT_RATE <98.5 THEN '0'
     WHEN P1.AREA ='ESSD' AND DFT_RATE > 99.4 THEN '12'
     WHEN P1.AREA ='ESSD' AND DFT_RATE >=99.2 AND DFT_RATE <=99.4 THEN '10'
     WHEN P1.AREA ='ESSD' AND DFT_RATE >=99 AND DFT_RATE <99.2 THEN '8'
     WHEN P1.AREA ='ESSD' AND DFT_RATE >=98.6 AND DFT_RATE <99 THEN '6'
     WHEN P1.AREA ='ESSD' AND DFT_RATE <98.6 THEN '0'
     WHEN P1.AREA IN('CSSD','SDT') AND DFT_RATE > 99.2 THEN '12'
     WHEN P1.AREA IN('CSSD','SDT') AND DFT_RATE >=99 AND DFT_RATE <=99.2 THEN '10'
     WHEN P1.AREA IN('CSSD','SDT') AND DFT_RATE >=98.80 AND DFT_RATE <99 THEN '8'
     WHEN P1.AREA IN('CSSD','SDT') AND DFT_RATE >=98.60 AND DFT_RATE <98.80 THEN '6'
     WHEN P1.AREA IN('CSSD','SDT') AND DFT_RATE <98.60 THEN '0'
     ELSE '0' END DFT_SCORE,
     NVL(P5.MATCH_RATE,0) MATCH_RATE,
     CASE
     WHEN MATCH_RATE > 100 THEN '12' --匹配率
     WHEN MATCH_RATE >=98 AND MATCH_RATE <=100 THEN '10'
     WHEN MATCH_RATE >=93 AND MATCH_RATE <98   THEN '8'
     WHEN MATCH_RATE >=88 AND MATCH_RATE <93   THEN '6'
     WHEN MATCH_RATE <88 THEN '0'
     ELSE '0' END MATCH_SCORE
 FROM
(
#NAME?
      SELECT D1.WORK_DATE ,D2.AREA
            FROM
            (SELECT TO_CHAR(FDATE,'YYYYMMDD') AS WORK_DATE
            FROM
            (SELECT TRUNC(SYSDATE, 'MONTH') + LEVEL - 1 AS FDATE  FROM DUAL CONNECT BY LEVEL <= 31 ) T
            WHERE TO_CHAR(FDATE, 'MM') = TO_CHAR(SYSDATE, 'MM')
            ) D1,
            (
                SELECT 'SDT' AREA FROM DUAL
                UNION ALL
                SELECT 'MEM' AREA FROM DUAL
                UNION ALL
                SELECT 'CSSD' AREA FROM DUAL
                UNION ALL
                SELECT 'ESSD' AREA FROM DUAL
            )D2
)P1,
(
#NAME?
SELECT WORK_DATE , PROD_SE AREA ,NVL(RATE,0) PROD_RATE
FROM
(
    WITH  A AS
    (
        SELECT E.WORK_DATE ,F.PROD_SE
            FROM
            (
              SELECT TO_CHAR(TO_DATE(TO_CHAR(TRUNC(SYSDATE,'yyyy'),'YYYYMMDD'),'YYYYMMDD')+LEVEL-1,'YYYYMMDD') AS WORK_DATE FROM DUAL CONNECT BY LEVEL <366
            ) E,
            (
                SELECT 'SDT' PROD_SE FROM DUAL
                UNION ALL
                SELECT 'MEM' PROD_SE FROM DUAL
                UNION ALL
                SELECT 'CSSD' PROD_SE FROM DUAL
                UNION ALL
                SELECT 'ESSD' PROD_SE FROM DUAL
            )F
    ),
    B AS
    (
         SELECT WORK_DATE,PROD_SE,SUM(PLAN_QTY) PLAN_QTY FROM
         (
           SELECT  WORK_DATE ,PRD.ORD_CMF_2 ,
                DECODE(MAT.MAT_CMF_1,'50','SDT','20','CSSD','21','ESSD','10','MEM','11','MEM','12','MEM') PROD_SE
                , SUM(PLAN_ORD_QTY) PLAN_QTY FROM CWIPORDPLN PRD ,MWIPMATDEF MAT
                WHERE 1=1
                AND PRD.FACTORY = 'RCM1'
                AND MAT.FACTORY = 'RCM1'
                AND PRD.DELETE_FLAG != 'Y'
                AND PRD.ORD_CMF_1 ='SMT'
                AND PRD.ORD_CMF_2 IN( 'DG_SSD' ,'DG_SDT','HY')
                AND PRD.MAT_ID = MAT.MAT_ID
                AND MAT.MAT_CMF_1 IN( '20','21','50','10','11','12')
                GROUP BY WORK_DATE ,PRD.ORD_CMF_2,MAT.MAT_CMF_1 ORDER BY WORK_DATE
            )
            GROUP BY WORK_DATE ,PROD_SE
    ),
    C AS
    (
         SELECT WORK_DATE,PROD_SE,SUM(ACT_QTY) ACT_QTY FROM
         (
              SELECT WORK_DATE ,GCM.DATA_2 ,DECODE(MAT.MAT_CMF_1,'50','SDT','20','CSSD','21','ESSD','10','MEM','11','MEM','12','MEM') PROD_SE,
                SUM(TRAN_QTY) ACT_QTY FROM CWIPPRDSUM PRD,MGCMTBLDAT GCM ,MWIPMATDEF MAT
                WHERE 1=1
                AND PRD.FACTORY = 'RCM1'
                AND MAT.FACTORY = 'RCM1'
                AND GCM.FACTORY = 'RCM1'
                AND GCM.TABLE_NAME = 'SUB_AREA'
                AND PRD.SUB_AREA = GCM.KEY_1
                AND GCM.DATA_2  IN( 'DG-SSD' ,'DG-SDT','HY-MEM')
                AND OPER ='120070'
                AND PRD.MAT_ID = MAT.MAT_ID
                AND MAT.MAT_CMF_1 IN( '20','21','50','10','11','12')
                GROUP BY WORK_DATE,GCM.DATA_2,MAT.MAT_CMF_1  ORDER BY WORK_DATE
          )GROUP BY WORK_DATE ,PROD_SE
    )
    SELECT A.WORK_DATE,A.PROD_SE, NVL(B.PLAN_QTY,0) PLAN_QTY, NVL(C.ACT_QTY,0) ACT_QTY,
    TRUNC(NVL(C.ACT_QTY/B.PLAN_QTY,0),4)*100 RATE
    FROM A ,B ,C
    WHERE 1=1
    AND A.WORK_DATE = B.WORK_DATE(+)
    AND A.PROD_SE = B.PROD_SE(+)
    AND A.WORK_DATE = C.WORK_DATE(+)
    AND A.PROD_SE = C.PROD_SE(+)
    ORDER BY A.WORK_DATE)
)P2,
(
#NAME?
WITH  A AS
(
       SELECT E.WORK_DATE
        FROM
        (
          SELECT TO_CHAR(TO_DATE(TO_CHAR(TRUNC(SYSDATE,'yyyy'),'YYYYMMDD'),'YYYYMMDD')+LEVEL-1,'YYYYMMDD') AS WORK_DATE FROM DUAL CONNECT BY LEVEL <366
        ) E
),
    B AS
    (
        SELECT WORK_DATE,AREA,COM_EFF FROM
        (
        SELECT WORK_DATE , AREA , SUM(TOTAL_TIME) T_TIME ,SUM(PROD_TIME) P_TIME,SUM(EXC_TIME) E_TIME,
        TRUNC(SUM(PROD_TIME) /( SUM(TOTAL_TIME))*100,2) COM_EFF FROM USER_EFF
        WHERE 1=1 AND PROD_TIME > 0 AND TOTAL_TIME > 0 AND AREA IN( 'DG-SDT','HY-MEM') GROUP BY WORK_DATE, AREA
        )
        UNION ALL
        SELECT WORK_DATE,AREA,COM_EFF FROM
        (
        SELECT WORK_DATE ,AREA , SUM(TOTAL_TIME) T_TIME ,SUM(PROD_TIME) P_TIME,
        SUM(EXC_TIME) E_TIME ,TRUNC(SUM(PROD_TIME) /( SUM(TOTAL_TIME))*100,2) COM_EFF FROM SSD_USER_EFF
        WHERE 1=1 AND PROD_TIME > 0 AND TOTAL_TIME > 0 AND AREA IN ('CSSD','ESSD') GROUP BY WORK_DATE, AREA
        )
)
SELECT A.WORK_DATE,
DECODE(B.AREA,'DG-SDT','SDT','HY-MEM','MEM','CSSD','CSSD','ESSD','ESSD') AREA,
 NVL(B.COM_EFF,0) COM_EFF FROM A ,B WHERE A.WORK_DATE = B.WORK_DATE(+) ORDER BY WORK_DATE, AREA
)P3,
(
 -------------------------------------------------------直通率
  SELECT WORK_DATE, AREA,NVL(TRUNC(EXP(SUM(LN(DFT_RATE)))*100,2),0) DFT_RATE FROM
   (
   WITH  A AS
        (
            SELECT E.WORK_DATE
            FROM
            (
              SELECT TO_CHAR(TO_DATE(TO_CHAR(TRUNC(SYSDATE,'yyyy'),'YYYYMMDD'),'YYYYMMDD')+LEVEL-1,'YYYYMMDD') AS WORK_DATE FROM DUAL CONNECT BY LEVEL <366
            ) E
        ),
        B AS
        (
                 SELECT WORK_DATE,AREA ,OPER ,SUM(TRAN_QTY) QTY FROM
               (
               SELECT PRD.WORK_DATE ,
               CASE
               WHEN GCM.DATA_2 = 'HY-MEM' THEN 'MEM'
               WHEN GCM.DATA_2 = 'DG-SDT' THEN 'SDT'
               WHEN GCM.DATA_2 = 'DG-SSD' AND MAT.MAT_CMF_1 ='20' THEN 'CSSD'
               WHEN GCM.DATA_2 = 'DG-SSD' AND MAT.MAT_CMF_1 ='21' THEN 'ESSD'
               END AREA,
               PRD.OPER ,PRD.TRAN_QTY FROM CWIPPRDSUM PRD, MWIPOPRDEF OPR ,MGCMTBLDAT GCM,MWIPMATDEF MAT
                WHERE 1=1
                AND PRD.FACTORY = 'RCM1'
                AND GCM.FACTORY = 'RCM1'
                AND OPR.FACTORY = 'RCM1'
                AND MAT.FACTORY = 'RCM1'
                AND PRD.MAT_ID = MAT.MAT_ID
                AND PRD.OPER = OPR.OPER
                AND OPR.OPER_CMF_7 = 'Y'
                AND PRD.SUB_AREA = GCM.KEY_1
                AND GCM.TABLE_NAME = 'SUB_AREA'
                AND PRD.SUB_AREA = GCM.KEY_1
                AND GCM.DATA_2 IN ('DG-SSD','DG-SDT','HY-MEM')
                AND MAT.MAT_CMF_1 IN('20','21','50','10','11','12')
             ) WHERE AREA IS NOT NULL
             GROUP BY WORK_DATE,AREA,OPER ORDER BY WORK_DATE,AREA,OPER
        ),
        C AS
        (
           SELECT WORK_DATE,AREA, OPER,SUM(1)NG_QTY FROM (
            SELECT (CASE
                     WHEN GCM.DATA_10 = 'DG'  AND SUBSTR(DFT.TRAN_TIME, 9, 6) >= '080000' THEN  TO_CHAR(TO_DATE(DFT.TRAN_TIME, 'YYYY-MM-DD HH24MISS'), 'YYYYMMDD')
                     WHEN GCM.DATA_10 = 'DG' AND SUBSTR(DFT.TRAN_TIME, 9, 6) < '080000'  THEN  TO_CHAR(TO_DATE(DFT.TRAN_TIME, 'YYYY-MM-DD HH24MISS') - 1, 'YYYYMMDD')
                     WHEN GCM.DATA_10 = 'HY' AND SUBSTR(DFT.TRAN_TIME, 9, 6) >= '083000' THEN  TO_CHAR(TO_DATE(DFT.TRAN_TIME, 'YYYY-MM-DD HH24MISS'), 'YYYYMMDD')
                     WHEN GCM.DATA_10 = 'HY' AND SUBSTR(DFT.TRAN_TIME, 9, 6) < '083000'  THEN  TO_CHAR(TO_DATE(DFT.TRAN_TIME, 'YYYY-MM-DD HH24MISS') - 1, 'YYYYMMDD')
                     ELSE              'NA'         END) WORK_DATE,
                     CASE
                   WHEN GCM.DATA_2 = 'HY-MEM' THEN 'MEM'
                   WHEN GCM.DATA_2 = 'DG-SDT' THEN 'SDT'
                   WHEN GCM.DATA_2 = 'DG-SSD' AND MAT.MAT_CMF_1 ='20' THEN 'CSSD'
                   WHEN GCM.DATA_2 = 'DG-SSD' AND MAT.MAT_CMF_1 ='21' THEN 'ESSD'
                   END AREA,
                     GCM.KEY_1 LINE_ID,DFT.OPER ,DFT.LOT_ID
            FROM MWIPLOTDFT DFT,MWIPLOTSTS STS,MWIPOPRDEF OPR, MGCMTBLDAT GCM ,MWIPMATDEF MAT WHERE 1=1
            AND DFT.FACTORY = 'RCM1'
            AND STS.FACTORY = 'RCM1'
            AND GCM.FACTORY = 'RCM1'
            AND OPR.FACTORY = 'RCM1'
            AND MAT.FACTORY = 'RCM1'
            AND DFT.MAT_ID = MAT.MAT_ID
            AND DFT.TRAN_TIME >'20180101000000'
            AND DFT.LOT_ID = STS.LOT_ID
            AND DFT.HIST_DEL_FLAG = ' '
            AND STS.LOT_CMF_17 = GCM.KEY_1
            AND DFT.OPER = OPR.OPER
            AND OPR.OPER_CMF_7 = 'Y'
            AND GCM.TABLE_NAME ='SUB_AREA'
            AND GCM.DATA_2 IN ('DG-SSD','DG-SDT','HY-MEM')
            AND MAT.MAT_CMF_1 IN('20','21','50','10','11','12')
            )
            GROUP BY  WORK_DATE,AREA, OPER ORDER BY WORK_DATE,AREA ,OPER
        )
        SELECT A.WORK_DATE, B.AREA, B.OPER ,B.QTY ,NVL(C.NG_QTY,0)NG_QTY, DECODE(C.NG_QTY,NULL,1,(1- C.NG_QTY/B.QTY)) DFT_RATE FROM A,B,C
        WHERE 1=1
        AND A.WORK_DATE = B.WORK_DATE(+)
        AND B.WORK_DATE = C.WORK_DATE(+)
        AND B.AREA = C.AREA(+)
        AND B.OPER = C.OPER(+)
        AND B.OPER IS NOT NULL
        AND B.AREA IS NOT NULL
        ORDER BY WORK_DATE ,AREA,OPER
  )
  WHERE DFT_RATE > 0
  GROUP BY WORK_DATE ,AREA  ORDER BY WORK_DATE
)P4,
(
  --------------------------------------------------------人力匹配状况
  SELECT WORK_DATE,AREA,MANAGER,NVL(MATCH_LAB,0) MATCH_RATE FROM
(
WITH
T1 AS
(
  SELECT E.WORK_DATE
    FROM
    (
      SELECT TO_CHAR(TO_DATE(TO_CHAR(TRUNC(SYSDATE,'yyyy'),'YYYYMMDD'),'YYYYMMDD')+LEVEL-1,'YYYYMMDD') AS WORK_DATE FROM DUAL CONNECT BY LEVEL <366
    ) E
),
T2 AS
(
    SELECT WORK_DATE,AREA,MANAGER, SUM(STA_LAB)STA_LAB FROM
    (
           SELECT A.WORK_DATE ,A.AREA,A.WORK_SHOP,A.MAT_ID,A.QTY,A.HOURS,B.STA_TIME, C.MANAGER, C.RATE ,DECODE(A.HOURS,0,0,CEIL (A.QTY * B.STA_TIME * C.RATE /100/3600/A.HOURS))STA_LAB FROM
            (
               SELECT PLN.WORK_DATE ,
                --DECODE(PLN.ORD_CMF_2,'DG_SDT','DG-SDT','DG_SSD','DG-SSD','HY','HY-MEM') S_AREA,
                DECODE(MAT.MAT_CMF_1,'20','CSSD','21','ESSD','50','DG-SDT','10','HY-MEM','11','HY-MEM','12','HY-MEM')AREA,
                PLN.ORD_CMF_1 WORK_SHOP,PLN.MAT_ID ,SUM(PLN.PLAN_ORD_QTY) QTY,
                 CASE PLN.ORD_CMF_1
                WHEN 'PAK' THEN '22'
                WHEN 'SMT' THEN ''||CEIL((TO_DATE(DECODE(MAX(PLN.END_TIME),' ', TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),MAX(PLN.END_TIME)), 'YYYYMMDDHH24MISS') - TO_DATE(MIN(PLN.START_TIME), 'YYYYMMDDHH24MISS')) *24 )
                ELSE '0' END HOURS
                 FROM CWIPORDPLN PLN,MWIPMATDEF MAT WHERE 1=1
                 AND PLN.FACTORY ='RCM1'
                 AND MAT.FACTORY ='RCM1'
                 AND MAT.MAT_ID = PLN.MAT_ID
                 AND PLN.DELETE_FLAG !='Y'
                 AND PLN.ORD_CMF_2 IN( 'DG_SDT' ,'DG_SSD' ,'HY')
                 AND PLN.ORD_CMF_1 IN('SMT','PAK')
                 AND MAT.MAT_CMF_1 IN('20','21','50','10','11','12')
                GROUP BY PLN.WORK_DATE, PLN.ORD_CMF_2 ,PLN.ORD_CMF_1,PLN.MAT_ID,MAT.MAT_CMF_1 ORDER BY WORK_DATE,AREA ,WORK_SHOP,MAT_ID
            )A,
            (
                SELECT WORK_DATE,AREA,WORK_SHOP,MAT_ID,SUM(STA_TIME)STA_TIME FROM (
                    SELECT PLN.WORK_DATE,DECODE(PLN.ORD_CMF_2,'DG_SDT','DG-SDT','DG_SSD','DG-SSD','HY','HY-MEM') S_AREA,
                    DECODE(MAT.MAT_CMF_1,'20','CSSD','21','ESSD','50','DG-SDT','10','HY-MEM','11','HY-MEM','12','HY-MEM') AREA,
                    'SMT' WORK_SHOP, PLN.MAT_ID, GCM.DATA_2 OPER,MAX(GCM.DATA_6)STA_TIME FROM
                    MGCMTBLDAT GCM , CWIPORDPLN PLN ,MWIPMATDEF MAT
                    WHERE 1=1
                    AND GCM.FACTORY = 'RCM1'
                    AND PLN.FACTORY = 'RCM1'
                    AND MAT.FACTORY = 'RCM1'
                    AND GCM.TABLE_NAME = 'C_LABOR_OPER'
                    AND GCM.KEY_2 = PLN.MAT_ID
                    AND GCM.DATA_2 = '120070'
                    AND PLN.DELETE_FLAG !='Y'
                    AND PLN.ORD_CMF_2 IN( 'DG_SDT' ,'HY','DG_SSD') AND PLN.ORD_CMF_1 = 'SMT'
                    AND PLN.MAT_ID = MAT.MAT_ID
                    AND MAT.MAT_CMF_1 IN('20','21','50','10','11','12')
                    GROUP BY PLN.WORK_DATE ,PLN.ORD_CMF_2 ,PLN.MAT_ID ,GCM.DATA_2,MAT.MAT_CMF_1
                )GROUP BY WORK_DATE, AREA,WORK_SHOP,MAT_ID
                UNION ALL
                SELECT WORK_DATE,AREA,WORK_SHOP,MAT_ID,SUM(STA_TIME)STA_TIME FROM (
                    SELECT PLN.WORK_DATE,DECODE(PLN.ORD_CMF_2,'DG_SDT','DG-SDT','DG_SSD','DG-SSD','HY','HY-MEM') S_AREA,
                    DECODE(MAT.MAT_CMF_1,'20','CSSD','21','ESSD','50','DG-SDT','10','HY-MEM','11','HY-MEM','12','HY-MEM') AREA, 'PAK' WORK_SHOP, PLN.MAT_ID, GCM.DATA_2 OPER,MAX(GCM.DATA_6)STA_TIME
                    FROM
                    MGCMTBLDAT GCM , CWIPORDPLN PLN ,MWIPMATDEF MAT
                    WHERE 1=1
                    AND GCM.FACTORY = 'RCM1'
                    AND PLN.FACTORY = 'RCM1'
                    AND MAT.FACTORY = 'RCM1'
                    AND GCM.TABLE_NAME = 'C_LABOR_OPER'
                    AND GCM.KEY_2 = PLN.MAT_ID
                    AND GCM.DATA_2 != '120070'
                    AND PLN.DELETE_FLAG !='Y'
                    AND PLN.ORD_CMF_2 IN( 'DG_SDT' ,'HY','DG_SSD') AND PLN.ORD_CMF_1 = 'PAK'
                    AND PLN.MAT_ID = MAT.MAT_ID
                    AND MAT.MAT_CMF_1 IN('20','21','50','10','11','12')
                    GROUP BY PLN.WORK_DATE ,PLN.ORD_CMF_2 ,PLN.MAT_ID ,GCM.DATA_2,MAT.MAT_CMF_1
                )GROUP BY WORK_DATE, AREA,WORK_SHOP,MAT_ID
            )B,
            (
             SELECT KEY_1 AREA, KEY_2 WORK_SHOP, TO_NUMBER(DATA_1) RATE,DATA_2 MANAGER FROM MGCMTBLDAT WHERE FACTORY = 'RCM1' AND TABLE_NAME ='KPI_AREA_LABOUR'
            )C
            WHERE 1=1
            AND A.WORK_DATE = B.WORK_DATE
            AND A.AREA = B.AREA
            AND A.WORK_SHOP = B.WORK_SHOP
            AND A.MAT_ID = B.MAT_ID
            AND A.AREA = C.AREA
            AND A.WORK_SHOP = C.WORK_SHOP
    )
    GROUP BY WORK_DATE ,AREA,MANAGER
),
T3 AS
(
     SELECT WORK_DATE, AREA ,SUM(1) ACT_LAB  FROM
    (
      SELECT SUBSTR(C.ON_TIME,0,8) WORK_DATE, C.AREA ,USER_ID
      FROM CSECUSRONO C
      WHERE
      C.FACTORY =  'RCM1' AND AREA ='DG-SDT'
      GROUP BY  SUBSTR(C.ON_TIME,0,8) ,  C.AREA ,USER_ID ORDER BY WORK_DATE,AREA
    ) GROUP BY WORK_DATE,AREA
    UNION
     SELECT WORK_DATE, 'ESSD' AREA ,CEIL(SUM(1)/2) ACT_LABOR  FROM
    (
      SELECT SUBSTR(C.ON_TIME,0,8) WORK_DATE, C.AREA ,USER_ID
      FROM CSECUSRONO C
      WHERE
      C.FACTORY =  'RCM1' AND AREA = 'DG-SSD'
      GROUP BY  SUBSTR(C.ON_TIME,0,8) ,  C.AREA ,USER_ID ORDER BY WORK_DATE,AREA
    ) GROUP BY WORK_DATE, AREA
     UNION
     SELECT WORK_DATE,'CSSD' AREA ,CEIL(SUM(1)/2) ACT_LABOR  FROM
    (
      SELECT SUBSTR(C.ON_TIME,0,8) WORK_DATE, C.AREA ,USER_ID
      FROM CSECUSRONO C
      WHERE
      C.FACTORY =  'RCM1' AND AREA = 'DG-SSD'
      GROUP BY  SUBSTR(C.ON_TIME,0,8) ,  C.AREA ,USER_ID ORDER BY WORK_DATE,AREA
    ) GROUP BY WORK_DATE,AREA
     UNION
    SELECT WORK_DATE, AREA ,SUM(1) ACT_LABOR  FROM
    (
      SELECT SUBSTR(C.ON_TIME,0,8) WORK_DATE, C.AREA ,USER_ID
      FROM CSECUSRONO C
      WHERE
      C.FACTORY =  'RCM1' AND AREA = 'HY-MEM'
      GROUP BY  SUBSTR(C.ON_TIME,0,8) ,  C.AREA ,USER_ID ORDER BY WORK_DATE,AREA
    ) GROUP BY WORK_DATE, AREA
)
SELECT T2.WORK_DATE,DECODE(T2.AREA,'DG-SDT','SDT','HY-MEM','MEM','CSSD','CSSD','ESSD','ESSD') AREA,T2.MANAGER,T2.STA_LAB,T3.ACT_LAB ,TRUNC((T3.ACT_LAB/T2.STA_LAB)*100,2) MATCH_LAB,(T2.STA_LAB - T3.ACT_LAB) DUTY_LAB FROM T1,T2,T3
WHERE 1=1
AND T1.WORK_DATE = T2.WORK_DATE(+)
AND T2.WORK_DATE = T3.WORK_DATE(+)
AND T2.AREA = T3.AREA(+)
)
)P5
WHERE  1=1
AND P1.WORK_DATE = P2.WORK_DATE(+)
AND P1.AREA = P2.AREA(+)
AND P1.WORK_DATE = P3.WORK_DATE(+)
AND P1.AREA = P3.AREA(+)
AND P1.WORK_DATE = P4.WORK_DATE(+)
AND P1.AREA = P4.AREA(+)
AND P1.WORK_DATE = P5.WORK_DATE(+)
AND P1.AREA = P5.AREA(+)
)
WHERE 1=1
AND AREA = NVL(TRIM('CSSD'),AREA)
AND WORK_DATE >= '20180601'
AND WORK_DATE <= '20180628'
ORDER BY WORK_DATE ,SCORE DESC
)
