SELECT * FROM
(
    WITH A AS
(
      SELECT E.WORK_DATE,F.LINE_ID
    FROM
      (SELECT TO_CHAR(FDATE,'yyyymmdd') AS WORK_DATE
      FROM
        (SELECT TRUNC(SYSDATE, 'MONTH') + LEVEL - 1 AS FDATE
        FROM DUAL
          CONNECT BY LEVEL <= 31
        ) T
      WHERE TO_CHAR(FDATE, 'MM') = TO_CHAR(SYSDATE, 'MM')
      ) E ,
      (SELECT key_1 LINE_ID,
        TO_CHAR(sysdate,'yyyymm') WORK_DATE
      FROM mgcmtbldat
      WHERE FACTORY  = 'RCM1'
      AND TABLE_NAME = 'SUB_AREA'
      )F
    WHERE SUBSTR(E.WORK_DATE,0,6) = F.WORK_DATE
),
B AS
(
  SELECT WORK_DATE ,   LINE_ID,
    SUM(PLAN_ORD_QTY) PLAN_ORD_QTY
  FROM cwipordpln
  WHERE ORD_CMF_1 = 'SMT'
  AND DELETE_FLAG = ' '
  AND WORK_DATE   >= TO_CHAR(TRUNC(add_months(last_day(sysdate), -1) + 1), 'yyyymmdd')
  GROUP BY WORK_DATE  ,LINE_ID
),
 C AS
(
 SELECT WORK_DATE , SUB_AREA LINE_ID ,SUM(TRAN_COUNT) ACT_TRAN_QTY  FROM cwipprdsum  WHERE
  OPER = '120070'
  AND WORK_DATE   >= TO_CHAR(TRUNC(add_months(last_day(sysdate), -1) + 1), 'yyyymmdd')
   GROUP BY WORK_DATE ,SUB_AREA
)
SELECT substr(A.WORK_DATE,7,2) WORK_DATE,  A.LINE_ID , B.PLAN_ORD_QTY,C.ACT_TRAN_QTY , trunc (C.ACT_TRAN_QTY /B.PLAN_ORD_QTY ,2) AS RATE  FROM A,B,C WHERE
A.WORK_DATE = B.WORK_DATE(+)
AND A.WORK_DATE = C.WORK_DATE (+)
AND A.LINE_ID = B.LINE_ID(+)
AND A.LINE_ID = C.LINE_ID(+)
ORDER BY A.WORK_DATE ,A.LINE_ID
)
WHERE LINE_ID = :LINE_ID
