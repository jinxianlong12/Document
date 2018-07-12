select 工单,
       产品组,
       成品编码,
       成品描述,
       客户,
       任务令,
       条码,
       状态,
       不良发现时间,
       T.FIND_USER ||'('||(select DISTINCT USER_DESC from MSECUSRDEF where USER_ID = T.FIND_USER) ||')'    AS 发现人,
       发现工序,
       不良代码,
       不良描述,
       不良数量,
       不良备注,
       测试首次Fail时间,
       维修申请时间,
       T.REP_APPLICANT ||'('||(select DISTINCT USER_DESC from MSECUSRDEF where USER_ID = T.REP_APPLICANT) ||')'    AS 维修申请人,
       维修接收时间,
       T.REP_RECEIVER ||'('||(select DISTINCT USER_DESC from MSECUSRDEF where USER_ID = T.REP_RECEIVER) ||')'    AS 维修接收人,
       维修缺陷类型,
       维修缺陷代码,
       维修缺陷描述,
       维修位置,
       维修点数,
       维修备注,
       T.REPAIR_USER_ID ||'('||(select DISTINCT USER_DESC from MSECUSRDEF where USER_ID = T.REPAIR_USER_ID) ||')'    AS 维修人,
       维修时间,
       转生产测试时间,
       T.PROD_RECEIVER ||'('||(select DISTINCT USER_DESC from MSECUSRDEF where USER_ID = T.PROD_RECEIVER) ||')'    AS 生产接收人,
       生产测试结果,
       T.FA_USER_ID ||'('||(select DISTINCT USER_DESC from MSECUSRDEF where USER_ID = T.FA_USER_ID) ||')'     AS FA处理人,
       FA处理时间,
       FA处理意见
from(
  select
  O.ORDER_ID                                             AS 工单,
  (select DISTINCT DATA_1
    from MGCMTBLDAT
    WHERE TABLE_NAME='PRODUCT_GRP'
    AND FACTORY = A.FACTORY
    AND KEY_1 = O.PRODUCT_GRP)                           AS  产品组,
  O.PROD_ID                                              AS  成品编码,
  O.PROD_DESC                                            AS  成品描述,
  O.CUST_SHORT_DESC                                      AS  客户,
  O.TASK_ORDER                                           AS  任务令,
  A.LOT_ID                                               AS 条码,
  H.LOT_CMF_2                                            AS 状态,
  A.Tran_Time                                            AS 不良发现时间,
  A.TRAN_USER_ID                                         AS FIND_USER,
  (SELECT OPER_DESC FROM MWIPOPRDEF
      WHERE OPER = A.OPER)                               AS 发现工序,
  A.DEFECT_CODE                                          AS 不良代码,
  (SELECT DISTINCT DATA_2
    FROM MGCMTBLDAT
    WHERE TABLE_NAME='OPER_DEFECT_CODE'
      AND FACTORY = 'RCM1'
      AND KEY_4 = A.DEFECT_CODE
      AND ROWNUM=1)                                      AS 不良描述,
  A.Defect_Qty                                           AS 不良数量,
  A.DEFECT_COMMENT                                       AS 不良备注,
  (select min(date_time)
    from cwiptstdat
  where TEST_RESULT = 'FAIL'
    and lot_id = A.LOT_ID
    and oper = A.OPER)                                   AS  测试首次Fail时间,
  A.HIST_SEQ,
  (SELECT TRAN_TIME FROM MWIPLOTHIS
    WHERE HIST_DEL_FLAG = ' '
      AND LOT_ID= A.LOT_ID
      AND OPER = A.OPER
      AND HIST_SEQ = (SELECT MIN(S.HIST_SEQ) FROM MWIPLOTHIS S
                      WHERE S.TRAN_CODE='HOLD' AND S.HOLD_CODE='REPAIR'
                        AND S.LOT_ID=A.LOT_ID AND S.OPER =A.OPER AND S.HIST_SEQ>=A.HIST_SEQ)
  )                                                    AS 维修申请时间,
  (SELECT DISTINCT TRAN_USER_ID FROM MWIPLOTHIS
    WHERE HIST_DEL_FLAG = ' '
      AND LOT_ID= A.LOT_ID
      AND OPER = A.OPER
      AND HIST_SEQ = (SELECT MIN(S.HIST_SEQ) FROM MWIPLOTHIS S
                      WHERE S.TRAN_CODE='HOLD' AND S.HOLD_CODE='REPAIR'
                        AND S.LOT_ID=A.LOT_ID AND S.OPER =A.OPER AND S.HIST_SEQ>=A.HIST_SEQ)
  )                                                    AS REP_APPLICANT,
  (SELECT TRAN_TIME FROM MWIPLOTHIS
    WHERE HIST_DEL_FLAG = ' '
      AND LOT_ID= A.LOT_ID
      AND OPER = A.OPER
      AND HIST_SEQ = (SELECT MIN(S.HIST_SEQ) FROM MWIPLOTHIS S
                      WHERE S.TRAN_CODE='RELEASE' AND S.REP_FLAG='Y'
                        AND S.LOT_ID=A.LOT_ID AND S.OPER =A.OPER AND S.HIST_SEQ>=A.HIST_SEQ)
  )                                                    AS 维修接收时间,
  (SELECT DISTINCT TRAN_USER_ID FROM MWIPLOTHIS
    WHERE HIST_DEL_FLAG = ' '
      AND LOT_ID= A.LOT_ID
      AND OPER = A.OPER
      AND HIST_SEQ = (SELECT MIN(S.HIST_SEQ) FROM MWIPLOTHIS S
                      WHERE S.TRAN_CODE='RELEASE' AND S.REP_FLAG='Y'
                        AND S.LOT_ID=A.LOT_ID AND S.OPER =A.OPER AND S.HIST_SEQ>=A.HIST_SEQ)
  )                                                    AS REP_RECEIVER,
  (SELECT DISTINCT DATA_1
    FROM MGCMTBLDAT
    WHERE TABLE_NAME='REP_DEFECT_TYPE'
    AND FACTORY =  'RCM1'
    AND KEY_1=L.REPAIR_TYPE
    AND ROWNUM=1)                                        AS  维修缺陷类型,
  L.REPAIR_CODE                                          AS  维修缺陷代码,
  (SELECT DISTINCT DATA_1
    FROM MGCMTBLDAT
    WHERE TABLE_NAME='REP_DEFECT_CODE'
    AND FACTORY =  'RCM1'
    AND KEY_1=L.REPAIR_CODE
    AND ROWNUM=1)                                        AS  维修缺陷描述,
  L.REPAIR_POSITION                                      AS  维修位置,
  L.REPAIR_QTY                                           AS  维修点数,
  L.REPAIR_COMMENT                                       AS  维修备注,
  L.REPAIR_USER_ID,
  L.REPAIR_TRAN_TIME                                     AS  维修时间,
  (SELECT TRAN_TIME FROM MWIPLOTHIS
    WHERE HIST_DEL_FLAG = ' '
      AND LOT_ID= A.LOT_ID
      AND HIST_SEQ = (SELECT MIN(S.HIST_SEQ) FROM MWIPLOTHIS S
                      WHERE S.TRAN_CODE='RELEASE' AND S.LOT_CMF_6='APPLY_RETURN'
                        AND S.LOT_ID=A.LOT_ID AND S.HIST_SEQ>=A.HIST_SEQ)
  )                                                    AS 转生产测试时间,
  (SELECT DISTINCT TRAN_USER_ID FROM MWIPLOTHIS
    WHERE HIST_DEL_FLAG = ' '
      AND LOT_ID= A.LOT_ID
      AND HIST_SEQ = (SELECT MIN(S.HIST_SEQ) FROM MWIPLOTHIS S
                      WHERE S.TRAN_CODE='RELEASE' AND S.LOT_CMF_6='APPLY_RETURN'
                        AND S.LOT_ID=A.LOT_ID AND S.HIST_SEQ>=A.HIST_SEQ)
  )                                                    AS PROD_RECEIVER,
  (SELECT LOT_CMF_10 FROM MWIPLOTHIS
    WHERE HIST_DEL_FLAG = ' '
      AND LOT_ID= A.LOT_ID
      AND HIST_SEQ = (SELECT MIN(S.HIST_SEQ) FROM MWIPLOTHIS S
                      WHERE S.TRAN_CODE='RELEASE' AND S.LOT_CMF_6='APPLY_RETURN'
                        AND S.LOT_ID=A.LOT_ID AND S.HIST_SEQ>=A.HIST_SEQ)
  )                                                    AS 生产测试结果,
  R.TRAN_USER_ID                                       AS FA_USER_ID,
  R.TRAN_TIME                                          AS FA处理时间,
  R.FA_REPORT_1|| CHR(13) ||R.FA_REPORT_2|| CHR(13) ||R.FA_REPORT_3 AS FA处理意见
  FROM MWIPLOTDFT A
    JOIN MWIPLOTHIS H ON A.LOT_ID = H.LOT_ID AND A.HIST_SEQ = H.HIST_SEQ AND H.HIST_DEL_FLAG = ' '
    JOIN CWIPORDDEF O ON H.ORDER_ID = O.ORDER_ID
    LEFT JOIN CWIPLOTREP L ON A.LOT_ID = L.LOT_ID AND A.OPER = L.CAUSE_OPER AND A.HIST_SEQ = L.CMF_4 AND A.FACTORY = L.FACTORY
    LEFT JOIN CWIPREPRPT R ON A.LOT_ID = R.LOT_ID AND A.HIST_SEQ = R.CMF_1  AND R.CMF_1 != ' '
  where A.factory = NVL(trim('RCM1'),A.FACTORY)
    AND A.tran_time >= '20180627'||'23'||'30'||'00'
    AND A.tran_time < '20180628'||'08'||'30'||'00'
    AND A.LOT_ID = NVL (TRIM (' '), A.LOT_ID)
    AND O.ORDER_ID = NVL (TRIM ('SFFB18060S6'),O.ORDER_ID)
) T
Where ROWNUM <=10000
