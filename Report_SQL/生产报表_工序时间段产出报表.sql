WITH DG_PROD AS (
                    SELECT /*+INDEX(H CWIPLOTMVH_IDX_3)*/
                    (
                      CASE WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'080000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'100000' THEN '101 08：00~10：00'
                           WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'100000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'120000' THEN '102 10：00~12：00'
                           WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'120000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'140000' THEN '103 12：00~14：00'
                           WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'140000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'160000' THEN '104 14：00~16：00'
                           WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'160000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'180000' THEN '105 16：00~18：00'
                           WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'180000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'200000' THEN '106 18：00~20：00'
                           WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'200000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'220000' THEN '207 20：00~22：00'
                           WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'220000' AND H.TRAN_TIME < NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'000000' THEN '208 22：00~00：00'
                           WHEN H.TRAN_TIME >= NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'000000' AND H.TRAN_TIME < NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'020000' THEN '209 00：00~02：00'
                           WHEN H.TRAN_TIME >= NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'020000' AND H.TRAN_TIME < NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'040000' THEN '210 02：00~04：00'
                           WHEN H.TRAN_TIME >= NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'040000' AND H.TRAN_TIME < NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'060000' THEN '211 04：00~06：00'
                           WHEN H.TRAN_TIME >= NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'060000' AND H.TRAN_TIME < NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'080000' THEN '212 06：00~18：00'
                      END ) TIME_PERIOD,
                            A.DATA_2 AS AREA,
                            H.OLD_OPER AS OPER,
                            H.MAT_ID,
                            H.ORDER_ID,
                            COUNT(DISTINCT H.LOT_ID) AS PROD_QTY
                    FROM CWIPLOTMVH H
                    LEFT OUTER JOIN (SELECT * FROM  MGCMTBLDAT WHERE FACTORY = 'RCM1' AND TABLE_NAME = 'SUB_AREA' AND DATA_10 = 'DG') A
                      ON A.FACTORY = H.FACTORY AND A.KEY_1 = H.LINE_ID
                    WHERE H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'080000'
                      AND H.TRAN_TIME < NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'080000'
                      AND (CASE WHEN H.OLD_OPER = '120070' AND H.BOARD_SIDE IN ( 'S',' ') AND H.TRAN_CODE IN ('END', 'COLLECT_DFT')
                                    THEN 1
                                    WHEN H.OLD_OPER = '120070' AND H.BOARD_SIDE IN ( 'T','B') AND H.TRAN_CODE IN ('CREATE','END', 'COLLECT_DFT')
                                    THEN 1
                                    WHEN H.OLD_OPER <> '120070' AND H.TRAN_CODE IN ('END', 'COLLECT_DFT')  THEN 1
                                    ELSE 2
                              END )  = 1
                      AND H.FACTORY = 'RCM1'
                      AND H.HIST_DEL_FLAG = ' '
                      AND NVL(A.KEY_1,' ') != ' '
                      AND H.MAT_ID = NVL(TRIM(' '), H.MAT_ID)
                      AND H.ORDER_ID = NVL(TRIM('FKFB180612J'), H.ORDER_ID)
                      AND A.DATA_2 = 'DG-SSD'
                    GROUP BY (
                              CASE WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'080000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'100000' THEN '101 08：00~10：00'
                                   WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'100000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'120000' THEN '102 10：00~12：00'
                                   WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'120000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'140000' THEN '103 12：00~14：00'
                                   WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'140000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'160000' THEN '104 14：00~16：00'
                                   WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'160000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'180000' THEN '105 16：00~18：00'
                                   WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'180000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'200000' THEN '106 18：00~20：00'
                                   WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'200000' AND H.TRAN_TIME < NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'220000' THEN '207 20：00~22：00'
                                   WHEN H.TRAN_TIME >= NVL (TRIM ( '20180627' ), to_char(sysdate,'yyyymmdd'))||'220000' AND H.TRAN_TIME < NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'000000' THEN '208 22：00~00：00'
                                   WHEN H.TRAN_TIME >= NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'000000' AND H.TRAN_TIME < NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'020000' THEN '209 00：00~02：00'
                                   WHEN H.TRAN_TIME >= NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'020000' AND H.TRAN_TIME < NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'040000' THEN '210 02：00~04：00'
                                   WHEN H.TRAN_TIME >= NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'040000' AND H.TRAN_TIME < NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'060000' THEN '211 04：00~06：00'
                                   WHEN H.TRAN_TIME >= NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'060000' AND H.TRAN_TIME < NVL (to_char(to_date(TRIM ( '20180627' ),'yyyymmdd')+1,'yyyymmdd'),to_char(sysdate+1,'yyyymmdd'))||'080000' THEN '212 06：00~18：00'
                              END ),
                              A.DATA_2,
                              H.OLD_OPER,
                              H.MAT_ID,
                              H.ORDER_ID
                 )
SELECT  SUBSTR(P.TIME_PERIOD,1,1) AS SHIFT,
        SUBSTR(P.TIME_PERIOD,2,2) AS TIME_SEQ,
        SUBSTR(P.TIME_PERIOD,5,11) AS TIME_INT,
        P.AREA,
        P.OPER,
        O.OPER_DESC,
        P.MAT_ID,
        P.ORDER_ID,
        P.PROD_QTY
FROM    DG_PROD  P,
        MWIPOPRDEF O
WHERE O.FACTORY = 'RCM1'
  AND O.OPER =P.OPER
ORDER BY TIME_SEQ,
         P.AREA,
         P.OPER,
         P.MAT_ID
