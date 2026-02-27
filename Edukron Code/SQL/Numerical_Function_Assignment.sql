-- Numerical Function Assignment----------

--1) Round Unit_Price to 2 decimal places.
select To_Char(Round(UNIT_PRICE, 2),'FM9999990.00')as Rounded_Price from ORDERS;

-- 2) Find total sales per order.
SELECT ORDER_ID, sum(UNIT_PRICE * QUANTITY) as sales_per_order 
from ORDERS
GROUP BY ORDER_ID;

-- 3)Calculate average order value.
select avg(Total_sales) as avg_order_value
from (SELECT ORDER_ID, sum(UNIT_PRICE * QUANTITY) as Total_sales from ORDERS GROUP BY ORDER_ID);

-- 4)Find highest product price.
select PRODUCT_NAME, UNIT_PRICE FROM ORDERS
where Unit_Price = (SELECT max(Unit_Price) from ORDERS);

-- 5)Find lowest product price.
select PRODUCT_NAME, UNIT_PRICE FROM ORDERS
where Unit_Price = (SELECT min(Unit_Price) from ORDERS);

-- 6)Calculate percentage discount applied
SELECT 
    Order_ID,
    ROUND(((Original_Price - Discounted_Price) / Original_Price) * 100, 2) AS Discount_Percentage
FROM Orders;

-- 7)Find modulus of Quantity divided by 2
SELECT quantity, MOD(QUANTITY, 2) as Reminder from ORDERS;

-- 8)Convert negative values to positive.
select ABS(QUANTITY) as Positive_Quantity from ORDERS;

-- 9) Truncate price without rounding
select trunc(UNIT_PRICE, 2) as truncated_price from ORDERS;

-- 10)Find square root of total sales.
select ORDER_ID,round(sqrt(sum(QUANTITY * UNIT_PRICE)), 2) as total_sales  
from ORDERS GROUP BY ORDER_ID;

-- 11) Calculate exponential value of a number.
select round(exp(total_sales),2) as expo_value 
from (select ORDER_ID,round(sqrt(sum(QUANTITY * UNIT_PRICE)), 2) as total_sales  
from ORDERS GROUP BY ORDER_ID);

-- 12) Calculate power of 2^5.
select power(2, 5) as power_value from dual;

-- 13) Find absolute difference between two prices.
SELECT abs(100 - 25) as abs_diff from dual;

-- 14) Calculate sales growth percentage.

-- Suppose you have a table sales_data with columns year, sales_amount. You can calculate growth between two years:

SELECT s1.year AS prev_year,
       s2.year AS curr_year,
       ((s2.sales_amount - s1.sales_amount) / s1.sales_amount) * 100 AS growth_percentage
FROM sales_data s1
JOIN sales_data s2
  ON s2.year = s1.year + 1;

--   15) Find random number between 1 and 100.
select round(DBMS_RANDOM.VALUE(1, 100)) as Random_Number from dual;

-- 16)Divide total sales by number of orders.
select count(ORDER_ID) as total_orders,sum(sales_per_order) as total_sales, (sum(sales_per_order) / count(ORDER_ID)) as sales_div_order
from(SELECT ORDER_ID, sum(UNIT_PRICE * QUANTITY) as sales_per_order 
from ORDERS
GROUP BY ORDER_ID
);

-- 17) Find ceiling value of price.
SELECT ceil(sales_div_order) ceilling_value
from (
    select count(ORDER_ID) as total_orders,sum(sales_per_order) as total_sales, (sum(sales_per_order) / count(ORDER_ID)) as sales_div_order
from(SELECT ORDER_ID, sum(UNIT_PRICE * QUANTITY) as sales_per_order 
from ORDERS
GROUP BY ORDER_ID
)
);

-- 18) Find floor value of price.
SELECT floor(sales_div_order) flor_value
from (
    select count(ORDER_ID) as total_orders,sum(sales_per_order) as total_sales, (sum(sales_per_order) / count(ORDER_ID)) as sales_div_order
from(SELECT ORDER_ID, sum(UNIT_PRICE * QUANTITY) as sales_per_order 
from ORDERS
GROUP BY ORDER_ID
)
);

-- 19) Convert decimal to integer.
select trunc(12.55) from dual;

-- 20) Calculate compound interest.
SELECT principal,
       rate,
       years,
       comp_per_year,
       principal * POWER(1 + rate / comp_per_year, comp_per_year * years) AS final_amount
FROM (
    SELECT 1000 AS principal,   -- Principal amount
           0.05 AS rate,        -- Annual interest rate (5%)
           10 AS years,         -- Time in years
           4 AS comp_per_year   -- Quarterly compounding
    FROM dual
);
