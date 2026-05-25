-- ============================================================
-- STEP 5: SORT & LIMIT — Top Products, Top Categories
-- ============================================================

-- 5.1 Top 10 Products by Total Sales
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    COUNT(*)              AS times_ordered,
    SUM(Quantity)         AS total_units_sold,
    ROUND(SUM(Sales), 2)  AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstore
GROUP BY Product_ID, Product_Name, Category, Sub_Category
ORDER BY total_sales DESC
LIMIT 10;

-- 5.2 Top 10 Products by Profit
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    COUNT(*)              AS times_ordered,
    ROUND(SUM(Sales), 2)  AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS margin_pct
FROM superstore
GROUP BY Product_ID, Product_Name, Category, Sub_Category
ORDER BY total_profit DESC
LIMIT 10;

-- 5.3 Bottom 10 Products by Profit (Loss-Making)
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    COUNT(*)              AS times_ordered,
    ROUND(SUM(Sales), 2)  AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstore
GROUP BY Product_ID, Product_Name, Category, Sub_Category
ORDER BY total_profit ASC
LIMIT 10;

-- 5.4 Top 5 Categories by Revenue
SELECT
    Category,
    ROUND(SUM(Sales), 2)         AS total_revenue,
    ROUND(SUM(Profit), 2)        AS total_profit,
    ROUND(SUM(Sales)*100.0 / (SELECT SUM(Sales) FROM superstore), 2) AS revenue_share_pct
FROM superstore
GROUP BY Category
ORDER BY total_revenue DESC
LIMIT 5;

-- 5.5 Top 10 Sub-Categories by Revenue
SELECT
    Sub_Category,
    Category,
    ROUND(SUM(Sales), 2)  AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    SUM(Quantity)         AS units_sold
FROM superstore
GROUP BY Sub_Category, Category
ORDER BY total_revenue DESC
LIMIT 10;

-- 5.6 Top 10 Most Profitable Sub-Categories
SELECT
    Sub_Category,
    Category,
    ROUND(SUM(Sales), 2)  AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Sub_Category, Category
ORDER BY total_profit DESC
LIMIT 10;

-- 5.7 Top 10 States by Revenue
SELECT
    State,
    Region,
    ROUND(SUM(Sales), 2)  AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    COUNT(DISTINCT Order_ID) AS total_orders
FROM superstore
GROUP BY State, Region
ORDER BY total_sales DESC
LIMIT 10;

-- 5.8 Ranking products within each category by profit
SELECT
    Category,
    Sub_Category,
    Product_Name,
    ROUND(SUM(Sales), 2)  AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    RANK() OVER (PARTITION BY Category ORDER BY SUM(Profit) DESC) AS rank_in_category
FROM superstore
GROUP BY Category, Sub_Category, Product_Name
ORDER BY Category, rank_in_category
LIMIT 30;
