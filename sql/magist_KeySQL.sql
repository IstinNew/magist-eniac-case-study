-- Use the Magist database
USE magist;

-- Seller Analysis
-- Count the total number of unique sellers
SELECT COUNT(DISTINCT seller_id) AS total_sellers
FROM sellers;

-- Count the number of unique tech sellers by filtering relevant product categories
SELECT COUNT(DISTINCT oi.seller_id) AS tech_sellers
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id
JOIN product_category_name_translation AS pcnt ON p.product_category_name = pcnt.product_category_name
WHERE product_category_name_english LIKE '%electronic%' 
   OR product_category_name_english LIKE '%technolog%' 
   OR product_category_name_english LIKE '%computer%' 
   OR product_category_name_english LIKE '%software%' 
   OR product_category_name_english LIKE '%information%' 
   OR product_category_name_english LIKE '%industr%' 
   OR product_category_name_english LIKE '%tele%';

-- Calculate the percentage of tech sellers among total sellers
SELECT (COUNT(DISTINCT oi.seller_id) * 100.0 / (SELECT COUNT(DISTINCT seller_id) FROM sellers)) AS percentage_tech_sellers
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id
JOIN product_category_name_translation AS pcnt ON p.product_category_name = pcnt.product_category_name
WHERE product_category_name_english LIKE '%electronic%' 
   OR product_category_name_english LIKE '%technolog%' 
   OR product_category_name_english LIKE '%computer%' 
   OR product_category_name_english LIKE '%software%' 
   OR product_category_name_english LIKE '%information%' 
   OR product_category_name_english LIKE '%industr%' 
   OR product_category_name_english LIKE '%tele%';

-- Earning Analysis
-- Calculate the total amount earned by all sellers
SELECT SUM(oi.price) AS total_earned
FROM order_items AS oi;

-- Calculate the total amount earned by tech sellers
SELECT SUM(oi.price) AS tech_earned
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id
JOIN product_category_name_translation AS pcnt ON p.product_category_name = pcnt.product_category_name
WHERE product_category_name_english LIKE '%electronic%' 
   OR product_category_name_english LIKE '%technolog%' 
   OR product_category_name_english LIKE '%computer%' 
   OR product_category_name_english LIKE '%software%' 
   OR product_category_name_english LIKE '%information%' 
   OR product_category_name_english LIKE '%industr%' 
   OR product_category_name_english LIKE '%tele%';

-- Calculate the total amount earned and tech earnings percentage
WITH earnings AS (
  SELECT SUM(price) AS total_earned
  FROM order_items
),
tech_earnings AS (
  SELECT SUM(oi.price) AS tech_earned
  FROM order_items AS oi
  JOIN products AS p ON oi.product_id = p.product_id
  JOIN product_category_name_translation AS pcnt ON p.product_category_name = pcnt.product_category_name
  WHERE product_category_name_english LIKE '%electronic%' 
     OR product_category_name_english LIKE '%technolog%' 
     OR product_category_name_english LIKE '%computer%' 
     OR product_category_name_english LIKE '%software%' 
     OR product_category_name_english LIKE '%information%' 
     OR product_category_name_english LIKE '%industr%' 
     OR product_category_name_english LIKE '%tele%'
)
SELECT e.total_earned, te.tech_earned, (te.tech_earned / e.total_earned) * 100 AS tech_percentage
FROM earnings e, tech_earnings te;

-- Monthly Income Analysis
-- Calculate the average monthly income of all sellers
SELECT (SUM(oi.price) / TIMESTAMPDIFF(MONTH, MIN(oi.shipping_limit_date), MAX(oi.shipping_limit_date))) AS avg_monthly_income
FROM order_items AS oi;

-- Calculate the average monthly income of tech sellers
SELECT (SUM(oi.price) / TIMESTAMPDIFF(MONTH, MIN(oi.shipping_limit_date), MAX(oi.shipping_limit_date))) AS avg_monthly_tech_income
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id
JOIN product_category_name_translation AS pcnt ON p.product_category_name = pcnt.product_category_name
WHERE product_category_name_english LIKE '%electronic%'
   OR product_category_name_english LIKE '%technolog%'
   OR product_category_name_english LIKE '%computer%'
   OR product_category_name_english LIKE '%software%'
   OR product_category_name_english LIKE '%information%'
   OR product_category_name_english LIKE '%industr%'
   OR product_category_name_english LIKE '%tele%';
