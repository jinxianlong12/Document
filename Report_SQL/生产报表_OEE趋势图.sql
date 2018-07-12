select  FAC,
         LINE_ID,
         LINE_DESC,
         SHIFT,
         RES_ID,
         RES_DESC,
         ORDER_ID,
         PRODUCT_GRP,
         GRP,
         MAT_ID,
         HIST_SEQ,
         SUM_SEQ,
         EVENT_ID,
         TRAN_TIME,
         OLD_EVENT_ID,
         OLD_TRAN_TIME,
         INV_TIMES,
         INV_STATUS,
         REA_TYPE,
         REA_CODE,
         REA_DESC,
         TRAN_USER_ID,
         WORK_TIME
  from CSUMRESMOV R
 where R.FACTORY = 'RCM1'
   AND R.SHIFT = nvl(TRIM(' '), R.SHIFT)
   AND R.INV_STATUS = nvl(TRIM(' '), R.INV_STATUS)
   AND R.LINE_ID in ( select distinct LINE_ID from CSUMRESMOV where LINE_ID <> ' '  )
   AND R.LINE_ID = '100050'
   AND R.PRODUCT_GRP = '20'
   AND R.WORK_TIME >= nvl(TRIM('20180601'), to_char(TRUNC(sysdate) - 1,'yyyymmdd'))
   AND R.WORK_TIME <= nvl(TRIM('20180627'), to_char(TRUNC(sysdate), 'yyyymmdd')) || '240000'
order by R.LINE_ID,R.RES_ID,R.HIST_SEQ,R.SUM_SEQ
