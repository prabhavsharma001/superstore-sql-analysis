-- ============================================================
-- STEP 4: GROUP BY AGGREGATIONS — Sales, Quantity, Averages
-- ============================================================

-- 4.1 Sales & Profit by Region
SELECT
    Region,
    COUNT(DISTINCT Order_ID)     AS total_orders,
    COUNT(*)                     AS total_line_items,
    ROUND(SUM(Sales), 2)         AS total_sales,
    ROUND(SUM(Profit), 2)        AS total_profit,
    ROUND(AVG(Sales), 2)         AS avg_order_sales,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Region
ORDER BY total_sales DESC;

-- 4.2 Sales & Profit by Category
SELECT
    Category,
    COUNT(DISTINCT Order_ID)     AS total_orders,
    SUM(Quantity)                AS total_units_sold,
    ROUND(SUM(Sales), 2)         AS total_sales,
    ROUND(SUM(Profit), 2)        AS total_profit,
    ROUND(AVG(Sales), 2)         AS avg_sales_per_item,
    ROUND(AVG(Discount)*100, 2)  AS avg_discount_pct,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Category
ORDER BY total_sales DESC;

-- 4.3 Sales by Sub-Category
SELECT
    Category,
    Sub_Category,
    COUNT(*)                     AS total_line_items,
    SUM(Quantity)                AS total_units_sold,
    ROUND(SUM(Sales), 2)         AS total_sales,
    ROUND(SUM(Profit), 2)        AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Category, Sub_Category
ORDER BY total_sales DESC;

-- 4.4 Sales by Customer Segment
SELECT
    Segment,
    COUNT(DISTINCT Customer_ID)  AS unique_customers,
    COUNT(DISTINCT Order_ID)     AS total_orders,
    ROUND(SUM(Sales), 2)         AS total_sales,
    ROUND(SUM(Profit), 2)        AS total_profit,
    ROUND(AVG(Sales), 2)         AS avg_sales_per_item,
    ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2) AS avg_order_value
FROM superstore
GROUP BY Segment
ORDER BY total_sales DESC;

-- 4.5 Sales by Region and Category (cross-tabulation)
SELECT
    Region,
    Category,
    ROUND(SUM(Sales), 2)  AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    COUNT(*)              AS orders
FROM superstore
GROUP BY Region, Category
ORDER BY Region, total_sales DESC;

-- 4.6 Quantity analysis by Ship Mode
SELECT
    Ship_Mode,
    COUNT(DISTINCT Order_ID)  AS total_orders,
    SUM(Quantity)             AS total_units,
    ROUND(AVG(Quantity), 2)   AS avg_qty_per_item,
    ROUND(SUM(Sales), 2)      AS total_sales,
    ROUND(AVG(Sales), 2)      AS avg_sale_value
FROM superstore
GROUP BY Ship_Mode
ORDER BY total_sales DESC;

-- 4.7 Discount impact analysis
SELECT
    CASE
        WHEN Discount = 0         THEN '0% (No Discount)'
        WHEN Discount <= 0.10     THEN '1-10%'
        WHEN Discount <= 0.20     THEN '11-20%'
        WHEN Discount <= 0.30     THEN '21-30%'
        WHEN Discount <= 0.40     THEN '31-40%'
        ELSE '41%+'
    END AS discount_range,
    COUNT(*)                     AS num_transactions,
    ROUND(SUM(Sales), 2)         AS total_sales,
    ROUND(SUM(Profit), 2)        AS total_profit,
    ROUND(AVG(Profit), 2)        AS avg_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY discount_range
ORDER BY Discount;

-- 4.8 Sales by State (top 20)
SELECT
    State,
    Region,
    COUNT(DISTINCT Customer_ID)  AS unique_customers,
    COUNT(DISTINCT Order_ID)     AS total_orders,
    ROUND(SUM(Sales), 2)         AS total_sales,
    ROUND(SUM(Profit), 2)        AS total_profit
FROM superstore
GROUP BY State, Region
ORDER BY total_sales DESC
LIMIT 20;
