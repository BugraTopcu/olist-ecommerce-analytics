
-- 02_quality_checks.sql
-- Olist data quality checks

-- Check 1: Row counts
SELECT 'orders' AS table_name, COUNT(*) AS n_rows FROM raw_orders
UNION ALL SELECT 'order_items', COUNT(*) FROM raw_order_items
UNION ALL SELECT 'customers', COUNT(*) FROM raw_customers
UNION ALL SELECT 'payments', COUNT(*) FROM raw_payments
UNION ALL SELECT 'reviews', COUNT(*) FROM raw_reviews
UNION ALL SELECT 'products', COUNT(*) FROM raw_products
UNION ALL SELECT 'sellers', COUNT(*) FROM raw_sellers;

-- Check 2: Unique orders
SELECT COUNT(*) AS n_rows,
       COUNT(DISTINCT order_id) AS n_unique_orders
FROM raw_orders;

-- Check 3: Multiple reviews
SELECT COUNT(*) AS orders_with_several_reviews
FROM (
    SELECT order_id
    FROM raw_reviews
    GROUP BY order_id
    HAVING COUNT(*) > 1
);

-- Check 4: Order statuses
SELECT order_status, COUNT(*) AS n_orders
FROM raw_orders
GROUP BY order_status
ORDER BY n_orders DESC;

-- Check 5: Missing delivery dates
SELECT COUNT(*) AS delivered_without_date
FROM raw_orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NULL;

-- Check 6: Monthly orders
SELECT date_trunc('month', order_purchase_timestamp) AS month,
       COUNT(*) AS n_orders
FROM raw_orders
GROUP BY month
ORDER BY month;

-- Check 7: Missing product categories
SELECT COUNT(*) AS products_without_category
FROM raw_products
WHERE product_category_name IS NULL;

-- Check 8: Customer identifiers
SELECT COUNT(DISTINCT customer_id) AS customer_ids,
       COUNT(DISTINCT customer_unique_id) AS real_customers
FROM raw_customers;
