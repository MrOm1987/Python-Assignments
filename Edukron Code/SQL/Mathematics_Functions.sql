-- Mathematics Functions
-- 1) Find sine value of an angle.
select round(sin(30 * (acos(-1)/180)), 10) as sin_angle from dual;

-- 2) Find cosine value of an angle.
select round(cos(30 * (acos(-1)/180)), 10) as sin_angle from dual;

--  3) Find tangent value.
select round(tan(30 * (acos(-1)/180)), 10) as sin_angle from dual;

-- 4) Convert degrees to radians.
select round(45*(acos(-1)/180), 10) as degree_to_radian from dual;

-- 5) Convert radians to degrees.
-- raian = degree * 180/pi

SELECT round(45 * 180/ acos(-1),10) as radian_bvalue from dual;

-- 6) Find logarithm (base 10) of a number.
-- log(base, number)
select round(log(10, 2), 4) as log_value from dual;

-- 7) Find natural log of a number.(LN)
SELECT LN(100) as natura_log from DUAL;

-- 8) Find square of a number.
select power(5, 2) as square_value from dual;

-- 9) Find cube of a number.
select power(5, 3) as cube_value from dual;

-- 10) Calculate factorial of a number.
SELECT EXP(SUM(LN(level))) AS factorial
FROM dual
CONNECT BY level <= 5;

-- other method........
DECLARE
  n NUMBER := 5;
  result NUMBER := 1;
BEGIN
  FOR i IN 1..n LOOP
    result := result * i;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Factorial of ' || n || ' is ' || result);
END;

-- 11) Find greatest value among three numbers.
select greatest(10, 47, 38) as greatest_value from dual;

-- 12) Find least value among three numbers
select least(10, 47, 38) as least_value from dual;

-- 13) Calculate variance of sales
select VARIANCE(total_sales) as sales_variance
from (SELECT sum(unit_price * quantity) as total_sales
from ORDERS
GROUP BY order_id);

-- 14) Calculate standard deviation of sales.
SELECT STDDEV(total_sales) AS sales_stddev
FROM (
  SELECT SUM(unit_price * quantity) AS total_sales
  FROM orders
  GROUP BY order_id
);

-- 15) Find average deviation.
select AVG(ABS(total_sales - AVG(total_sales) OVER())) AS avg_deviation
FROM (
  select SUM(unit_price * quantity) AS total_sales
  FROM orders
  GROUP BY order_id
);

WITH sales_data AS (
  SELECT order_id,
         SUM(unit_price * quantity) AS total_sales
  FROM orders
  GROUP BY order_id
),
sales_mean AS (
  SELECT AVG(total_sales) AS avg_sales
  FROM sales_data
)
SELECT AVG(ABS(sd.total_sales - sm.avg_sales)) AS avg_deviation
FROM sales_data sd
CROSS JOIN sales_mean sm;

-- 16) Calculate geometric mean.
SELECT EXP(AVG(LN(total_sales))) AS geometric_mean
FROM (
  SELECT SUM(unit_price * quantity) AS total_sales
  FROM orders
  GROUP BY order_id
);

-- 17) Calculate harmonic mean.
SELECT COUNT(total_sales) / SUM(1/total_sales) AS harmonic_mean
FROM (
  SELECT SUM(unit_price * quantity) AS total_sales
  FROM orders
  GROUP BY order_id
);

-- 18) Find sum of squares.
SELECT SUM(POWER(total_sales, 2)) AS sum_of_squares
FROM (
  SELECT SUM(unit_price * quantity) AS total_sales
  FROM orders
  GROUP BY order_id
);

-- 19) Calculate correlation between two columns.
SELECT CORR(total_sales, per_order) AS correlation_value
FROM (
  SELECT order_id,
         SUM(unit_price * quantity) AS total_sales,
         SUM(order_id) AS per_order
  FROM orders
  GROUP BY order_id
);

-- 20) Calculate regression slope.
SELECT REGR_SLOPE(total_sales, discount ) AS slope
FROM (
  SELECT order_id,
         SUM(unit_price * quantity) AS total_sales,
         SUM(order_id) AS discount
  FROM orders
  GROUP BY order_id
);
