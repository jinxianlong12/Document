SELECT * FROM (
WITH ATT AS
(
    SELECT
    A.*,
    ROUND(NVL(GET_HOURLY_WAGES('RCM1', A.WORK_DATE,A.USER_ID, A.ORDER_ID,A.MAT_ID, A.OPER,A.SHIFT, A.AREA,A.HOLIDAY_FLAG, A.WEEKEND_FLAG,A.PRICE_WAGE, A.ATT_TIME, A.ABN_TIME),0),2) AS TIME_WAGE,
    DECODE(ATT_TIME - ABN_TIME,0,0,ROUND((A.PROD_TIME + REAL_TIME)/(ATT_TIME - ABN_TIME) * 100,2)) || '%' AS RATIO,
    DECODE(ATT_TIME,0,0,ROUND((A.PROD_TIME + REAL_TIME)/(ATT_TIME)* 100,2)) || '%'  AS TOTOAL_RATIO
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
			  A.TIME_RATIO，
			  SUM(A.ATT_TIME) AS ATT_TIME,
			  SUM(A.ABN_TIME) AS ABN_TIME,
			  SUM(A.REAL_TIME) AS REAL_TIME,
			  SUM(A.PROD_QTY) AS PROD_QTY,
			  SUM(A.PROD_TIME) AS PROD_TIME,
			  MAX(A.BIAOGONG)  AS BIAOGONG
			FROM
			(
				#NAME?
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
				0             AS ABN_TIME,
				0                                                               AS REAL_TIME,
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
				   WORK_DATE BETWEEN '20180621' AND '20180628'
				   AND  TIM.ACT_TIME_TYPE = 1
				   AND  TIM.DELETE_FLAG = ' '
				UNION ALL
				#NAME?
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
				0                                                               AS REAL_TIME,
				0                                                               AS PROD_QTY,
				0                                                               AS PROD_TIME,
				0                                                               AS BIAOGONG
				FROM CWIPACTTME TIM
				WHERE
				   WORK_DATE BETWEEN '20180621' AND '20180628'
				   AND  TIM.ACT_TIME_TYPE = '2'
				   AND  TIM.DELETE_FLAG = ' '
				UNION ALL
				#NAME?
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
				0                                                               AS ABN_TIME,
				TO_NUMBER(DECODE(TIM.ATT_TIME,' ',0,TIM.ATT_TIME))              AS REAL_TIME,
				0                                                               AS PROD_QTY,
				0                                                               AS PROD_TIME,
				0                                                               AS BIAOGONG
				FROM CWIPACTTME TIM
				WHERE
				   WORK_DATE BETWEEN '20180621' AND '20180628'
				   AND  TIM.ACT_TIME_TYPE = '3'
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
    TO_CHAR(TO_DATE(ATT.WORK_DATE,'YYYYMMDD'),'YYYY-MM-DD')                     AS WORK_DATE,
    ATT.USER_ID ,
    USR.USER_DESC ,
    ATT.WEEKEND_FLAG,
    ATT.HOLIDAY_FLAG ,
    ATT.NEW_PEOPLE_FLAG,
    ATT.SHIFT ,
    SHIFT.DATA_1   AS SHIFT_DESC,
    ATT.FACTORY       ,
    ATT.ORDER_ID  ,
    ATT.MAT_ID ,
    MAT.MAT_DESC,
    ATT.OPER,
    OPR.OPER_DESC,
    ATT.AREA,
    AREA.DATA_1  AS AREA_DESC,
    ATT.ATT_TIME,
    ATT.ABN_TIME,
    ATT.REAL_TIME,
    ATT.PROD_TIME,
    ATT.BIAOGONG,
    ATT.PROD_QTY,
    ATT.UNIT_PRICE,
    ATT.TIME_WAGE,
    ATT.PRICE_WAGE,
    ATT.TIME_WAGE + ATT.PRICE_WAGE AS TOTAL_WAGE,
    ATT.RATIO,
    ATT.TOTOAL_RATIO
FROM ATT
LEFT OUTER JOIN MSECUSRDEF USR
ON USR.FACTORY = 'RCM1'
AND USR.USER_ID = ATT.USER_ID
LEFT OUTER JOIN MWIPOPRDEF OPR
ON OPR.FACTORY = 'RCM1'
AND OPR.OPER = ATT.OPER
LEFT OUTER JOIN MGCMTBLDAT SHIFT
ON SHIFT.FACTORY = 'RCM1'
AND SHIFT.TABLE_NAME = 'SHIFT'
AND SHIFT.KEY_1 = ATT.SHIFT
LEFT OUTER JOIN MWIPMATDEF MAT
ON MAT.FACTORY = 'RCM1'
AND MAT.MAT_ID = ATT.MAT_ID
AND MAT.MAT_VER = 1
LEFT OUTER JOIN MGCMTBLDAT AREA
ON AREA.FACTORY = 'RCM1'
AND AREA.TABLE_NAME = 'AREA'
AND AREA.KEY_1 = ATT.AREA
WHERE 1=1
AND ATT.USER_ID = NVL(TRIM(' '), ATT.USER_ID)
AND ATT.MAT_ID = NVL(TRIM(' '), ATT.MAT_ID)
AND ATT.ORDER_ID = NVL(TRIM(' '), ATT.ORDER_ID)
AND ATT.SHIFT = '1'
AND ATT.AREA = 'DG-SSD'
ORDER BY ATT.WORK_DATE,ATT.SHIFT,ATT.USER_ID
 ) A  WHERE
   WEEKEND_FLAG = 'Y'
