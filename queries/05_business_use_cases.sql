-- ============================================================
-- STEP 6: BUSINESS USE CASES
-- Monthly Trends | Top Customers | Duplicates
-- ============================================================

-- 6.1 Monthly Sales Trend (all years)
SELECT
    SUBSTR(Order_Date, 1, 7)     AS year_month,
    STRFTIME('%Y', Order_Date)   AS year,
    STRFTIME('%m', Order_Date)   AS month,
    COUNT(DISTINCT Order_ID)     AS total_orders,
    ROUND(SUM(Sales), 2)         AS monthly_sales,
    ROUND(SUM(Profit), 2)        AS monthly_profit,
    ROUND(AVG(Sales), 2)         AS avg_sale_value
FROM superstore
GROUP BY year_month
ORDER BY year_month;

-- 6.2 Year-over-Year Sales Comparison
SELECT
    STRFTIME('%Y', Order_Date) AS year,
    ROUND(SUM(Sales), 2)       AS annual_sales,
    ROUND(SUM(Profit), 2)      AS annual_profit,
    COUNT(DISTINCT Order_ID)   AS total_orders,
    COUNT(DISTINCT Customer_ID) AS active_customers,
    ROUND(AVG(Sales), 2)       AS avg_transaction_value
FROM superstore
GROUP BY year
ORDER BY year;

-- 6.3 Quarterly Sales Trend
SELECT
    STRFTIME('%Y', Order_Date) AS year,
    CASE
        WHEN CAST(STRFTIME('%m', Order_Date) AS INT) BETWEEN 1 AND 3  THEN 'Q1'
        WHEN CAST(STRFTIME('%m', Order_Date) AS INT) BETWEEN 4 AND 6  THEN 'Q2'
        WHEN CAST(STRFTIME('%m', Order_Date) AS INT) BETWEEN 7 AND 9  THEN 'Q3'
        ELSE 'Q4'
    END AS quarter,
    ROUND(SUM(Sales), 2)         AS quarterly_sales,
    ROUND(SUM(Profit), 2)        AS quarterly_profit,
    COUNT(DISTINCT Order_ID)     AS orders
FROM superstore
GROUP BY year, quarter
ORDER BY year, quarter;

-- 6.4 Top 20 Customers by Total Sales
SELECT
    Customer_ID,
    Customer_Name,
    Segment,
    Region,
    COUNT(DISTINCT Order_ID)     AS total_orders,
    SUM(Quantity)                AS total_units_bought,
    ROUND(SUM(Sales), 2)         AS total_sales,
    ROUND(SUM(Profit), 2)        AS total_profit_generated,
    ROUND(AVG(Sales), 2)         AS avg_order_value
FROM superstore
GROUP BY Customer_ID, Customer_Name, Segment, Region
ORDER BY total_sales DESC
LIMIT 20;

-- 6.5 Top 20 Customers by Profit Generated
SELECT
    Customer_ID,
    Customer_Name,
    Segment,
    Region,
    COUNT(DISTINCT Order_ID)     AS total_orders,
    ROUND(SUM(Sales), 2)         AS total_sales,
    ROUND(SUM(Profit), 2)        AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Customer_ID, Customer_Name, Segment, Region
ORDER BY total_profit DESC
LIMIT 20;

-- 6.6 Customer Segmentation by Order Frequency
SELECT
    CASE
        WHEN order_count = 1      THEN 'One-Time Buyer'
        WHEN order_count <= 3     THEN 'Occasional Buyer (2-3 orders)'
        WHEN order_count <= 6     THEN 'Regular Buyer (4-6 orders)'
        ELSE 'Loyal Customer (7+ orders)'
    END AS buyer_segment,
    COUNT(*) AS num_customers,
    ROUND(AVG(total_sales), 2) AS avg_total_spend,
    ROUND(SUM(total_sales), 2) AS segment_total_sales
FROM (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS order_count,
        SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY Customer_ID
) sub
GROUP BY buyer_segment
ORDER BY avg_total_spend DESC;

-- 6.7 Detect Duplicate Orders (same Order_ID, same Product_ID)
SELECT
    Order_ID,
    Product_ID,
    Customer_Name,
    Order_Date,
    COUNT(*) AS occurrences
FROM superstore
GROUP BY Order_ID, Product_ID, Customer_Name, Order_Date
HAVING COUNT(*) > 1
ORDER BY occurrences DESC
LIMIT 20;

-- 6.8 Detect rows where Order_Date > Ship_Date (data quality issue)
SELECT COUNT(*) AS invalid_shipping_records
FROM superstore
WHERE Order_Date > Ship_Date;

-- 6.9 Records with NULL or empty critical fields
SELECT
    SUM(CASE WHEN Customer_Name IS NULL OR Customer_Name = '' THEN 1 ELSE 0 END) AS null_customer_names,
    SUM(CASE WHEN Order_ID IS NULL OR Order_ID = ''           THEN 1 ELSE 0 END) AS null_order_ids,
    SUM(CASE WHEN Sales IS NULL OR Sales <= 0                  THEN 1 ELSE 0 END) AS invalid_sales,
    SUM(CASE WHEN Quantity IS NULL OR Quantity <= 0            THEN 1 ELSE 0 END) AS invalid_quantities,
    SUM(CASE WHEN Region IS NULL OR Region = ''               THEN 1 ELSE 0 END) AS null_regions,
    SUM(CASE WHEN Category IS NULL OR Category = ''           THEN 1 ELSE 0 END) AS null_categories
FROM superstore;

-- 6.10 Seasonal Pattern: Sales by Month (aggregated across all years)
SELECT
    STRFTIME('%m', Order_Date) AS month_num,
    CASE STRFTIME('%m', Order_Date)
        WHEN '01' THEN 'January'   WHEN '02' THEN 'February'
        WHEN '03' THEN 'March'     WHEN '04' THEN 'April'
        WHEN '05' THEN 'May'       WHEN '06' THEN 'June'
        WHEN '07' THEN 'July'      WHEN '08' THEN 'August'
        WHEN '09' THEN 'September' WHEN '10' THEN 'October'
        WHEN '11' THEN 'November'  WHEN '12' THEN 'December'
    END AS month_name,
    ROUND(AVG(monthly_sales), 2) AS avg_monthly_sales,
    ROUND(SUM(monthly_sales), 2) AS total_across_years
FROM (
    SELECT
        STRFTIME('%Y-%m', Order_Date) AS ym,
        STRFTIME('%m', Order_Date)    AS month,
        SUM(Sales) AS monthly_sales
    FROM superstore
    GROUP BY ym, month
) sub
GROUP BY month_num, month_name
ORDER BY month_num;

-- 6.11 Shipping efficiency: Average days to ship by Ship Mode
SELECT
    Ship_Mode,
    COUNT(*) AS total_orders,
    ROUND(AVG(JULIANDAY(Ship_Date) - JULIANDAY(Order_Date)), 2) AS avg_days_to_ship,
    MIN(CAST(JULIANDAY(Ship_Date) - JULIANDAY(Order_Date) AS INT)) AS min_days,
    MAX(CAST(JULIANDAY(Ship_Date) - JULIANDAY(Order_Date) AS INT)) AS max_days
FROM superstore
GROUP BY Ship_Mode
ORDER BY avg_days_to_ship;

-- 6.12 Profitability by Region and Year
SELECT
    STRFTIME('%Y', Order_Date) AS year,
    Region,
    ROUND(SUM(Sales), 2)         AS sales,
    ROUND(SUM(Profit), 2)        AS profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS margin_pct
FROM superstore
GROUP BY year, Region
ORDER BY year, Region;
