SELECT C.RES_LINE_ID                                                                                     AS 线别 ,
  C.RES_ID                                                                                               AS 设备编号,
  M.LAST_DOWN_TIME                                                                                       AS 故障开始时间,
  C.REA_TYPE                                                                                             AS 故障类型,
  C.REA_DESC                                                                                             AS 故障类型描述,
  C.RES_REP_START_TIME                                                                                   AS 维修开始时间 ,
  C.RES_REP_END_TIME                                                                                     AS 维修结束时间 ,
  decode(C.RES_REP_END_TIME ,' ' ,' ' ,(to_date(C.RES_REP_END_TIME,'yyyyMMddHH24miss') - to_date(C.RES_REP_START_TIME,'yyyyMMddHH24miss'))*24)  AS 维修时长 ,
  C.CREATE_DATE                                                                                          AS 故障处理完成时间 ,
  '00'                                                                                                   AS 故障时长,
  '00'                                                                                                   AS 生产确认时间 ,
  '00'                                                                                                   AS 生产确认时长 ,
  C.REA_CODE                                                                                             AS 故障代码,
  C.FAULT_APPEARANCE                                                                                     AS 故障代码说明 ,
  C.REASON_ANALYSIS                                                                                      AS 原因分析 ,
  C.REPAIR_CONTENT                                                                                       AS 维修内容 ,
  C.REPAIR_RESULT                                                                                        AS 维修结果 ,
  C.MEASURE                                                                                              AS 预防措施 ,
  C.REPAIR_EXPERIENCE                                                                                    AS 维修体会,
  C.REPORTER                                                                                             AS 维修人,
  C.AUDITOR                                                                                              AS 审核人 ,
  C.CREATE_DATE                                                                                          AS 审核日期 ,
  M.TRAN_USER_ID
FROM CRASREAHIS C ,
  mrasreshis M
WHERE C.FACTORY = M.FACTORY
AND C.RES_ID    = M.RES_ID
AND C.HIST_SEQ  = M.HIST_SEQ
AND C.RES_ID    = NVL (TRIM ('X4I-FCM-001'),C.RES_ID)
  --AND C.REA_TYPE = 'CODE'
AND M.EVENT_ID = 'DOWN'
