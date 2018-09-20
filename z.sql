SELECT
  substr((to_char(LOT1.DISCOVERY_TIME,'yyyy-mm-dd hh24:mi:ss.ff')),1,19) AS discovery_time,
  LOT1.LOT_ID AS lot_id,
  NVL(LOT1.DEFECT_CODE_C,'') AS defect_code_c,
  NVL(LOT1.DEFECT_CODE,'') AS defect_code,
  NVL(LOT1.DEFECT_LEVEL_C,'') AS defect_level_c,
  NVL(LOT1.DEFECT_LEVEL,'') AS defect_level,
  NVL(LOT1.DEFECT_TYPE_C,'') AS defect_type_c,
  NVL(LOT1.DEFECT_TYPE,'') AS defect_type,
  LOT1.COMMENTS AS comments,
  LOT1.PO_NAME AS po_name,
  LOT1.PO_DESC AS po_desc,
  LOT1.PO_PROJECT AS po_project,
  LOT1.PROCESS_TYPE AS process_type,
  LOT1.VEHICLE_NO AS vehicle_no,
  LOT1.PO_MODEL AS po_model,
  LOT1.SF_NAME AS shift_name,
  LOT1.CHECKER AS checker,
  LOT1.DISCOVERY_OPER AS discovery_oper,
  LOT2.RESPONSOR AS responsor,
  LOT2.RESP_OPER_ID AS resp_oper_id,
  LOT3.OPERATOR AS operator,
  LOT3.INTERACTOR AS interactor
FROM
(
WITH TEMP AS(
    SELECT
      po.NAME AS NAME,
      po.DESCRIPTION AS DESCRIPTION,
      po.ORDER_ITEM AS ORDER_ITEM,
      po.PROCESS_TYPE AS PROCESS_TYPE,
      po.VEHICLE_NO AS VEHICLE_NO,
      po.PRODUCT_MODEL_ID AS PRODUCT_MODEL_ID,
      wo.ID AS ID
    FROM WORK_ORDERS wo
      LEFT OUTER JOIN PRODUCT_ORDERS po
      ON wo.PRODUCT_ORDER_ID=po.ID
  ),
  SF AS(
    SELECT
      US.USER_ID,
      US.SHIFT_ID,
      SF.NAME
    FROM SHIFT_USERS US
      LEFT OUTER JOIN SHIFTS SF
      ON US.SHIFT_ID=SF.ID
  )
SELECT
  lot.CREATED_AT AS discovery_time,
  lot.LOT_ID AS lot_id,
	lot.EXAM_ITEM_ID,
  lot.REASON_1 AS defect_code_c,
  lot.REASON_1 AS defect_code,
  lot.REASON_2 AS defect_level_c,
  lot.REASON_2 AS defect_level,
  lot.REASON_3 AS defect_type_c,
  lot.REASON_3 AS defect_type,
  lot.COMMENTS AS comments,
  us.NAME AS checker,
  op.NAME AS discovery_oper,
  sf.NAME AS SF_NAME,
  po.NAME AS po_name,
  po.DESCRIPTION AS po_desc,
  po.ORDER_ITEM AS po_project,
  po.PROCESS_TYPE AS process_type,
  po.VEHICLE_NO AS vehicle_no,
  po.PRODUCT_MODEL_ID AS po_model
FROM LOT_TESTS lot
  LEFT OUTER JOIN TEMP po
  ON lot.WORK_ORDER_ID = po.ID
  LEFT OUTER JOIN OPERATIONS op
  ON lot.OPERATION_ID = op.ID
  LEFT OUTER JOIN SF sf
  ON lot.CREATOR_ID = sf.USER_ID
  LEFT OUTER JOIN USERS us
  ON lot.CREATOR_ID = us.ID
WHERE EXAM_RESULT=0
ORDER BY lot.LOT_ID
)LOT1 
LEFT OUTER JOIN
(
SELECT
  lot.LOT_ID,
  lot.INSPECTOR_ID,
  us.NAME AS responsor,
  op.NAME AS resp_oper_id
FROM LOT_DEFECTS lot
  LEFT OUTER JOIN OPERATIONS op
  ON lot.RESP_OPER_ID=op.ID
  LEFT OUTER JOIN USERS us
  ON lot.INSPECTOR_ID=us.ID
)
LOT2 ON LOT1.LOT_ID=LOT2.LOT_ID
LEFT OUTER JOIN
(
SELECT
  lot.EXAM_ITEM_ID,
	SUBSTR(
    (
		nvl(us1.NAME,CONCAT(',', us1.NAME)) ||
		nvl(us2.NAME,CONCAT(',', us2.NAME)) ||
		nvl(us3.NAME,CONCAT(',', us3.NAME)) ||
		nvl(us4.NAME,CONCAT(',', us4.NAME)) ||
		nvl(us5.NAME,CONCAT(',', us5.NAME))
		),2) AS operator,
  SUBSTR(
		(
    nvl(ins1.NAME,CONCAT(',', ins1.NAME)) ||
    nvl(ins2.NAME,CONCAT(',', ins2.NAME))
		),2) AS interactor
FROM LOT_TEST_APPLIES lot
LEFT OUTER JOIN USERS us1
  ON lot.OPERATOR1_ID=us1.ID
  LEFT OUTER JOIN USERS us2
  ON lot.OPERATOR2_ID=us2.ID
  LEFT OUTER JOIN USERS us3
  ON lot.OPERATOR3_ID=us3.ID
  LEFT OUTER JOIN USERS us4
  ON lot.OPERATOR4_ID=us4.ID
  LEFT OUTER JOIN USERS us5
  ON lot.OPERATOR5_ID=us5.ID
  LEFT OUTER JOIN USERS ins1
  ON lot.INTERACTOR1_ID=ins1.ID
  LEFT OUTER JOIN USERS ins2
  ON lot.INTERACTOR2_ID=ins2.ID
)
LOT3 ON LOT1.EXAM_ITEM_ID=LOT3.EXAM_ITEM_ID   