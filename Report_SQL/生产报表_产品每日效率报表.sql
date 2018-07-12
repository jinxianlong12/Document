SELECT T.MONTH,--当前月份
       T.WORK_DATE,--当前日期
       T.AREA,--车间
       T.MAT_ID,--物料编号
       T.PRODUCT_NAME,--产品名称
       T.PROD_QTY,--产品数量
       T.TOTAL_TIME,--投入工时(A)
       T.PROD_TIME,--产出工时(B)
       T.EXC_TIME,--间接/异常工时(C)
       T.ACT_TIME,--实做工时(D)
       TRUNC(DECODE((T.TOTAL_TIME - T.EXC_TIME),0,0,T.PROD_TIME / (T.TOTAL_TIME - T.EXC_TIME) * 100),2) DIR_EFF, --直接效率 (B/(A-C))) ,
       TRUNC(DECODE(T.TOTAL_TIME, 0, 0, T.PROD_TIME / T.TOTAL_TIME * 100),2) COM_EFF -- 综合效率(B/A)
  FROM (WITH A AS --正常工时
                (SELECT M.WORK_DATE,
                        M.AREA,
                        M.MAT_ID,
                        M.PRODUCT_NAME,
                        SUM(DECODE(M.PROD_QTY, ' ', 0, '-', 0, M.PROD_QTY)) AS PROD_QTY,
                        SUM(DECODE(M.ATT_TIME, ' ', 0, ATT_TIME)) AS ATT_TIME,
                        SUM(DECODE(M.PROD_TIME, ' ', 0, '-', 0, PROD_TIME)) AS PROD_TIME
                   FROM CWIPACTTME M
                  WHERE M.WORK_DATE = NVL(TRIM('20180621'),M.WORK_DATE)
                    AND M.DELETE_FLAG != 'Y'
                    AND M.ACT_TIME_TYPE = '1'
                    AND M.PRODUCT_GRP = '20'
                    AND M.MAT_ID = NVL(TRIM(' '),M.MAT_ID)
                    AND M.ORDER_ID = NVL(TRIM(' '),M.ORDER_ID)
                  GROUP BY M.WORK_DATE, M.AREA, M.MAT_ID, M.PRODUCT_NAME),
           B AS --间接/异常工时
                (SELECT M.WORK_DATE,
                        M.AREA,
                        M.MAT_ID,
                        M.PRODUCT_NAME,
                        SUM(DECODE(M.PROD_QTY, ' ', 0, '-', 0, M.PROD_QTY)) AS PROD_QTY,
                        SUM(DECODE(M.ATT_TIME, ' ', 0, '-', 0, ATT_TIME)) AS ATT_TIME,
                        SUM(DECODE(M.PROD_TIME, ' ', 0, PROD_TIME)) AS PROD_TIME
                   FROM CWIPACTTME M
                  WHERE M.WORK_DATE = NVL(TRIM('20180621'),M.WORK_DATE)
                    AND M.DELETE_FLAG != 'Y'
                    AND M.ACT_TIME_TYPE = '2'
                    AND M.PRODUCT_GRP = '20'
                    AND M.MAT_ID = NVL(TRIM(' '),M.MAT_ID)
                    AND M.ORDER_ID = NVL(TRIM(' '),M.ORDER_ID)
                  GROUP BY M.WORK_DATE, M.AREA, M.MAT_ID, M.PRODUCT_NAME),
           C AS --实做工时
                (SELECT M.WORK_DATE,
                        M.AREA,
                        M.MAT_ID,
                        M.PRODUCT_NAME,
                        SUM(DECODE(M.PROD_QTY, ' ', 0, '-', 0, M.PROD_QTY)) AS PROD_QTY,
                        SUM(DECODE(M.ATT_TIME, ' ', 0, ATT_TIME)) AS ATT_TIME,
                        SUM(DECODE(M.PROD_TIME, ' ', 0, '-', 0, PROD_TIME)) AS PROD_TIME
                   FROM CWIPACTTME M
                  WHERE M.WORK_DATE = NVL(TRIM('20180621'),M.WORK_DATE)
                    AND M.DELETE_FLAG != 'Y'
                    AND M.ACT_TIME_TYPE = '3'
                    AND M.PRODUCT_GRP = '20'
                    AND M.MAT_ID = NVL(TRIM(' '),M.MAT_ID)
                    AND M.ORDER_ID = NVL(TRIM(' '),M.ORDER_ID)
                  GROUP BY M.WORK_DATE, M.AREA, M.MAT_ID, M.PRODUCT_NAME)
         SELECT SUBSTR(A.WORK_DATE, 5, 2) MONTH,
                A.WORK_DATE,
                A.AREA,
                A.MAT_ID,
                A.PRODUCT_NAME,
                NVL(A.PROD_QTY, 0) + NVL(B.PROD_QTY, 0) + NVL(C.PROD_QTY, 0) AS PROD_QTY,
                NVL(A.ATT_TIME, 0) + NVL(B.ATT_TIME, 0) + NVL(C.ATT_TIME, 0) AS TOTAL_TIME, --投入工时
                NVL(A.PROD_TIME, 0) + NVL(C.ATT_TIME, 0) PROD_TIME, --产出工时 B
                NVL(B.ATT_TIME, 0) AS EXC_TIME, --间接/异常工时 C
                NVL(C.ATT_TIME, 0) ACT_TIME --实做工时 D
           FROM A, B, C
          WHERE A.WORK_DATE = B.WORK_DATE(+)
            AND A.AREA = B.AREA(+)
            AND A.MAT_ID = B.MAT_ID(+)
            AND A.WORK_DATE = C.WORK_DATE(+)
            AND A.AREA = C.AREA(+)
            AND A.MAT_ID = C.MAT_ID(+)) T
ORDER BY T.WORK_DATE ASC
