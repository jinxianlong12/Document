SELECT
 D.DATA_8                            AS    工厂
,A.BATCH_ID                          AS    检验批次号
,A.ORDER_ID                          AS    工单
,A.MAT_ID                            AS    产品编码
,B.PROD_DESC                         AS    产品描述
,C.DATA_1                            AS    产品组
,C.DATA_2                            AS    产品大类
,D.DATA_1                            AS    产线
,TO_NUMBER(A.QTY_1,'99999999.09')               AS    批次数量
,TO_NUMBER(A.CHECK_QTY,'99999999.09')              AS    标准抽样数
,TO_NUMBER(A.NG_QTY + A.PASS_QTY,'99999999.09')    AS    实际抽样数
,TO_NUMBER(A.NG_QTY,'99999999.09')                 AS    不良数
,TO_NUMBER(A.PASS_QTY,'99999999.09')               AS    良品数																		
,TO_NUMBER(A.QTY_1 - (SELECT count(1) FROM CQCMBATLOT
    WHERE
        FACTORY = 'RCM1'
        AND BATCH_ID = A.BATCH_ID
        AND LOT_CMF_1 = 'REPAIR'),'99999999.09')   AS    可包装数量
,A.CREATE_USER_ID ||'('||(select DISTINCT USER_DESC from MSECUSRDEF where USER_ID = A.CREATE_USER_ID) ||')'     AS    送检人
,A.CREATE_TIME        AS    送检时间
,A.UPDATE_USER_ID ||'('||(select DISTINCT USER_DESC from MSECUSRDEF where USER_ID = A.UPDATE_USER_ID) ||')'      AS    检验人
,A.UPDATE_TIME        AS    抽检时间
,A.INSP_RESULT        AS    检验结果
FROM CQCMBATDTL A
JOIN CWIPORDDEF B ON A.ORDER_ID=B.ORDER_ID
JOIN ( select DISTINCT KEY_1,DATA_1,DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY =  'RCM1'  )  C ON C.KEY_1=B.PRODUCT_GRP
JOIN ( select DISTINCT KEY_1,DATA_1,DATA_8 from MGCMTBLDAT WHERE TABLE_NAME='SUB_AREA' AND FACTORY =  'RCM1'  ) D ON D.KEY_1=A.LINE_ID
where 1=1
  AND A.BAT_CMF_1 = ' '
  AND A.FACTORY = NVL(trim('RCM1'),A.FACTORY)
  AND B.PRODUCT_GRP = '20'
  AND A.LINE_ID = '100050'
  AND A.ORDER_ID = NVL (TRIM (' '),A.ORDER_ID)
  AND A.BATCH_ID = NVL(trim(' '),A.BATCH_ID)
  AND A.UPDATE_TIME >= '20180627'||'08'||'30'||'00'
  AND A.UPDATE_TIME < '20180628'||'08'||'30'||'00'
order by D.DATA_8
