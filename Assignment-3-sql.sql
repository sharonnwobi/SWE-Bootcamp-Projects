-- Assignment 3: I am going to make a database for the efficient runnig og an ecommerce jewellery store. The jewellery store wants to have a scheduled sale date in a week.
-- they would like their inventory to show which items are qualified to go on sale (based their stock quantity) and for each sale item,
-- we want to see how many we sell over the sale season. 

DROP DATABASE jewellery; -- Use this to restart the programming process

CREATE DATABASE jewellery;
USE jewellery;
-- Creating my 1st table in the database. This table holds the important information on all items in the store.
CREATE TABLE inventory(
item_sku VARCHAR(10) PRIMARY KEY , 
item_name VARCHAR(250),
jewellery_type VARCHAR(250),
restock_quantity INT,
current_quantity INT,
material VARCHAR(250),
unit_price FLOAT(2) NOT NULL, 
sale_price FLOAT(2));

-- Now, i will add a constraint to only allow items in the inventory that have a positive profit margin
ALTER TABLE inventory
ADD CONSTRAINT check_profit_positive CHECK (unit_price > 0.00);

-- MAKING A FUNCTION THAT WILL AUTOMATICALLY ADD VALUES INTO MY TABLE
USE jewellery
DELIMITER //
CREATE PROCEDURE inventory_sproc
(item_sku VARCHAR(100), 
item_name VARCHAR(250),
jewellery_type VARCHAR(250),
restock_quantity INT,
current_quantity INT,
material VARCHAR(250),
unit_price FLOAT(2), 
sale_price FLOAT(2))
BEGIN 
	INSERT INTO inventory 
    (item_sku, item_name, jewellery_type, restock_quantity, current_quantity, material, unit_price, sale_price)
    VALUES 
    (item_sku, item_name, jewellery_type, restock_quantity, current_quantity, material, unit_price, sale_price);
END//
DELIMITER ;
-- ETERING VALUES INTO MY TABLE: Stored pproceedures, concat function, 

CALL inventory_sproc('VS01', 'zara ring', 'ring', 15, 0, 'stainless steel', 5.09, 39.99);
CALL inventory_sproc('VS02', 'dara ring', 'ring', 15, 10, 'stainless steel', 5.99, 34.99);
CALL inventory_sproc('VS03', 'fara ring', 'ring', 10, 6, 'sterling silver', 4.99, 29.99);
CALL inventory_sproc('VS04', 'gold ring', 'ring', 15, 3, '14k gold', 19.99, 129.99);
CALL inventory_sproc('VS05', 'silver ring', 'ring', 10, 6, 'sterling silver',  13.99, 49.99);
CALL inventory_sproc('VS06', 'tennis bracelet', 'bracelet', 10, 7, CONCAT('cubic zirconia', ' ', 'sterling silver'), 17.99, 89.99);
CALL inventory_sproc('VS07', 'gold bracelet', 'bracelet', 10, 0, '14k gold', 33.99, 189.99);
CALL inventory_sproc('VS08', 'zara bracelet', 'bracelet', 10, 2, 'stainless steel', 5.09, 39.99);
CALL inventory_sproc('VS09', 'zara necklace', 'necklace', 10, 9, 'stainless steel', 7.99, 49.99);
CALL inventory_sproc('VS10', 'tennis chain', 'necklace', 15, 3, CONCAT('cubic zirconia', ' ', 'sterling silver'), 24.99, 139.99);
CALL inventory_sproc('VS11', 'fara necklace', 'necklace', 10, 10, ' sterling silver', 8.99, 59.99);
CALL inventory_sproc('VS12', 'silver necklace', 'necklace', 15, 8, 'sterling silver', 9.09, 69.99);

SELECT * FROM inventory; -- This query allows us to view our inventory table


-- CREATING MY 2ND TABLE USING SELF LEFT JOIN, ORDER BY AND VIEWS
-- THIS TABLE WILL SHOW THE CLIENT WHICH ITEMS ARE ELIGIBLE FOR THE ANNUAL SALE
-- WE HAVE BEEN TOLD, WE ONLY WANT ITEMS THAT HAVE  60% OR MORE OF THEIR RESTOCK QUANTITY REMAINING.

USE jewellery;
CREATE TABLE inventory_analysis (item_sku VARCHAR(200), item_name VARCHAR(250), current_quantity INT, restock_quantity INT);
INSERT INTO inventory_analysis
SELECT i1.item_sku, i1.item_name, i2.current_quantity, i2.restock_quantity -- selecting columns we want to join
FROM inventory i2 LEFT JOIN inventory i1 -- i1 & i2 are alias we have set here, 
ON i1.item_sku = i2.item_sku; -- joining condition 
SELECT * FROM inventory_analysis;

-- I now want to add an extra column to show the percentage of current_quantity in relation to the restock_quantity 

ALTER TABLE inventory_analysis 
ADD COLUMN current_quantity_percentage INT;
SET SQL_SAFE_UPDATES = 0; -- turning off safe UPDATE mode, to enable my update the empty column without adding extra rows or specifying a were condition 
UPDATE inventory_analysis SET current_quantity_percentage = FLOOR((current_quantity/restock_quantity) * 100); -- adding the calculation into my aggregatefunction to obtain the percentge
-- Now i will set the item_sku as a foreign key that references the inventory table
ALTER TABLE inventory_analysis 
ADD CONSTRAINT item_sku_pk FOREIGN KEY (item_sku) REFERENCES inventory (item_sku);

-- WE WANT TO SEE THE ITEMS THAT ARE ACTUALLY ELIGIBLE FOR THIS SALE 
-- SO, I AM WRITING A QUERY TO SHOW ONLY THE PRODUCTS WITH 60% OR MORE STOCK PERCENTAGE, IN DESCENDING ORDER
CREATE VIEW sale_eligible_items
AS
SELECT * FROM inventory_analysis i 
WHERE i.current_quantity_percentage >= 60 
ORDER BY i.current_quantity_percentage DESC;

-- TO SEE ALL SALE ELIGIBLE ITEMS RUN THE LINE OF CODE BELOW
SELECT * FROM sale_eligible_items;

--
-- 
-- THE CLIENT WOULD BE GREATEFUL IF THERE WAS AN EASY WAY TO CHECK IF A PRODUCT IS IN STOCK, 
-- THIS WILL COME IN HANDY DURING BUSY SALE PERIODS AND WILL REDUCE BACK ORDERS
-- TO DO THIS, I WILL WRITE STORED PROCEDURE TO RETURN THE STOCK QUANTITY OF A SPECIFC ITEM 
-- IDEALLY TO BE USED BEFORE AN ORDER IS FINALISED.
DELIMITER //
CREATE PROCEDURE check_stock
(item VARCHAR(200))
BEGIN 
SELECT i.item_sku, i.item_name, i.current_quantity FROM inventory i
WHERE i.item_sku = item OR i.item_name = item;
END //
DELIMITER ;
-- Example, to check the stock count of 'zara ring', you would type "CALL check_stock('VS01')" or "CALL check_Stock('zara ring')";


-- CREATING MY 3RD TABLE CALLED ORDERS. 
-- This will be used to document mock orders from on the annual sale.


USE jewellery;
CREATE TABLE orders (
order_number INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
order_date DATE,
first_name VARCHAR (200) NOT NULL,
last_name VARCHAR(200) NOT NULL,
email_address VARCHAR(200),
order_total INT NOT NULL
); 
ALTER TABLE orders AUTO_INCREMENT=1000; 
-- settng auto increment to start at the 1000, as this is the format of their order numbers :)

-- MAKING A STORED PROCEEDURE TO INPUT DATA INTO MY TABLE
USE jewellery
DELIMITER //
CREATE PROCEDURE orders_sproc
	(
	order_date DATE,
	first_name VARCHAR(250),
	last_name VARCHAR (250),
	email_address VARCHAR (250),
	order_total FLOAT(2))
BEGIN 
	INSERT INTO orders 
    (order_date, first_name, last_name, email_address, order_total)
    VALUES 
    (order_date, first_name, last_name, email_address, order_total);
END//
DELIMITER ;

-- ADDING DATA INTO MY ORDERS TABLE

CALL orders_sproc('2024-09-09', 'mary', 'miller', 'mm@sky.com', 100.00);
CALL orders_sproc ('2024-09-09', 'philip', 'peters', 'pp@gmail.com',100.00);
CALL orders_sproc ('2024-09-09', 'barry', 'bones', 'bb@gmail.com', 100.00);
CALL orders_sproc ('2024-09-09', 'amy', 'anther', 'aa@yahoo.com', 100.00);
CALL orders_sproc ('2024-09-09', 'fay', 'fuller', 'ff@outlook.com', 100.00);
CALL orders_sproc ('2024-09-09', 'gary', 'grey', 'gg@gmail.com', 100.00);
CALL orders_sproc ('2024-09-09', 'telly', 'tiara', 't@gmail.com', 100.00);
CALL orders_sproc ('2024-09-09', 'havard', 'henry', 'hh@gmail.com', 100.00);
CALL orders_sproc ('2024-09-09', 'ursla', 'unniform', 'uu@gmail.com', 100.00);
CALL orders_sproc ('2024-09-09', 'zai', 'zebra', 'zz@gmail.com', 100.00);
CALL orders_sproc ('2024-09-09', 'nea', 'nee', 'nn@gmail.com', 100.00);
CALL orders_sproc ('2024-09-09', 'nea', 'nee', 'nn@gmail.com', 100.00);
SELECT * FROM orders;
--  DELETING A DUPLICATE ORDER ---
DELETE FROM orders WHERE order_number = 1011 ;
-- FOR A SUMMARY OF ALL YOUR SALE ORDERS, RUN THE LINE OF CODE BELOW
SELECT * FROM orders;



-- CREATING MY 4TH TABLE CALLED purchases
-- The aim of this table is to record individual items purchased from the store in the sale period.
SELECT * FROM orders;
USE jewellery;
CREATE TABLE purchases (
	item_sku VARCHAR(200) NOT NULL,
    quantity INT,
    order_number INT,
    order_date DATE,
    sale_price FLOAT(2),
    FOREIGN KEY (item_sku) REFERENCES inventory (item_sku) -- connecting item _sku to that on the inventory table
    );
-- ADDING A CONSTRAINT (FOREIGN KEY) LINKING THIS TABLE TO THE INVENTORY TABLE
ALTER TABLE purchases ADD CONSTRAINT order_number_fk 
FOREIGN KEY (order_number) REFERENCES orders (order_number);-- adding a foreign key that connects the order_number to the orders table 


-- CREATING A SPROC PROCEEDURE TO ADD DATA TO THIS TABLE 
USE jewellery
DELIMITER //
CREATE PROCEDURE purchases_sproc
	(item_sku VARCHAR(250),
	quantity INT,
	order_number INT,
	order_date DATE,
    sale_price FLOAT(2))
BEGIN 
	INSERT INTO purchases 
    (item_sku, quantity, order_number, order_date, sale_price)
    VALUES 
    (item_sku, quantity, order_number, order_date, sale_price);
END//
DELIMITER ;



--
CALL purchases_sproc('VS02', 4, 1001, '2024-09-09', 25.00);
CALL purchases_sproc('VS04', 1, 1002, '2024-09-09', 100.00);
CALL purchases_sproc('VS02', 4, 1003, '2024-09-09', 25.00);
CALL purchases_sproc('VS02', 2, 1004, '2024-09-09', 20.00);
CALL purchases_sproc('VS06', 1, 1004, '2024-09-09', 50.00);
CALL purchases_sproc('VS08', 1, 1004, '2024-09-09', 10.00);
CALL purchases_sproc('VS10', 1, 1005, '2024-09-09', 70.00);
CALL purchases_sproc('VS09', 2, 1005, '2024-09-09', 15.00);

-- TO VIEW THIS TABLE, JUST RUN THE LINE BELOW
SELECT * FROM purchases; 


-- TO WRAP UP, I WILL CREATE A VIEW OF ALL SOLD ITEMS AND THEIR RESPECTIVE QUANTITIES
-- I WILL DO THIS WITH A LEFT JOIN, AGGREGATE AND GROUP BY FUCNTIONS
CREATE VIEW items_sold
AS
SELECT i.item_name, p.item_sku, SUM(p.quantity) AS total_sold -- selecting columns we want to join
FROM purchases p LEFT JOIN inventory i -- i1 & i2 are alias we have set here, 
ON i.item_sku = p.item_sku GROUP BY p.item_sku;

-- TO VIEW INDIVIDUAL ITEMS SOLD THIS SEASON AND THIER RESPECTIVE QUANTITIES, RUN THE LINE OF CODE BELOW
 SELECT * FROM items_sold;
 
 
-- THANK YOU FOR TKAING THE TIME TO TRUST ME WITH YOUR E-COMMERCE DATABASE. 
-- I HOPE YOU ARE HAPPY WITH THE RESULTS :)

						-- GLOSSARY --
 -- TO VIEW THE INVENTORY TABLE RUN: SELECT * FROM inventory;  
 -- TO ADD AN ITEM TO YOUR INVENTORY RUN: CALL inventory_sproc('item sku', 'item name', 'jewellery category', restock quantity, current quantity, 'material ', unit price, market price); 
 -- TO VIEW SALE ELIGIBLE ITEMS RUN: SELECT * FROM sale_eligible_items;
 -- TO CHECK IF AN ITEM IS IN STOCK RUN: CALL check_Stock('item name'); or CALL check_Stock('item sku');
 -- TO ADD AN ORDER(CUSTOMERS DETAILS MAINLY) TO THE DATABASE RUN:  CALL orders_sproc ('order date (in format YYY-MM-DD)', 'first name', 'last name', 'email', order total(in format 00.00));
 -- TO SEE ALL ORDERS RUN: SELECT * FROM orders; 
 -- TO ADD A DETAILS ABOUT AN ORDER RUN: CALL purchases_sproc('item_sku', quantity, order number( orders table), 'order date (in format YYY-MM-DD)', item price(in format 00.00) );
-- TO VIEW THE PURCHASES TABLE RUN: SELECT * FROM purchases
-- TO VIEW WHICH ITEMS SOLD IN YOUR SALE RUN: SELECT * FROM items_sold
						-- THANK YOU --
 

