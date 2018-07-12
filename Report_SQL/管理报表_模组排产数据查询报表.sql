SELECT
      A.ORD_CMF_1       AS 段别,
      A.WORK_DATE       AS 生产日期,
      A.GRP             AS 产品组,
      A.PLANT           AS 工厂,
      A.ORDER_ID        AS 工单,
      A.TASK_ORDER      AS 任务令,
      A.LINE_ID         AS 线体,
      A.LINE_DESC       AS 线体描述,
      A.MAT_ID          AS 成品编码,
      A.MAT_DESC        AS 成品描述,
      A.CUSTOMER_NAME   AS 客户简称,
      A.START_TIME      AS 排产时间,
      A.END_TIME        AS 排产结束时间,
      A.PLAN_ORD_QTY    AS 排产数量,
      A.SEQ_NUM         AS 导入次数,
      A.CREATE_USER_ID  AS 导入人工号,
      A.USER_DESC       AS 导入人,
      A.CREATE_TIME     AS 导入时间,
      DECODE(A.DELETE_FLAG,' ','.','Y')     AS 删除标记,
      DELETE_TIME       AS 变更时间,
      DELETE_USER       AS 变更人
FROM
(
SELECT
      A.ORD_CMF_1,
      A.WORK_DATE,
      (select DISTINCT DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' AND FACTORY = 'RCM1' AND KEY_1 = D.MAT_CMF_1) AS GRP,
      DECODE(SUBSTR(A.LINE_ID,0,3),'100','东莞','200','惠阳',' ') AS PLANT,
      A.ORDER_ID        ,
      A.TASK_ORDER      ,
      A.LINE_ID         ,
      C.DATA_1 AS LINE_DESC,
      A.MAT_ID          ,
      A.MAT_DESC        ,
      A.CUSTOMER_NAME   ,
      A.START_TIME      ,
      A.END_TIME        ,
      A.PLAN_ORD_QTY    ,
      A.SEQ_NUM         ,
      A.CREATE_USER_ID  ,
      B.USER_DESC       ,
      A.CREATE_TIME     ,
      A.DELETE_FLAG     ,
      A.DELETE_TIME     ,
      DECODE(A.DELETE_USER_ID,B.USER_ID,B.USER_DESC,' ') DELETE_USER
FROM CWIPORDPLN A
LEFT OUTER JOIN MGCMTBLDAT C
ON C.FACTORY = A.FACTORY    AND C.KEY_1 = A.LINE_ID   AND C.TABLE_NAME = 'SUB_AREA'
LEFT OUTER JOIN MWIPMATDEF D
ON A.FACTORY = D.FACTORY    AND A.MAT_ID = D.MAT_ID
LEFT OUTER JOIN MSECUSRDEF B
ON A.FACTORY = B.FACTORY
AND B.USER_ID = A.CREATE_USER_ID
WHERE A.ORD_CMF_1 = 'SMT'
AND A.FACTORY = NVL(trim('RCM1'), A.FACTORY)
AND A.ORDER_ID = NVL (TRIM (' '),A.ORDER_ID)
AND A.CREATE_USER_ID = NVL(TRIM(' '),A.CREATE_USER_ID)
AND ((A.WORK_DATE >= '20180627'
AND A.WORK_DATE <= '20180628') OR A.WORK_DATE = ' ' )
ORDER BY DECODE(A.WORK_DATE,' ','99999999',A.WORK_DATE) DESC,A.CREATE_TIME DESC
) A
WHERE A.PLANT = NVL(TRIM(' '), A.PLANT)
