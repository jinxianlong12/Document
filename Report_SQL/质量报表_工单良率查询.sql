WITH ORDOK AS (
          SELECT
                   A.ORDER_ID,
                   A.OLD_OPER,
                   A.LINE_ID,
                   A.HIST_DEL_FLAG,
                   COUNT( DISTINCT A.LOT_ID) QTY
            FROM CWIPLOTMVH A
            WHERE A.TRAN_TIME >= '20180627'||'08'||'30'||'00' AND A.TRAN_TIME < '20180628'||'08'||'30'||'00'
                  AND A.TRAN_CODE IN( 'END','SKIP','COLLECT_DFT')
                  AND A.FACTORY =  NVL (TRIM ('RCM1'), A.FACTORY)
                  AND A.ORDER_ID = NVL (TRIM ('FBFB18060PC'), A.ORDER_ID)
                  AND A.OLD_OPER not in('170010','170020','170030','170040','170050')
            GROUP BY
                  A.ORDER_ID,
                   A.OLD_OPER,
                   A.LINE_ID,
                   A.HIST_DEL_FLAG
               ) ,
 ORDNG AS (
          SELECT
                  A.ORDER_ID,
                   A.OLD_OPER,
                   A.LINE_ID,
                   COUNT( DISTINCT A.LOT_ID) QTY
            FROM CWIPLOTMVH A
            WHERE A.TRAN_TIME >= '20180627'||'08'||'30'||'00' AND A.TRAN_TIME < '20180628'||'08'||'30'||'00'
                  AND A.TRAN_CODE='COLLECT_DFT'
                  AND A.FACTORY =  NVL (TRIM ('RCM1'), A.FACTORY)
                  AND A.STATUS='NG'
                  AND A.ORDER_ID = NVL (TRIM ('FBFB18060PC'), A.ORDER_ID)
                  AND A.OLD_OPER not in('170010','170020','170030','170040','170050')
            GROUP BY
                  A.ORDER_ID,
                   A.OLD_OPER,
                   A.LINE_ID
               )
SELECT
       Q5.DATA_8  工厂,
       Q6.DATA_1  产品组描述,
       Q6.DATA_2  产品组大类,
       Q7.MAT_CMF_5 产品系列,
       Q1.ORDER_ID  工单,
       Q4.PROD_ID 成品编码,
       Q4.PROD_DESC 成品描述,
       Q4.CUST_SHORT_DESC 客户,
       Q4.ORD_QTY 工单数量,
       Q4.TASK_ORDER 客户任务令,
       Q4.CUSTOMER_MAT_ID 客户料号,
       Q5.DATA_4  线别,
       Q3.OPER_SHORT_DESC 工序,
       Q3.OPER_DESC 工序说明,
       Q1.QTY 投入数,
       NVL(Q2.QTY,0) 不良数,
       DECODE(NVL(Q2.QTY,0),0,0,ROUND(Q2.QTY/Q1.QTY*1000000,0))     AS  不良率PPM,
       ROUND((NVL(Q1.QTY,0)-NVL(Q2.QTY,0))/NVL(Q1.QTY,1),4)*100 ||'%'    AS  "良率(%)",
       Q1.HIST_DEL_FLAG      AS 删除标记
  FROM ORDOK      Q1,
       ORDNG      Q2,
       MWIPOPRDEF Q3,
       CWIPORDDEF Q4,
       MGCMTBLDAT Q5,
       MGCMTBLDAT Q6,
       MWIPMATDEF Q7
 WHERE Q1.OLD_OPER = Q3.OPER
   AND Q1.ORDER_ID = Q4.ORDER_ID
   AND Q1.LINE_ID = Q5.KEY_1
   AND Q5.FACTORY =  NVL (TRIM ('RCM1'), Q5.FACTORY)
   AND Q5.TABLE_NAME = 'SUB_AREA'
   AND Q4.PRODUCT_GRP = Q6.KEY_1
   AND Q6.TABLE_NAME = 'PRODUCT_GRP'
   AND Q6.FACTORY =  NVL (TRIM ('RCM1'), Q6.FACTORY)
   AND Q7.MAT_ID=Q4.PROD_ID
   AND Q7.FACTORY =  NVL (TRIM ('RCM1'), Q7.FACTORY)
   AND Q7.MAT_ID =  NVL (TRIM (' '), Q7.MAT_ID)
   AND Q1.ORDER_ID = Q2.ORDER_ID(+)
   AND Q1.OLD_OPER = Q2.OLD_OPER(+)
   AND Q1.LINE_ID = Q2.LINE_ID(+)
   AND Q4.PRODUCT_GRP = NVL (TRIM ('20'), Q4.PRODUCT_GRP)
      AND Q5.DATA_8 = NVL (TRIM ('东莞'), Q5.DATA_8)
  ORDER BY Q1.ORDER_ID,Q1.OLD_OPER
