SELECT
      A.PLANT AS 工厂,
      A.LINE AS 线体,
      A.DATA_1 AS 产品组,
      A.MAT_ID AS 产品编码,
      A.MAT_DESC AS 产品描述,
      DECODE(A.MAT_TYPE,'ZERT','成品','半成品') AS 类型,
      A.ORDER_ID AS 工单,
      A.TASK_ORDER AS 任务令,
      A.OPER,
      A.OPER_DESC AS 工序,
      COUNT(DISTINCT A.LOT_ID) AS 数量,
      A.BOARD_SIDE AS 面别,
      A.SHIFT AS 班次
FROM (
      SELECT
            E.DATA_8 AS PLANT,
            E.DATA_1 AS LINE,
            C.DATA_1,
            A.MAT_ID,
            B.MAT_DESC,
	    B.MAT_TYPE,
            A.ORDER_ID,
            A.TASK_ORDER,
            A.OLD_OPER OPER,
            D.OPER_DESC,
            A.LOT_ID,
            A.BOARD_SIDE,
            (CASE WHEN A.SHIFT_ID = '1' THEN '白班' ELSE '晚班' END) SHIFT
      FROM CWIPLOTMVH A
      LEFT OUTER JOIN (SELECT DISTINCT FACTORY,KEY_1,DATA_1,DATA_8 FROM MGCMTBLDAT WHERE TABLE_NAME = 'SUB_AREA') E
      ON E.FACTORY = A.FACTORY AND E.KEY_1 = A.LINE_ID
      LEFT OUTER JOIN MWIPOPRDEF D
      ON D.FACTORY = A.FACTORY
      AND D.OPER = A.OLD_OPER
      LEFT OUTER JOIN MWIPMATDEF B
      ON A.FACTORY = B.FACTORY
      AND A.MAT_ID = B.MAT_ID
      LEFT OUTER JOIN ( select DISTINCT FACTORY,KEY_1,DATA_1,DATA_2 from MGCMTBLDAT WHERE TABLE_NAME='PRODUCT_GRP' ) C
      ON C.FACTORY = B.FACTORY AND C.KEY_1 = B.MAT_CMF_1
      WHERE A.TRAN_TIME >= '20180627'||'08'||'30'||'00'
      AND A.TRAN_TIME < '20180628'||'08'||'30'||'00'
      AND A.FACTORY = NVL(trim('RCM1'),A.FACTORY)
      AND E.DATA_8 = '东莞'
      AND A.LINE_ID = '100050'
      AND B.MAT_TYPE = 'ZERT'
      AND A.ORDER_ID =  NVL (TRIM (' '), A.ORDER_ID)
               AND B.MAT_CMF_1 = '20'
      AND A.SHIFT_ID = NVL (TRIM (' '), A.SHIFT_ID)
      AND A.HIST_DEL_FLAG = ' '
      AND (CASE WHEN A.OLD_OPER = '120070' AND A.BOARD_SIDE IN ( 'S',' ') AND A.TRAN_CODE IN ('END', 'COLLECT_DFT')
                    THEN 1
                    WHEN A.OLD_OPER = '120070' AND A.BOARD_SIDE IN ( 'T','B') AND A.TRAN_CODE IN ('CREATE','END', 'COLLECT_DFT')
                    THEN 1
                    WHEN A.OLD_OPER <> '120070' AND A.TRAN_CODE IN ('END', 'COLLECT_DFT')  THEN 1
                    ELSE 2
              END )  = 1
      ) A
GROUP BY A.PLANT, A.LINE, A.DATA_1,A.MAT_ID, A.MAT_DESC, DECODE(A.MAT_TYPE,'ZERT','成品','半成品'),  A.ORDER_ID, A.TASK_ORDER, A.OPER,A.OPER_DESC, A.BOARD_SIDE, A.SHIFT
ORDER BY A.OPER
