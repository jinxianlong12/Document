SELECT rownum rn9__, A.*  FROM ( SELECT FACTORY AS FACTORY , RES_ID AS RES_ID , LINE_ID AS LINE_ID , ORDER_ID AS ORDER_ID , LANE_ID AS LANE_ID , PROGRAM_NAME AS PROGRAM_NAME , CONVEYER_BELT AS CONVEYER_BELT , N2_AIR AS N2_AIR , ZONE_1_TOP_ST AS ZONE_1_TOP_ST , ZONE_1_TOP_CT AS ZONE_1_TOP_CT , ZONE_1_BOTTOM_ST AS ZONE_1_BOTTOM_ST , ZONE_1_BOTTOM_CT AS ZONE_1_BOTTOM_CT , ZONE_2_TOP_ST AS ZONE_2_TOP_ST , ZONE_2_TOP_CT AS ZONE_2_TOP_CT , ZONE_2_BOTTOM_ST AS ZONE_2_BOTTOM_ST , ZONE_2_BOTTOM_CT AS ZONE_2_BOTTOM_CT , ZONE_3_TOP_ST AS ZONE_3_TOP_ST , ZONE_3_TOP_CT AS ZONE_3_TOP_CT , ZONE_3_BOTTOM_ST AS ZONE_3_BOTTOM_ST , ZONE_3_BOTTOM_CT AS ZONE_3_BOTTOM_CT , ZONE_4_TOP_ST AS ZONE_4_TOP_ST , ZONE_4_TOP_CT AS ZONE_4_TOP_CT , ZONE_4_BOTTOM_ST AS ZONE_4_BOTTOM_ST , ZONE_4_BOTTOM_CT AS ZONE_4_BOTTOM_CT , ZONE_5_TOP_ST AS ZONE_5_TOP_ST , ZONE_5_TOP_CT AS ZONE_5_TOP_CT , ZONE_5_BOTTOM_ST AS ZONE_5_BOTTOM_ST , ZONE_5_BOTTOM_CT AS ZONE_5_BOTTOM_CT , ZONE_6_TOP_ST AS ZONE_6_TOP_ST , ZONE_6_TOP_CT AS ZONE_6_TOP_CT , ZONE_6_BOTTOM_ST AS ZONE_6_BOTTOM_ST , ZONE_6_BOTTOM_CT AS ZONE_6_BOTTOM_CT , ZONE_7_TOP_ST AS ZONE_7_TOP_ST , ZONE_7_TOP_CT AS ZONE_7_TOP_CT , ZONE_7_BOTTOM_ST AS ZONE_7_BOTTOM_ST , ZONE_7_BOTTOM_CT AS ZONE_7_BOTTOM_CT , ZONE_8_TOP_ST AS ZONE_8_TOP_ST , ZONE_8_TOP_CT AS ZONE_8_TOP_CT , ZONE_8_BOTTOM_ST AS ZONE_8_BOTTOM_ST , ZONE_8_BOTTOM_CT AS ZONE_8_BOTTOM_CT , ZONE_9_TOP_ST AS ZONE_9_TOP_ST , ZONE_9_TOP_CT AS ZONE_9_TOP_CT , ZONE_9_BOTTOM_ST AS ZONE_9_BOTTOM_ST , ZONE_9_BOTTOM_CT AS ZONE_9_BOTTOM_CT , ZONE_10_TOP_ST AS ZONE_10_TOP_ST , ZONE_10_TOP_CT AS ZONE_10_TOP_CT , ZONE_10_BOTTOM_ST AS ZONE_10_BOTTOM_ST , ZONE_10_BOTTOM_CT AS ZONE_10_BOTTOM_CT , ZONE_11_TOP_ST AS ZONE_11_TOP_ST , ZONE_11_TOP_CT AS ZONE_11_TOP_CT , ZONE_11_BOTTOM_ST AS ZONE_11_BOTTOM_ST , ZONE_11_BOTTOM_CT AS ZONE_11_BOTTOM_CT , ZONE_12_TOP_ST AS ZONE_12_TOP_ST , ZONE_12_TOP_CT AS ZONE_12_TOP_CT , ZONE_12_BOTTOM_ST AS ZONE_12_BOTTOM_ST , ZONE_12_BOTTOM_CT AS ZONE_12_BOTTOM_CT , COOLING_ZONE_1_ST AS COOLING_ZONE_1_ST , COOLING_ZONE_1_CT AS COOLING_ZONE_1_CT , MES_IF AS MES_IF , MES_IF_TIME AS MES_IF_TIME , RET_TIME AS RET_TIME
FROM (SELECT
   FACTORY,
   RES_ID,
   LINE_ID,
   ORDER_ID,
   LANE_ID,
   PROGRAM_NAME,
   CONVEYER_BELT,
   N2_AIR,
   ZONE_1_TOP_ST,
   ZONE_1_TOP_CT,
   ZONE_1_BOTTOM_ST,
   ZONE_1_BOTTOM_CT,
   ZONE_2_TOP_ST,
   ZONE_2_TOP_CT,
   ZONE_2_BOTTOM_ST,
   ZONE_2_BOTTOM_CT,
   ZONE_3_TOP_ST,
   ZONE_3_TOP_CT,
   ZONE_3_BOTTOM_ST,
   ZONE_3_BOTTOM_CT,
   ZONE_4_TOP_ST,
   ZONE_4_TOP_CT,
   ZONE_4_BOTTOM_ST,
   ZONE_4_BOTTOM_CT,
   ZONE_5_TOP_ST,
   ZONE_5_TOP_CT,
   ZONE_5_BOTTOM_ST,
   ZONE_5_BOTTOM_CT,
   ZONE_6_TOP_ST,
   ZONE_6_TOP_CT,
   ZONE_6_BOTTOM_ST,
   ZONE_6_BOTTOM_CT,
   ZONE_7_TOP_ST,
   ZONE_7_TOP_CT,
   ZONE_7_BOTTOM_ST,
   ZONE_7_BOTTOM_CT,
   ZONE_8_TOP_ST,
   ZONE_8_TOP_CT,
   ZONE_8_BOTTOM_ST,
   ZONE_8_BOTTOM_CT,
   ZONE_9_TOP_ST,
   ZONE_9_TOP_CT,
   ZONE_9_BOTTOM_ST,
   ZONE_9_BOTTOM_CT,
   ZONE_10_TOP_ST,
   ZONE_10_TOP_CT,
   ZONE_10_BOTTOM_ST,
   ZONE_10_BOTTOM_CT,
   ZONE_11_TOP_ST,
   ZONE_11_TOP_CT,
   ZONE_11_BOTTOM_ST,
   ZONE_11_BOTTOM_CT,
   ZONE_12_TOP_ST,
   ZONE_12_TOP_CT,
   ZONE_12_BOTTOM_ST,
   ZONE_12_BOTTOM_CT,
   COOLING_ZONE_1_ST,
   COOLING_ZONE_1_CT,
   MES_IF,
   MES_IF_TIME,
   RET_TIME
FROM CRASREFSTS A
WHERE 1=1
  AND A.FACTORY = NVL(trim( 'RCM1' ),A.FACTORY)
  AND A.MES_IF_TIME >=  '20180627' || '23' || '30' ||'00'
  AND A.MES_IF_TIME <  '20180628' || '08' || '30' ||'00'
  AND A.LINE_ID = NVL (TRIM ( ' ' ), A.LINE_ID)
  AND A.RES_ID = NVL (TRIM ( ' ' ), A.RES_ID)
  AND A.ORDER_ID LIKE NVL(TRIM( ' ' ), A.ORDER_ID)||'%'
  AND A.LANE_ID LIKE NVL(TRIM( ' ' ), A.LANE_ID)||'%'
  AND A.PROGRAM_NAME LIKE NVL(TRIM( ' ' ), A.PROGRAM_NAME)||'%'
ORDER BY   A.FACTORY, A.LINE_ID, A.RES_ID, A.MES_IF_TIME) A
 ) A  WHERE ROWNUM < 10000
