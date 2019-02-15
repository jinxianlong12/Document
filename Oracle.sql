--------------------------------------------字符串函数--------------------------------------------
SELECT concat('010-','88888888')||'23' phoneNo FROM dual;
-------------010-8888888823, concat是添加两个字符串
SELECT initcap('smith hEllo') upp FROM dual;
-------------Smith Hello
SELECT lower('AaBbCcDd') AaBbCcDd FROM dual;
-------------aabbccdd
SELECT upper('AaBbCcDd') AaBbCcDd FROM dual;
-------------AABBCCDD
SELECT lpad(rpad('gao',10,'*'),17,'*') FROM dual;
-------------*******gao*******
SELECT replace('he lohe you','he','i') FROM dual;
-------------i loi you
SELECT ltrim(rtrim('   gao qian jing   ',' '),' ') FROM dual;
-------------gao qian jing
SELECT trim('a' FROM 'abacda') FROM dual;
-------------bacd
SELECT ltrim('abaaaabbbcda','ab') FROM dual;
-------------cda
SELECT substr('130123456789',3,8) 截取字符串 FROM dual;
-------------01234567
SELECT substr('aaaa-bbbb-cc',instr('aaaa-bbbb-cc','-',-1)+1) FROM dual;
-------------cc    截取最后一个'-'后面的字符串

--------------------------------------------数字函数--------------------------------------------
-------------如果表中dummy列有为NULL，就替换成0
SELECT instr('oracle traning','ra',1,2) instring FROM dual;
-------------返回9, 第'1'个位置开始搜索, '2'次出现的位置返回, '1', '2'是函数里参数值
SELECT LENGTH (' 130 ') 返回字符串长度  FROM DUAL;
-------------返回5, 空格也算
SELECT FLOOR (2345.67), FLOOR (-2345.67) FROM dual;
-------------2345, -2346, 返回小于等于x的最大整数值
SELECT mod(10,3),mod(3,3),mod(2,0) FROM dual;
-------------1  0  2, 返回x除以y的余数.如果y是0,则返回x
SELECT power(2,10),power(3,3) FROM dual;
-------------1024   27
SELECT ROUND (55.655, 2),ROUND (55.654, 2),ROUND (45.654, -1),ROUND (45.654, -2),ROUND (55.654, -2) FROM DUAL;
-------------55.66               55.65             50                 0                  100
SELECT sign(123),sign(-100),sign(0) FROM dual;
-------------1,-1,0
SELECT trunc(123.567,2), trunc(123.567,-2), trunc(123.567) FROM dual;
-------------123.56          100                  123
SELECT sum(列明) FROM 表名 group by 分组的列
-------------计算该列的总和, 按分组来显示
SELECT name, DECODE(admin_flag,0,'普通用户',1,'管理员','默认值') FROM USERS;
-------------jinxianlon	管理员
-------------MY TEST	普通用户
-------------decode(条件,值1,返回值1,值2,返回值2,...值n,返回值n,默认值)
SELECT avg(plan_qty)  FROM work_orders;
-------------平均
SELECT sum(plan_qty)  FROM work_orders;
-------------和
SELECT count(plan_qty)  FROM work_orders;
-------------数据数
-------------max(列明), min(列明)   取最大值最小值

--------------------------------------------日期函数--------------------------------------------
SELECT trunc (SYSDATE, 'DD'),trunc (SYSDATE, 'MM'),trunc (SYSDATE, 'yyyy'),trunc (SYSDATE, 'day'),trunc (SYSDATE, 'q') FROM DUAL;
-------------当天                    本月第一天             本年第一天                本周第一天             本季度第一天
Select * From GG_DTXX t Where trunc(create_time)= trunc(Sysdate)
-------------当天：
select * from GG_DTXX t where t.create_time >=trunc(next_day(sysdate-8,1)+1) and t.create_time<=trunc(next_day(sysdate-8,1)+7)
-------------本周
Select * From GG_DTXX t Where to_char(create_time,'yyyymm') = to_char(Sysdate,'yyyymm')
select * from GG_DTXX t where t.create_time >=trunc(sysdate, 'MM') and t.create_time<=last_day(sysdate)    
-------------当月：
select * from GG_DTXX t where t.create_time >=trunc(sysdate,'YYYY') and t.create_time<=add_months(trunc(sysdate,'YYYY'),12)-1
-------------当年：
SELECT trunc(SYSDATE ,'HH24') FROM dual;
-------------2017/2/13 15:00:00,返回本小时的开始时间
SELECT trunc(SYSDATE ,'MI') FROM dual;
-------------2017/2/13 15:13:00,返回本分钟的开始时间  
SELECT to_char(add_months(to_date('199912','yyyymm'),2),'yyyymm') FROM dual;
-------------200002
SELECT SYSDATE FROM daul
-------------当前时间(2018-08-18 17:31:54)
SELECT LOCALTIMESTAMP FROM dual;
-------------(2018-08-18 17:41:57:391000)
SELECT CURRENT_TIMESTAMP FROM dual;
-------------(2018-08-18 17:33:54:874000 +08:00)
SELECT extract(year FROM SYSDATE) year FROM dual;
-------------2018, 系统时间中获取所需字段
SELECT last_day(SYSDATE) FROM dual;
-------------2018-08-31 17:41:00, 返回当月最后一天,  可以用来计算剩余天数
SELECT months_between('19-12月-1999','19-3月-1999') mon_between FROM dual;
-------------9, 两个日期之间的相差月数
SELECT next_day('18-8-2018','星期五') next_day FROM dual;
-------------2018-08-24 00:00:00, 
SELECT round(SYSDATE,'MONTH') FROM dual;
-------------将日期d按照由format指定的格式进行四舍五入处理处理.如果没有给format则使用缺省设置`DD`.
SELECT cast(TO_TIMESTAMP('2015-10-01 21:11:11.328', 'yyyy-mm-dd hh24:mi:ss.ff') as date) FROM dual;
-------------2015-10-01 21:11:11
SELECT cast(SYSDATE as timestamp) date_to_timestamp FROM dual;
-------------2015-10-01 21:11:11.328

--------------------------------------------转换--------------------------------------------
SELECT to_char(SYSDATE,'yyyy.mm.dd') aa FROM dual;
-------------2018.08.18(转换成char类型)
SELECT to_date('19991201','yyyy-mm-dd') FROM dual;
-------------1999-12-01 00:00:00(字符串转换成date类型)
SELECT to_number('1999') year FROM dual;
-------------1999(转换成int类型)

--------------------------------------------其他--------------------------------------------
SELECT nullif(expr1, expr2) FROM table_name;
-------------用于比较表达式expr1和expr2，相等返回null，否则返回expr1.
SELECT nvl(column_name,0) FROM tbale_name;
-------------列值是null的话返回0
SELECT nvl(column_name,0,1) FROM tbale_name;
-------------列值是null的话返回1, 不是null返回0
with temp as(
  SELECT 'China' nation ,'Guangzhou' city FROM dual UNION ALL
  SELECT 'China' nation ,'Shanghai' city FROM dual UNION ALL
  SELECT 'China' nation ,'Beijing' city FROM dual UNION ALL
  SELECT 'USA' nation ,'New York' city FROM dual UNION ALL
  SELECT 'USA' nation ,'Bostom' city FROM dual UNION ALL
  SELECT 'Japan' nation ,'Tokyo' city FROM dual 
)
SELECT nation,listagg(city,',') within GROUP (order by city desc)
FROM temp
group by nation;
-------------China	Shanghai,Guangzhou,Beijing
-------------Japan	Tokyo
-------------USA	New York,Bostom

---1. 添加数据库: 用Database Configuration   添加数据库
---2. cmd界面创建用户(cmd—> sqlplus /nolog; conn / as sysdba): create user user_name identified by pwd;
---3. 给用户赋权限: grant connect,resource,dba to user_name;
---4. 导出数据库: exp user_name/pwd@database_name  dumpfile =xx.dmp ;
---5. 导入数据库: imp user_name/pwd@localhost/database_name file="D:\xx.DMP" full=y;

---登陆: grant create session to zhangsan;
---使用表空间: grant unlimited tablespace to zhangsan;
---创建表: grant create table to zhangsan;
---删除表: grant drop table to zhangsan;
---插入表: grant insert table to zhangsan;
---更新表数据: grant update table to zhangsan;
---修改表结构: grant alter table on table_name to user_name;
---查询表: grant select on table_name to user_name;
---创建过程: grant create any procedure to username;
---执行过程: grant execute any procedure to username;
---授予所有权限(all)给所有用户(public): grant all to public;

---导出表: exp qdcrrcoes/crrcoes@127.0.0.1:1521/qdcrrcoes file=d:/diy.dmp tables=(DIY_GRIDS, DIY_SERVICES)
---导入表: imp crrcoes/crrcoes@localhost:1521/oes file=d:/diy.dmp tables=(DIY_GRIDS, DIY_SERVICES)
