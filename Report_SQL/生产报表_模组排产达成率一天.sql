WITH PCB_INFO AS (
      select (select DISTINCT DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = 'RCM1' AND KEY_1 = D.MAT_CMF_1) T_TYPE,
            (CASE WHEN H.CREATE_TIME >= SUBSTR(H.CREATE_TIME,0,8)||'080000' THEN TO_CHAR(to_date(H.CREATE_TIME,'YYYY-MM-DD HH24MISS'),'YYYYMMDD')
              ELSE TO_CHAR(to_date(H.CREATE_TIME,'YYYY-MM-DD HH24MISS') -1,'YYYYMMDD')
             END
            )
            WORK_DATE,
            H.PCBA_ID,
            H.AB_SUBFACE
      from CWIPVIPCBA H
        LEFT OUTER JOIN MWIPMATDEF D
          ON H.FACTORY = D.FACTORY    AND H.MAT_ID = D.MAT_ID
      where H.LINE_ID like '100%'
        AND H.FACTORY = NVL(trim('RCM1'),H.FACTORY)
        AND H.LINE_ID = '100050'
        AND H.ORDER_ID = NVL (TRIM (' '),H.ORDER_ID)
        AND D.MAT_CMF_1 IN(
          select DISTINCT KEY_1 from MGCMTBLDAT
          WHERE TABLE_NAME='PRODUCT_GRP'
            AND FACTORY = 'RCM1'
                 AND KEY_1 = '20'
                )
        AND H.CREATE_TIME >= '20180627' || '080000'
        AND H.CREATE_TIME <  TO_CHAR(TO_DATE('20180627','YYYYMMDD') + 1,'YYYYMMDD') || '080000'
    ),
  SMT_PROD_TEMP AS (
    select T_TYPE,WORK_DATE,sum(PROD_QTY) PROD_QTY from(
      select T_TYPE,WORK_DATE,sum(PROD_QTY)/2 PROD_QTY from(
        select T_TYPE,WORK_DATE,COUNT(distinct PCBA_ID) PROD_QTY from PCB_INFO
            where AB_SUBFACE = 'T'
              AND WORK_DATE >= '20180627'
              AND WORK_DATE <= TO_CHAR(TO_DATE('20180627','YYYYMMDD') + 1,'YYYYMMDD')
            group by T_TYPE,WORK_DATE
        union all
        select T_TYPE,WORK_DATE,COUNT(distinct PCBA_ID) PROD_QTY from PCB_INFO
            where AB_SUBFACE = 'B'
              AND WORK_DATE >= '20180627'
              AND WORK_DATE <= TO_CHAR(TO_DATE('20180627','YYYYMMDD') + 1,'YYYYMMDD')
            group by T_TYPE,WORK_DATE
        )
        group by T_TYPE,WORK_DATE
      union all
        select T_TYPE,WORK_DATE,COUNT(distinct PCBA_ID) PROD_QTY from PCB_INFO
            where AB_SUBFACE = 'S'
              AND WORK_DATE >= '20180627'
              AND WORK_DATE <= TO_CHAR(TO_DATE('20180627','YYYYMMDD') + 1,'YYYYMMDD')
            group by T_TYPE,WORK_DATE
      )
      group by T_TYPE,WORK_DATE
  ),
  SMT_PLAN_TEMP AS (
    select T_TYPE,WORK_DATE,SUM(PLAN_ORD_QTY) PLAN_QTY from(
      select (select DISTINCT DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = 'RCM1' AND KEY_1 = D.MAT_CMF_1) T_TYPE,
             P.WORK_DATE,
             P.PLAN_ORD_QTY
      from CWIPORDPLN P
        LEFT JOIN MWIPMATDEF D
          ON P.FACTORY = D.FACTORY    AND P.MAT_ID = D.MAT_ID
      where P.LINE_ID LIKE '100%'
        AND P.FACTORY = NVL(trim('RCM1'),P.FACTORY)
        AND P.LINE_ID = '100050'
        AND P.ORDER_ID = NVL (TRIM (' '),P.ORDER_ID)
        AND D.MAT_CMF_1 IN(
          select DISTINCT KEY_1 from MGCMTBLDAT
          WHERE TABLE_NAME='PRODUCT_GRP'
            AND FACTORY = 'RCM1'
                 AND KEY_1 = '20'
                )
        AND P.ORD_CMF_1 = 'SMT'
        AND P.DELETE_FLAG = ' '
        AND P.WORK_DATE >= '20180627'
        AND P.WORK_DATE <= TO_CHAR(TO_DATE('20180627','YYYYMMDD') + 1,'YYYYMMDD')
    )
    group by  T_TYPE,WORK_DATE
  ),
  HD_PROD_TEMP AS (
    select T_TYPE,WORK_DATE,COUNT(distinct LOT_ID) PROD_QTY from(
      select (select DISTINCT DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = 'RCM1' AND KEY_1 = D.MAT_CMF_1) T_TYPE,
            (CASE WHEN H.TRAN_TIME >= SUBSTR(H.TRAN_TIME,0,8)||'080000' THEN TO_CHAR(to_date(H.TRAN_TIME,'YYYY-MM-DD HH24MISS'),'YYYYMMDD')
              ELSE TO_CHAR(to_date(H.TRAN_TIME,'YYYY-MM-DD HH24MISS') -1,'YYYYMMDD')
             END
            )
            WORK_DATE,
            H.LOT_ID
      from CWIPLOTMVH H
        LEFT JOIN MWIPMATDEF D
          ON H.FACTORY = D.FACTORY    AND H.MAT_ID = D.MAT_ID
      where H.TRAN_TIME >= '20180627' || '080000'
        AND H.TRAN_TIME <  TO_CHAR(TO_DATE('20180627','YYYYMMDD') + 1,'YYYYMMDD')  || '080000'
        AND H.TRAN_CODE IN ( 'END','COLLECT_DFT')
        AND H.HIST_DEL_FLAG = ' '
        AND H.LINE_ID like '100%'
       and substr( H.order_id ,2,1)!='K'
        AND H.FACTORY = NVL(trim('RCM1'),H.FACTORY)
        AND H.LINE_ID = '100050'
        AND H.ORDER_ID = NVL (TRIM (' '),H.ORDER_ID)
        AND D.MAT_CMF_1 IN(
          select DISTINCT KEY_1 from MGCMTBLDAT
          WHERE TABLE_NAME='PRODUCT_GRP'
            AND FACTORY = 'RCM1'
                 AND KEY_1 = '20'
                )
        AND H.OLD_OPER = '180010'
        AND D.MAT_TYPE = (CASE WHEN H.MAT_ID IN ('1103-00036','1103-00046') THEN D.MAT_TYPE ELSE 'ZERT' END)
        )
    where WORK_DATE >= '20180627'
      AND WORK_DATE <= TO_CHAR(TO_DATE('20180627','YYYYMMDD') + 1,'YYYYMMDD')
    group by T_TYPE,WORK_DATE
  ),
    HD_PROD_TEMP_RE AS (
    select T_TYPE,WORK_DATE,COUNT(distinct LOT_ID) PROD_QTY from(
      select (select DISTINCT DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = 'RCM1' AND KEY_1 = D.MAT_CMF_1) T_TYPE,
            (CASE WHEN H.TRAN_TIME >= SUBSTR(H.TRAN_TIME,0,8)||'080000' THEN TO_CHAR(to_date(H.TRAN_TIME,'YYYY-MM-DD HH24MISS'),'YYYYMMDD')
              ELSE TO_CHAR(to_date(H.TRAN_TIME,'YYYY-MM-DD HH24MISS') -1,'YYYYMMDD')
             END
            )
            WORK_DATE,
            H.LOT_ID
      from CWIPLOTMVH H
        LEFT JOIN MWIPMATDEF D
          ON H.FACTORY = D.FACTORY    AND H.MAT_ID = D.MAT_ID
      where H.TRAN_TIME >= '20180627' || '080000'
        AND H.TRAN_TIME <  TO_CHAR(TO_DATE('20180627','YYYYMMDD') + 1,'YYYYMMDD')  || '080000'
        AND H.TRAN_CODE IN ( 'END','COLLECT_DFT')
        AND H.HIST_DEL_FLAG = ' '
        AND H.LINE_ID like '100%'
       and substr( H.order_id ,2,1)='K'
        AND H.FACTORY = NVL(trim('RCM1'),H.FACTORY)
        AND H.LINE_ID = '100050'
        AND H.ORDER_ID = NVL (TRIM (' '),H.ORDER_ID)
        AND D.MAT_CMF_1 IN(
          select DISTINCT KEY_1 from MGCMTBLDAT
          WHERE TABLE_NAME='PRODUCT_GRP'
            AND FACTORY = 'RCM1'
                 AND KEY_1 = '20'
                )
        AND H.OLD_OPER = '180010'
        AND D.MAT_TYPE = (CASE WHEN H.MAT_ID IN ('1103-00036','1103-00046') THEN D.MAT_TYPE ELSE 'ZERT' END)
        )
    where WORK_DATE >= '20180627'
      AND WORK_DATE <= TO_CHAR(TO_DATE('20180627','YYYYMMDD') + 1,'YYYYMMDD')
    group by T_TYPE,WORK_DATE
  ),
  HD_PLAN_TEMP AS (
    select T_TYPE,WORK_DATE,SUM(PLAN_ORD_QTY) PLAN_QTY from(
      select (select DISTINCT DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = 'RCM1' AND KEY_1 = D.MAT_CMF_1) T_TYPE,
             P.WORK_DATE,
             P.PLAN_ORD_QTY
      from CWIPORDPLN P
        LEFT JOIN MWIPMATDEF D
          ON P.FACTORY = D.FACTORY    AND P.MAT_ID = D.MAT_ID
       LEFT OUTER JOIN CWIPORDDEF E
         ON E.ORDER_ID = P.ORDER_ID AND E.PROD_ID = P.MAT_ID
        LEFT OUTER JOIN MGCMTBLDAT F
         ON F.TABLE_NAME = 'SUB_AREA' AND F.DATA_9 = E.CMF_5
      where F.DATA_8 = '东莞'      and  substr( P.order_id ,2,1)!='K'
        AND P.FACTORY = NVL(trim('RCM1'),P.FACTORY)
        AND F.KEY_1 = '100050'
        AND P.ORDER_ID = NVL (TRIM (' '),P.ORDER_ID)
        AND D.MAT_CMF_1 IN(
          select DISTINCT KEY_1 from MGCMTBLDAT
          WHERE TABLE_NAME='PRODUCT_GRP'
            AND FACTORY = 'RCM1'
                 AND KEY_1 = '20'
                )
        AND P.ORD_CMF_1 = 'PAK'
        AND P.DELETE_FLAG = ' '
        AND P.WORK_DATE >= '20180627'
    AND P.WORK_DATE <= TO_CHAR(TO_DATE('20180627','YYYYMMDD') + 1,'YYYYMMDD')
    )
    group by  T_TYPE,WORK_DATE
  ),
    HD_PLAN_TEMP_RE AS (
    select T_TYPE,WORK_DATE,SUM(PLAN_ORD_QTY) PLAN_QTY from(
      select (select DISTINCT DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = 'RCM1' AND KEY_1 = D.MAT_CMF_1) T_TYPE,
             P.WORK_DATE,
             P.PLAN_ORD_QTY
      from CWIPORDPLN P
        LEFT JOIN MWIPMATDEF D
          ON P.FACTORY = D.FACTORY    AND P.MAT_ID = D.MAT_ID
       LEFT OUTER JOIN CWIPORDDEF E
         ON E.ORDER_ID = P.ORDER_ID AND E.PROD_ID = P.MAT_ID
        LEFT OUTER JOIN MGCMTBLDAT F
         ON F.TABLE_NAME = 'SUB_AREA' AND F.DATA_9 = E.CMF_5
      where F.DATA_8 = '东莞'     and   substr( P.order_id ,2,1)='K'
        AND P.FACTORY = NVL(trim('RCM1'),P.FACTORY)
        AND F.KEY_1 = '100050'
        AND P.ORDER_ID = NVL (TRIM (' '),P.ORDER_ID)
        AND D.MAT_CMF_1 IN(
          select DISTINCT KEY_1 from MGCMTBLDAT
          WHERE TABLE_NAME='PRODUCT_GRP'
            AND FACTORY = 'RCM1'
                 AND KEY_1 = '20'
                )
        AND P.ORD_CMF_1 = 'PAK'
        AND P.DELETE_FLAG = ' '
        AND P.WORK_DATE >= '20180627'
    AND P.WORK_DATE <= TO_CHAR(TO_DATE('20180627','YYYYMMDD') + 1,'YYYYMMDD')
    )
    group by  T_TYPE,WORK_DATE
  ),
  DUE_TEMP AS (
    SELECT B.DATA_2 T_TYPE,A.WORK_DATE,0 PLAN_QTY,0 PROD_QTY,0 RATE FROM (
      SELECT TO_CHAR(TO_DATE('20180627', 'yyyy-MM-dd') + ROWNUM - 1, 'yyyyMMdd') WORK_DATE FROM DUAL
        CONNECT BY ROWNUM < trunc(to_date('20180627', 'yyyy-MM-dd') + 1-  to_date('20180627', 'yyyy-MM-dd')) + 1
      ) A ,(
      SELECT DISTINCT DATA_2 FROM MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP'
        AND FACTORY =  'RCM1'
        AND DATA_2 in('PC内存','SV内存','SDT代工','企业级SSD','消费级SSD','安全产品')
      ) B
  )
select SMT.Y,SMT.M,SMT.产品类型,SMT.日期,SMT.SMT计划排产,SMT.SMT实际产出,SMT.SMT达成率,HD.后段计划排产,HD.后段实际产出,HD.后段达成率,HD_RE.后段返工计划排产,HD_RE.后段返工实际产出,HD_RE.后段返工达成率 from
(select substr(W.WORK_DATE,0,4) Y,to_char(to_date(W.WORK_DATE,'yyyymmdd hh24miss'),'mm') M,W.T_TYPE 产品类型,to_char(to_date(W.WORK_DATE,'YYYY-MM-DD HH24MISS'),'YYYY-MM-DD') 日期,NVL(P.PLAN_QTY,0) SMT计划排产,NVL(D.PROD_QTY,0) SMT实际产出,TO_CHAR(ROUND(NVL(D.PROD_QTY,0)/decode(NVL(P.PLAN_QTY,0),0,null,P.PLAN_QTY),4)*100,'99990.99') ||'%' SMT达成率 from DUE_TEMP W
  left join SMT_PROD_TEMP D ON W.WORK_DATE = D.WORK_DATE AND W.T_TYPE = D.T_TYPE
  left join SMT_PLAN_TEMP P ON W.WORK_DATE = P.WORK_DATE AND W.T_TYPE = P.T_TYPE
union all
select substr(W.WORK_DATE,0,4) Y,to_char(to_date(W.WORK_DATE,'yyyymmdd hh24miss'),'mm') M,W.T_TYPE  产品类型,to_char(to_date(W.WORK_DATE,'yyyymmdd hh24miss'),'"全"mm"月"')||'汇总' 日期,NVL(SUM(P.PLAN_QTY),0) SMT计划排产,NVL(SUM(D.PROD_QTY),0) SMT实际产出,TO_CHAR(ROUND(NVL(SUM(D.PROD_QTY),0)/decode(NVL(SUM(P.PLAN_QTY),0),0,null,SUM(P.PLAN_QTY)),4)*100,'99990.99') ||'%' SMT达成率 from DUE_TEMP W
  left join SMT_PROD_TEMP D ON W.WORK_DATE = D.WORK_DATE AND W.T_TYPE = D.T_TYPE
  left join SMT_PLAN_TEMP P ON W.WORK_DATE = P.WORK_DATE AND W.T_TYPE = P.T_TYPE
  group by substr(W.WORK_DATE,0,4),to_char(to_date(W.WORK_DATE,'yyyymmdd hh24miss'),'mm'),W.T_TYPE,to_char(to_date(W.WORK_DATE,'yyyymmdd hh24miss'),'"全"mm"月"')||'汇总'
) SMT
left join
(
select substr(W1.WORK_DATE,0,4) Y,to_char(to_date(W1.WORK_DATE,'yyyymmdd hh24miss'),'mm') M,W1.T_TYPE 产品类型,to_char(to_date(W1.WORK_DATE,'YYYY-MM-DD HH24MISS'),'YYYY-MM-DD') 日期,NVL(P1.PLAN_QTY,0) 后段计划排产,NVL(D1.PROD_QTY,0) 后段实际产出,TO_CHAR(ROUND(NVL(D1.PROD_QTY,0)/decode(NVL(P1.PLAN_QTY,0),0,null,P1.PLAN_QTY),4)*100,'99990.99') ||'%' 后段达成率 from DUE_TEMP W1
  left join HD_PROD_TEMP D1 ON W1.WORK_DATE = D1.WORK_DATE AND W1.T_TYPE = D1.T_TYPE
  left join HD_PLAN_TEMP P1 ON W1.WORK_DATE = P1.WORK_DATE AND W1.T_TYPE = P1.T_TYPE
union all
select substr(W1.WORK_DATE,0,4) Y,to_char(to_date(W1.WORK_DATE,'yyyymmdd hh24miss'),'mm') M,W1.T_TYPE 产品类型,to_char(to_date(W1.WORK_DATE,'yyyymmdd hh24miss'),'"全"mm"月"')||'汇总' 日期,NVL(SUM(P1.PLAN_QTY),0) 后段计划排产,NVL(SUM(D1.PROD_QTY),0) 后段实际产出,TO_CHAR(ROUND(NVL(SUM(D1.PROD_QTY),0)/decode(NVL(SUM(P1.PLAN_QTY),0),0,null,SUM(P1.PLAN_QTY)),4)*100,'99990.99') ||'%' 后段达成率 from DUE_TEMP W1
  left join HD_PROD_TEMP D1 ON W1.WORK_DATE = D1.WORK_DATE AND W1.T_TYPE = D1.T_TYPE
  left join HD_PLAN_TEMP P1 ON W1.WORK_DATE = P1.WORK_DATE AND W1.T_TYPE = P1.T_TYPE
  group by substr(W1.WORK_DATE,0,4),to_char(to_date(W1.WORK_DATE,'yyyymmdd hh24miss'),'mm'),W1.T_TYPE,to_char(to_date(W1.WORK_DATE,'yyyymmdd hh24miss'),'"全"mm"月"')||'汇总'
)HD ON SMT.Y = HD.Y AND SMT.日期 = HD.日期 AND SMT.产品类型 = HD.产品类型
left join (
select substr(W1.WORK_DATE,0,4) Y,to_char(to_date(W1.WORK_DATE,'yyyymmdd hh24miss'),'mm') M,W1.T_TYPE 产品类型,to_char(to_date(W1.WORK_DATE,'YYYY-MM-DD HH24MISS'),'YYYY-MM-DD') 日期,NVL(P1.PLAN_QTY,0) 后段返工计划排产,NVL(D1.PROD_QTY,0) 后段返工实际产出,TO_CHAR(ROUND(NVL(D1.PROD_QTY,0)/decode(NVL(P1.PLAN_QTY,0),0,null,P1.PLAN_QTY),4)*100,'99990.99') ||'%' 后段返工达成率 from DUE_TEMP W1
  left join HD_PROD_TEMP_RE D1 ON W1.WORK_DATE = D1.WORK_DATE AND W1.T_TYPE = D1.T_TYPE
  left join HD_PLAN_TEMP_RE P1 ON W1.WORK_DATE = P1.WORK_DATE AND W1.T_TYPE = P1.T_TYPE
union all
select substr(W1.WORK_DATE,0,4) Y,to_char(to_date(W1.WORK_DATE,'yyyymmdd hh24miss'),'mm') M,W1.T_TYPE 产品类型,to_char(to_date(W1.WORK_DATE,'yyyymmdd hh24miss'),'"全"mm"月"')||'汇总' 日期,NVL(SUM(P1.PLAN_QTY),0) 后段返工计划排产,NVL(SUM(D1.PROD_QTY),0) 后段返工实际产出,TO_CHAR(ROUND(NVL(SUM(D1.PROD_QTY),0)/decode(NVL(SUM(P1.PLAN_QTY),0),0,null,SUM(P1.PLAN_QTY)),4)*100,'99990.99') ||'%' 后段返工达成率 from DUE_TEMP W1
  left join HD_PROD_TEMP_RE D1 ON W1.WORK_DATE = D1.WORK_DATE AND W1.T_TYPE = D1.T_TYPE
  left join HD_PLAN_TEMP_RE P1 ON W1.WORK_DATE = P1.WORK_DATE AND W1.T_TYPE = P1.T_TYPE
  group by substr(W1.WORK_DATE,0,4),to_char(to_date(W1.WORK_DATE,'yyyymmdd hh24miss'),'mm'),W1.T_TYPE,to_char(to_date(W1.WORK_DATE,'yyyymmdd hh24miss'),'"全"mm"月"')||'汇总'
) HD_RE
ON SMT.Y = HD_RE.Y AND SMT.日期 = HD_RE.日期 AND SMT.产品类型 = HD_RE.产品类型
order by 1,2,3,4
