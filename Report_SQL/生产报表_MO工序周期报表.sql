SELECT (select DISTINCT DATA_8 from MGCMTBLDAT WHERE TABLE_NAME='SUB_AREA' AND FACTORY = T.FACTORY AND KEY_1 = C.LINE_ID) 工厂,
       (select DISTINCT DATA_1 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = T.FACTORY AND KEY_1 = D.MAT_CMF_1) 产品组,
       TO_CHAR(T.ORDER_ID) 工单,
       TO_CHAR(T.MAT_ID) 物料编码,
       TO_CHAR(T.OLD_OPER) OPER,
       T.OPER_DESC||'(天)' OPER_DESC,
       TO_CHAR( ROUND(to_date(NVL(trim(T.END_TIME),to_char(SYSDATE,'yyyy-mm-dd hh24:mi:ss')),'yyyy-mm-dd hh24:mi:ss') - to_date(NVL(trim(T.START_TIME),to_char(SYSDATE,'yyyy-mm-dd hh24:mi:ss')),'yyyy-mm-dd hh24:mi:ss'),2),'99990.99' ) USED_TIME
FROM  (
   SELECT  A.FACTORY,
           A.ORDER_ID,
           A.MAT_ID ,
           A.OLD_OPER,
           B.OPER_DESC,
           MIN(A.TRAN_TIME) START_TIME,
           MAX(A.TRAN_TIME) END_TIME
    FROM MWIPLOTHIS A
      LEFT JOIN MWIPOPRDEF B
        ON B.FACTORY = A.FACTORY AND B.OPER = A.OLD_OPER
    where 1=1
      AND A.HIST_DEL_FLAG = ' '
      AND A.TRAN_CMF_4  = ' '  --返工时标记为D
      AND A.FACTORY = NVL(trim('RCM1'),A.FACTORY)
      AND A.ORDER_ID = NVL (TRIM (' '),A.ORDER_ID)
    GROUP BY
           A.FACTORY,
           A.ORDER_ID,
           A.MAT_ID ,
           A.OLD_OPER,
           B.OPER_DESC
    order by A.OLD_OPER
) T
  LEFT JOIN CWIPORDSTS C
      ON T.FACTORY = C.FACTORY	AND T.ORDER_ID = C.ORDER_ID
  LEFT JOIN MWIPMATDEF D
      ON T.FACTORY = D.FACTORY	AND T.MAT_ID = D.MAT_ID
  where 1=1
          AND C.ORD_CMF_3 = '20'
        AND C.LINE_ID = '100050'
    AND C.ORD_START_TIME >= '20180601'||'08'||'30'||'00'  AND C.ORD_START_TIME < '20180628'||'08'||'30'||'00'
