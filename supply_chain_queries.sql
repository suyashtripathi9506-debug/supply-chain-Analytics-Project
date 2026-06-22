/* ============================================================
   SUPPLY CHAIN ANALYSIS - SQL QUERIES
   Data: supply_chain_500_rows.csv (500 orders)
   Compatible with: SQLite / MySQL / PostgreSQL / SQL Server
   (Table name used below: supply_chain)
   ============================================================ */

-- 1. Revenue by Category (for Pie / Bar chart)
SELECT
    Category,
    SUM(Quantity * Unit_Price) AS Total_Revenue,
    SUM(Quantity)              AS Total_Quantity
FROM supply_chain
GROUP BY Category
ORDER BY Total_Revenue DESC;


-- 2. Revenue by Product (Top products - Bar chart)
SELECT
    Product,
    SUM(Quantity * Unit_Price) AS Total_Revenue,
    SUM(Quantity)              AS Total_Quantity,
    COUNT(*)                   AS Order_Count
FROM supply_chain
GROUP BY Product
ORDER BY Total_Revenue DESC;


-- 3. Revenue & Order Count by Supplier (Bar chart)
SELECT
    Supplier,
    SUM(Quantity * Unit_Price) AS Total_Revenue,
    COUNT(*)                   AS Order_Count,
    ROUND(AVG(Delivery_Days),1) AS Avg_Delivery_Days
FROM supply_chain
GROUP BY Supplier
ORDER BY Total_Revenue DESC;


-- 4. Average Delivery Days by Warehouse (Bar chart - performance)
SELECT
    Warehouse,
    ROUND(AVG(Delivery_Days),1) AS Avg_Delivery_Days,
    ROUND(AVG(Inventory_Level),0) AS Avg_Inventory_Level,
    COUNT(*) AS Order_Count
FROM supply_chain
GROUP BY Warehouse
ORDER BY Avg_Delivery_Days ASC;


-- 5. Monthly Revenue Trend (Line chart)
SELECT
    strftime('%Y-%m', Order_Date) AS Order_Month,
    SUM(Quantity * Unit_Price)    AS Total_Revenue,
    COUNT(*)                      AS Order_Count
FROM supply_chain
GROUP BY Order_Month
ORDER BY Order_Month;


-- 6. Average Inventory Level by Product (Bar chart - stock health)
SELECT
    Product,
    ROUND(AVG(Inventory_Level),0) AS Avg_Inventory_Level,
    MIN(Inventory_Level) AS Min_Inventory,
    MAX(Inventory_Level) AS Max_Inventory
FROM supply_chain
GROUP BY Product
ORDER BY Avg_Inventory_Level ASC;


-- 7. Delivery Performance Buckets (Bar chart - SLA tracking)
SELECT
    CASE
        WHEN Delivery_Days <= 5  THEN '1-5 days (Fast)'
        WHEN Delivery_Days <= 10 THEN '6-10 days (Normal)'
        WHEN Delivery_Days <= 15 THEN '11-15 days (Slow)'
        ELSE '16-20 days (Very Slow)'
    END AS Delivery_Bucket,
    COUNT(*) AS Order_Count
FROM supply_chain
GROUP BY Delivery_Bucket
ORDER BY Delivery_Bucket;


-- 8. Top 10 Highest-Value Orders
SELECT
    Order_ID, Product, Supplier, Warehouse,
    Quantity, Unit_Price, (Quantity * Unit_Price) AS Order_Value
FROM supply_chain
ORDER BY Order_Value DESC
LIMIT 10;
