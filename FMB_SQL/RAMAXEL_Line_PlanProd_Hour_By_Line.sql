WITH A AS
  (SELECT *
  FROM
    (SELECT TO_CHAR(to_date('20171026', 'yyyy-mm-dd hh24:mi:ss') + (rownum - 1) / 24, 'hh24') WORK_DATE ,
      ' ' AS LINE_ID,
      00  AS PLAN_ORD_QTY,
      00 ACT_TRAN_QTY,
      00         AS RATE ,
      '20171026' AS E_DAY
    FROM dual
      CONNECT BY rownum <= 8
    UNION ALL
    SELECT *
    FROM
      (SELECT TO_CHAR(to_date('20171025', 'yyyy-mm-dd hh24:mi:ss') + (rownum - 1) / 24, 'hh24') WORK_DATE ,
        ' ' AS LINE_ID,
        00  AS PLAN_ORD_QTY,
        00 ACT_TRAN_QTY,
        00         AS RATE ,
        '20171025' AS E_DAY
      FROM dual
        CONNECT BY rownum <= 24
      )
    WHERE WORK_DATE > '07'
    )
  ORDER BY E_DAY ,
    WORK_DATE
  ),
  B AS
  (SELECT S.TRAN_HOUR WORK_DATE ,
    S.SUB_AREA AS LINE_ID,
    ' '        AS PLAN_ORD_QTY,
    TRUNC(SUM(S.TRAN_COUNT)) ACT_TRAN_QTY,
    80          AS RATE ,
    S.WORK_DATE AS E_DAY
  FROM cwipprdsum S
  WHERE S.OPER    = '120070'
  AND S.FACTORY   = 'RCM1'
  AND S.WORK_DATE = (select decode(sign(to_char(sysdate,'hh24miss')-080000),1,TO_CHAR(sysdate,'yyyymmdd'),TO_CHAR(trunc(sysdate, 'dd') - 1,'yyyymmdd')) from DUAL )
  AND S.SUB_AREA  = :LINE_ID
  GROUP BY S.TRAN_HOUR,
    S.SUB_AREA ,
    S.WORK_DATE
  ORDER BY S.TRAN_HOUR
  ),
  C AS
  (SELECT P.WORK_DATE ,
    P.LINE_ID,
    TRUNC(SUM(PLAN_ORD_QTY)/23) PLAN_ORD_QTY ,
    00 ACT_TRAN_QTY,
    00          AS RATE ,
    P.WORK_DATE AS E_DAY
  FROM cwipordpln P
  WHERE
      P.ORD_CMF_1  = 'SMT'
  AND P.WORK_DATE  = (select decode(sign(to_char(sysdate,'hh24miss')-080000),1,TO_CHAR(sysdate,'yyyymmdd'),TO_CHAR(trunc(sysdate, 'dd') - 1,'yyyymmdd')) from DUAL )
  AND P.FACTORY    = 'RCM1'
  AND P.LINE_ID      = :LINE_ID
  GROUP BY P.WORK_DATE ,
    P.LINE_ID
  )
SELECT A.WORK_DATE ,
  B.LINE_ID,
  C.PLAN_ORD_QTY,
  B.ACT_TRAN_QTY,
  TRUNC((B.ACT_TRAN_QTY /C.PLAN_ORD_QTY)*100,3) AS RATE
FROM A ,
  B ,
  C
WHERE A.WORK_DATE = B.WORK_DATE(+)
AND B.E_DAY       = C.E_DAY(+)
