select a.order_id as 工单,
       (SELECT DATA_1 FROM MGCMTBLDAT WHERE FACTORY = a.FACTORY AND TABLE_NAME='PRODUCT_GRP' AND KEY_1=b.product_grp AND ROWNUM=1) AS 产品组,
       b.prod_id AS 成品编码,
       b.prod_desc AS 产品描述,
       (req_user_id || '(' || (SELECT distinct USER_DESC FROM MSECUSRDEF WHERE USER_ID=A.req_user_id AND Factory=a.FACTORY ) || ')') as 申请人,
       (select distinct DATA_1 from mgcmtbldat where rownum=1 AND factory=a.FACTORY AND table_name='SHIFT' AND KEY_1=a.SHIFT) as 班次,
       (select TO_CHAR(to_date(a.req_time,'yyyy-mm-dd,hh24:mi:ss'), 'YYYY-MM-DD HH24:MI:SS') from dual) as 申请时间,
       (SELECT distinct OPER_DESC FROM MWIPOPRDEF WHERE OPER = a.from_oper AND factory=a.FACTORY AND ROWNUM=1) as 转出工序,
       req_qty 申请数量,
       (SELECT distinct OPER_DESC FROM MWIPOPRDEF WHERE OPER = a.to_oper AND factory=a.FACTORY AND ROWNUM=1) as  转入工序,
       (CASE WHEN A.REQ_STATUS='CONFIRM' THEN (C.OUT_USER_ID || '(' ||
        (SELECT distinct USER_DESC
                     FROM MSECUSRDEF
                    WHERE USER_ID = C.OUT_USER_ID
                        AND FACTORY = a.FACTORY) || ')') ELSE '' END) AS 接收人,
       TO_CHAR(TO_DATE(C.OUT_TIME, 'yyyy-mm-dd,hh24:mi:ss'),'YYYY-MM-DD HH24:MI:SS') AS 接收时间,
       c.out_qty as 确认数量,
       (SELECT distinct aa.data_1 FROM mgcmtbldat aa WHERE aa.table_name='HANDOVER_STATUS' AND aa.KEY_1=a.req_status) 交接状态,
       req_comment as 备注
  from cwiphovreq a LEFT JOIN cwiporddef b ON a.order_id = b.order_id
      LEFT JOIN CWIPHOVOUT c ON a.order_id = c.order_id AND a.req_seq = c.req_seq
      WHERE A.FACTORY = NVL (TRIM (' '), A.FACTORY)
      AND UPPER(A.ORDER_ID) = UPPER(NVL (TRIM (' '), A.ORDER_ID))
      AND A.SHIFT = NVL (TRIM (' '), A.SHIFT)
      AND A.REQ_TIME >= '20180627'||'08'||'30'||'00'
      AND A.REQ_TIME < '20180628'||'08'||'30'||'00'
AND ROWNUM <= 50000
      --AND B.PRODUCT_GRP = NVL (TRIM (' '), B.PRODUCT_GRP)
      order by a.req_time DESC,a.order_id DESC,a.req_seq DESC
