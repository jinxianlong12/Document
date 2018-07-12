WITH ATT AS
(
    SELECT
    A.*,
    ROUND(NVL(GET_HOURLY_WAGES('RCM1', A.WORK_DATE,A.USER_ID, A.ORDER_ID,A.MAT_ID, A.OPER,A.SHIFT, A.AREA,A.HOLIDAY_FLAG, A.WEEKEND_FLAG,A.PRICE_WAGE, A.ATT_TIME, A.ABN_TIME),0),2) AS TIME_WAGE,
    DECODE(ATT_TIME - ABN_TIME,0,0,ROUND(A.PROD_TIME/(ATT_TIME - ABN_TIME) * 100,2)) || '%' AS RATIO,
    DECODE(ATT_TIME,0,0,ROUND(A.PROD_TIME/(ATT_TIME)* 100,2)) || '%'  AS TOTOAL_RATIO
    FROM
    (
    SELECT
    A.*,
    CAL.HOLIDAY_FLAG AS WEEKEND_FLAG,
    CAL.CAL_CMF_1 AS HOLIDAY_FLAG,
    CASE WHEN CAL.HOLIDAY_FLAG = 'Y' OR CAL.CAL_CMF_1 = 'Y' THEN 'Y' ELSE 'N' END AS BONUS_FLAG,
    CASE WHEN GCM.FACTORY IS NULL THEN 0
           WHEN  CAL.HOLIDAY_FLAG = 'Y' OR CAL.CAL_CMF_1 = 'Y' THEN TO_NUMBER(DECODE(GCM.DATA_3,' ',0,GCM.DATA_3))
           ELSE TO_NUMBER(DECODE(GCM.DATA_2,' ',0,GCM.DATA_2))
          END AS UNIT_PRICE,
    A.PROD_QTY * CASE WHEN GCM.FACTORY IS NULL THEN 0
           WHEN  CAL.HOLIDAY_FLAG = 'Y' OR CAL.CAL_CMF_1 = 'Y' THEN TO_NUMBER(DECODE(GCM.DATA_3,' ',0,GCM.DATA_3))
           ELSE TO_NUMBER(DECODE(GCM.DATA_2,' ',0,GCM.DATA_2))
          END AS PRICE_WAGE,
    CASE WHEN
        USR.ENTER_DATE = ' ' THEN  'Y'
    WHEN
        MONTHS_BETWEEN(SYSDATE，TO_DATE(USR.ENTER_DATE,'YYYYMMDD')) <= 3 THEN 'Y'
    ELSE
     ' '
    END  AS NEW_PEOPLE_FLAG
    FROM
    (
    SELECT
      SUBSTR(A.WORK_DATE,0,4) AS WORK_YEAR,
      SUBSTR(A.WORK_DATE,5,2) AS WORK_MONTH,
      SUBSTR(A.WORK_DATE,7,2) AS WORK_DAY,
      A.WORK_DATE,
      A.USER_ID,
      A.ORDER_ID,
      A.MAT_ID,
      A.OPER,
      A.SHIFT,
      A.FACTORY,
      A.AREA,
      A.TIME_RATIO,
      SUM(A.ATT_TIME) AS ATT_TIME,
      SUM(A.ABN_TIME) AS ABN_TIME,
      SUM(A.PROD_QTY) AS PROD_QTY,
      SUM(A.PROD_TIME) AS PROD_TIME,
      MAX(A.BIAOGONG)  AS BIAOGONG
    FROM
    (
    --正常生产部分
    SELECT
    TIM.WORK_DATE                                                   AS WORK_DATE,
    TIM.USER_ID                                                     AS USER_ID,
    TIM.ORDER_ID                                                    AS ORDER_ID,
    TIM.MAT_ID                                                      AS MAT_ID,
    GCM.DATA_2                                                      AS OPER,
    TIM.SHIFT                                                       AS SHIFT,
    CASE WHEN
            TIM.AREA = ' ' THEN '未登录'
         WHEN
            SUBSTR(TIM.AREA,0,2) = 'DG' THEN '东莞'
         WHEN
            SUBSTR(TIM.AREA,0,2) = 'HY' THEN '惠阳'
         ELSE
            '其他'
         END                                                        AS FACTORY,
    TIM.AREA                                                        AS AREA,
    TO_NUMBER(DECODE(TIM.TIME_RATIO,' ',0,TIM.TIME_RATIO))          AS TIME_RATIO,
    TO_NUMBER(DECODE(TIM.ATT_TIME,' ',0,TIM.ATT_TIME))              AS ATT_TIME,
    0                                                               AS ABN_TIME,
    TO_NUMBER(DECODE(TIM.PROD_QTY,' ',0,TIM.PROD_QTY))              AS PROD_QTY,
    TO_NUMBER(DECODE(TIM.PROD_TIME,' ',0,TIM.PROD_TIME))            AS PROD_TIME,
    TO_NUMBER(DECODE(TIM.CMF_1,' ',0,TIM.CMF_1))                    AS BIAOGONG
    FROM CWIPACTTME TIM
    LEFT OUTER JOIN MGCMTBLDAT GCM
    ON GCM.FACTORY = 'RCM1'
    AND GCM.TABLE_NAME = 'C_LABOR_OPER'
    AND GCM.KEY_1 = TIM.OPER
    AND GCM.KEY_2 = TIM.MAT_ID
    WHERE
       TIM.WORK_DATE >= '20180621'
       AND TIM.WORK_DATE <='20180627'
       AND  TIM.ACT_TIME_TYPE = 1
       AND  TIM.DELETE_FLAG = ' '
    UNION ALL
    --异常
    SELECT
    TIM.WORK_DATE                                                   AS WORK_DATE,
    TIM.USER_ID                                                     AS USER_ID,
    TIM.ORDER_ID                                                    AS ORDER_ID,
    TIM.MAT_ID                                                      AS MAT_ID,
    TIM.OPER                                                        AS OPER,
    TIM.SHIFT                                                       AS SHIFT,
    CASE WHEN
            TIM.AREA = ' ' THEN '未登录'
         WHEN
            SUBSTR(TIM.AREA,0,2) = 'DG' THEN '东莞'
         WHEN
            SUBSTR(TIM.AREA,0,2) = 'HY' THEN '惠阳'
         ELSE
            '其他'
         END                                                        AS FACTORY,
    TIM.AREA                                                        AS AREA,
    TO_NUMBER(DECODE(TIM.TIME_RATIO,' ',0,TIM.TIME_RATIO))          AS TIME_RATIO,
    TO_NUMBER(DECODE(TIM.ATT_TIME,' ',0,TIM.ATT_TIME))              AS ATT_TIME,
    TO_NUMBER(DECODE(TIM.ATT_TIME,' ',0,TIM.ATT_TIME))              AS ABN_TIME,
    TO_NUMBER(DECODE(TIM.PROD_QTY,' ',0,TIM.PROD_QTY))               AS PROD_QTY,
    0                                                               AS PROD_TIME,
    0                                                               AS BIAOGONG
    FROM CWIPACTTME TIM
    WHERE
       TIM.WORK_DATE >= '20180621'
       AND TIM.WORK_DATE <='20180627'
       AND  TIM.ACT_TIME_TYPE IN ('2','3')
       AND  TIM.DELETE_FLAG = ' '
    ) A
    GROUP BY
        A.WORK_DATE,A.USER_ID,A.ORDER_ID,
        A.MAT_ID,A.OPER,A.SHIFT,A.FACTORY,
        A.AREA,A.TIME_RATIO
    ) A
    LEFT OUTER JOIN MWIPCALDEF CAL
    ON CAL.CALENDAR_ID = 'RCM1'
    AND CAL.SYS_YEAR = A.WORK_YEAR
    AND CAL.SYS_MONTH = A.WORK_MONTH
    AND CAL.SYS_DAY = A.WORK_DAY
    LEFT OUTER JOIN MGCMTBLDAT GCM
    ON GCM.FACTORY = 'RCM1'
    AND GCM.TABLE_NAME = 'C_UNIT_PRICE'
    AND GCM.KEY_1 = A.MAT_ID
    AND GCM.KEY_2 = A.OPER
    LEFT OUTER JOIN MSECUSRDEF USR
    ON  USR.FACTORY = 'RCM1'
    AND USR.USER_ID = A.USER_ID
    ) A
)
SELECT
    A.WORK_DATE,
    ROUND(SUM(ATT_TIME),0) AS ATT_TIME,
    ROUND(SUM(PROD_QTY),0) AS PROD_QTY,
    ROUND(SUM(TOTAL_WAGE),0)AS TOTAL_WAGE
FROM
(
    SELECT
        A.FACTORY,
        A.MAT_GRP,
         TO_CHAR(TO_DATE(A.WORK_DATE,'YYYYMMDD'),'YYYY-MM-DD') AS WORK_DATE,
        --A.OPER,
        OPR.OPER_DESC,
        SUM(A.ATT_TIME) AS ATT_TIME,
        SUM(A.PROD_QTY) AS PROD_QTY,
        SUM(A.TOTAL_WAGE) AS TOTAl_WAGE
    FROM
    (
        SELECT
        ATT.FACTORY,
        GCM.DATA_1 AS MAT_GRP,
        ATT.WORK_DATE,
        ATT.OPER,
        SUM(ATT.ATT_TIME) AS ATT_TIME,
        SUM(ATT.PROD_QTY) AS PROD_QTY,
        SUM(ATT.PRICE_WAGE + ATT.TIME_WAGE) AS TOTAL_WAGE
        FROM ATT
        LEFT OUTER JOIN MWIPMATDEF MAT
        ON MAT.FACTORY = 'RCM1'
        AND MAT.MAT_ID = ATT.MAT_ID
        AND MAT.MAT_VER = 1
        LEFT OUTER JOIN MGCMTBLDAT GCM
        ON GCM.FACTORY = 'RCM1'
        AND GCM.TABLE_NAME = 'PRODUCT_GRP'
        AND GCM.KEY_1 = MAT.MAT_CMF_1
        GROUP BY
            ATT.FACTORY,
            GCM.DATA_1,
            ATT.WORK_DATE,
            ATT.OPER
    ) A
    LEFT OUTER JOIN MWIPOPRDEF OPR
    ON OPR.FACTORY = 'RCM1'
    AND OPR.OPER = A.OPER
    GROUP BY
        A.FACTORY,
        A.WORK_DATE,
        A.MAT_GRP,
        OPR.OPER_DESC
 ) A
 GROUP BY
    WORK_DATE
