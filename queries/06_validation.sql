-- ============================================================
-- STEP 7: VALIDATION — Row Counts, Data Quality Checks
-- ============================================================

-- 7.1 Total row count vs expected
SELECT COUNT(*) AS total_rows FROM superstore;

-- 7.2 Row counts per year (ensure no gaps)
SELECT
    STRFTIME('%Y', Order_Date) AS year,
    COUNT(*)                   AS row_count,
    COUNT(DISTINCT Order_ID)   AS unique_orders
FROM superstore
GROUP BY year
ORDER BY year;

-- 7.3 Row count by Region (check even distribution)
SELECT Region, COUNT(*) AS row_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM superstore), 2) AS pct
FROM superstore
GROUP BY Region;

-- 7.4 Row count by Category
SELECT Category, COUNT(*) AS row_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM superstore), 2) AS pct
FROM superstore
GROUP BY Category;

-- 7.5 Check for missing/null values across all key columns
SELECT 'Row_ID'         AS column_name, SUM(CASE WHEN Row_ID IS NULL THEN 1 ELSE 0 END) AS null_count FROM superstore UNION ALL
SELECT 'Order_ID',       SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END)       FROM superstore UNION ALL
SELECT 'Order_Date',     SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END)     FROM superstore UNION ALL
SELECT 'Ship_Date',      SUM(CASE WHEN Ship_Date IS NULL THEN 1 ELSE 0 END)      FROM superstore UNION ALL
SELECT 'Ship_Mode',      SUM(CASE WHEN Ship_Mode IS NULL THEN 1 ELSE 0 END)      FROM superstore UNION ALL
SELECT 'Customer_ID',    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END)    FROM superstore UNION ALL
SELECT 'Customer_Name',  SUM(CASE WHEN Customer_Name IS NULL THEN 1 ELSE 0 END)  FROM superstore UNION ALL
SELECT 'Segment',        SUM(CASE WHEN Segment IS NULL THEN 1 ELSE 0 END)        FROM superstore UNION ALL
SELECT 'Region',         SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END)         FROM superstore UNION ALL
SELECT 'Category',       SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END)       FROM superstore UNION ALL
SELECT 'Sub_Category',   SUM(CASE WHEN Sub_Category IS NULL THEN 1 ELSE 0 END)   FROM superstore UNION ALL
SELECT 'Sales',          SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END)          FROM superstore UNION ALL
SELECT 'Quantity',       SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END)       FROM superstore UNION ALL
SELECT 'Discount',       SUM(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END)       FROM superstore UNION ALL
SELECT 'Profit',         SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END)         FROM superstore;

-- 7.6 Validate Sales > 0 for all records
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Sales > 0 THEN 1 ELSE 0 END) AS valid_sales_rows,
    SUM(CASE WHEN Sales <= 0 THEN 1 ELSE 0 END) AS invalid_sales_rows,
    SUM(CASE WHEN Quantity > 0 THEN 1 ELSE 0 END) AS valid_quantity_rows
FROM superstore;

-- 7.7 Validate Discount is between 0 and 1
SELECT
    MIN(Discount) AS min_discount,
    MAX(Discount) AS max_discount,
    SUM(CASE WHEN Discount < 0 OR Discount > 1 THEN 1 ELSE 0 END) AS invalid_discounts
FROM superstore;

-- 7.8 Check for exact full-row duplicates
SELECT
    Order_ID, Product_ID, Customer_ID, Order_Date, Sales, Quantity,
    COUNT(*) AS cnt
FROM superstore
GROUP BY Order_ID, Product_ID, Customer_ID, Order_Date, Sales, Quantity
HAVING COUNT(*) > 1
ORDER BY cnt DESC
LIMIT 10;

-- 7.9 Verify all regions are valid
SELECT DISTINCT Region FROM superstore ORDER BY Region;

-- 7.10 Verify all categories are valid
SELECT DISTINCT Category, Sub_Category FROM superstore ORDER BY Category, Sub_Category;

-- 7.11 Cross-check: sum of regional sales = total sales
SELECT
    (SELECT ROUND(SUM(Sales), 2) FROM superstore)        AS grand_total,
    (SELECT ROUND(SUM(Sales), 2) FROM superstore WHERE Region = 'West')    AS west,
    (SELECT ROUND(SUM(Sales), 2) FROM superstore WHERE Region = 'East')    AS east,
    (SELECT ROUND(SUM(Sales), 2) FROM superstore WHERE Region = 'Central') AS central,
    (SELECT ROUND(SUM(Sales), 2) FROM superstore WHERE Region = 'South')   AS south,
    ROUND(
        (SELECT SUM(Sales) FROM superstore WHERE Region = 'West') +
        (SELECT SUM(Sales) FROM superstore WHERE Region = 'East') +
        (SELECT SUM(Sales) FROM superstore WHERE Region = 'Central') +
        (SELECT SUM(Sales) FROM superstore WHERE Region = 'South'), 2
    ) AS computed_total;
