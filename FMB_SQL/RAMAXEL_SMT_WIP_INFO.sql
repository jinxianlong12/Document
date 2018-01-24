SELECT A.LINE_ID,B.ORDER_ID,B.PROD_ID,NVL(B.ORD_QTY,0) ORD_QTY,NVL(B.PROD_QTY,0) PROD_QTY,B.CUST_SHORT_DESC
FROM(
  (select KEY_1 LINE_ID,'' ORDER_ID,'' PROD_ID,0 ORD_QTY,0 PROD_QTY,'' CUST_SHORT_DESC from MGCMTBLDAT WHERE TABLE_NAME='SUB_AREA' AND FACTORY = 'RCM1') A
  LEFT JOIN
  (SELECT S.SUB_AREA LINE_ID,
         S.ORDER_ID,
         D.PROD_ID,
         D.ORD_QTY,
         (SELECT SUM(TRAN_QTY) FROM CWIPPRDSUM
          WHERE 1=1
            AND SUB_AREA=S.SUB_AREA
            AND OPER = '120070'
            AND ORDER_ID=S.ORDER_ID) PROD_QTY,
         D.CUST_SHORT_DESC
  FROM (
      select * from(
        SELECT ROW_NUMBER() OVER (PARTITION BY S.SUB_AREA ORDER BY UPDATE_TIME DESC) RN,S.ORDER_ID,S.SUB_AREA
        FROM CWIPPRDSUM S
        WHERE OPER = '120070'
          AND FACTORY = 'RCM1'
      )
      where RN=1
  ) S,CWIPORDDEF D
  where S.ORDER_ID = D.ORDER_ID
    AND D.FACTORY = 'RCM1') B
  ON A.LINE_ID = B.LINE_ID
)
ORDER BY A.LINE_ID