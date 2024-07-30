-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema online_shopping
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema online_shopping
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `online_shopping` DEFAULT CHARACTER SET utf8 ;
USE `online_shopping` ;

-- -----------------------------------------------------
-- Table `online_shopping`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(45) NOT NULL,
  `category_desc` VARCHAR(45) NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `online_shopping`.`payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`payment` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `method` VARCHAR(45) NOT NULL,
  `payment_date` DATE NOT NULL,
  PRIMARY KEY (`payment_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `online_shopping`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`customer` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `fname` VARCHAR(45) NOT NULL,
  `lname` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` INT NOT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `online_shopping`.`store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`store` (
  `store_id` INT NOT NULL AUTO_INCREMENT,
  `store_name` VARCHAR(45) NULL,
  PRIMARY KEY (`store_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `online_shopping`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`address` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `street` VARCHAR(100) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(2) NOT NULL,
  `zipcode` VARCHAR(5) NOT NULL,
  `country` VARCHAR(30) NULL,
  `customer_id` INT NULL,
  `store_id` INT NULL,
  PRIMARY KEY (`address_id`),
  INDEX `fk_address_customer1_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_address_store1_idx` (`store_id` ASC) VISIBLE,
  CONSTRAINT `fk_address_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `online_shopping`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_address_store1`
    FOREIGN KEY (`store_id`)
    REFERENCES `online_shopping`.`store` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `online_shopping`.`coupon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`coupon` (
  `coupon_id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(10) NOT NULL,
  `discount_amount` DECIMAL(6,2) NOT NULL,
  `expriration_date` DATE NOT NULL,
  `start_date` DATE NOT NULL,
  `is_active` ENUM('yes', 'no') NOT NULL,
  PRIMARY KEY (`coupon_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `online_shopping`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`product` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(100) NOT NULL,
  `product_description` VARCHAR(200) NULL,
  `product_price` DECIMAL(6,2) NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `fk_product_category1_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk_product_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `online_shopping`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `online_shopping`.`review`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`review` (
  `review_id` INT NOT NULL AUTO_INCREMENT,
  `review_date` DATE NOT NULL,
  `comment` VARCHAR(200) NOT NULL,
  `product_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  PRIMARY KEY (`review_id`),
  INDEX `fk_review_product1_idx` (`product_id` ASC) VISIBLE,
  INDEX `fk_review_customer1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_review_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `online_shopping`.`product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `online_shopping`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `online_shopping`.`shipping`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`shipping` (
  `shipping_id` INT NOT NULL AUTO_INCREMENT,
  `method` VARCHAR(45) NOT NULL,
  `shipping_cost` DECIMAL(6,2) NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `address_id` INT NOT NULL,
  PRIMARY KEY (`shipping_id`),
  INDEX `fk_shipping_address1_idx` (`address_id` ASC) VISIBLE,
  CONSTRAINT `fk_shipping_address1`
    FOREIGN KEY (`address_id`)
    REFERENCES `online_shopping`.`address` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `online_shopping`.`order_sumary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`order_sumary` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `order_date` DATE NOT NULL,
  `customer_id` INT NOT NULL,
  `payment_id` INT NOT NULL,
  `shipping_id` INT NOT NULL,
  `coupon_id` INT NULL,
  `sub_total` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_orders_customers_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_order_payment1_idx` (`payment_id` ASC) VISIBLE,
  INDEX `fk_order_sumary_coupon1_idx` (`coupon_id` ASC) VISIBLE,
  INDEX `fk_order_sumary_shipping1_idx` (`shipping_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_customers`
    FOREIGN KEY (`customer_id`)
    REFERENCES `online_shopping`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_payment1`
    FOREIGN KEY (`payment_id`)
    REFERENCES `online_shopping`.`payment` (`payment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_sumary_coupon1`
    FOREIGN KEY (`coupon_id`)
    REFERENCES `online_shopping`.`coupon` (`coupon_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_sumary_shipping1`
    FOREIGN KEY (`shipping_id`)
    REFERENCES `online_shopping`.`shipping` (`shipping_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `online_shopping`.`store_products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`store_products` (
  `store_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  PRIMARY KEY (`store_id`, `product_id`),
  INDEX `fk_store_has_product_product1_idx` (`product_id` ASC) VISIBLE,
  INDEX `fk_store_has_product_store1_idx` (`store_id` ASC) VISIBLE,
  CONSTRAINT `fk_store_has_product_store1`
    FOREIGN KEY (`store_id`)
    REFERENCES `online_shopping`.`store` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_store_has_product_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `online_shopping`.`product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `online_shopping`.`order_has_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `online_shopping`.`order_has_product` (
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  PRIMARY KEY (`order_id`, `product_id`),
  INDEX `fk_order_has_product_product1_idx` (`product_id` ASC) VISIBLE,
  INDEX `fk_order_has_product_order1_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_has_product_order1`
    FOREIGN KEY (`order_id`)
    REFERENCES `online_shopping`.`order_sumary` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_has_product_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `online_shopping`.`product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- CRUD statements & Test Case SQL statements

-- CREATE {SELECT}
-- READ {SELECT}
-- UPDATE
-- DELETE

-- DELETE FROM customer;
-- DELETE FROM category;

-- =====================================================================
-- 1.CUSTOMER-----------------------------------------------------------
INSERT INTO customer 
(fname, lname, email, phone) 
VALUES 
('Angel', 'Green', 'angel@gmail.com','1234567890'),
('Emily', 'Brown', 'emily@gmail.com', '1231412589'),
('Olivia', 'White', 'olivia@gmail.com', '1232504567');

SELECT * FROM customer;

-- I can change Olivia's last name to Adam by using the UPDATE statement
-- UPDATE customer
-- SET lname = 'Adam'
-- WHERE customer_id = 3;

-- =====================================================================
-- 2.CATEGORY--------------------------------------------------------------
INSERT INTO category
(category_name, category_desc) 
VALUES 
('Clothing', 'Apparel and accessories'),
('Beauty & Health', 'Beauty products and health supplies'),
('Sports & Outdoors', 'Sporting goods and outdoor equipment');

SELECT * FROM category;

-- To find what products available in Beauty & Health category
SELECT c.category_name, p.product_name
FROM category c
JOIN product p 
ON p.category_id = c.category_id
WHERE category_name = 'Beauty & Health';

-- =====================================================================
-- 3.PRODUCT--------------------------------------------------------------------
INSERT INTO product
(product_name, product_description, product_price, category_id) 
VALUES 
('Summer Dress', 
'Lightweight summer dress with floral pattern', 
39.99, 
(SELECT category_id
FROM category
WHERE category_name = 'Clothing')
), 

('Sunscreen Lotion',
'SPF 50 sunscreen lotion for sun protection.',
29.99,
(SELECT category_id
FROM category
WHERE category_name = 'Beauty & Health')),

('Yoga Mat',
'Non-slip yoga mat for all types of yoga practice.',
19.99,
(SELECT category_id
FROM category
WHERE category_name = 'Sports & Outdoors')),

('Lipstick',
'Long-lasting lipstick in various shades.',
24.99,
(SELECT category_id
FROM category
WHERE category_name = 'Beauty & Health')),

('Denim Jacket',
'Stylish denim jacket with a comfortable fit.',
69.99,
(SELECT category_id
FROM category
WHERE category_name = 'Clothing')),

('Hiking Backpack',
'Spacious hiking backpack with multiple pockets.',
59.99,
(SELECT category_id
FROM category
WHERE category_name = 'Sports & Outdoors'));

SELECT * FROM product;

-- To find product details of product_name = 'Summer Dress' ==== UI2====
SELECT 
p.product_name, 
p.product_description, 
p.product_price, 
r.review_date, 
r.comment, 
c.fname
FROM product p 
JOIN review r
ON p.product_id = r.product_id
JOIN customer c
ON r.customer_id = c.customer_id
WHERE p.product_name = 'Summer Dress';

-- =====================================================================
-- 4.REVIEW-----------------------------------------------------------------
INSERT INTO review
(review_date, comment, product_id, customer_id) 
VALUES 
('2024-07-01',
'Comfortable and stylish. Will buy again.',
(SELECT product_id
FROM product
WHERE product_name = 'Summer Dress'),
(SELECT customer_id
FROM customer
WHERE fname = 'Olivia')),

('2024-07-02',
'Amazing product! Exceeded my expectations.',
(SELECT product_id
FROM product
WHERE product_name = 'Sunscreen Lotion'),
(SELECT customer_id
FROM customer
WHERE fname = 'Emily')),

('2024-07-05',
'Good value for money.',
(SELECT product_id
FROM product
WHERE product_name = 'Hiking Backpack'),
(SELECT customer_id
FROM customer
WHERE fname = 'Angel'));

SELECT * FROM review;

-- To see review about 'Hiking Backpack'
SELECT r.comment, r.review_date, c.fname AS customer
FROM customer c
JOIN review r
ON r.customer_id = c.customer_id
JOIN product p
ON r.product_id = p.product_id
WHERE product_name = 'Hiking Backpack';


-- =====================================================================
-- 5.STORE-----------------------------------------------------------------------
INSERT INTO store
(store_name)
VALUES
('Oak Store'),
('Maple Boutique'),
('Cedar Mall');

SELECT * FROM store;

-- To find the address of ALL stores ==== UI1====
SELECT 
s.store_name, 
CONCAT(street,', ', city,', ', state,', ', zipcode,', ',country) 
AS 'Store Address'
FROM store s
JOIN address a
ON s.store_id = a.store_id;
 
-- To find the address of Maple Boutique
SELECT s.store_name, CONCAT(street,', ', city,', ', state,', ', zipcode,', ',country) AS 'Store Address'
FROM store s
JOIN address a
ON s.store_id = a.store_id
WHERE s.store_name = 'Maple Boutique';

-- To find the address of Oak Store
SELECT s.store_name, CONCAT(street,', ', city,', ', state,', ', zipcode,', ',country) AS 'Store Address'
FROM store s
JOIN address a
ON s.store_id = a.store_id
WHERE s.store_name = 'Oak Store';

-- To find the address of Cedar Mall
SELECT s.store_name, CONCAT(street,', ', city,', ', state,', ', zipcode,', ',country) AS 'Store Address'
FROM store s
JOIN address a
ON s.store_id = a.store_id
WHERE s.store_name = 'Cedar Mall';


-- =====================================================================
-- 6.ADDRESS-----------------------------------------------------------------------
INSERT INTO address
(street, city, state, zipcode, country, customer_id, store_id) 
VALUES 
('123 Main St',
'San Francisco',
'CA', 
'94101',
'USA',
(SELECT customer_id
FROM customer
WHERE fname = 'Olivia'),
NULL),

('456 Pine Rd',
'Austin',
'TX',
'73301',
'USA',
(SELECT customer_id
FROM customer
WHERE fname = 'Angel'),
NULL),

('789 Walnut Ave',
'Portland',
'OR',
'97201',
'USA',
(SELECT customer_id
FROM customer
WHERE fname = 'Emily'),
NULL),

('780 Oak St', 
'Chicago', 
'IL',
'60601',
'USA',
NULL, 
(SELECT store_id
FROM store
WHERE store_name = 'Oak Store')),

('100 Maple St', 
'Phoenix', 
'AZ',
'85001',
'USA',
NULL, 
(SELECT store_id
FROM store
WHERE store_name = 'Maple Boutique')),

('900 Cedar St', 
'San Francisco', 
'CA',
'94101',
'USA',
NULL, 
(SELECT store_id
FROM store
WHERE store_name = 'Cedar Mall'));


SELECT * FROM address;

-- =====================================================================
-- 7.SHIPPING-----------------------------------------------------------------------
INSERT INTO shipping
(method, shipping_cost, status, address_id)
VALUES
('Standard',
10.00, 
'Delivered', 
(SELECT a.address_id
FROM address a 
JOIN customer c 
ON a.customer_id = c.customer_id
WHERE fname = 'Emily')),

('Overnight',
20.00,
'Shipped',
(SELECT a.address_id
FROM address a 
JOIN customer c 
ON a.customer_id = c.customer_id
WHERE fname = 'Angel')),

('Two-Day',
15.00, 
'Processing',
(SELECT a.address_id
FROM address a 
JOIN customer c 
ON a.customer_id = c.customer_id
WHERE fname = 'Olivia'));

SELECT * FROM shipping;

-- Change status of Standard shipping method to 'Shipped' instead of 'Delivered' (`shipping-id` = 1)
UPDATE shipping
SET status = 'Shipped'
WHERE address_id = (SELECT a.address_id
FROM address a 
JOIN customer c 
ON a.customer_id = c.customer_id
WHERE fname = 'Emily');


-- Change status of Overnight shipping method to 'Delivered' instead of 'Shipped' (`shipping-id` = 2)
UPDATE shipping
SET status = 'Delivered'
WHERE shipping_id = 2;


-- =====================================================================
-- 8.STORE_PRODUCTS-----------------------------------------------------------------------
INSERT INTO store_products
VALUES
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(2,2),
(2,3),
(2,6),
(3,1),
(3,2),
(3,3),
(3,4),
(3,5),
(3,6);

SELECT * from store_products;

-- To check the product in Cedar Mall
SELECT p. product_name, s.store_name
FROM product p 
JOIN store_products sp
ON p.product_id = sp.product_id
JOIN store s
ON s.store_id = sp.store_id
WHERE s.store_id = 3;

-- =====================================================================
-- 9.PAYMENT-----------------------------------------------------------------------
INSERT INTO payment
(method, payment_date)
VALUES
('Credit Card', '2024-07-01'),
('Debit Card', '2024-07-01'),
('PayPal', '2024-07-01');

SELECT * FROM payment;

-- =====================================================================
-- 10.COUPON-----------------------------------------------------------------------
INSERT INTO coupon
(code, discount_amount, expriration_date, start_date, is_active)
VALUES
('WELCOME20', 20.00, '2024-07-05', '2024-07-01', 'yes'),
('HURRY25', 25.00, '2025-07-10', '2024-07-06' , 'yes'),
('SUMMER20', 20.00, '2025-07-15', '2024-07-11' ,'yes');

SELECT * FROM coupon;

-- Change the expriration_date column to after start_date
-- ALTER TABLE coupon
-- MODIFY COLUMN expriration_date DATE AFTER start_date;

-- Update Is_active to No or Yes
UPDATE coupon
SET is_active = 'yes'
Where coupon_id = 3;

-- =====================================================================
-- 11.ORDER_SUMARY-----------------------------------------------------------------------// Need to add shipping costs
INSERT INTO order_sumary
(order_date, customer_id, payment_id, shipping_id, coupon_id, sub_total)
VALUES
-- Total_Amount = $32.09
('2024-07-01', 
(SELECT customer_id
FROM customer
WHERE fname = 'Emily'),
1,
(SELECT  s.shipping_id
FROM shipping s
JOIN address a 
ON a.address_id = s.address_id
JOIN customer c
ON a.customer_id = c.customer_id
WHERE fname = 'Emily'),
NULL, 
(SELECT ROUND((product_price + (product_price * 0.07)), 2) as item_total
FROM product p
WHERE p.product_name = 'Sunscreen Lotion')),


-- Total_Amount = $69.53
('2024-07-01', 
(SELECT customer_id
FROM customer
WHERE fname = 'Olivia'),
2,
(SELECT  s.shipping_id
FROM shipping s
JOIN address a 
ON a.address_id = s.address_id
JOIN customer c
ON a.customer_id = c.customer_id
WHERE fname = 'Olivia'),
NULL, 
(SELECT ROUND(SUM(product_price + (product_price * 0.07)), 2) as item_total
FROM product
WHERE product_name IN ('Summer Dress', 'Lipstick'))),

-- Total_Amount = $64.19
('2024-07-01', 
(SELECT customer_id
FROM customer
WHERE fname = 'Angel'),
3,
(SELECT  s.shipping_id
FROM shipping s
JOIN address a 
ON a.address_id = s.address_id
JOIN customer c
ON a.customer_id = c.customer_id
WHERE fname = 'Angel'),
3, 
(SELECT ROUND(SUM(product_price + (product_price * 0.07)), 2) as item_total
FROM product
WHERE product_name = 'Hiking Backpack'));

SELECT * FROM order_sumary;

-- change sub_total column to item_total
-- ALTER TABLE order_sumary
-- CHANGE COLUMN sub_total item_total DECIMAL(6,2);

-- Find Angel's order sumary with sub_total (use code SUMMER20)==== UI3====
SELECT 
cu.fname, 
cu.lname, 
p.product_name AS Merchandise, 
p.product_price AS Price, 
(- COALESCE(co.discount_amount, 0) ) AS Discounts, 
co.code, s.shipping_cost, s.method AS 'Shipping Method', 
(p.product_price * 0.07) AS Tax,
o.item_total, 
    (SELECT ROUND(SUM(p2.product_price + (p2.product_price * 0.07)) - COALESCE(co2.discount_amount, 0), 2) + 
            CASE 
                WHEN s2.method = 'Standard' THEN 10.00 
                WHEN s2.method = 'Two-Day' THEN 15.00 
                WHEN s2.method = 'Overnight' THEN 20.00 
                ELSE s2.shipping_cost 
            END
        FROM product p2
        JOIN order_has_product op2 
        ON p2.product_id = op2.product_id
        JOIN order_sumary o2 
        ON op2.order_id = o2.order_id
        JOIN shipping s2 
        ON o2.shipping_id = s2.shipping_id
        LEFT JOIN coupon co2 
        ON co2.coupon_id = o2.coupon_id
        WHERE o2.order_id = o.order_id
        GROUP BY o2.order_id, s2.shipping_cost, s2.method
    ) AS sub_total
FROM product p
JOIN order_has_product op 
ON p.product_id = op.product_id
JOIN order_sumary o 
ON op.order_id = o.order_id
LEFT JOIN coupon co 
ON co.coupon_id = o.coupon_id
JOIN customer cu 
ON o.customer_id = cu.customer_id
JOIN shipping s 
ON o.shipping_id = s.shipping_id
WHERE cu.fname = 'Angel';

-- Find Angel's order sumary with sub_total (use code SUMMER20)==== UI3==== 
-- (Expand- Using CASE with is_active = No from the coupon table)
SELECT cu.fname, cu.lname, p.product_name AS Merchandise, p.product_price AS Price,
    (-CASE 
        WHEN co.is_active = 'yes' THEN COALESCE(co.discount_amount, 0) 
        ELSE 0 
    END) AS Discounts,
    co.code,
    CASE 
        WHEN s.method = 'Standard' THEN 10.00 
        WHEN s.method = 'Two-Day' THEN 15.00 
        WHEN s.method = 'Overnight' THEN 20.00 
        ELSE s.shipping_cost 
    END AS 'Shipping Cost', 
    s.method AS 'Shipping Method', 
    (p.product_price * 0.07) AS Tax,
    o.item_total, 
    (SELECT ROUND(
            SUM(p2.product_price + (p2.product_price * 0.07) - CASE 
                WHEN co2.is_active = 'yes' THEN COALESCE(co2.discount_amount, 0) 
                ELSE 0 
            END), 2) + 
            CASE 
                WHEN s2.method = 'Standard' THEN 10.00 
                WHEN s2.method = 'Two-Day' THEN 15.00 
                WHEN s2.method = 'Overnight' THEN 20.00 
                ELSE s2.shipping_cost 
            END
        FROM product p2
        JOIN order_has_product op2 
        ON p2.product_id = op2.product_id
        JOIN order_sumary o2 
        ON op2.order_id = o2.order_id
        JOIN shipping s2 
        ON o2.shipping_id = s2.shipping_id
        LEFT JOIN coupon co2 
        ON co2.coupon_id = o2.coupon_id
        WHERE o2.order_id = o.order_id
        GROUP BY o2.order_id, s2.shipping_cost, s2.method
    ) AS sub_total
FROM product p
JOIN order_has_product op 
ON p.product_id = op.product_id
JOIN order_sumary o 
ON op.order_id = o.order_id
LEFT JOIN coupon co 
ON co.coupon_id = o.coupon_id
JOIN customer cu 
ON o.customer_id = cu.customer_id
JOIN shipping s 
ON o.shipping_id = s.shipping_id
WHERE cu.fname = 'Angel';

-- Find Olivia's order sumary with sub_total=== use the COALESCE function, which returns the first non-null value in the list
SELECT 
    cu.fname, 
    cu.lname,
    p.product_name AS Merchandise, 
    p.product_price AS Price, 
    (-COALESCE(co.discount_amount, 0)) AS Discounts, 
    co.code,
    CASE 
        WHEN s.method = 'Standard' THEN 10.00 
        WHEN s.method = 'Two-Day' THEN 15.00 
        WHEN s.method = 'Overnight' THEN 20.00 
        ELSE s.shipping_cost 
    END AS 'Shipping Cost', 
    s.method AS 'Shipping Method', 
    (p.product_price * 0.07) AS Tax,
    o.item_total, 
    (
        SELECT ROUND(
            SUM(p2.product_price + (p2.product_price * 0.07) - COALESCE(co2.discount_amount, 0)), 2) + s2.shipping_cost
        FROM product p2
        JOIN order_has_product op2 
        ON p2.product_id = op2.product_id
        JOIN order_sumary o2 
        ON op2.order_id = o2.order_id
        JOIN shipping s2 
        ON o2.shipping_id = s2.shipping_id
        LEFT JOIN coupon co2 
        ON co2.coupon_id = o2.coupon_id
        WHERE p2.product_name IN ('Summer Dress', 'Lipstick')
        GROUP BY s2.shipping_cost
    ) AS sub_total
FROM product p
JOIN order_has_product op 
ON p.product_id = op.product_id
JOIN order_sumary o 
ON op.order_id = o.order_id
LEFT JOIN coupon co 
ON co.coupon_id = o.coupon_id
JOIN customer cu 
ON o.customer_id = cu.customer_id
JOIN shipping s 
ON o.shipping_id = s.shipping_id
WHERE cu.fname = 'Olivia';


-- Find Emily's order sumary with sub_total=== use the COALESCE function, which returns the first non-null value in the list
SELECT 
    cu.fname, 
    cu.lname,
    p.product_name, 
    p.product_price AS Merchandise, 
    (-COALESCE(co.discount_amount, 0)) AS Discounts, 
    co.code,
	CASE 
        WHEN s.method = 'Standard' THEN 10.00 
        WHEN s.method = 'Two-Day' THEN 15.00 
        WHEN s.method = 'Overnight' THEN 20.00 
        ELSE s.shipping_cost 
    END AS 'Shipping Cost', 
    s.method AS 'Shipping Method', 
    (p.product_price * 0.07) AS Tax,
    o.item_total, 
    (
        SELECT ROUND(
            SUM(p2.product_price + (p2.product_price * 0.07) - COALESCE(co2.discount_amount, 0)), 2) + s2.shipping_cost
        FROM product p2
        JOIN order_has_product op2 
        ON p2.product_id = op2.product_id
        JOIN order_sumary o2 
        ON op2.order_id = o2.order_id
        JOIN shipping s2 
        ON o2.shipping_id = s2.shipping_id
        LEFT JOIN coupon co2 
        ON co2.coupon_id = o2.coupon_id
        WHERE p2.product_name = 'Sunscreen Lotion'
        GROUP BY s2.shipping_cost
    ) AS sub_total
FROM product p
JOIN order_has_product op 
ON p.product_id = op.product_id
JOIN order_sumary o 
ON op.order_id = o.order_id
LEFT JOIN coupon co 
ON co.coupon_id = o.coupon_id
JOIN customer cu 
ON o.customer_id = cu.customer_id
JOIN shipping s 
ON o.shipping_id = s.shipping_id
WHERE cu.fname = 'Emily';

-- =====================================================================
-- 12.ORDER_HAS_PRODUCT-----------------------------------------------------------------------
INSERT INTO order_has_product
(order_id, product_id)
VALUES
(1, 2),
(2, 1),
(2, 4),
(3, 6);

SELECT * FROM order_has_product
ORDER BY order_id;

-- Test what products in order_id = 2, fname = 'Olivia' (shopping bag)
SELECT c.fname, c.lname, p.product_name, p.product_price
FROM customer c
JOIN order_sumary o 
ON c.customer_id = o.customer_id
JOIN order_has_product op
ON o.order_id = op.order_id
JOIN product p 
ON p.product_id = op.product_id
WHERE o.order_id = 2;

-- Test what products in order_id = 3, fname = 'Angel' (shopping bag)
SELECT c.fname, c.lname, p.product_name, p.product_price
FROM customer c
JOIN order_sumary o 
ON c.customer_id = o.customer_id
JOIN order_has_product op
ON o.order_id = op.order_id
JOIN product p 
ON p.product_id = op.product_id
WHERE o.order_id = 3;


-- Test what products in order_id = 1, fname = 'Emily' (shopping bag)
SELECT c.fname, c.lname, p.product_name, p.product_price
FROM customer c
JOIN order_sumary o 
ON c.customer_id = o.customer_id
JOIN order_has_product op
ON o.order_id = op.order_id
JOIN product p 
ON p.product_id = op.product_id
WHERE o.order_id = 1;

-- ======================================================================
-- PONDERING:

-- Sub_total can be "nullable" in Order_sumary then I can add quantity to the order_has_product table. 
-- how NULL in coupon table affect order sumary with sub_total, YES! NULL + 0 = NULL. Therefore, I should use COALESCE function or set if value = NUll then let it be 0. 
--  I could add payment_status, created_at, updated_at for further better details in payment table. Additionally, I can add payment_total in the payment table. What if a cx wants to pay with 2 different payments for 1 order? WHat a good point!
-- Should I add customer_id into Payment? Checked, It would be better in the order_summary table
-- How to better design this ERD? Checked!