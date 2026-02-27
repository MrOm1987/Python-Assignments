-- SQL Date Function
-- 1) Extract year from Order_Date.
select extract(year from ORDER_DATE) as order_year from ORDERS;

-- 2) Extract month from Order_Date.
select extract(MONTH from ORDER_DATE) as order_month from ORDERS;

-- 3) Extract day from Order_Date
select extract(DAY from Order_Date) as order_day FROM ORDERS;

-- 4) Find current date.
SELECT current_date from dual;

-- 5) Find current timestamp.
select current_timestamp from dual;

-- 6) Add 7 days to Order_Date.
SELECT order_date + 7 as next_week from orders;

-- 7) Subtract 30 days from Order_Date.
SELECT order_date - 30 as last_month from ORDERS;

-- 8) Find difference between two dates.
SELECT DATE '2026-03-10' - DATE '2026-02-26' AS days_diff FROM dual;

-- 9) Find number of months between two dates.
SELECT months_between(DATE'2026-03-10', DATE'2026-02-26' ) as month_diff from DUAL;

-- 10) Find last day of the month.
SELECT last_day(DATE'2026-03-10') from dual;

-- 11) Get first day of the year.
select trunc(order_date, 'year') from ORDERS;

-- 12) Format date as 'DD-MM-YYYY'.
select TO_DATE(order_date,'DD-MM-YYYY') from ORDERS;

-- 13) Convert string to date.
select TO_DATE(order_date,'DD-MM-YYYY') from ORDERS;

-- 14) Convert date to string.
SELECT to_char(order_date, 'DD-MM-YYYY') from ORDERS;

-- 15) Find week number of the year.
SELECT to_char(order_date, 'WW') as week_of_year from ORDERS;

-- 16) Find day name from date
select to_char(order_date, 'DAY') as Day_Name from ORDERS;

-- 17) Find quarter of the year.
select to_char(order_date, 'Q') as Quater_Num from ORDERS;

-- 18) Calculate age from DOB
SELECT floor(months_between(sysdate,'05-09-1987')/12) as Age from dual;

-- 19) Check if date is weekend.
select CASE
          WHEN to_char(order_date, 'DY', 'nls_date_language = english') in ('SAT','SUN')
          THEN 'Weekend'
          ELSE 'Weekdays'
       END as day_type
from ORDERS;

-- 20) Find next Monday after a given date.
select next_day(order_date, 'MONDAY') as next_monday from orders;