SELECT  distinct
E.DATA_8                                              AS     工厂,
K1.DATA_1                                             AS  产品组描述,
K1.DATA_2                                             AS  产品组大类,
K.MAT_CMF_5                                            AS   产品系列,
B.CMF_1                                                AS     工单,
C.PROD_ID                                              AS     成品编码,
C.PROD_DESC                                            AS     成品描述,
C.CUST_SHORT_DESC                                      AS   客户,
C.ORD_QTY                                              AS     工单数量,
C.TASK_ORDER                                        AS    客户任务令,
(CASE WHEN C.CUSTOMER_MAT_ID=' ' THEN K.MAT_CMF_12 ELSE C.CUSTOMER_MAT_ID END )AS 客户料号,
--A.Flow                                                 AS  工艺路线,
B1.DATA_1                                            　AS   班次,
E.DATA_1                                               AS 线别,
A.LOT_ID                                               AS     条码,
B.STATUS                                               AS 状态,
TO_CHAR(to_date(A.Tran_Time,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd hh24:mi:ss')       AS  不良发现时间,
A.TRAN_USER_ID ||'('|| A1.USER_DESC  || ')'            AS 　发现人,
D.OPER_SHORT_DESC                                      AS  发现工序,
--B2.DATA_1                                              AS  发现工位,
G.OPER_SHORT_DESC                                      AS  责任工序,
H.DATA_1                                               AS  责任工位_01,
B.Duty_User ||'('|| J.USER_DESC  || ')'                AS  责任人,
F2.DATA_1                                              AS 不良类型,
A.DEFECT_CODE                                          AS 不良代码,
F.DATA_2                                               AS 不良描述,
B.Defect_Location                                      AS 不良位置,
A.Defect_Qty                                           AS 不良数量,
A.DEFECT_COMMENT                                       AS 不良备注,
B.Board_Side                                           AS 不良面,
B.Mat_Vender                                           AS 料件厂家,
B.Cmf_2                                                AS 料件周期,
L.DEFECT_SUB_SN                                        AS  不良子板SN,
R1.DATA_1                                              AS  维修缺陷类型,
L.REPAIR_CODE                                          AS  维修缺陷代码,
M.DATA_1                                               AS  维修缺陷描述,
L.REPAIR_POSITION                                      AS  维修位置,
L.change_flag                                          AS  是否换料,
L.change_mat_id                                        AS  维修料号,
L.HAWEI_MAT_ID                                         AS  客户物料号,
L.PSN_09_NUM                                           AS  批次,
L.REPAIR_QTY                                           AS  维修点数,
L.REPAIR_COMMENT                                       AS  维修备注，
DECODE(L.REPAIR_USER_ID,'' ,'',L.REPAIR_USER_ID||'('|| R2.USER_DESC  || ')')           AS    维修人,
TO_CHAR(to_date(L.REPAIR_TRAN_TIME,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd hh24:mi:ss')       AS  维修时间
FROM MWIPLOTDFT A
JOIN MWIPLOTHIS HIS1 ON A.LOT_ID=HIS1.LOT_ID AND HIS1.HIST_SEQ=A.HIST_SEQ AND HIS1.HIST_DEL_FLAG=' '
JOIN MSECUSRDEF A1 ON A1.USER_ID=A.TRAN_USER_ID
JOIN CWIPDFTEXT B ON A.LOT_ID=B.LOT_ID AND A.SUBLOT_ID=B.SUBLOT_ID AND A.HIST_SEQ=B.HIST_SEQ AND A.SEQ_NUM=B.SEQ_NUM AND A.DEFECT_CODE=B.DEFECT_CODE
JOIN (SELECT DISTINCT KEY_1,DATA_1 FROM MGCMTBLDAT WHERE TABLE_NAME='SHIFT' AND FACTORY ='RCM1' ) B1 ON B1.KEY_1=B.SHIFT_ID
--JOIN(SELECT DISTINCT KEY_1,DATA_1 FROM MGCMTBLDAT WHERE TABLE_NAME='WORK_STATION' AND FACTORY = 'RCM1' ) B2 ON A.ATTACH_FILE_1=B2.KEY_1
JOIN CWIPORDDEF C ON B.CMF_1=C.ORDER_ID
LEFT JOIN ( select DISTINCT KEY_1,DATA_1,DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY =  'RCM1'  )  K1 ON K1.KEY_1=C.PRODUCT_GRP
JOIN MWIPOPRDEF D ON A.OPER=D.OPER
JOIN MGCMTBLDAT E ON B.LINE_ID=E.KEY_1 AND E.TABLE_NAME='SUB_AREA' AND E.FACTORY  = 'RCM1'
JOIN (SELECT DISTINCT KEY_1,key_2,key_3,KEY_4,DATA_2,OPER FROM MGCMTBLDAT DF1,MWIPOPRDEF DF2 WHERE DF1.FACTORY='RCM1' AND DF1.TABLE_NAME='OPER_DEFECT_CODE' AND DF1.FACTORY=DF2.FACTORY AND DF1.KEY_2=DF2.OPER_SHORT_DESC  ) F ON F.OPER=A.OPER AND F.KEY_3=B.DEFECT_TYPE AND F.KEY_4=B.DEFECT_CODE
LEFT JOIN (SELECT DISTINCT KEY_1,DATA_1 FROM MGCMTBLDAT WHERE TABLE_NAME='LOT_DEFECT_TYPE'AND FACTORY = 'RCM1' ) F2 ON F2.KEY_1=B.DEFECT_TYPE
JOIN MWIPOPRDEF G ON B.DUTY_OPER=G.OPER
LEFT JOIN (SELECT DISTINCT KEY_1,DATA_1 FROM MGCMTBLDAT WHERE TABLE_NAME='WORK_STATION' AND FACTORY = 'RCM1' ) H ON B.Duty_Station=H.KEY_1
JOIN MSECUSRDEF J ON J.USER_ID=B.Duty_User
JOIN (SELECT A.MAT_ID,A.MAT_CMF_1,B.DATA_2,MAT_CMF_5,MAT_CMF_12  FROM MWIPMATDEF A LEFT JOIN MGCMTBLDAT B ON B.TABLE_NAME='PRODUCT_GRP' AND B.KEY_1=A.MAT_CMF_1 AND A.FACTORY=B.FACTORY AND B.FACTORY = 'RCM1' ) K ON K.MAT_ID=A.MAT_ID
LEFT JOIN CWIPLOTREP L ON A.LOT_ID=L.LOT_ID AND A.OPER=L.CAUSE_OPER AND A.FACTORY=L.FACTORY --AND A.CLEAN_HIST_SEQ=L.HIST_SEQ
LEFT JOIN (SELECT DISTINCT KEY_1,DATA_1,KEY_3 FROM MGCMTBLDAT WHERE TABLE_NAME='REP_DEFECT_CODE'AND FACTORY =  'RCM1' ) M ON M.KEY_1=L.REPAIR_CODE  AND M.KEY_3=K.MAT_CMF_1
LEFT JOIN (SELECT DISTINCT KEY_1,DATA_1 FROM MGCMTBLDAT WHERE TABLE_NAME='REP_DEFECT_TYPE'AND FACTORY =  'RCM1' ) R1 ON R1.KEY_1=L.REPAIR_TYPE
LEFT JOIN MSECUSRDEF R2 ON R2.USER_ID=L.REPAIR_USER_ID
where A.factory = NVL(trim('RCM1'),A.FACTORY) AND A.RES_ID=' '
  AND A.tran_time >= '20180627'||'08'||'30'||'00'
  AND A.tran_time < '20180628'||'08'||'30'||'00'
  AND A.LOT_ID = NVL (TRIM (' '), A.LOT_ID)
  AND D.OPER_SHORT_DESC = NVL (TRIM (' '), D.OPER_SHORT_DESC)
  AND B.CMF_1 = NVL (TRIM ('MBFB18060VX'), B.CMF_1)
  AND E.DATA_8 = NVL (TRIM (' '), E.DATA_8)
  AND ROWNUM <=50000
