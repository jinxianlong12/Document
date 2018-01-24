WITH A AS
(
   SELECT  to_char(sysdate,'yyyymmdd') AS WORK_DATE  ,M.KEY_1 LINE_ID
     FROM MGCMTBLDAT M WHERE M.TABLE_NAME = 'SUB_AREA'  AND M.FACTORY = 'RCM1'
),
 B AS
(
   SELECT WORK_DATE , LINE_ID,
    SUM(PLAN_ORD_QTY) PLAN_ORD_QTY
  FROM cwipordpln
  WHERE
      ORD_CMF_1 = 'SMT'
  AND WORK_DATE   = to_char(sysdate,'yyyymmdd')
  AND DELETE_FLAG = ' '
  AND FACTORY = 'RCM1'
  GROUP BY WORK_DATE ,LINE_ID
),
 C AS
(
 SELECT P.WORK_DATE ,P.SUB_AREA AS LINE_ID,  SUM(P.TRAN_COUNT) ACT_TRAN_QTY  FROM cwipprdsum P WHERE
  P.OPER = '120070'
   AND P.WORK_DATE   = to_char(sysdate,'yyyymmdd')
   AND P.FACTORY = 'RCM1'
   GROUP BY P.WORK_DATE ,P.SUB_AREA
)
SELECT A.WORK_DATE, A.LINE_ID , B.PLAN_ORD_QTY,C.ACT_TRAN_QTY , trunc (C.ACT_TRAN_QTY /B.PLAN_ORD_QTY ,3)*100 AS RATE  FROM A,B,C
WHERE
 A.LINE_ID = B.LINE_ID(+)
AND A.LINE_ID = C.LINE_ID(+)

ORDER BY A.LINE_ID
