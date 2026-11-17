
-- 03_star_schema.sql
-- Builds 4 dimensions and 2 fact tables.

-- Dimension 1: Customers
CREATE OR REPLACE TABLE dim_customer AS
SELECT
    customer_unique_id AS customer_key,
    any_value(customer_state) AS customer_state,
    any_value(customer_city) AS customer_city
FROM raw_customers
GROUP BY customer_unique_id;

-- Dimension 2: Products
CREATE OR REPLACE TABLE dim_product AS
SELECT
    p.product_id AS product_key,
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'unknown'
    ) AS category,
    p.product_weight_g,
    p.product_photos_qty
FROM raw_products p
LEFT JOIN raw_category_translation t
    ON p.product_category_name = t.product_category_name;

-- Dimension 3: Sellers
CREATE OR REPLACE TABLE dim_seller AS
SELECT
    seller_id AS seller_key,
    seller_city,
    seller_state
FROM raw_sellers;

-- Dimension 4: Dates
CREATE OR REPLACE TABLE dim_date AS
SELECT
    CAST(d AS DATE) AS date_key,
    year(d) AS year,
    month(d) AS month,
    strftime(d, '%Y-%m') AS year_month,
    quarter(d) AS quarter,
    dayname(d) AS weekday
FROM range(
    DATE '2016-01-01',
    DATE '2019-01-01',
    INTERVAL 1 DAY
) AS r(d);

-- Fact 1: Orders
CREATE OR REPLACE TABLE fact_orders AS
WITH reviews AS (
    SELECT order_id, review_score
    FROM raw_reviews
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY order_id
        ORDER BY review_answer_timestamp DESC
    ) = 1
),
payments AS (
    SELECT
        order_id,
        SUM(payment_value) AS order_value
    FROM raw_payments
    GROUP BY order_id
)
SELECT
    o.order_id,
    c.customer_unique_id AS customer_key,
    CAST(o.order_purchase_timestamp AS DATE) AS order_date,
    o.order_status,
    p.order_value,
    date_diff(
        'day',
        o.order_purchase_timestamp,
        o.order_delivered_customer_date
    ) AS delivery_days,
    date_diff(
        'day',
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date
    ) AS days_late,
    CASE
        WHEN o.order_delivered_customer_date IS NULL THEN NULL
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date THEN 1
        ELSE 0
    END AS is_late,
    r.review_score
FROM raw_orders o
JOIN raw_customers c
    ON o.customer_id = c.customer_id
LEFT JOIN payments p
    ON o.order_id = p.order_id
LEFT JOIN reviews r
    ON o.order_id = r.order_id;

-- Fact 2: Order Items
CREATE OR REPLACE TABLE fact_order_items AS
SELECT
    i.order_id,
    i.order_item_id,
    i.product_id AS product_key,
    i.seller_id AS seller_key,
    c.customer_unique_id AS customer_key,
    CAST(o.order_purchase_timestamp AS DATE) AS order_date,
    o.order_status,
    i.price,
    i.freight_value
FROM raw_order_items i
JOIN raw_orders o
    ON i.order_id = o.order_id
JOIN raw_customers c
    ON o.customer_id = c.customer_id;
