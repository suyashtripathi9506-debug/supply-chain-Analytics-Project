# Power BI Dashboard Guide — Supply Chain Analysis

Data file: **Supply_Chain_PowerBI_Data.xlsx** (table name: `SupplyChainData`, 500 rows, 13 columns including Year/Month/Quarter helper columns)

---

## Step 1 — Import the data
1. Open **Power BI Desktop**.
2. **Home → Get Data → Excel workbook** → select `Supply_Chain_PowerBI_Data.xlsx`.
3. In the Navigator window, tick **SupplyChainData** → click **Load** (or **Transform Data** if you want to preview first).
4. Confirm data types in **Power Query Editor**: `Order_Date` = Date, `Quantity`/`Inventory_Level`/`Delivery_Days` = Whole Number, `Unit_Price` = Decimal Number. Fix any that show as Text.

## Step 2 — Create a Date table (recommended)
In **Modeling → New Table**, paste:
```dax
DateTable = CALENDAR(MIN(SupplyChainData[Order_Date]), MAX(SupplyChainData[Order_Date]))
```
Then mark it as a **Date Table** (Modeling → Mark as Date Table → pick the Date column), and relate it to `SupplyChainData[Order_Date]` (1-to-many).

## Step 3 — Add DAX measures
Go to **Modeling → New Measure** and add each of these one by one:

```dax
Total Revenue = SUMX(SupplyChainData, SupplyChainData[Quantity] * SupplyChainData[Unit_Price])

Total Quantity = SUM(SupplyChainData[Quantity])

Total Orders = COUNTROWS(SupplyChainData)

Avg Delivery Days = AVERAGE(SupplyChainData[Delivery_Days])

Avg Inventory Level = AVERAGE(SupplyChainData[Inventory_Level])

Avg Order Value = DIVIDE([Total Revenue], [Total Orders])

Revenue MTD = TOTALMTD([Total Revenue], 'DateTable'[Date])

Revenue % of Total = DIVIDE([Total Revenue], CALCULATE([Total Revenue], ALL(SupplyChainData)))

On-Time Orders (<=10 days) = CALCULATE([Total Orders], SupplyChainData[Delivery_Days] <= 10)

On-Time Delivery % = DIVIDE([On-Time Orders (<=10 days)], [Total Orders])
```

## Step 4 — Build the report pages

### Page 1: Overview
| Visual | Fields |
|---|---|
| Card x4 | Total Revenue, Total Orders, Avg Delivery Days, On-Time Delivery % |
| Pie Chart | Legend = `Category`, Values = `Total Revenue` |
| Clustered Bar Chart | Axis = `Product`, Values = `Total Revenue` (sort descending) |
| Line Chart | Axis = `DateTable[Date]` (set hierarchy to Month), Values = `Total Revenue` |

### Page 2: Supplier & Warehouse Performance
| Visual | Fields |
|---|---|
| Clustered Column Chart | Axis = `Supplier`, Values = `Total Revenue`, `Avg Delivery Days` |
| Clustered Bar Chart | Axis = `Warehouse`, Values = `Avg Delivery Days` |
| Table | `Warehouse`, `Avg Inventory Level`, `Total Orders` |
| Matrix | Rows = `Supplier`, Columns = `Category`, Values = `Total Revenue` |

### Page 3: Delivery & Inventory
| Visual | Fields |
|---|---|
| Histogram (Bar) | Axis = `Delivery_Days` bins (right-click → New group → bin size 5), Values = Count |
| Scatter Chart | X = `Avg Inventory Level`, Y = `Avg Delivery Days`, Details = `Product` |
| Gauge | Value = `On-Time Delivery %`, Target = 80% |

## Step 5 — Add slicers
Add slicer visuals for `Category`, `Supplier`, `Warehouse`, and `DateTable[Date]` (between dates) at the top of each page, and sync them across pages via **View → Sync slicers**.

## Step 6 — Formatting
- Theme: View → Themes → pick a clean theme, or import a custom JSON theme.
- Format cards with `Total Revenue` as Currency (₹), 0 decimals.
- Set `Avg Delivery Days` to 1 decimal, `On-Time Delivery %` as Percentage.

## Step 7 — Publish (optional)
File → Publish → Publish to Power BI → choose your workspace (needs a Power BI account/license).

---
### Quick reference — column meanings
| Column | Description |
|---|---|
| Order_ID | Unique order identifier |
| Product | Item ordered (Laptop, Monitor, SSD, etc.) |
| Supplier | Supplier A–D |
| Category | Electronics / Networking / Accessories |
| Order_Date | Date the order was placed |
| Quantity | Units ordered |
| Unit_Price | Price per unit (₹) |
| Inventory_Level | Stock on hand at time of order |
| Delivery_Days | Days taken to deliver |
| Warehouse | Fulfilling warehouse (city) |
| Year / Month / Quarter | Pre-computed date helpers |
