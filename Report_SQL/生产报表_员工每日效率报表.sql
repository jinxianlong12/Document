SELECT
--month,
--WORK_DATE ,
--SHIFT,AREA,
--WORK_SHOP,
--USER_ID,
USER_DESC,
--TOTAL_TIME ,  --投入工时
--PROD_TIME,    --产出工时
--EXC_TIME ,    --异常/间接工时
--ACT_TIME ,    --实做工时
trunc(decode((TOTAL_TIME - EXC_TIME),0,0, PROD_TIME/(TOTAL_TIME - EXC_TIME ) *100),2) DIR_EFF --直接效率 ,
--trunc(decode(TOTAL_TIME,0,0, PROD_TIME/TOTAL_TIME * 100),2) COM_EFF  -- 综合效率
--,IS_VERIFY
FROM
(
       with
    A as  --头
    (
       SELECT  work_date ,shift, area ,work_shop ,user_id,user_desc ,DECODE(CMF_5,' ',0 ,CMF_5) T_ATT_TIME ,0 T_PROD_TIME ,CMF_6 IS_VERIFY  FROM CWIPACTTME
        where 1=1  AND delete_flag != 'Y'
         AND WORK_DATE = NVL(TRIM('20180621'),WORK_DATE)
        AND AREA = 'DG-SSD'
        AND WORK_SHOP = 'SMT'
        AND USER_ID = NVL(TRIM(' '),USER_ID)
         GROUP BY work_date ,SHIFT ,AREA ,WORK_SHOP ,USER_ID ,USER_DESC ,CMF_5,CMF_6
    ),
    B as  --正常工时
    (
        SELECT  work_date ,shift, area ,work_shop ,user_id,user_desc,sum(ATT_TIME)T_ATT_TIME , sum(PROD_TIME)T_PROD_TIME  FROM CWIPACTTME
        where 1=1 AND  ACT_TIME_TYPE = '1'  AND delete_flag != 'Y'
          AND WORK_DATE = NVL(TRIM('20180621'),WORK_DATE)
        AND AREA = 'DG-SSD'
        AND WORK_SHOP = 'SMT'
        AND USER_ID = NVL(TRIM(' '),USER_ID)
         GROUP BY work_date ,SHIFT ,AREA ,WORK_SHOP ,USER_ID ,USER_DESC
    ),
    C as --间接/异常工时
    (
         SELECT  work_date ,shift, area ,work_shop ,user_id,user_desc,sum(ATT_TIME)T_ATT_TIME ,0 T_PROD_TIME   FROM CWIPACTTME
        where 1=1  AND  ACT_TIME_TYPE = '2' AND delete_flag != 'Y'
          AND WORK_DATE = NVL(TRIM('20180621'),WORK_DATE)
        AND AREA = 'DG-SSD'
        AND WORK_SHOP = 'SMT'
        AND USER_ID = NVL(TRIM(' '),USER_ID)
         GROUP BY work_date ,SHIFT ,AREA ,WORK_SHOP ,USER_ID ,USER_DESC
    ),
    D as --实做工时
    (
         SELECT  work_date ,shift, area ,work_shop ,user_id,user_desc,sum(ATT_TIME)T_ATT_TIME ,0 T_PROD_TIME   FROM CWIPACTTME
        where 1=1  AND  ACT_TIME_TYPE = '3' AND delete_flag != 'Y'
          AND WORK_DATE = NVL(TRIM('20180621'),WORK_DATE)
        AND AREA = 'DG-SSD'
        AND WORK_SHOP = 'SMT'
        AND USER_ID = NVL(TRIM(' '),USER_ID)
         GROUP BY work_date ,SHIFT ,AREA ,WORK_SHOP ,USER_ID ,USER_DESC
    )
    select  substr(a.work_date,5,2) month, a.WORK_DATE ,A.SHIFT,A.AREA,A.WORK_SHOP,A.USER_ID,A.USER_DESC,A.IS_VERIFY,
    --decode(nvl(B.T_ATT_TIME,0), 0 , nvl(C.T_ATT_TIME,0)+ nvl(D.T_ATT_TIME,0) , nvl(B.T_ATT_TIME,0))  TOTAL_TIME, --投入工时  A
    A.T_ATT_TIME TOTAL_TIME, --投入工时
    nvl(B.T_PROD_TIME,0) + nvl(D.T_ATT_TIME,0) PROD_TIME,  --产出工时 B
    nvl(C.T_ATT_TIME,0) EXC_TIME,--间接/异常工时 C
    nvl(D.T_ATT_TIME,0) ACT_TIME --实做工时 D
    from  A, B, C,D
    WHERE 1=1
    AND A.WORK_DATE = B.WORK_DATE (+)
    AND A.SHIFT = B.SHIFT (+)
    AND A.AREA = B.AREA (+)
    AND A.WORK_SHOP = B.WORK_SHOP (+)
    AND A.USER_ID = B.USER_ID (+)
    AND A.WORK_DATE = C.WORK_DATE(+)
    AND A.SHIFT = C.SHIFT(+)
    AND A.AREA = C.AREA (+)
    AND A.WORK_SHOP = C.WORK_SHOP (+)
    AND A.USER_ID = C.USER_ID (+)
    AND A.WORK_DATE = D.WORK_DATE(+)
    AND A.SHIFT = D.SHIFT(+)
    AND A.AREA = D.AREA (+)
    AND A.WORK_SHOP = D.WORK_SHOP (+)
    AND A.USER_ID = D.USER_ID (+)
) t
order by DIR_EFF desc
