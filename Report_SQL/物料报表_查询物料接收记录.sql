SELECT rownum rn9__, A.*  FROM ( SELECT STORE_ID AS STORE_ID , 当前条码 AS 当前条码 , 记忆批次号 AS 记忆批次号 , 供应商批次号 AS 供应商批次号 , 原始条码 AS 原始条码 , VENDOR_ID AS VENDOR_ID , VENDOR_DESC AS VENDOR_DESC , QTY_1 AS QTY_1 , INV_MAT_ID AS INV_MAT_ID , MAT_DESC AS MAT_DESC , DC AS DC , CUST_DC AS CUST_DC , CUST_MAT_ID AS CUST_MAT_ID , PO AS PO , 送货单号 AS 送货单号 , TRAN_TIME AS TRAN_TIME , TRAN_USER_ID AS TRAN_USER_ID
FROM (select a.store_id,
       a.LABEL_INV_LOT_ID as "当前条码",
       a.INV_LOT_ID       as "记忆批次号",
       a.vendor_lot_id    as "供应商批次号",
       a.label_cus_id     as "原始条码",
       a.vendor_id,
       c.data_1           as "VENDOR_DESC",
       a.qty_1,
       a.inv_mat_id,
       b.mat_desc,
       a.dc,
       a.inv_lot_cmf_19   as "CUST_DC",
       a.inv_lot_cmf_20   as "CUST_MAT_ID",
       a.add_order_id_1   as "PO",
       a.slot_id          as "送货单号",
TO_CHAR(to_date(trim(a.tran_time),'yyyy-mm-dd,hh24:mi:ss'), 'YYYY-MM-DD HH24:MI:SS') tran_time,
       a.tran_user_id
  from minvlothis a,
       mwipmatdef b,
       (select key_1, data_1
          from mgcmlagdat
         where table_name = 'VENDOR_CODE'
           and factory = trim( 'RCM1' )) c
 where a.in_type = 'OO'
   and a.tran_code like 'CREATE%'
   and a.factory = b.factory
   and a.inv_mat_id = b.mat_id
   and a.inv_mat_ver = b.mat_ver
   and c.key_1(+) = a.vendor_id
   and (case
         when trim( '20180627' ) is null then
1
         when a.tran_time >=  '20180627'  ||  '20'  ||  '30'  || '00' then
1
         else
0
       end) = 1
   and (case
         when trim( '20180628' ) is null then
1
         when a.tran_time <  '20180628'   ||  '08'  ||  '30'  || '00'  then
1
         else
0
       end) = 1
   and (case
         when trim( ' ' ) is null then
1
         when trim( ' ' ) = a.add_order_id_1 then
1
         else
0
       end) = 1
   and (case
         when trim( ' ' ) is null then
1
         when trim( ' ' ) = a.slot_id then
1
         else
0
       end) = 1
   and (case
         when trim( ' ' ) is null then
1
         when trim( ' ' ) = a.inv_mat_id then
1
         else
0
       end) = 1
   and (case
         when trim( ' ' ) is null then
1
         when trim( ' ' ) = a.store_id then
1
         else
0
       end) = 1
   and (case
         when trim( ' ' ) is null then
1
         when trim( ' ' ) = a.vendor_id then
1
         else
0
       end) = 1
 order by a.tran_time) A
 ) A  WHERE ROWNUM < 10000
