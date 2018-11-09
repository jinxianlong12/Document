SELECT
  nvl(A.wip_qty,0)*100/decode(A.plan_qty,0,1,A.plan_qty) as wip_rate,
  A.process_type AS process_type,
  A.po_type AS po_type,
  A.po_name AS po_name,
  A.po_status AS po_status,
  A.plan_qty AS plan_qty,
  A.actual_qty AS actual_qty,
  A.wip_qty AS wip_qty,
  A.plan_start AS plan_start,
  A.plan_end AS plan_end,
  A.prd_model AS prd_model,
  A.prd_no AS prd_no,
  A.prd_desc AS prd_desc,
  A.RN
FROM
  (  
SELECT
    po.ORDER_ITEM AS po_project,
    DECODE(po.PROCESS_TYPE,'L4FST','四级修','L4SND','次轮四级修','L5FST','五级修','L5SND','次轮五级修','') AS process_type,
    DECODE(po.ORDER_TYPE,'PP01','标准生产订单','ZS01','测试订单','') AS po_type,
    po.NAME AS po_name,
    DECODE(po.STATUS,'RELEASED','已发布','RUNNING','已开始','RECEIVED','已开始') AS po_status,
    po.PLAN_QTY AS plan_qty,
    po.ACTUAL_QTY AS actual_qty,
    po.INPUT_QTY-(po.ACTUAL_QTY) AS wip_qty,
    po.ACTUAL_STARTED_AT AS plan_start,
    po.ACTUAL_ENDED_AT AS plan_end,
    DECODE(po.PRODUCT_MODEL_ID,'CI','牵引变流器','APU','辅助变流器','APU3','辅助变流器3','MON','列车信息装置','ARF','ARF','HQ','换气装置','KV','20KVA变流器','') AS prd_model,
    mt.NAME AS prd_no,
    mt.DESCRIPTION AS prd_desc,
    ROWNUM RN
  FROM PRODUCT_ORDERS po
    LEFT OUTER JOIN MATERIALS mt
    ON po.MATERIAL_ID = mt.ID
  WHERE po.STATUS='RUNNING'


  ORDER BY po.PLAN_START 
)A
WHERE 1=1
