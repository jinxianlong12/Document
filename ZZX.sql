SELECT
  to_char((CURRENT_DATE +cast(-1*(TO_NUMBER(to_char(CURRENT_DATE,'D'),'99')-2) ||' days' as interval)),'yyyy-mm-dd') as s_day,
  to_char((CURRENT_DATE +cast(-1*(TO_NUMBER(to_char(CURRENT_DATE,'D'),'99')-7) ||' days' as interval)),'yyyy-mm-dd') as e_day