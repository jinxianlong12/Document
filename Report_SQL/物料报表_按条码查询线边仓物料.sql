SELECT rownum rn9__, A.*  FROM ( SELECT INV_MAT_ID AS INV_MAT_ID , MAT_DESC AS MAT_DESC , CUSTOMER_MAT_ID AS CUSTOMER_MAT_ID , INV_LOT_ID AS INV_LOT_ID , VENDOR_LOT_ID AS VENDOR_LOT_ID , LABEL_CUS_ID AS LABEL_CUS_ID , DC AS DC
FROM (select b.inv_mat_id,
       c.mat_desc,
       c.customer_mat_id,
       b.inv_lot_id,
       b.vendor_lot_id,
       b.label_cus_id,
       b.dc
  from mwiplotsts x, minvlotsts b, mwipmatdef c
 where x.lot_id =  trim( 'FB0517070010000008' )
   and x.order_id = b.inv_ord_id
   and c.mat_id(+) = b.inv_mat_id
 order by b.inv_mat_id) A
 ) A  WHERE ROWNUM < 10000
