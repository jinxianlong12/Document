SELECT * FROM (
SELECT '100010' AS LINE_ID, '10-01' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-02' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-03' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-04' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-05' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-06' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-07' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-08' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-09' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-10' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-11' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-12' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-13' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-14' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-15' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-16' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-17' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-18' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-19' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-20' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100010' AS LINE_ID, '10-21' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-01' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-02' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-03' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-04' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-05' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-06' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-07' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-08' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-09' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-10' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-11' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-12' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-13' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-14' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-15' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-16' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-17' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-18' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-19' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-20' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100050' AS LINE_ID, '10-21' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-01' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-02' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-03' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-04' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-05' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-06' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-07' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-08' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-09' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-10' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-11' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-12' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-13' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-14' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-15' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-16' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-17' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-18' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-19' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-20' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   
UNION ALL
SELECT '100300' AS LINE_ID, '10-21' AS WORK_DATE, A.PLAN_QTY AS PLAN_QTY, A.PROD_QTY AS PROD_QTY, ROUND((A.PROD_QTY/A.PLAN_QTY)*100,2) AS RATE FROM   
(SELECT ROUND(DBMS_RANDOM.VALUE(9000,10000),0) AS PLAN_QTY, ROUND(DBMS_RANDOM.VALUE(8000,9000),0) AS PROD_QTY FROM DUAL)A   

)WHERE LINE_ID=:LINE_ID