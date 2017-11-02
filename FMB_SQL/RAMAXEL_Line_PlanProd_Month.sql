select WORK_DATE, 
       LINE_ID, 
       (select  DATA_1 from MGCMTBLDAT WHERE TABLE_NAME='SUB_AREA' AND FACTORY = 'RCM1' AND KEY_1 = A.LINE_ID) LINE_DESC, 
       SUM(QTY_1) AS PROD_QTY, 
        NVL((select SUM(P.PLAN_ORD_QTY) from ( 
              select T.ORDER_ID,T.ORD_CMF_1,T.WORK_DATE,T.PLAN_ORD_QTY,decode(T.LINE_ID2,' ',T.LINE_ID3,T.LINE_ID2) LINE_ID  
              from ( 
                select P.ORDER_ID,P.ORD_CMF_1,P.WORK_DATE,P.PLAN_ORD_QTY,O.ORD_CMF_4 LINE_ID2,(select distinct KEY_1 from MGCMTBLDAT WHERE TABLE_NAME='SUB_AREA' AND FACTORY = 'RCM1' AND DATA_9=C.CMF_5) LINE_ID3  
                from CWIPORDPLN P,MWIPORDSTS O,CWIPORDDEF C  
                where P.ORDER_ID=O.ORDER_ID  
                and P.ORDER_ID=C.ORDER_ID 
                ) T 
            ) P  
            where P.ORD_CMF_1 = 'SMT' 
              and P.LINE_ID = A.LINE_ID  
              and substr(P.WORK_DATE,0,6) = A.WORK_DATE),0)  AS PLAN_QTY 
from ( 
  select TO_CHAR(sysdate,'yyyymm') WORK_DATE,    
         H.LOT_CMF_17 AS LINE_ID, 
         QTY_1       
  from MWIPLOTHIS H   
  where H.FACTORY = 'RCM1'  
    AND H.HIST_DEL_FLAG = ' '  
    AND (CASE WHEN OLD_OPER = '120070' AND LOT_CMF_15 IN ( 'S',' ') AND TRAN_CODE IN ('END', 'COLLECT_DFT')  
                THEN 1  
                WHEN OLD_OPER = '120070' AND LOT_CMF_15 IN ( 'T','B') AND TRAN_CODE IN ('CREATE','END', 'COLLECT_DFT')  
                THEN 1  
          END )  = 1  
  --      AND LOT_CMF_17 = '200010' 
    AND H.TRAN_TIME >= TO_CHAR(sysdate,'yyyymm') 
  Union all 
  select to_char(sysdate, 'YYYYMM') WORK_DATE, KEY_1 LINE_ID,0 QTY_1 from MGCMTBLDAT WHERE TABLE_NAME='SUB_AREA' AND FACTORY = 'RCM1' 
) A 
GROUP BY WORK_DATE,LINE_ID 
order by LINE_ID