-- ====================================================================
-- TASK 3: SQL DATA ANALYSIS
-- Dataset: Auto_Dealership_Sales
-- ====================================================================


-- --------------------------------------------------------------------
-- SETUP: Creating a secondary table to demonstrate JOINS
-- --------------------------------------------------------------------
CREATE TABLE Vehicle_Categories (
    Vehicle_Type TEXT,
    Maintenance_Package TEXT
);

INSERT INTO Vehicle_Categories (Vehicle_Type, Maintenance_Package) VALUES 
    ('SUV', 'Premium Family Care'),
    ('Sedan', 'Standard Commuter Care'),
    ('Coupe', 'Sport Performance Plan'),
    ('EV', 'Advanced Battery Protection');


-- --------------------------------------------------------------------
-- REQUIREMENT A & D: SELECT, WHERE, GROUP BY, ORDER BY & Aggregates
-- Goal: Calculate total revenue and average customer age for 
-- vehicles financed via 'Loan', grouped by Vehicle Type.
-- --------------------------------------------------------------------
SELECT 
    Vehicle_Type, 
    SUM(Sale_Price) AS Total_Revenue, 
    AVG(Customer_Age) AS Avg_Customer_Age
FROM Auto_Dealership_Sales
WHERE Financing_Type = 'Loan'
GROUP BY Vehicle_Type
ORDER BY Total_Revenue DESC;


-- --------------------------------------------------------------------
-- REQUIREMENT B: JOINS (LEFT JOIN)
-- Goal: Combine the main auto sales dataset with the Vehicle Categories 
-- table to see the included maintenance package for each sale.
-- --------------------------------------------------------------------
SELECT 
    a.Sale_ID, 
    a.Sale_Date, 
    a.Vehicle_Type, 
    v.Maintenance_Package, 
    a.Sale_Price
FROM Auto_Dealership_Sales a
LEFT JOIN Vehicle_Categories v 
    ON a.Vehicle_Type = v.Vehicle_Type
LIMIT 15; 


-- --------------------------------------------------------------------
-- REQUIREMENT C: Subqueries
-- Goal: Filter sales to display individual vehicle transactions that 
-- sold for more than the overall dealership average sale price.
-- --------------------------------------------------------------------
SELECT 
    Sale_ID, 
    Vehicle_Type, 
    Financing_Type, 
    Sale_Price
FROM Auto_Dealership_Sales
WHERE Sale_Price > (
    SELECT AVG(Sale_Price) 
    FROM Auto_Dealership_Sales
)
ORDER BY Sale_Price DESC
LIMIT 10;


-- --------------------------------------------------------------------
-- REQUIREMENT E: Create Views for Analysis
-- Goal: Save a shortcut virtual table for high-value Electric Vehicles
-- so the management team can easily monitor premium EV trends.
-- --------------------------------------------------------------------
CREATE VIEW Premium_EV_Sales AS
SELECT 
    Sale_ID, 
    Sale_Date, 
    Sale_Price, 
    Financing_Type
FROM Auto_Dealership_Sales
WHERE Vehicle_Type = 'EV' AND Sale_Price > 70000;

-- Querying the newly created view:
SELECT * FROM Premium_EV_Sales;


-- --------------------------------------------------------------------
-- REQUIREMENT F: Optimize queries with indexes
-- Goal: Optimize database speed by indexing the highly-queried 
-- Vehicle_Type column.
-- --------------------------------------------------------------------
CREATE INDEX idx_vehicle_type ON Auto_Dealership_Sales(Vehicle_Type);