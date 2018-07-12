SELECT rownum rn9__, A.*  FROM ( SELECT 工单 AS 工单 , 物料编码 AS 物料编码 , 物料描述 AS 物料描述 , 任务工单 AS 任务工单 , 客户 AS 客户 , 客户描述 AS 客户描述 , 产线 AS 产线 , 工单状态 AS 工单状态 , 面 AS 面 , 工作日期 AS 工作日期 , 工单开始时间 AS 工单开始时间 , 工单结束时间 AS 工单结束时间 , 拼板数 AS 拼板数 , 工单数量 AS 工单数量 , SMT产出数量 AS SMT产出数量 , 后工序产出数量 AS 后工序产出数量
FROM (SELECT DEF.ORDER_ID AS 工单,
  DEF.PROD_ID AS 物料编码,
  DEF.PROD_DESC AS 物料描述,
  DEF.TASK_ORDER AS 任务工单,
  DEF.CUSTOMER_ID AS 客户,
  DEF.CUSTOMER_DESC AS 客户描述,
  NVL((CASE
    WHEN ORD.LINE_ID = ' ' THEN ' '
    ELSE (SELECT DAT.DATA_1 FROM MGCMTBLDAT DAT WHERE DAT.TABLE_NAME = 'SUB_AREA' AND DAT.FACTORY = ORD.FACTORY AND DAT.KEY_1 = ORD.LINE_ID)
  END), ' ') AS 产线,
  (CASE
    WHEN STS.ORD_STATUS_FLAG = ' ' THEN ' '
    ELSE (SELECT DAT.DATA_1 FROM MGCMTBLDAT DAT WHERE DAT.TABLE_NAME = 'ORDER_STATUS' AND DAT.FACTORY = STS.FACTORY AND DAT.KEY_1 = STS.ORD_STATUS_FLAG)
  END) AS 工单状态,
  NVL(ORD.SURFACE, ' ') AS 面,
  STS.WORK_DATE AS 工作日期,
  NVL(ORD.ORD_START_TIME, ' ') AS 工单开始时间,
  NVL(ORD.ORD_END_TIME, ' ') AS 工单结束时间,
  NVL(ORD.ORD_CMF_1, 0) AS 拼板数,
  STS.ORD_QTY AS 工单数量,
  NVL(ORD.SMT_OUT_QTY, 0) AS SMT产出数量,
  NVL(ORD.PAK_OUT_QTY, 0) AS 后工序产出数量
FROM CWIPORDDEF DEF, MWIPORDSTS STS, CWIPORDSTS ORD
WHERE DEF.FACTORY =  'RCM1'
AND DEF.FACTORY = ORD.FACTORY(+)
AND DEF.ORDER_ID = ORD.ORDER_ID(+)
AND DEF.FACTORY = STS.FACTORY
AND DEF.ORDER_ID = STS.ORDER_ID
AND DEF.FACTORY =  'RCM1'
AND (case
         when trim( '20180627' ) is null then
1
         when DEF.WORK_DATE >=  '20180627'   then
1
         else
0
       end) = 1
AND (case
         when trim( '20180628' ) is null then
1
         when DEF.WORK_DATE <=  '20180628'   then
1
         else
0
       end) = 1
AND  (case
         when trim( ' ' ) is null then
1
         when trim( ' ' ) = DEF.ORDER_ID then
1
         else
0
       end) = 1
AND  (case
         when trim( ' ' ) is null then
1
         when trim( ' ' ) = STS.ORD_STATUS_FLAG  then
1
         else
0
       end) = 1
ORDER BY STS.WORK_DATE DESC, STS.ORDER_ID) A
 ) A  WHERE ROWNUM < 10000
