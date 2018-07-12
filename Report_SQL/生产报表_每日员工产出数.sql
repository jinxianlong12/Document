WITH  ORD AS(
    SELECT (CASE  WHEN TO_NUMBER(substr(A1.TRAN_TIME,9,6)) - TO_NUMBER(SUBSTR('20180627' || '08' || '30' || '00',9,6)) >= 0
                  THEN TO_CHAR(TO_DATE(A1.TRAN_TIME,'YYYYMMDDHH24MISS'),'YYYY-MM-DD')
            ELSE
                  TO_CHAR(TO_DATE(A1.TRAN_TIME,'YYYYMMDDHH24MISS') - 1,'YYYY-MM-DD')
            END) AS PROD_TIME
            ,A1.FACTORY
            ,A1.ORDER_ID
            ,A1.OLD_OPER
            ,A1.TRAN_USER_ID
           ,E.DATA_8
            ,A2.PRODUCT_GRP
            ,COUNT(DISTINCT(A1.LOT_ID)) AS QTY
            FROM MWIPLOTHIS A1
           JOIN MGCMTBLDAT E ON A1.lot_cmf_17=E.KEY_1 AND E.TABLE_NAME='SUB_AREA' AND E.FACTORY  = A1.FACTORY
            LEFT JOIN CWIPORDDEF A2 ON  A1.FACTORY=A2.FACTORY  AND A1.ORDER_ID=A2.ORDER_ID
            where A1.factory = NVL(TRIM ('RCM1'), A1.factory)
            AND A1.TRAN_CODE IN ('END','COLLECT_DFT')
            AND A1.TRAN_TIME >= '20180627'||'08'||'30'||'00'
            AND A1.TRAN_TIME < '20180628'||'08'||'30'||'00'
            AND A1.HIST_DEL_FLAG = ' '
            AND A2.PRODUCT_GRP = '20'
            AND A1.ORDER_ID = NVL(TRIM (' '), A1.ORDER_ID)
            GROUP BY (CASE  WHEN TO_NUMBER(substr(A1.TRAN_TIME,9,6)) - TO_NUMBER(SUBSTR('20180627' || '08' || '30' || '00',9,6)) >= 0
                  THEN TO_CHAR(TO_DATE(A1.TRAN_TIME,'YYYYMMDDHH24MISS'),'YYYY-MM-DD')
            ELSE
                  TO_CHAR(TO_DATE(A1.TRAN_TIME,'YYYYMMDDHH24MISS') - 1,'YYYY-MM-DD')
            END)
            ,A1.FACTORY
            ,A1.ORDER_ID
            ,A1.OLD_OPER
            ,A1.TRAN_USER_ID
           ,E.DATA_8
            ,A2.PRODUCT_GRP
)
select
A.DATA_8       AS   工厂
,A.PROD_TIME     AS   生产日期
,A.ORDER_ID            AS   工单
,B.PROD_ID             As   产品编码
,B.PROD_DESC            As   产品描述
,B.PRODUCT_GRP          As   产品组
,B1.DATA_1            As   产品组描述
,B1.DATA_2             As   产品分类
,C.OPER_SHORT_DESC     AS   工序
,D.USER_DESC           AS   用户姓名
,A.QTY                 AS   产出数
FROM  ORD A
JOIN CWIPORDDEF B ON A.ORDER_ID=B.ORDER_ID  AND A.FACTORY=B.FACTORY
JOIN MWIPOPRDEF C ON A.OLD_OPER=C.OPER AND A.FACTORY=C.FACTORY
JOIN MSECUSRDEF D ON A.TRAN_USER_ID=D.USER_ID
Left  join (SELECT DISTINCT KEY_1,DATA_1,DATA_2,FACTORY FROM MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP') B1  ON B1.FACTORY = B.FACTORY AND B1.KEY_1=B.PRODUCT_GRP
ORDER BY  B.PRODUCT_GRP,A.ORDER_ID,A.OLD_OPER
