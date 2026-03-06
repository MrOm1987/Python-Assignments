-- 1. Create CUSTOMERS Table
CREATE TABLE CUSTOMERS (
    CUSTOMER_ID NUMBER PRIMARY KEY,
    FIRST_NAME VARCHAR2(50),
    LAST_NAME VARCHAR2(50),
    CITY VARCHAR2(50),
    PHONE_NUMBER VARCHAR2(20),
    LOYALTY_POINTS NUMBER
);

select * from CUSTOMERS;
select * from ORDERS;
DROP TABLE ORDERS

-- 2. Create ORDERS Table
CREATE TABLE ORDERS (
    ORDER_ID NUMBER PRIMARY KEY,
    CUSTOMER_ID NUMBER,
    ORDER_DATE DATE,
    TOTAL_AMOUNT NUMBER(10, 2),
    DISCOUNT_AMT NUMBER(10, 2), -- Can be NULL if no discount
    SHIPPING_DATE DATE          -- Can be NULL if not shipped yet
);

-- 3. Insert Data with intentional NULL values
-- Customers
INSERT INTO CUSTOMERS VALUES (101, 'John', 'Doe', 'New York', '555-0100', 500);
INSERT INTO CUSTOMERS VALUES (102, 'Jane', 'Smith', NULL, '555-0101', 120);
INSERT INTO CUSTOMERS VALUES (103, 'Robert', 'Brown', 'Chicago', NULL, 0);
INSERT INTO CUSTOMERS VALUES (104, 'Emily', 'Davis', NULL, NULL, NULL); -- Lots of NULLs
INSERT INTO CUSTOMERS VALUES (105, 'Michael', 'Wilson', 'Miami', '555-0105', NULL);

-- Orders
INSERT INTO ORDERS VALUES (5001, 101, DATE '2023-10-01', 150.00, 10.00, DATE '2023-10-03');
INSERT INTO ORDERS VALUES (5002, 102, DATE '2023-10-02', 200.50, NULL, DATE '2023-10-05'); -- No discount
INSERT INTO ORDERS VALUES (5003, 101, DATE '2023-10-05', 75.00, 5.00, NULL); -- Not shipped
INSERT INTO ORDERS VALUES (5004, 104, DATE '2023-10-06', 300.00, NULL, NULL); -- No discount, Not shipped
INSERT INTO ORDERS VALUES (5005, 105, DATE '2023-10-07', 50.00, 0.00, DATE '2023-10-08');
INSERT INTO ORDERS VALUES (5006, NULL, DATE '2023-10-08', 20.00, NULL, DATE '2023-10-09'); -- Orphan order

COMMIT;

select * FROM CUSTOMERS;
SELECT * from ORDERS;

-- 1. (Inner Join) Retrieve a list of customers who have placed at least one order.
    --Display Name and Order ID. Note: This excludes customers with no orders and orders with NULL Customer IDs.

SELECT c.FIRST_NAME, c.LAST_NAME, o.ORDER_ID
FROM CUSTOMERS c 
INNER JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;

-- 2. (Left Join) List all customers and their Order IDs. Include customers who have not 
-- placed any orders. Note: Returns NULL in the Order column for customers like 'Robert' or 'Emily'.

SELECT c.FIRST_NAME, c.LAST_NAME,c.CUSTOMER_ID, o.ORDER_ID
FROM CUSTOMERS c
LEFT JOIN ORDERS o on c.CUSTOMER_ID = o.CUSTOMER_ID;

-- 3. (Left Join - Finding Non-Matches) Find customers who have NEVER placed an order.
--  Note: We join, then filter for where the "Right" table is NULL.

SELECT c.FIRST_NAME, c.LAST_NAME,c.CUSTOMER_ID, o.ORDER_ID
FROM CUSTOMERS c
LEFT JOIN ORDERS o on c.CUSTOMER_ID = o.CUSTOMER_ID
where o.ORDER_ID is NULL;

-- 4. (Right Join) List all orders and the associated customer name. Include orders that 
-- do not have a linked Customer ID. Note: This will show Order 5006, which has a NULL Customer_ID.

SELECT c.FIRST_NAME, o.ORDER_ID, c.CUSTOMER_ID
FROM CUSTOMERS c
RIGHT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;

-- 5. (Full Outer Join) List ALL customers and ALL orders. If a customer has no order, 
-- show NULLs for order info. If an order has no customer, show NULLs for customer info.

SELECT c.FIRST_NAME,c.LAST_NAME,c.CUSTOMER_ID, o.ORDER_ID,o.ORDER_DATE,o.TOTAL_AMOUNT
FROM CUSTOMERS c
FULL OUTER JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;

-- 6. (Left Join with NVL) Calculate the total amount spent by each customer. 
-- If they haven't bought anything, display 0 instead of NULL.

SELECT c.CUSTOMER_ID, c.FIRST_NAME,c.LAST_NAME, nvl(sum(o.TOTAL_AMOUNT), 0) as Total_Spent
FROM CUSTOMERS c 
LEFT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID,c.FIRST_NAME,c.LAST_NAME;

-- 7. (Self Join) Find pairs of customers who live in the same City. Note: We must exclude 
-- NULL cities and ensure we don't match a customer to themselves.
SELECT * FROM CUSTOMERS;

SELECT 
    a.FIRST_NAME AS CUST_1, 
    b.FIRST_NAME AS CUST_2, 
    a.CITY
FROM CUSTOMERS a
JOIN CUSTOMERS b 
    ON a.CITY = b.CITY
WHERE a.CUSTOMER_ID < b.CUSTOMER_ID;

-- 8. (Cross Join) Generate a theoretical list of every customer 
-- buying every order (Cartesian Product).

SELECT c.FIRST_NAME, o.ORDER_ID
FROM CUSTOMERS c
CROSS JOIN ORDERS o;

-- 9. (Natural Join) Join Customers and Orders automatically based on the common column (CUSTOMER_ID).
--  Note: Oracle does not require table aliases on the common column in a Natural Join.

SELECT FIRST_NAME, ORDER_ID
FROM CUSTOMERS
NATURAL JOIN ORDERS;

-- 10. (Left Join & Filtering) List all Customers and their Order Dates, but only for
-- orders placed after October 5th. Keep customers with NO orders in the list. 
-- Note: The condition must be in the ON clause, not WHERE, to preserve the Left Join behavior for non-matching rows.

SELECT c.FIRST_NAME, o.ORDER_DATE
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID AND o.ORDER_DATE > DATE '2023-10-05';

-- 11. (Full Join - Exclusive) Find records that are EITHER a Customer without an order 
-- OR an Order without a Customer (The "Anti-Join" of both sides).

SELECT c.CUSTOMER_ID AS C_ID, o.ORDER_ID
FROM CUSTOMERS c
FULL OUTER JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE c.CUSTOMER_ID IS NULL OR o.CUSTOMER_ID IS NULL;

-- 12. (Inner Join with Aggregates) Find the average loyalty points of customers who have 
-- actually placed an order. Note: Distinct ensures we don't double count points if a customer ordered twice.
SELECT AVG(DISTINCT c.LOYALTY_POINTS)
FROM CUSTOMERS c
JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;

-- 13. (Left Join with Coalesce) Display a report: "Customer Name - Order ID". 
-- If there is no order, display "Customer Name - No Order".

SELECT c.FIRST_NAME || ' - ' || COALESCE(TO_CHAR(o.ORDER_ID), 'No Order') AS REPORT_LOG
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;

-- 14. (Self Join on Inequality) Find pairs of orders where the first order has a higher amount
-- than the second order.

SELECT o1.ORDER_ID AS HIGH_VAL_ORDER, o2.ORDER_ID AS LOW_VAL_ORDER
FROM ORDERS o1
JOIN ORDERS o2 ON o1.TOTAL_AMOUNT > o2.TOTAL_AMOUNT;

-- 15. (Left Join) Count how many orders each customer has made. Note: COUNT(O.ORDER_ID)
--  is safer than COUNT(*) because it returns 0 for NULLs.

SELECT c.FIRST_NAME, COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
GROUP BY c.FIRST_NAME;

-- 16. (Right Join with Date Logic) List all orders and the Customer City. If the
-- Customer is NULL (orphan order), display 'Unknown City'.

SELECT o.ORDER_ID, NVL(c.CITY, 'Unknown City')
FROM CUSTOMERS c
RIGHT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;

-- 17. (Non-Equi Join) Find customers whose Loyalty Points are greater than the Total Amount
--  of any single order. Note: Joining based on value comparison rather than ID equality.

SELECT DISTINCT c.FIRST_NAME, c.LOYALTY_POINTS, o.TOTAL_AMOUNT
FROM CUSTOMERS c
JOIN ORDERS o ON c.LOYALTY_POINTS > O.TOTAL_AMOUNT;

-- 18. (Left Join) List Customers and their "Shipping Status". If the order exists 
-- but Shipping Date is NULL, show 'Pending'. If no order exists, show 'N/A'.

SELECT c.FIRST_NAME,
       CASE
           WHEN o.ORDER_ID IS NULL THEN 'N/A'
           WHEN o.SHIPPING_DATE IS NULL THEN 'Pending'
           ELSE 'Shipped'
       END AS STATUS
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;

-- 19. (Using USING) Perform an Inner Join using the USING clause instead of ON. 
-- Note: This works because both tables share the column name CUSTOMER_ID.

SELECT FIRST_NAME, ORDER_ID
FROM CUSTOMERS
JOIN ORDERS USING (CUSTOMER_ID);

-- 20. (Multiple Join Conditions) Join Customers and Orders where the Customer ID matches
--  AND the Customer has a valid City (City is not null).

SELECT c.FIRST_NAME, o.ORDER_ID
FROM CUSTOMERS c
JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE c.CITY IS NOT NULL;

-- 21. (Inner Join) List the FIRST_NAME of the customer and the TOTAL_AMOUNT for all orders 
-- that have a Discount (DISCOUNT_AMT is not null).

SELECT DISTINCT c.FIRST_NAME, o.TOTAL_AMOUNT
FROM CUSTOMERS c
JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE o.DISCOUNT_AMT IS NOT NULL;

-- 22. (Left Join) List all Customers. If they have an order, display the ORDER_DATE.
--  If not, ensure the row still appears with a NULL date.

SELECT 
    c.CUSTOMER_ID,
    c.FIRST_NAME,
    c.LAST_NAME,
    o.ORDER_DATE
FROM CUSTOMERS c
LEFT JOIN ORDERS o 
    ON c.CUSTOMER_ID = o.CUSTOMER_ID;

-- 23. (Right Join) Display ORDER_ID and FIRST_NAME. We want to see all orders, 
-- including the one with CUSTOMER_ID NULL (Order 5006).

SELECT c.FIRST_NAME, o.ORDER_ID
FROM CUSTOMERS c 
RIGHT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;

-- 24. (Full Outer Join) Find the count of rows returned when you Full Outer Join Customers 
-- and Orders. (Try to predict the number before running it).

select count(*)
from CUSTOMERS c 
FULL OUTER JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;

-- 25. (Left Join - Anti Join) Find the CUSTOMER_IDs that exist in the CUSTOMERS table 
-- but do NOT exist in the ORDERS table.

SELECT c.FIRST_NAME, o.ORDER_ID
FROM CUSTOMERS c 
Left JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE o.Customer_ID IS NULL;

-- 26. (Self Join) Find pairs of Orders (O1, O2) that were placed on the exact same ORDER_DATE.

SELECT o1.ORDER_ID AS O1, o2.ORDER_ID AS O2, o1.ORDER_DATE
FROM ORDERS o1
JOIN ORDERS o2 ON o1.ORDER_DATE = o2.ORDER_DATE AND o1.ORDER_ID < o2.ORDER_ID;

-- 27. (Cross Join) Create a list showing every Customer paired with every unique CITY found in
--  the Customer table.

SELECT c.FIRST_NAME,city_list.CITY
FROM CUSTOMERS c
CROSS JOIN (
    SELECT DISTINCT CITY 
    FROM CUSTOMERS
) city_list
ORDER BY c.FIRST_NAME, city_list.CITY;

-- 28. (Inner Join + Aggregates) Calculate the total DISCOUNT_AMT given to customers living 
-- in 'New York'.

SELECT SUM(o.DISCOUNT_AMT) AS TOTAL_DISCOUNT
FROM CUSTOMERS c
INNER JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE c.CITY = 'New York';



-- 29. (Left Join + NVL) Select FIRST_NAME and the SHIPPING_DATE. If the shipping date is NULL 
-- (either because the order isn't shipped OR the customer has no order), display 'Not Shipped'.

SELECT c.FIRST_NAME,NVL(TO_CHAR(o.SHIPPING_DATE, 'DD-MON-YYYY'), 'Not Shipped') AS SHIPPING_STATUS
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;


-- 30. (Right Join) Find the sum of TOTAL_AMOUNT for orders that do not have a linked Customer 
-- (Orphan orders).

SELECT SUM(o.TOTAL_AMOUNT) AS ORPHAN_ORDER_TOTAL
FROM CUSTOMERS c
RIGHT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE c.CUSTOMER_ID IS NULL;


-- 31. (Natural Join) Use a Natural Join to display LAST_NAME and TOTAL_AMOUNT. 
-- (Be careful: does LOYALTY_POINTS exist in both tables? No? Then it uses CUSTOMER_ID).

SELECT c.LAST_NAME,o.TOTAL_AMOUNT
FROM CUSTOMERS c
NATURAL JOIN ORDERS o;

-- 32.(Left Join with Multiple Conditions) Join Customers to Orders, but ONLY link orders 
-- where the TOTAL_AMOUNT is greater than 100. Customers with small orders should look like 
-- they have NULL orders.

SELECT c.CUSTOMER_ID,c.FIRST_NAME,o.ORDER_ID,o.TOTAL_AMOUNT
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID AND o.TOTAL_AMOUNT > 100;

-- 33. (Inner Join) List FIRST_NAME and ORDER_ID for customers who have a Phone Number
--  (IS NOT NULL).

SELECT c.FIRST_NAME,o.ORDER_ID
FROM CUSTOMERS c
INNER JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE c.PHONE_NUMBER IS NOT NULL;


-- 34. (Full Join + Coalesce) Display a list of IDs. If it's a Customer without an order, 
-- show Customer ID. If it's an Order without a Customer, show Order ID. Use COALESCE.

SELECT COALESCE(c.CUSTOMER_ID, o.ORDER_ID) AS ID
FROM CUSTOMERS c
FULL OUTER JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;


-- 35. (Self Join) Find customers who have the same LOYALTY_POINTS value as another customer.

SELECT c1.CUSTOMER_ID AS CUST_1,c1.FIRST_NAME AS NAME_1,c2.CUSTOMER_ID AS CUST_2,c2.FIRST_NAME AS NAME_2,c1.LOYALTY_POINTS
FROM CUSTOMERS c1
JOIN CUSTOMERS c2 ON c1.LOYALTY_POINTS = c2.LOYALTY_POINTS AND c1.CUSTOMER_ID < c2.CUSTOMER_ID;
 

--  36. (Inner Join) Display FIRST_NAME, CITY, and ORDER_DATE for orders that have actually been 
--  shipped (SHIPPING_DATE is not null).

SELECT c.FIRST_NAME,c.CITY,o.ORDER_DATE
FROM CUSTOMERS c
INNER JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE o.SHIPPING_DATE IS NOT NULL;

-- 37. (Left Join) Calculate the Average TOTAL_AMOUNT per Customer. Ensure customers 
-- with no orders show up (likely as NULL or 0 depending on how you write the Average).

SELECT c.CUSTOMER_ID,c.FIRST_NAME,NVL(AVG(o.TOTAL_AMOUNT), 0) AS AVG_TOTAL_AMOUNT
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID, c.FIRST_NAME;

-- 38. (Cartesian/Cross) Count how many rows are generated if you Cross Join CUSTOMERS (5 rows)
--  and ORDERS (6 rows)

SELECT COUNT(*)
FROM CUSTOMERS
CROSS JOIN ORDERS;

-- 39. (Join with Date Comparison) Find Customers who placed an order on the same day their 
-- account was created? (Wait, we don't have account creation date. Instead: Find Orders placed 
-- after the shipping date? This checks for data errors).

SELECT c.CUSTOMER_ID,c.FIRST_NAME,o.ORDER_ID,o.ORDER_DATE,o.SHIPPING_DATE
FROM CUSTOMERS c
INNER JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE o.ORDER_DATE > o.SHIPPING_DATE;


-- 40. (Three-way Simulation) Advanced Challenge: Perform a Left Join from Customers to Orders,
--  and then Self Join that result to find Customers who have placed more than one order.

