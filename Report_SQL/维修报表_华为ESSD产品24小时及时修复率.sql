select  b.prod_id,b.order_id,a.lot_id,a.defect_time,a.test_time_fail,a.test_time_pass,a.repair_time , task_order,opr.oper_desc oper,
 to_char(case when (test_time_pass<>' ' and test_time_fail<>' ' and repair_time <>' ' ) then
 ((to_date(repair_time ,'YYYY-MM-DD HH24MISS')-to_date(a.test_time_fail,'YYYY-MM-DD HH24MISS'))*24) else 0 end,'9999.99') as duration
 from crpttstrep a join cwiporddef b on a.factory=b.factory and a.order_id=b.order_id
 join MWIPOPRDEF opr on opr.factory=a.factory and opr.oper=a.oper
 where customer_desc like '华为%'  and substr(task_order,3,1) not in ('L','C','W') and b.product_grp in ('20','21')
 and    test_time_fail<>' ' and to_char(to_date(substr(defect_time,0,8),'YYYY-MM-DD'),'YYYY-MM-DD')>=' '
 and to_char(to_date(substr(defect_time,0,8),'YYYY-MM-DD'),'YYYY-MM-DD')<=' '
