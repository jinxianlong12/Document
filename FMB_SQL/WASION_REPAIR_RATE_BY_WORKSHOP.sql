SELECT WP.DATA_1 AS WORKSHOP,LINE.DATA_1 AS LINE_ID,  
         SUM (DEFECT_QTY) AS DEFECT_QTY,   
         SUM (REPAIR_QTY) REPAIR_QTY,  
          SUM (DEFECT_QTY)-SUM (REPAIR_QTY) AS WAIT_QTY,    
         100 * ROUND (SUM (REPAIR_QTY) / SUM (DEFECT_QTY), 4) AS RATE   
    FROM (SELECT DISTINCT T.FACTORY,    T.LOT_ID,   
                          T.HIST_SEQ,   
                          1 AS DEFECT_QTY,   
                          T.ATTACH_FILE_3 AS WORKSHOP,   
                          T.ATTACH_FILE_4 AS AREA,   
                          T.ATTACH_FILE_5 AS LINE_ID,   
                          DECODE (T.ATTACH_FILE_7, ' ', 0, 1) AS REPAIR_QTY   
            FROM MWIPLOTDFT T   
           WHERE T.FACTORY = 'WASION' 
               AND (T.ATTACH_FILE_3 = :CODE OR :CODE='ALL') 
               AND T.SYS_TRAN_TIME >= 
                      DECODE (:W_DATE, 
                         'day', TO_CHAR (SYSDATE, 'YYYYMMDD'), 
                         'week', TO_CHAR (TRUNC (SYSDATE, 'D') + 1,'YYYYMMDD'), 
                         'month', TO_CHAR (TRUNC (SYSDATE, 'MM'), 'YYYYMMDD'), 
                         TO_CHAR (SYSDATE, 'YYYYMMDD')) || '000000' 
               AND T.SYS_TRAN_TIME <= 
                      DECODE (:W_DATE, 
                         'day', TO_CHAR (SYSDATE, 'YYYYMMDD'), 
                         'week', TO_CHAR (TRUNC (SYSDATE, 'D') + 7,'YYYYMMDD'), 
                         'month', TO_CHAR (LAST_DAY (TRUNC (SYSDATE)),'YYYYMMDD'), 
                         TO_CHAR (SYSDATE, 'YYYYMMDD'))|| '235959') TMP ,  
           MGCMTBLDAT WP,MGCMTBLDAT LINE  
           WHERE WP.FACTORY = TMP.FACTORY AND WP.KEY_1 = TMP.WORKSHOP  
           AND LINE.FACTORY = TMP.FACTORY AND LINE.KEY_1 = TMP.LINE_ID  
           AND WP.TABLE_NAME = 'WORKSHOP'  
           AND LINE.TABLE_NAME = 'SUB_AREA'  
GROUP BY WP.DATA_1,LINE.DATA_1  
ORDER BY WP.DATA_1,LINE.DATA_1