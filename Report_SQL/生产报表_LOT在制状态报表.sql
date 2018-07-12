WITH WIP_TEMP AS(
  SELECT t.factory,
         t.ORDER_ID,
         t.oper,
         o.oper_desc,
          CASE
           WHEN t.lot_status = 'WAIT' AND t.hold_flag <> 'Y'  THEN t.qty_1
           ELSE
0
         END ProcQty,
          CASE
           WHEN t.hold_flag = 'Y' THEN t.qty_1
           ELSE
0
         END HoldQty
    FROM MWIPLOTSTS T
      JOIN MWIPOPRDEF O
        ON O.FACTORY = T.FACTORY AND O.OPER = T.OPER
      JOIN IWIPORDSTS D
        ON D.FACTORY = T.FACTORY AND D.ORDER_ID = T.ORDER_ID
      LEFT JOIN ( SELECT DISTINCT FACTORY,KEY_1,DATA_1,DATA_2 FROM MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' ) C
        ON C.FACTORY = D.FACTORY AND C.KEY_1 = D.PRODUCT_GRP
     WHERE T.FACTORY = NVL(TRIM('RCM1'),T.FACTORY)
           AND T.LOT_DEL_FLAG != 'Y'
           AND D.ORD_STATUS !='DLFL'
          AND T.ORDER_ID = NVL (TRIM (' '), T.ORDER_ID)
)
    select ORDER_ID,
           OPER,
           OPER_DESC,
           (sum(ProcQty) + sum(HoldQty))  QTY
    from WIP_TEMP
    group by ORDER_ID,OPER,OPER_DESC
union all
    select ORDER_ID,
           '999999' OPER,
           '总计' OPER_DESC,
           (sum(ProcQty) + sum(HoldQty)) QTY
    from WIP_TEMP
    group by ORDER_ID,'999999','总计'
order by ORDER_ID,OPER
