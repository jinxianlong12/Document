SELECT DISTINCT
  H.DATA_8                  AS 工厂,
  G.DATA_1                  AS 产品组,
  B.MAT_ID                  AS 成品编码,
  C.MAT_DESC                AS 产品描述,
  E.DATA_1                  AS 客户,
  B.ORD_QTY                 AS MO数量,
  D.ORD_INPUT_QTY           AS 投入数,
  D.CREATE_TIME             AS 投入时间,
  (SELECT QTY FROM CWIPHOVSTS WHERE FACTORY = A.FACTORY AND ORDER_ID = A.ORDER_ID AND OPER = '190010') AS 入库数,
  B.ORD_QTY       - B.ORD_OUT_QTY AS 工单差异数,
  D.ORD_INPUT_QTY - B.ORD_OUT_QTY AS 在制差异数,
  B.ORD_CMF_3 AS 任务令,
  A.*
FROM
  (SELECT *
  FROM
    (SELECT FACTORY,
      ORDER_ID,
      OPER,
      NVL(QTY, 0) AS QTY,
      (SELECT NVL(SUM(NVL(E.OUT_QTY, 0)), 0)
      FROM CWIPHOVREQ D,
        CWIPHOVOUT E
      WHERE D.FACTORY = E.FACTORY
      AND D.ORDER_ID  = E.ORDER_ID
      AND D.REQ_SEQ   = E.REQ_SEQ
      AND D.FACTORY   = A.FACTORY
      AND D.ORDER_ID  = A.ORDER_ID
      AND D.FROM_OPER = A.OPER
      AND REQ_CMF_1  <> 'Y'
      ) AS REQ_QTY
    FROM CWIPHOVSTS A
    ) PIVOT (SUM(QTY) AS "WIP数", SUM(REQ_QTY) AS "转出数" FOR OPER IN ('120010' "投板工序", '120020' "印刷", '120030' "SPI", '120040' "贴片", '120050' "炉前AOI", '120060' "炉后AOI", '120070' "炉后外观", '120080' "XRAY检测", '130010' "分板", '130020' "插件", '130040' "手工焊接", '140010' "ICT测试", '140020' "执锡外观", '140030' "装配1", '140040' "装配2", '140050' "改制装配01", '140060' "FT1功能测试", '140070' "高温老化", '140080' "FT2功能测试", '140090' "系统测试", '140100' "温循测试", '140160' "电性能测试01", '140180' "兼容性测试01", '140190' "兼容性测试02", '140260' "SPD测试", '140270' "Phison功能测试1", '140280' "Phison功能测试2", '140300' "回路测试", '140310' "加电目测", '140330' "半成品无平台测试", '140340' "半成品有平台测试01", '140360' "常温老化", '140370' "成品无平台测试", '140380' "成品有平台测试01", '150010' "成品外观", '160010' "FQA", '170010' "维修方法录入", '180010' "包装", '190010' "虚拟入库"))
  ) A,
  MWIPORDSTS B,
  MWIPMATDEF C,
  CWIPHOVSTS D,
  MGCMTBLDAT E,
  MGCMTBLDAT G,
  MGCMTBLDAT H
WHERE 1               =1
AND A.FACTORY         = B.FACTORY
AND A.ORDER_ID        = B.ORDER_ID
AND B.FACTORY         = C.FACTORY
AND B.MAT_ID          = C.MAT_ID
AND C.MAT_VER         = 1
AND B.FACTORY         = D.FACTORY
AND B.ORDER_ID        = D.ORDER_ID
AND D.FIRST_OPER_FLAG = 'Y'
AND C.FACTORY         = G.FACTORY(+)
AND C.MAT_CMF_1     = G.KEY_1(+)
AND G.TABLE_NAME(+)   = 'PRODUCT_GRP'
AND B.FACTORY         = E.FACTORY(+)
AND B.CUSTOMER_ID     = E.KEY_1(+)
AND E.TABLE_NAME(+)   = 'CUSTOMER_ID'
AND B.FACTORY         = H.FACTORY(+)
AND B.ORD_CMF_4         = H.KEY_1(+)
AND H.TABLE_NAME(+)   = 'SUB_AREA'
AND B.FACTORY         = 'RCM1'
AND B.ORDER_ID = NVL(TRIM(' '),B.ORDER_ID)
   AND B.ORD_STATUS_FLAG IN ('C','D')
AND B.MAT_ID = NVL(TRIM(' '),B.MAT_ID)
AND B.ORDER_ID NOT IN (SELECT ORDER_ID FROM CWIPMOCLOSE)
ORDER BY A.FACTORY,A.ORDER_ID
