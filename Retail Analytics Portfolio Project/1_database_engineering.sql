------------QUERY 1------------
CREATE DATABASE IF NOT EXISTS retail_db;
USE retail_db;

CREATE TABLE IF NOT EXISTS retail_master (
    Order_ID VARCHAR(20) PRIMARY KEY, Order_Date DATE, Order_Year INT, Season VARCHAR(20),
    Category VARCHAR(50), Sub_Category VARCHAR(50), Region VARCHAR(50), Supply_Chain_Status VARCHAR(50),
    Quantity INT, Unit_Cost DECIMAL(10,2), Unit_Price DECIMAL(10,2), 
    Discount_Pct DECIMAL(4,2), Inventory_Days INT, Requires_Liquidation INT
);



------------QUERY 2------------
USE retail_db;
SET SQL_SAFE_UPDATES = 0;

-- 1. Clean the NULL sub-categories
UPDATE retail_master SET sub_category = 'Uncategorized' WHERE sub_category IS NULL OR sub_category = '';

-- 2. Create the master financial view with margin calculations
CREATE OR REPLACE VIEW v_base_financials AS
SELECT 
    order_id, order_date, category, sub_category, region, supply_chain_status, inventory_days,
    quantity, unit_cost, unit_price, discount_pct,
    ROUND(quantity * unit_price, 2) AS gross_revenue,
    ROUND(quantity * unit_cost, 2) AS total_cost,
    ROUND((quantity * unit_price) * (1 - discount_pct), 2) AS net_revenue,
    ROUND(((quantity * unit_price) * (1 - discount_pct)) - (quantity * unit_cost), 2) AS net_profit,
    ROUND(((((quantity * unit_price) * (1 - discount_pct)) - (quantity * unit_cost)) / 
          ((quantity * unit_price) * (1 - discount_pct))) * 100, 2) AS profit_margin_pct
FROM retail_master;

-- 3. Display the finalized table for export
SELECT * FROM v_base_financials;