/* =========================================
   Ecommerce Data Analysis (MS SQL Server)
   Author: Prasad
========================================= */

-- Use Database
USE ecommerce_project;

------------------------------------------
-- 1. Preview Data
------------------------------------------
SELECT TOP 10 *
FROM olist_orders_dataset;

------------------------------------------
-- 2. Total Orders
------------------------------------------
SELECT COUNT(*) AS total_orders
FROM olist_orders_dataset;

------------------------------------------
-- 3. Orders by Status
------------------------------------------
SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

------------------------------------------
-- 4. Orders Trend (Year-Month)
------------------------------------------
SELECT 
    YEAR(order_purchase_timestamp) AS year,
    MONTH(order_purchase_timestamp) AS month,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY 
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY year, month;

------------------------------------------
-- 5. Daily Orders Trend
------------------------------------------
SELECT TOP 1
    YEAR(order_purchase_timestamp) AS year,
    MONTH(order_purchase_timestamp) AS month,
    DAY(order_purchase_timestamp) AS day,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY 
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp),
    DAY(order_purchase_timestamp)
ORDER BY total_orders DESC;

------------------------------------------
-- 6. Total Customers
------------------------------------------
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM olist_orders_dataset;

------------------------------------------
-- 7. Top Customers (By Orders)
------------------------------------------
SELECT TOP 10
    customer_id,
    COUNT(order_id) AS total_orders
FROM olist_orders_dataset
GROUP BY customer_id
ORDER BY total_orders DESC;

------------------------------------------
-- 8. Revenue Analysis (Monthly)
------------------------------------------
SELECT 
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
GROUP BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY year, month;

------------------------------------------
-- 9. Top Products by Sales
------------------------------------------
SELECT TOP 10
    product_id,
    COUNT(*) AS total_sold
FROM olist_order_items_dataset
GROUP BY product_id
ORDER BY total_sold DESC;

------------------------------------------
-- 10. Average Price
------------------------------------------
SELECT AVG(price) AS avg_price
FROM olist_order_items_dataset;

------------------------------------------
-- 11. Total Revenue
------------------------------------------
SELECT SUM(price) AS total_revenue
FROM olist_order_items_dataset;

------------------------------------------
-- 12. Delivery Performance
------------------------------------------
SELECT 
    AVG(DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date)) 
    AS avg_delivery_days
FROM olist_orders_dataset
WHERE order_status = 'delivered';

------------------------------------------
-- 13. Late Deliveries Count
------------------------------------------
SELECT COUNT(*) AS late_deliveries
FROM olist_orders_dataset
WHERE order_delivered_customer_date > order_estimated_delivery_date;

------------------------------------------
-- 14. Late Delivery Percentage
------------------------------------------
SELECT 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_orders_dataset) 
    AS late_delivery_percentage
FROM olist_orders_dataset
WHERE order_delivered_customer_date > order_estimated_delivery_date;

------------------------------------------
-- 15. Top Cities by Revenue
------------------------------------------
SELECT TOP 10
    c.customer_city,
    SUM(oi.price) AS revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi 
    ON o.order_id = oi.order_id
JOIN olist_customers_dataset c 
    ON o.customer_id = c.customer_id
GROUP BY c.customer_city
ORDER BY revenue DESC;

------------------------------------------
-- 16. Top Categories by Revenue
------------------------------------------
SELECT TOP 10
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;