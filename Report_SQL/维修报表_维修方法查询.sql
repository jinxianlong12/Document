SELECT rownum rn9__, A.*  FROM ( SELECT 产品 AS 产品 , 不良子项 AS 不良子项 , 产品编码 AS 产品编码 , 责任流程 AS 责任流程 , 责任工序 AS 责任工序 , 责任工位 AS 责任工位 , 维修类型 AS 维修类型 , 维修类型描述 AS 维修类型描述 , 维修代码 AS 维修代码 , 维修代码描述 AS 维修代码描述 , 位置号 AS 位置号 , 供应商编码 AS 供应商编码 , 供应商名称 AS 供应商名称 , 料件周期 AS 料件周期 , PSN AS PSN , 更换物料编码 AS 更换物料编码 , 华为物料编码 AS 华为物料编码 , 维修点数 AS 维修点数 , 维修人 AS 维修人
FROM (SELECT R.LOT_ID AS 产品,
  R.DEFECT_SUB_SN AS 不良子项,
  R.MAT_ID AS 产品编码,
  R.CAUSE_FLOW AS 责任流程,
  (R.CAUSE_OPER || O.OPER_DESC) AS 责任工序,
  R.CAUSE_STATION AS 责任工位,
  R.REPAIR_TYPE AS 维修类型,
  (CASE
    WHEN R.REPAIR_TYPE = ' ' THEN ' '
    ELSE NVL((SELECT DAT.DATA_1 FROM MGCMTBLDAT DAT WHERE DAT.TABLE_NAME = 'REP_DEFECT_TYPE' AND DAT.FACTORY = R.FACTORY AND DAT.KEY_1 = R.REPAIR_TYPE AND DAT.KEY_2 = M.MAT_CMF_1), ' ')
  END)  AS 维修类型描述 ,
  R.REPAIR_CODE AS 维修代码,
  (CASE
    WHEN R.REPAIR_CODE = ' ' THEN ' '
    ELSE NVL((SELECT DAT.DATA_1 FROM MGCMTBLDAT DAT WHERE DAT.TABLE_NAME = 'REP_DEFECT_CODE' AND DAT.FACTORY = R.FACTORY AND DAT.KEY_1 = R.REPAIR_CODE AND DAT.KEY_2 = R.REPAIR_TYPE AND DAT.KEY_3 = M.MAT_CMF_1), ' ')
  END) AS 维修代码描述,
  R.REPAIR_POSITION AS 位置号,
  R.VENDOR_ID AS 供应商编码,
  (CASE
    WHEN R.VENDOR_ID = ' ' THEN ' '
    ELSE NVL((SELECT DAT.DATA_1 FROM MGCMLAGDAT DAT WHERE DAT.TABLE_NAME = 'VENDOR_CODE' AND DAT.FACTORY = R.FACTORY AND DAT.KEY_1 = R.VENDOR_ID), ' ')
  END)  AS 供应商名称,
  R.MAT_CYCLE AS 料件周期,
  R.PSN_09_NUM AS PSN,
  R.CHANGE_MAT_ID AS 更换物料编码,
  R.HAWEI_MAT_ID AS 华为物料编码,
  R.REPAIR_COUNT AS 维修点数,
  R.REPAIR_USER_ID ||  S.USER_DESC as 维修人
FROM CWIPLOTREP R, MWIPOPRDEF O, MWIPMATDEF M, MSECUSRDEF S
WHERE R.FACTORY =  'RCM1'
AND R.FACTORY = O.FACTORY(+)
AND R.CAUSE_OPER = O.OPER(+)
AND R.FACTORY = M.FACTORY
AND R.MAT_ID = M.MAT_ID
AND R.MAT_VER = M.MAT_VER
AND R.FACTORY = S.FACTORY
AND R.REPAIR_USER_ID = S.USER_ID
AND
       (CASE
         WHEN trim( ' ' ) IS NULL THEN
1
         WHEN trim( ' ' ) = R.LOT_ID THEN
1
         ELSE
0
       END) = 1
AND (case
         when trim( '20180627' ) is null then
1
         when R.REPAIR_TRAN_TIME>=  '20180627'  ||  ' '  ||  '30'  || '00' then
1
         else
0
       end) = 1
AND (case
         when trim( '20180628' ) is null then
1
         when R.REPAIR_TRAN_TIME <  '20180628'  ||  '08'  ||  '30'  || '00' then
1
         else
0
       end) = 1
ORDER BY REPAIR_TRAN_TIME ASC) A
 ) A  WHERE ROWNUM < 10000
