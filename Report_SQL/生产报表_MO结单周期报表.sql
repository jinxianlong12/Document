SELECT M.FAC 工厂,
       M.GRP 产品组,
       TO_CHAR(M.MAT_ID) 物料编码,
       TO_CHAR(M.ORDER_ID) 工单,
       TO_CHAR(M.ORD_QTY) 工单数量,
		   TO_CHAR(M.ORD_OUT_QTY) 完成数,
		   TO_CHAR(M.DIFF_QTY) 差异数,
       M.PLAN_START_TIME 计划开始时间,
       M.PLAN_END_TIME 计划结束时间,
       TO_CHAR(M.STANDARD_CLOSE_DAYS) 标准结单天数,
       M.END_TIME 实际结束时间,
       TO_CHAR( ROUND(to_date( NVL(trim(M.END_TIME),to_char(SYSDATE,'yyyy-mm-dd hh24:mi:ss')),'yyyy-mm-dd hh24:mi:ss') - to_date(NVL(trim(M.ORD_START_TIME),to_char(SYSDATE,'yyyy-mm-dd hh24:mi:ss')),'yyyy-mm-dd hh24:mi:ss'),2),'99990.99' ) "周期时间(天)",
       CASE WHEN ( ROUND(to_date( NVL(trim(M.END_TIME),to_char(SYSDATE,'yyyy-mm-dd hh24:mi:ss')),'yyyy-mm-dd hh24:mi:ss') - to_date(NVL(trim(M.ORD_START_TIME),to_char(SYSDATE,'yyyy-mm-dd hh24:mi:ss')),'yyyy-mm-dd hh24:mi:ss'),2) - to_number(NVL(decode(M.STANDARD_CLOSE_DAYS,' ','0',M.STANDARD_CLOSE_DAYS),'0')) ) < 0
          THEN '0.00'
          ELSE TO_CHAR( ROUND(to_date( NVL(trim(M.END_TIME),to_char(SYSDATE,'yyyy-mm-dd hh24:mi:ss')),'yyyy-mm-dd hh24:mi:ss') - to_date(NVL(trim(M.ORD_START_TIME),to_char(SYSDATE,'yyyy-mm-dd hh24:mi:ss')),'yyyy-mm-dd hh24:mi:ss'),2) - to_number(NVL(decode(M.STANDARD_CLOSE_DAYS,' ','0',M.STANDARD_CLOSE_DAYS),'0')),'99990.99' )
       END 超期天数,
       M.ORD_START_TIME 开始投入时间,
       M.LAST_TRAN_TIME 最后记录时间,
       M.LAST_TRAN_TIME_95  完工百分之95的时间
FROM (
  SELECT distinct  (select DISTINCT DATA_8 from MGCMTBLDAT WHERE TABLE_NAME='SUB_AREA' AND FACTORY = A.FACTORY AND KEY_1 = C.LINE_ID) FAC,
        (select DISTINCT DATA_1 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = A.FACTORY AND KEY_1 = D.MAT_CMF_1) GRP,
        A.MAT_ID ,
        A.ORDER_ID ,
        A.ORD_QTY ,
        S.QTY ORD_OUT_QTY ,
        A.ORD_QTY - S.QTY DIFF_QTY,
        A.PLAN_START_TIME ,
        A.PLAN_END_TIME ,
        I.ORD_CREATE_TIME,
        (select DISTINCT DATA_3 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = F.FACTORY AND KEY_1 = F.PRODUCT_GRP) STANDARD_CLOSE_DAYS, --标准结单天数
        CASE
           WHEN A.ORD_QTY <= S.QTY
              THEN COMPLETE_TIME
           ELSE
            ' '
        END END_TIME,
        START_TIME ORD_START_TIME,
        END_TIME LAST_TRAN_TIME,
        end_time_95 LAST_TRAN_TIME_95
  FROM  MWIPORDSTS A
  LEFT JOIN (select count(distinct lot_id) qty,oper,order_id from mwiplothis    group by oper,order_id  ) S
    ON A.ORDER_ID = S.ORDER_ID AND S.OPER='190010'
      LEFT JOIN crptordsts SS   ON  A.ORDER_ID = SS.ORDER_ID AND SS.OPER='190010'
     LEFT JOIN CWIPORDDEF F ON A.FACTORY = F.FACTORY AND A.ORDER_ID = F.ORDER_ID
    LEFT JOIN CWIPORDSTS C   ON A.FACTORY = C.FACTORY  AND A.ORDER_ID = C.ORDER_ID
    LEFT JOIN MWIPMATDEF D   ON A.FACTORY = D.FACTORY  AND A.MAT_ID = D.MAT_ID
    LEFT JOIN iwipordsts I ON A.FACTORY = I.FACTORY  AND A.ORDER_ID = I.ORDER_ID
    WHERE 1=1
      AND A.FACTORY = NVL(trim('RCM1'),A.FACTORY)
      AND A.ORDER_ID = NVL (TRIM (' '),A.ORDER_ID)
               AND C.ORD_CMF_3 = '20'
  ) M
  WHERE 1=1
    AND (M.ORD_CREATE_TIME>= '20180601'||'08'||'30'||'00'  AND M.ORD_CREATE_TIME< '20180628'||'08'||'30'||'00')
  ORDER BY  m.grp,m.DIFF_QTY,M.LAST_TRAN_TIME ,M.MAT_ID
