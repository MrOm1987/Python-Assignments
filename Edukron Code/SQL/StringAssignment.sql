-- CREATE TABLE Orders (
--     Order_ID INT PRIMARY KEY,
--     Order_Date DATE,
--     Customer_ID VARCHAR(10),
--     Customer_Name VARCHAR(100),
--     Product_Category VARCHAR(100),
--     Product_Name VARCHAR(150),
--     Quantity INT,
--     Unit_Price DECIMAL(10,2),
--     Payment_Mode VARCHAR(50),
--     Store_Location VARCHAR(100)
-- );

-- INSERT INTO Orders
-- (Order_ID, Order_Date, Customer_ID, Customer_Name, Product_Category, Product_Name, Quantity, Unit_Price, Payment_Mode, Store_Location)
-- VALUES
-- (1001, DATE'2026-02-01', 'C001', 'Ravi Kumar', 'Electronics', 'Wireless Mouse', 2, 799, 'UPI', 'Bangalore');

-- INSERT INTO Orders
-- (Order_ID, Order_Date, Customer_ID, Customer_Name, Product_Category, Product_Name, Quantity, Unit_Price, Payment_Mode, Store_Location)
-- VALUES
-- (1002, DATE'2026-02-02', 'C002', 'Sneha Reddy', 'Grocery', 'Basmati Rice 5kg', 1, 650, 'Credit Card', 'Hyderabad');

-- INSERT INTO Orders
-- (Order_ID, Order_Date, Customer_ID, Customer_Name, Product_Category, Product_Name, Quantity, Unit_Price, Payment_Mode, Store_Location)
-- VALUES
-- (1003, DATE'2026-02-03', 'C003', 'Arjun Mehta', 'Fashion', 'Men''s T-Shirt', 3, 499, 'Cash', 'Chennai');

-- INSERT INTO Orders
-- (Order_ID, Order_Date, Customer_ID, Customer_Name, Product_Category, Product_Name, Quantity, Unit_Price, Payment_Mode, Store_Location)
-- VALUES
-- (1004, DATE'2026-02-04', 'C004', 'Priya Sharma', 'Electronics', 'Bluetooth Speaker', 1, 1499, 'Debit Card', 'Mumbai');

-- INSERT INTO Orders
-- (Order_ID, Order_Date, Customer_ID, Customer_Name, Product_Category, Product_Name, Quantity, Unit_Price, Payment_Mode, Store_Location)
-- VALUES
-- (1005, DATE'2026-02-05', 'C005', 'Kiran Rao', 'Home and Kitchen', 'Mixer Grinder', 1, 2499, 'UPI', 'Bangalore');

-- INSERT INTO Orders
-- (Order_ID, Order_Date, Customer_ID, Customer_Name, Product_Category, Product_Name, Quantity, Unit_Price, Payment_Mode, Store_Location)
-- VALUES
-- (1006, DATE'2026-02-06', 'C006', 'Neha Verma', 'Beauty', 'Face Cream', 4, 299, 'Credit Card', 'Delhi');

-- INSERT INTO Orders
-- (Order_ID, Order_Date, Customer_ID, Customer_Name, Product_Category, Product_Name, Quantity, Unit_Price, Payment_Mode, Store_Location)
-- VALUES
-- (1007, DATE'2026-02-07', 'C007', 'Rahul Das', 'Grocery', 'Cooking Oil 1L', 5, 180, 'Cash', 'Kolkata');

-- INSERT INTO Orders
-- (Order_ID, Order_Date, Customer_ID, Customer_Name, Product_Category, Product_Name, Quantity, Unit_Price, Payment_Mode, Store_Location)
-- VALUES
-- (1008, DATE'2026-02-08', 'C008', 'Anjali Nair', 'Fashion', 'Women''s Jeans', 2, 1199, 'UPI', 'Kochi');

-- INSERT INTO Orders
-- (Order_ID, Order_Date, Customer_ID, Customer_Name, Product_Category, Product_Name, Quantity, Unit_Price, Payment_Mode, Store_Location)
-- VALUES
-- (1009, DATE'2026-02-09', 'C009', 'Suresh Patel', 'Electronics', 'Smartphone', 1, 15999, 'Debit Card', 'Ahmedabad');

-- INSERT INTO Orders
-- (Order_ID, Order_Date, Customer_ID, Customer_Name, Product_Category, Product_Name, Quantity, Unit_Price, Payment_Mode, Store_Location)
-- VALUES
-- (1010, DATE'2026-02-10', 'C010', 'Meena Iyer', 'Home & Kitchen', 'Pressure Cooker', 1, 1899, 'Credit Card', 'Pune');


-- select * from ORDERS;
-----------------------------------------------------
-- STRING FUNCTIONS – 20 Questions
-- -----------------------------------------------------
-- 1)Write a query to convert all customer names to uppercase.
select upper(CUSTOMER_NAME) from ORDERS;

-- 2) Extract the first 5 characters from Product_Name.
SELECT substr(Product_Name, 1, 5) from ORDERS;

-- 3) Find the length of each Customer_Name.
SELECT  CUSTOMER_NAME,length(CUSTOMER_NAME) as Neme_Length from ORDERS;

-- 4) Replace the word "Rice" with "Premium Rice" in Product_Name.
select replace(Product_Name, 'Rice', 'Premium Rice') from ORDERS;

-- 5) Remove leading and trailing spaces from Customer_Name.
SELECT LTRIM(RTRIM(CUSTOMER_NAME)) from ORDERS;

-- 6) Concatenate First_Name and Last_Name as Full_Name.
SELECT first_name ||''||Last_name as Full_Name from ORDERS;

-- 7) Find customers whose names start with 'A'.
select CUSTOMER_NAME from ORDERS WHERE CUSTOMER_NAME LIKE 'A%';

-- 8) Extract the domain name from Email_ID.
select substr(Email_ID, INSTR(Email_ID, '@') + 1) As DomainName from ORDERS;

-- 9)Find the position of '@' in Email_ID.
select INSTR(Email_ID, '@') from ORDERS;

-- 10) Reverse the Product_Name.
select Product_Name, Reverse(Product_Name) as Reversed_Name from orders;

-- 11) Convert the first letter of each word in Product_Name to uppercase.
select INITCAP(Product_Name) from ORDERS;

-- 12)Extract the last 3 characters from Order_ID.
select substr(Order_ID, -3) from ORDERS;

-- 13) Count how many times letter 'a' appears in Customer_Name.
select Customer_Name, length(CUSTOMER_NAME) - length(replace(CUSTOMER_NAME, 'a', '')) As CountOf_a from ORDERS;

-- 14)Mask the last 4 digits of a phone number
SELECT RPAD(SUBSTR(phone_number, 1, LENGTH(phone_number) - 4), LENGTH(phone_number), '*') AS masked_phone
FROM ORDERS;

-- 15) Split Full_Name into First_Name and Last_Name.
select CUSTOMER_NAME,substr(CUSTOMER_NAME, 1, instr(CUSTOMER_NAME, ' ') - 1) as First_Name,
        substr(CUSTOMER_NAME, instr(CUSTOMER_NAME, ' ') + 1) as Last_Name
 from ORDERS;

--  16) Remove all special characters from Product_Code.
SELECT REGEXP_REPLACE(Product_Code, '[^A-Za-z0-9]', '') AS Clean_Product_Code
FROM ORDERS;

-- 17) Compare two columns ignoring case sensitivity.
select * from ORDERS WHERE upper(CUSTOMER_NAME) = upper(PRODUCT_NAME);

-- 18) Find customers whose name contains 'kumar'
select Customer_Name from ORDERS WHERE CUSTOMER_NAME like '%Kumar%';

-- 19) Pad Order_ID with leading zeros to make it 6 digits.
select LPAD(Order_ID, 6, 0) from ORDERS;

-- 20) Extract substring between two characters. 
SELECT SUBSTR(
           Product_Code,
           INSTR(Product_Code, '(') + 1,
           INSTR(Product_Code, ')', INSTR(Product_Code, '(') + 1) 
             - INSTR(Product_Code, '(') - 1
       ) AS Extracted_Text
FROM your_table;
