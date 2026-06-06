SELECT *
FROM sales
LIMIT 10;
SELECT ROUND(SUM("TotalPrice")::numeric, 2) AS total_revenue
FROM sales;
SELECT COUNT(DISTINCT "Customer ID") AS total_customers
FROM sales;

--aVERAGE ORDER VALUE
SELECT ROUND(
    AVG(order_total)::numeric,
    2
) AS avg_order_value
FROM (
    SELECT "Invoice",
           SUM("TotalPrice") AS order_total
    FROM sales
    GROUP BY "Invoice"
) sub;
--SELECT ROUND(
    AVG(order_total)::numeric,
    2
) AS avg_order_value
FROM (
    SELECT "Invoice",
           SUM("TotalPrice") AS order_total
    FROM sales
    GROUP BY "Invoice"
) sub;
--Monthly Revenue Trend
SELECT
    DATE_TRUNC('month', "InvoiceDate"::timestamp) AS month,
    ROUND(SUM("TotalPrice")::numeric, 2) AS revenue
FROM sales
GROUP BY month
ORDER BY month;
--TOP 10 PRODUCTS BY REVENUE
SELECT
    "Description",
    ROUND(SUM("TotalPrice")::numeric, 2) AS revenue
FROM sales
GROUP BY "Description"
ORDER BY revenue DESC
LIMIT 10;
--TOP COUNTRIES BY REVENUE
SELECT
    "Country",
    ROUND(SUM("TotalPrice")::numeric, 2) AS revenue
FROM sales
GROUP BY "Country"
ORDER BY revenue DESC
LIMIT 10;
--TOP CUSTOMERS BY REVENUE
SELECT
    "Customer ID",
    ROUND(SUM("TotalPrice")::numeric, 2) AS revenue
FROM sales
GROUP BY "Customer ID"
ORDER BY revenue DESC
LIMIT 10;
--REPEAT CUSTOMERS
SELECT
    "Customer ID",
    COUNT(DISTINCT "Invoice") AS orders
FROM sales
GROUP BY "Customer ID"
HAVING COUNT(DISTINCT "Invoice") > 1
ORDER BY orders DESC;
--REPEAT PURCHASE RATE
WITH customer_orders AS (
    SELECT
        "Customer ID",
        COUNT(DISTINCT "Invoice") AS orders
    FROM sales
    GROUP BY "Customer ID"
)

SELECT
ROUND(
    (
        COUNT(
            CASE WHEN orders > 1 THEN 1 END
        ) * 100.0
    ) / COUNT(*),
    2
) AS repeat_purchase_rate
FROM customer_orders;
--REVENUE BY MONTH 
SELECT
    TO_CHAR(
        "InvoiceDate"::timestamp,
        'YYYY-MM'
    ) AS month,
    ROUND(SUM("TotalPrice")::numeric, 2) AS revenue
FROM sales
GROUP BY month
ORDER BY month;
--BEST SELLING PRODUCTS BY QUANTITY
SELECT
    "Description",
    SUM("Quantity") AS total_quantity
FROM sales
GROUP BY "Description"
ORDER BY total_quantity DESC
LIMIT 10;
--REVENUE PER CUSTOMER
SELECT
    ROUND(
        SUM("TotalPrice") /
        COUNT(DISTINCT "Customer ID"),
        2
    ) AS revenue_per_customer
FROM sales;
--CUSTOMER LIFETIME VALUE (LTV) BASIC
SELECT
    "Customer ID",
    ROUND(SUM("TotalPrice")::numeric, 2) AS customer_lifetime_value
FROM sales
GROUP BY "Customer ID"
ORDER BY customer_lifetime_value DESC;