# 🛒 Superstore Sales Analysis — SQL with Python

> **Celebal Technologies Internship Project**  
> Analyze retail sales data using SQL filtering, aggregation, and business intelligence queries.

---

## 📋 Project Overview

This project performs a comprehensive SQL-based analysis of the Superstore dataset (~10,000 records, 2019–2022) using Python + SQLite. It covers the full lifecycle from data ingestion and schema exploration to business use-case queries and data validation.

**Dataset:** [Kaggle — Superstore Dataset Final](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

---

## 🗂️ Project Structure

```
superstore-sql-analysis/
│
├── 📓 superstore_sql_analysis.ipynb     ← Main Jupyter Notebook (all steps)
│
├── data/
│   ├── superstore.csv                   ← Raw dataset (CSV)
│   └── superstore.db                    ← SQLite database
│
├── queries/
│   ├── 01_schema_exploration.sql        ← Schema & sample data
│   ├── 02_where_filters.sql             ← WHERE clause filtering
│   ├── 03_group_by_aggregations.sql     ← GROUP BY aggregations
│   ├── 04_sort_and_limit.sql            ← ORDER BY / LIMIT / RANK
│   ├── 05_business_use_cases.sql        ← Business intelligence queries
│   └── 06_validation.sql               ← Data quality validation
│
├── results/
│   ├── query_results.json               ← All SQL results in JSON
│   ├── 01_regional_performance.png
│   ├── 02_category_performance.png
│   ├── 03_subcategory_sales.png
│   ├── 04_product_profitability.png
│   ├── 05_monthly_trends.png
│   ├── 06_yoy_performance.png
│   ├── 07_quarterly_heatmap.png
│   ├── 08_top_customers.png
│   ├── 09_customer_loyalty.png
│   ├── 10_discount_analysis.png
│   ├── 11_shipping_analysis.png
│   ├── 12_seasonal_pattern.png
│   └── 13_region_year_heatmap.png
│
├── requirements.txt
└── README.md
```

---

## 🔧 Tech Stack

| Tool | Purpose |
|------|---------|
| Python 3.x | Core language |
| SQLite3 | In-process SQL database |
| Pandas | Data manipulation |
| Matplotlib | Charting & visualization |
| Seaborn | Heatmaps & statistical plots |
| Jupyter Notebook | Interactive analysis environment |

---

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/<your-username>/superstore-sql-analysis.git
cd superstore-sql-analysis
```

### 2. Install Dependencies
```bash
pip install -r requirements.txt
```

### 3. Run the Notebook
```bash
jupyter notebook superstore_sql_analysis.ipynb
```

Or run the SQL files directly against the database:
```bash
sqlite3 data/superstore.db < queries/01_schema_exploration.sql
```

---

## 📊 Analysis Steps

### Step 1 — Load Data
Load the Superstore CSV into a SQLite database using Pandas.

### Step 2 — Schema Exploration
```sql
PRAGMA table_info(superstore);
SELECT COUNT(DISTINCT Order_ID), COUNT(DISTINCT Customer_ID), ... FROM superstore;
```
- **9,994 rows** across **21 columns**
- Date range: **2019-01-01 to 2022-12-31**

### Step 3 — WHERE Filters
```sql
-- Region filter
SELECT * FROM superstore WHERE Region = 'West' ORDER BY Sales DESC LIMIT 15;

-- Date range filter
SELECT * FROM superstore WHERE Order_Date BETWEEN '2021-01-01' AND '2021-12-31';

-- High-value orders
SELECT * FROM superstore WHERE Sales > 1000 ORDER BY Sales DESC;

-- Loss-making discounted orders
SELECT * FROM superstore WHERE Discount > 0 AND Profit < 0 ORDER BY Profit ASC;
```

### Step 4 — GROUP BY Aggregations
```sql
-- Sales & Profit by Region
SELECT Region, SUM(Sales), SUM(Profit), AVG(Sales),
       SUM(Profit)/SUM(Sales)*100 AS profit_margin_pct
FROM superstore GROUP BY Region ORDER BY SUM(Sales) DESC;

-- Sub-category breakdown
SELECT Category, Sub_Category, SUM(Sales), SUM(Profit)
FROM superstore GROUP BY Category, Sub_Category;
```

### Step 5 — Sort & Limit (Rankings)
```sql
-- Top 10 products by sales
SELECT Product_Name, SUM(Sales) total_sales
FROM superstore GROUP BY Product_Name ORDER BY total_sales DESC LIMIT 10;

-- Product ranking within category using window functions
SELECT Category, Product_Name, SUM(Profit),
       RANK() OVER (PARTITION BY Category ORDER BY SUM(Profit) DESC) AS rank
FROM superstore GROUP BY Category, Product_Name;
```

### Step 6 — Business Use Cases
| Query | Insight |
|-------|---------|
| Monthly trend | Revenue peaked in Nov, lowest in Feb |
| YoY comparison | Consistent ~$15.3M–15.5M annual revenue |
| Top customers | Jessica Miller ($90.6K, 8 orders) leads by revenue |
| Loyalty segmentation | 392 loyal customers drive majority of revenue |
| Discount impact | Heavy discounts (31–40%) still maintain 12.57% margins |
| Shipping analysis | All modes take ~4 days on average |

### Step 7 — Validation
```sql
-- Null value check (all zero = clean data)
SELECT SUM(CASE WHEN Customer_Name IS NULL THEN 1 ELSE 0 END) null_customers, ... 

-- Duplicate detection
SELECT Order_ID, Product_ID, COUNT(*) FROM superstore
GROUP BY Order_ID, Product_ID HAVING COUNT(*) > 1;

-- Cross-check regional totals == grand total
SELECT (SELECT SUM(Sales) FROM superstore) grand_total,
       (SELECT SUM(Sales) FROM superstore WHERE Region='West') + ... computed_total;
```

---

## 📈 Key Business Insights

| # | Insight |
|---|---------|
| 1 | **Total Revenue:** ~$61.6M (2019–2022), **Total Profit:** ~$7.3M (11.9% avg margin) |
| 2 | **South** leads in sales ($15.8M) but has the **lowest margin** (11.81%) |
| 3 | **Furniture** has the highest revenue but the **lowest profit margin** (11.63%) |
| 4 | **Office Supplies** has the **best margin** (12.44%) — high volume, lower discounts |
| 5 | **November** is peak sales month; **February** is the slowest |
| 6 | **Loyal customers (7+ orders)** drive the majority of total revenue |
| 7 | Data quality: ✅ Zero nulls · ✅ No invalid dates · ✅ No out-of-range discounts |

---

## 📸 Sample Visualizations

| Chart | Description |
|-------|-------------|
| `01_regional_performance.png` | Sales & profit margin by region |
| `02_category_performance.png` | Revenue, profit, and discount by category |
| `05_monthly_trends.png` | Monthly sales & profit line chart (2019–2022) |
| `07_quarterly_heatmap.png` | Quarterly sales heatmap by year |
| `08_top_customers.png` | Top 20 customers by revenue |
| `12_seasonal_pattern.png` | Average monthly sales — seasonal pattern |

---

## 📄 SQL Files Reference

| File | Queries |
|------|---------|
| `01_schema_exploration.sql` | PRAGMA, COUNT, MIN/MAX, date range, summary stats |
| `02_where_filters.sql` | Region, category, date, sales threshold, multi-condition |
| `03_group_by_aggregations.sql` | Region, category, sub-category, segment, ship mode, discount, state |
| `04_sort_and_limit.sql` | Top/bottom products, category ranking, RANK() window function |
| `05_business_use_cases.sql` | Monthly/yearly/quarterly trends, top customers, loyalty, seasonality, shipping |
| `06_validation.sql` | Null checks, duplicate detection, date validation, cross-check totals |

---

## 👤 Author

**Your Name**  
Intern @ Celebal Technologies  
[LinkedIn](https://linkedin.com/in/yourprofile) · [GitHub](https://github.com/yourusername)

---

## 📃 License

This project is licensed under the MIT License.
