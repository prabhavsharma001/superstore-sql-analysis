-- ============================================================
-- STEP 1 & 2: SCHEMA EXPLORATION & SAMPLE DATA
-- Superstore Sales Analysis
-- ============================================================

-- 1.1 View table schema
PRAGMA table_info(superstore);

-- 1.2 Total row count
SELECT COUNT(*) AS total_rows FROM superstore;

-- 1.3 Sample data (first 10 rows)
SELECT * FROM superstore LIMIT 10;

-- 1.4 Distinct values in key categorical columns
SELECT
    COUNT(DISTINCT Order_ID)      AS unique_orders,
    COUNT(DISTINCT Customer_ID)   AS unique_customers,
    COUNT(DISTINCT Product_ID)    AS unique_products,
    COUNT(DISTINCT Region)        AS unique_regions,
    COUNT(DISTINCT Category)      AS unique_categories,
    COUNT(DISTINCT Sub_Category)  AS unique_sub_categories,
    COUNT(DISTINCT State)         AS unique_states,
    COUNT(DISTINCT Segment)       AS unique_segments
FROM superstore;

-- 1.5 Date range of orders
SELECT
    MIN(Order_Date) AS earliest_order,
    MAX(Order_Date) AS latest_order,
    CAST(JULIANDAY(MAX(Order_Date)) - JULIANDAY(MIN(Order_Date)) AS INTEGER) AS days_span
FROM superstore;

-- 1.6 Summary statistics for numeric columns
SELECT
    ROUND(MIN(Sales), 2)     AS min_sales,
    ROUND(MAX(Sales), 2)     AS max_sales,
    ROUND(AVG(Sales), 2)     AS avg_sales,
    ROUND(SUM(Sales), 2)     AS total_sales,
    ROUND(MIN(Profit), 2)    AS min_profit,
    ROUND(MAX(Profit), 2)    AS max_profit,
    ROUND(AVG(Profit), 2)    AS avg_profit,
    ROUND(SUM(Profit), 2)    AS total_profit,
    MIN(Quantity)            AS min_qty,
    MAX(Quantity)            AS max_qty,
    ROUND(AVG(Quantity), 2)  AS avg_qty
FROM superstore;
