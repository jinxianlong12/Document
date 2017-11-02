WITH A 
AS  
( 
select to_char(to_date('20171025', 'yyyy-mm-dd hh24:mi:ss') + 
               (rownum - 1) / 24, 
               'hh24')  WORK_DATE ,' ' AS LINE_ID,  00 AS PLAN_ORD_QTY,  00 ACT_TRAN_QTY, 00 AS RATE , '00' AS E_DAY 
  from dual 
connect by rownum <= 24 
), 
 B AS 
 ( 
   SELECT S.TRAN_HOUR WORK_DATE , S.SUB_AREA AS LINE_ID, ' ' AS PLAN_ORD_QTY, trunc(SUM(S.TRAN_COUNT)) ACT_TRAN_QTY,80 AS RATE ,S.WORK_DATE AS E_DAY  FROM cwipprdsum S  
    WHERE  S.OPER = '120070'  
    AND S.FACTORY = 'RCM1'  
    AND S.WORK_DATE = to_char(sysdate,'YYYYMMDD')  
    AND S.SUB_AREA= :LINE_ID  
    group BY S.TRAN_HOUR,S.SUB_AREA ,S.WORK_DATE  ORDER BY S.TRAN_HOUR 
 ), 
 C AS 
 ( 
   select ' 'AS  WORK_DATE ,' ' AS LINE_ID,  sum(PLAN_ORD_QTY)/23 AS PLAN_ORD_QTY,  00 ACT_TRAN_QTY, 00 AS RATE , WORK_DATE AS E_DAY from CWIPORDPLN where work_date = to_char(sysdate,'YYYYMMDD') AND ORD_CMF_1 = 'SMT'   GROUP BY WORK_DATE 
 ) 
SELECT A.WORK_DATE ,B.LINE_ID,C.PLAN_ORD_QTY,B.ACT_TRAN_QTY, trunc((B.ACT_TRAN_QTY /C.PLAN_ORD_QTY)*100,3) AS RATE FROM A  , B ,C 
WHERE A.WORK_DATE = B.WORK_DATE(+) 
      AND B.E_DAY = C.E_DAY(+) 
ORDER BY A.WORK_DATE