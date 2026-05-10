CREATE DATABASE inventory_supply_chain;


DROP TABLE IF EXISTS inv_data;
CREATE TABLE inv_data (
			Date DATE,	
			Product_ID CHAR(4),
			Product_Name VARCHAR(30),	
			Category VARCHAR(30),	
			Warehouse VARCHAR(30),	
			Stock_Level	INT,
			Reorder_Level INT,	
			Reorder_Quantity INT,	
			Supplier VARCHAR(30),	
			Lead_Time_Days INT,	
			Unit_Cost INT,	
			Unit_Price INT,	
			Units_Sold	INT,
			Units_Ordered INT,	
			Delivery_Status VARCHAR(30)

		);



-------------------------------------------------------------------------------------------------------------

--Inventory Management
-- Which products frequently fall below the reorder level?

SELECT product_name,
       COUNT(*) AS low_stock_occurrences
FROM inv_data
WHERE stock_level < reorder_level
GROUP BY product_name
ORDER BY low_stock_occurrences DESC;

-- Which warehouse has the highest stock shortages?


SELECT warehouse,
       SUM(stock_level) AS total_inventory
FROM inv_data
GROUP BY warehouse
ORDER BY total_inventory DESC;


--Are reorder quantities sufficient to meet demand?

SELECT warehouse, SUM(reorder_quantity) as stock_available, SUM(units_ordered) as stock_ordered
FROM inv_data
GROUP BY warehouse;

-------------------------------------------------------------------------------------------------------------

-- Sales & Demand Analysis
-- Which products have the highest sales volume?
SELECT  product_name, SUM(units_sold) as sale_volume
FROM inv_data
GROUP BY product_name
ORDER BY sale_volume DESC;

-- What are the sales trends over time?
SELECT
	product_name,
	category,
	EXTRACT (MONTH FROM date) as Months,
	SUM(unit_price *units_sold) as sales
FROM inv_data
GROUP BY Months, product_name, category
ORDER BY Months

	
-- Which categories perform best?

SELECT 
	category,
	SUM(unit_price *units_sold) as sales
FROM inv_data
GROUP BY category
ORDER BY sales DESC;

------------------------------------------------------------------------------------------------------------

--Profitability Analysis
-- What is the total revenue per product?

SELECT product_name,
	SUM(unit_price *units_sold) as sales
FROM inv_data
GROUP BY product_name
ORDER BY sales DESC;

-- Which products generate the highest profit margins?

SELECT product_name,
		SUM(unit_cost) as unit_cost,
		SUM(unit_price) as unit_price,
		ROUND ((unit_price - unit_cost) * 100.0 / unit_price, 2 ) as profit_magin 
FROM inv_data
GROUP BY product_name, profit_magin; 


-- Are high-cost products also high-performing

SELECT  
		product_name,
		SUM(unit_cost) as unit_cost,
		SUM(unit_price) as unit_price,
		ROUND ((unit_price - unit_cost) * 100.0 / unit_price, 2 ) as profit_magin
FROM inv_data
where unit_cost > 200
GROUP BY product_name,profit_magin
order by unit_cost  desc

------------------------------------------------------------------------------------------------------------

-- Supplier Performance
-- Which supplier has the longest average lead time?

SELECT
	supplier,
	ROUND(AVG(lead_time_days),2) as avg_lead_time
FROM inv_data
GROUP BY supplier
ORDER BY avg_lead_time DESC;

-- Which supplier has the most delayed deliveries?

SELECT
	supplier,
	count(delivery_status) as delayed_deliveries
FROM inv_data
WHERE delivery_status = 'Delayed'
GROUP BY supplier
ORDER BY delayed_deliveries DESC;


-- How does supplier performance impact stock levels?

SELECT 
	supplier,
	SUM(stock_level) as total_stock_level,
	count(delivery_status) as deliveries
FROM inv_data
WHERE delivery_status = 'Delivered'
GROUP BY supplier
ORDER BY  total_stock_level DESC;

-------------------------------------------------------------------------------------------------------------

--Operational Efficiency
-- How often are orders placed (Units_Ordered > 0)?
SELECT*FROM inv_data

SELECT
	COUNT(units_ordered) as count_of_units_ordered,
SUM(CASE
		WHEN units_ordered > 0 THEN 1 ELSE 0
END) 
	AS ordered_units,
SUM(CASE
		WHEN units_ordered = 0 THEN 1 ELSE 0
	END) as not_ordered_units	
FROM inv_data
	
-- Which products generate the highest profit?

SELECT product_name,
       ROUND(SUM((unit_price - unit_cost) * units_sold),2) AS total_profit
FROM inv_data
GROUP BY product_name
ORDER BY total_profit DESC;



-- Which suppliers are linked to the most stock shortages?
SELECT supplier,
       COUNT(*) AS shortage_occurrences
FROM inv_data
WHERE stock_level < reorder_level
GROUP BY supplier
ORDER BY shortage_occurrences DESC;


