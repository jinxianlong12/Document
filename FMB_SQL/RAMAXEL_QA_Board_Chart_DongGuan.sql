	select TO_CHAR(to_date(H.TRAN_TIME,'YYYY-MM-DD HH24MISS'),'YYYY-MM-DD') WORK_DATE,    
       SUM(H.QTY_1) PROD_QTY, 
       SUM(CASE WHEN H.TRAN_CODE = 'COLLECT_DFT' THEN QTY_1 ELSE 0 END) DEFT_QTY 
  from MWIPLOTHIS H   
  where H.FACTORY = 'RCM1'  
    AND H.HIST_DEL_FLAG = ' '   
    AND H.LOT_CMF_17 in('100050','100010','100020')        
    AND (CASE WHEN LOT_CMF_15 IN ( 'S',' ') AND TRAN_CODE IN ('END', 'COLLECT_DFT')  
                THEN 1  
                WHEN LOT_CMF_15 IN ( 'T','B') AND TRAN_CODE IN ('CREATE','END', 'COLLECT_DFT')  
                THEN 1  
          END )  = 1 
    AND OLD_OPER = '120070' 
    AND H.TRAN_TIME >= TO_CHAR(sysdate,'yyyymm') 
  group by TO_CHAR(to_date(H.TRAN_TIME,'YYYY-MM-DD HH24MISS'),'YYYY-MM-DD') 
  order by WORK_DATE