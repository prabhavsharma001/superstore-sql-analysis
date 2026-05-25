-- ============================================================
-- STEP 3: WHERE FILTERS — Region, Category, Date, Sales
-- ============================================================

-- 3.1 Filter by Region: West only
SELECT Order_ID, Customer_Name, State, Category, Sales, Profit
FROM superstore
WHERE Region = 'West'
ORDER BY Sales DESC
LIMIT 15;

-- 3.2 Filter by Category: Technology products
SELECT Order_ID, Customer_Name, Sub_Category, Product_Name, Sales, Discount, Profit
FROM superstore
WHERE Category = 'Technology'
ORDER BY Sales DESC
LIMIT 15;

-- 3.3 Filter by Date Range: Orders in 2021
SELECT Order_ID, Order_Date, Customer_Name, Region, Category, Sales, Profit
FROM superstore
WHERE Order_Date BETWEEN '2021-01-01' AND '2021-12-31'
ORDER BY Order_Date
LIMIT 20;

-- 3.4 Filter by Sales threshold: High-value orders > $1000
SELECT Order_ID, Customer_Name, Region, Category, Sub_Category,
       ROUND(Sales, 2) AS Sales, ROUND(Profit, 2) AS Profit, Quantity, Discount
FROM superstore
WHERE Sales > 1000
ORDER BY Sales DESC
LIMIT 20;

-- 3.5 Filter: Discounted orders with negative profit (loss-making)
SELECT Order_ID, Customer_Name, Region, Category, Sub_Category,
       ROUND(Sales, 2) AS Sales, ROUND(Profit, 2) AS Profit, Discount
FROM superstore
WHERE Discount > 0 AND Profit < 0
ORDER BY Profit ASC
LIMIT 20;

-- 3.6 Combined filter: East region + Furniture + 2020
SELECT Order_ID, Order_Date, Customer_Name, Sub_Category,
       ROUND(Sales, 2) AS Sales, ROUND(Profit, 2) AS Profit
FROM superstore
WHERE Region = 'East'
  AND Category = 'Furniture'
  AND Order_Date BETWEEN '2020-01-01' AND '2020-12-31'
ORDER BY Sales DESC;

-- 3.7 Filter by Segment: Corporate customers
SELECT Order_ID, Customer_Name, State, Category,
       ROUND(Sales, 2) AS Sales, ROUND(Profit, 2) AS Profit
FROM superstore
WHERE Segment = 'Corporate'
ORDER BY Sales DESC
LIMIT 15;

-- 3.8 Multi-condition filter: Large quantity discounted orders
SELECT Order_ID, Customer_Name, Category, Sub_Category,
       Quantity, Discount, ROUND(Sales, 2) AS Sales, ROUND(Profit, 2) AS Profit
FROM superstore
WHERE Quantity >= 10 AND Discount >= 0.3
ORDER BY Quantity DESC
LIMIT 15;
