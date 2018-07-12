WITH TEMP AS (
            SELECT
                    A.FACTORY,
                    A.PLANT,
                    A.WORK_DATE,
                    A.ORDER_ID,
                    A.MAT_ID,
                    A.OPER,
                    COUNT(DISTINCT A.LOT_ID) AS QTY,
                    A.USER_ID
            FROM (
                    SELECT
                            A.FACTORY,
                            (SELECT DISTINCT DATA_8 FROM MGCMTBLDAT WHERE TABLE_NAME = 'SUB_AREA' AND FACTORY = A.FACTORY AND KEY_1 = A.LINE_ID) AS PLANT,
                            (CASE
                            WHEN TO_NUMBER(substr(A.TRAN_TIME,9,6)) - TO_NUMBER(SUBSTR('20171204' || '08' || '30',9,6)) >= 0
                            THEN TO_CHAR(TO_DATE(A.TRAN_TIME,'YYYYMMDDHH24MISS'),'YYYY-MM-DD')
                            ELSE
                            TO_CHAR(TO_DATE(A.TRAN_TIME,'YYYYMMDDHH24MISS') - 1,'YYYY-MM-DD')
                            END) AS WORK_DATE,
                            A.ORDER_ID,
                            A.MAT_ID,
                            A.OLD_OPER AS OPER,
                            A.LOT_ID,
                            A.TRAN_USER_ID AS USER_ID
                    FROM CWIPLOTMVH A
                    WHERE A.TRAN_TIME >= '20180627'||'08'||'30'||'00'
                    AND A.TRAN_TIME < '20180628'||'08'||'30'||'00'
                    AND A.FACTORY = NVL(trim('RCM1'),A.FACTORY)
                    AND A.SEQ_NUM = 1
      		    AND A.ORDER_ID =  NVL (TRIM (' '), A.ORDER_ID)
                    AND A.HIST_DEL_FLAG = ' '
                    AND (CASE WHEN A.OLD_OPER = '120070' AND A.BOARD_SIDE IN ( 'S',' ') AND A.TRAN_CODE IN ('END', 'COLLECT_DFT')
                                THEN 1
                                WHEN A.OLD_OPER = '120070' AND A.BOARD_SIDE IN ( 'T','B') AND A.TRAN_CODE IN ('CREATE','END', 'COLLECT_DFT')
                                THEN 1
                                WHEN A.OLD_OPER <> '120070' AND A.TRAN_CODE IN ('END', 'COLLECT_DFT')  THEN 1
                                ELSE 2
                          END )  = 1
                    ) A
            GROUP BY A.FACTORY,A.PLANT,A.WORK_DATE,A.ORDER_ID,A.MAT_ID,A.OPER,A.USER_ID
            )
SELECT
         A.FACTORY
        ,A.PLANT         AS 工厂
        ,A.WORK_DATE     AS 日期
        ,A.ORDER_ID      AS 工单
        ,C.DATA_1        AS 产品组
        ,A.MAT_ID        AS 产品编码
        ,B.MAT_DESC      AS 产品描述
        ,A.OPER
        ,D.OPER_DESC     AS 工序
        ,A.QTY           AS 数量
        ,E.USER_DESC     AS 用户
        ,A.USER_ID       AS 工号
FROM TEMP A
LEFT OUTER JOIN MWIPOPRDEF D ON D.FACTORY = A.FACTORY AND D.OPER = A.OPER
LEFT OUTER JOIN MWIPMATDEF B ON A.FACTORY = B.FACTORY AND A.MAT_ID = B.MAT_ID
LEFT OUTER JOIN ( select DISTINCT FACTORY,KEY_1,DATA_1,DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' ) C
ON C.FACTORY = B.FACTORY AND C.KEY_1 = B.MAT_CMF_1
LEFT OUTER JOIN MSECUSRDEF E ON E.FACTORY = A.FACTORY AND E.USER_ID = A.USER_ID
WHERE C.DATA_1 LIKE '%SDT%'
ORDER BY A.WORK_DATE DESC,A.OPER
