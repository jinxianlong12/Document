SELECT DFT.FACTORY, DFT.DFT_CODE, CODE.DATA_1 DFT_DESC, 
       SUB.DATA_1 AS SUB_DESC, SUP.DATA_1 AS SUP_DESC, DFT.DFT_COUNT 
  FROM (  SELECT FACTORY, DFT_CODE, COUNT (1) DFT_COUNT 
            FROM CWIPREPDFT 
           WHERE     FACTORY = 'WASION' 
                 AND (WORKSHOP = :CODE OR :CODE='ALL') 
                 AND CREATE_TIME >= 
                           DECODE ( 
                              :W_DATE, 
                              'day', TO_CHAR (SYSDATE, 'YYYYMMDD'), 
                              'week', TO_CHAR (TRUNC (SYSDATE, 'D') + 1, 
                                               'YYYYMMDD'), 
                              'month', TO_CHAR (TRUNC (SYSDATE, 'MM'), 
                                                'YYYYMMDD'), 
                              TO_CHAR (SYSDATE, 'YYYYMMDD')) 
                        || '000000' 
                 AND CREATE_TIME <= 
                           DECODE ( 
                              :W_DATE, 
                              'day', TO_CHAR (SYSDATE, 'YYYYMMDD'), 
                              'week', TO_CHAR (TRUNC (SYSDATE, 'D') + 7, 
                                               'YYYYMMDD'), 
                              'month', TO_CHAR (LAST_DAY (TRUNC (SYSDATE)), 
                                                'YYYYMMDD'), 
                              TO_CHAR (SYSDATE, 'YYYYMMDD')) 
                        || '235959' 
        GROUP BY FACTORY, DFT_CODE 
        ORDER BY COUNT (1) DESC) DFT, 
       MGCMTBLDAT CODE, 
       MGCMTBLDAT SUB, 
       MGCMTBLDAT SUP 
 WHERE     DFT.FACTORY = CODE.FACTORY 
       AND DFT.DFT_CODE = CODE.KEY_1 
       AND CODE.FACTORY = SUB.FACTORY 
       AND CODE.KEY_2 = SUB.KEY_1 
       AND SUB.FACTORY = SUP.FACTORY 
       AND SUB.KEY_2 = SUP.KEY_1 
       AND CODE.TABLE_NAME = 'LOT_DEFECT_CODE' 
       AND SUB.TABLE_NAME = 'DFT_APR_SUB' 
       AND SUP.TABLE_NAME = 'DFT_APR_SUP' 
       AND ROWNUM <= 5