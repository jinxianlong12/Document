WITH TMP AS
(
  select M.*,
         ROUND(to_date( NVL(trim(M.END_TIME),to_char(SYSDATE,'yyyy-mm-dd hh24:mi:ss')),'yyyy-mm-dd hh24:mi:ss') - to_date(NVL(trim(M.ORD_START_TIME),to_char(SYSDATE,'yyyy-mm-dd hh24:mi:ss')),'yyyy-mm-dd hh24:mi:ss'),2) cycle_time
  from(
    select  A.FACTORY ,
            (select DISTINCT DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = A.FACTORY AND KEY_1 = C.ORD_CMF_3) GRP,
            A.ORDER_ID ,
            CASE
               WHEN A.ORD_QTY <= S.QTY  THEN
                  (SELECT MAX(END_TIME) FROM CWIPORDSUM WHERE ORDER_ID = A.ORDER_ID AND OPER='190010')
               ELSE
                ''
            END END_TIME,
            (SELECT MIN(START_TIME) FROM CWIPORDSUM
            WHERE ORDER_ID = A.ORDER_ID) ORD_START_TIME
     from MWIPORDSTS A
     LEFT JOIN CWIPORDSUM S
      ON A.ORDER_ID = S.ORDER_ID AND S.OPER='190010'
     LEFT JOIN CWIPORDSTS C
      ON A.FACTORY = C.FACTORY	AND A.ORDER_ID = C.ORDER_ID
    where 1=1
      and A.ORD_QTY <= S.QTY
    ) M
)
select substr(END_TIME,0,4) Y,to_char(to_date(END_TIME,'yyyymmdd hh24miss'),'mm"月"') work_date,GRP,ROUND(sum(cycle_time)/count(ORDER_ID),2) AVG_TIME from TMP
where GRP != ' '
  AND END_TIME >= '20180301'||'08'||'30'||'00'
  AND END_TIME < '20180628'||'08'||'30'||'00'
  group by substr(END_TIME,0,4),to_char(to_date(END_TIME,'yyyymmdd hh24miss'),'mm"月"'),GRP
order by Y,work_date
