WITH OEE_INFO AS(
  select R.RES_ID,
         R.SHIFT,
         SUM(CASE
               WHEN R.INV_STATUS = 'WAIT' THEN
                R.INV_TIMES
               ELSE
0
             END) WAIT_TIMES,
         SUM(CASE
               WHEN R.INV_STATUS = 'PROC' THEN
                R.INV_TIMES
               ELSE
0
             END) PROC_TIMES,
         SUM(CASE
               WHEN R.INV_STATUS = 'DOWN' THEN
                R.INV_TIMES
               ELSE
0
             END) DOWN_TIMES,
         SUM(CASE
               WHEN R.INV_STATUS = 'IDLE' THEN
                R.INV_TIMES
               ELSE
0
             END) IDLE_TIMES
    from CSUMRESMOV R
   where R.FACTORY = 'RCM1'
     AND R.SHIFT = nvl(TRIM(' '), R.SHIFT)
     AND R.RES_ID like 'LINE%'
     AND R.LINE_ID = '100050'
     AND R.PRODUCT_GRP = '20'
     AND R.WORK_TIME >= nvl(TRIM('20180627'), to_char(TRUNC(sysdate) - 1,'yyyymmdd'))
     AND R.WORK_TIME <= nvl(TRIM('20180628'), to_char(TRUNC(sysdate), 'yyyymmdd')) || '240000'
   group by R.RES_ID,R.SHIFT
   )
select RES_ID,
       SHIFT,
       WAIT_TIMES,
       PROC_TIMES,
       DOWN_TIMES,
       IDLE_TIMES,
       ROUND(PROC_TIMES/DECODE((PROC_TIMES+WAIT_TIMES+DOWN_TIMES),0,1,(PROC_TIMES+WAIT_TIMES+DOWN_TIMES)),4)*100 RATE
 from OEE_INFO
 order by RES_ID
