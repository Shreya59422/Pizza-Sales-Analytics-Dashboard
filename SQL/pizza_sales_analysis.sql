
-- KPI 1: Total Revenue
-- Business Question: How much money did the pizza store earn in total?
SELECT ROUND(SUM(total_price),2) AS Total_Revenue
FROM pizza_sales;
-- Output: Total Revenue = 817860.05
-- Insight: The pizza company generated total revenue of 817,860.05 during the analysis period.


-- KPI 2: Total Orders
-- Business Question: How many customer orders were placed?
-- DISTINCT is used because one order may contain multiple pizzas.
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales;
-- Output: Total Orders = 21350
-- Insight: The business received 21,350 customer orders.


-- KPI 3: Total Pizzas Sold
-- Business Question: How many pizzas were sold?
SELECT SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales;
-- Output: Total Pizzas Sold = 49574
-- Insight: The company sold 49,574 pizzas during the period.



-- KPI 4: Average Order Value
-- Business Question: On average, how much money does one customer spend per order?
-- Formula: Average Order Value = Total Revenue / Total Orders
SELECT ROUND(SUM(total_price)/COUNT(DISTINCT order_id),2) AS 
Average_Order_Value
FROM pizza_sales;
-- Output: Average Order Value = 38.31
-- Insight: On average, a customer spends 38.31 per order.


-- KPI 5: Average Pizzas Per Order
-- Business Question: On average, how many pizzas does a customer buy in one order?
-- Formula: Average Pizzas Per Order = Total Pizzas Sold / Total Orders
SELECT ROUND(SUM(quantity) / COUNT(DISTINCT order_id),2) 
AS Avg_Pizzas_Per_Order 
FROM pizza_sales;
-- Output: Average Pizzas Per Order = 2.32
-- Insight: Customers purchase approximately 2.32 pizzas in each order.

                          
						  --TREND ANALYSIS--
--Business Question: Which day of the week receives the highest number of orders?
SELECT TO_CHAR(order_date,'Day') AS Day_Name,
COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY Day_Name
ORDER BY Total_Orders DESC;
--Insight: Fridays are the busiest day, so additional staff and inventory should be allocated on Fridays.


--Business Question: Which month generated the highest number of orders?
SELECT TO_CHAR(order_date,'Month') AS Month_Name,
COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY Month_Name
ORDER BY Total_Orders DESC; 
-- Insight: January is the strongest month, suggesting increased customer activity during that period.


--Business Question: At what time do customers place the most orders?
SELECT EXTRACT(HOUR FROM order_time) AS Hour,
COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY Hour
ORDER BY Hour;
-- Insight: Peak demand occurs around 12 PM (Lunch Time). The business should ensure sufficient staff and inventory during lunch hours.


--Business Question: Which category contributes the highest revenue?
SELECT pizza_category, 
 ROUND(SUM(total_price),2) AS Revenue
 FROM pizza_sales
 GROUP BY pizza_category
 ORDER BY Revenue DESC;
-- Insight: The Classic category generated the highest revenue among all categories, indicating strong customer preference and consistent demand.

--Business Question: Which size do customers spend most on?
 SELECT pizza_size,
  ROUND(SUM(total_price),2) AS Revenue
  FROM pizza_sales
  GROUP BY pizza_size
  ORDER BY Revenue DESC;
--Insight:Large (L) pizzas generated the highest revenue, suggesting that customers,
--prefer larger pizzas and are willing to spend more on bigger portions.


--Business Question: Which pizzas are most popular?
SELECT pizza_name,
SUM(quantity)AS Total_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Sold DESC
LIMIT 5;
-- Insight:
-- The Classic Deluxe Pizza, Barbecue Chicken Pizza,
-- Hawaiian Pizza, Pepperoni Pizza, and Thai Chicken Pizza were the top-selling pizzas, indicating strong customer demand.



--Business Question: Which pizzas perform poorly?
SELECT pizza_name,
SUM(quantity) AS Total_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Sold ASC
LIMIT 5;
-- Insight:
-- The Brie Carre Pizza, Mediterranean Pizza,
-- Calabrese Pizza, Spinach Supreme Pizza,
-- and Soppressata Pizza recorded the lowest sales, suggesting lower customer preference.


--Business question:Which pizzas generate the highest revenue?
SELECT pizza_name,
ROUND(SUM(total_price),2)AS Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Revenue DESC
LIMIT 5;
-- Insight:
-- Thai Chicken Pizza generated the highest revenue,
-- followed by Barbecue Chicken Pizza, California Chicken Pizza,
-- Classic Deluxe Pizza, and Spicy Italian Pizza.
-- These pizzas contribute significantly to overall business revenue.



                          -- CUSTOMER BEHAVIOR ANALYS--
--Business Question: Which category contributes what percentage of total revenue?
SELECT pizza_category,
 ROUND(SUM(total_price),2) AS Revenue,
 ROUND(SUM(total_price)*100/
 ( SELECT SUM(total_price)
   FROM pizza_sales),2) AS Revenue_Percentage
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Revenue DESC;
--Insight: The Classic category contributes the highest percentage
-- of total revenue, making it the most important category.


--Business Question: Do customers order more on weekdays or weekends?
SELECT
CASE
    WHEN EXTRACT(DOW FROM order_date) IN (0,6)
    THEN 'Weekend'
    ELSE 'Weekday'
END AS Day_Type,
COUNT(DISTINCT order_id) AS Orders
FROM pizza_sales
GROUP BY Day_Type;
-- Insight: Weekdays generated more orders than weekends,
-- indicating consistent customer demand throughout the week.



--Lunch vs Dinner Analysis--
--Business Question: During which meal period do customers order more?
SELECT
CASE
WHEN EXTRACT(HOUR FROM order_time) BETWEEN 11 AND 14
THEN 'Lunch'
WHEN EXTRACT(HOUR FROM order_time) BETWEEN 17 AND 20
THEN 'Dinner'
ELSE 'Other'
END AS Time_Period,
COUNT(DISTINCT order_id) AS Orders
FROM pizza_sales
GROUP BY Time_Period;
-- Insight: Dinner hours received the highest number of orders,
-- indicating stronger customer demand during evening meal periods.


--Business Question: Which pizzas generated revenue greater than 40,000?
SELECT
pizza_name,
ROUND(SUM(total_price),2) AS Revenue
FROM pizza_sales
GROUP BY pizza_name
HAVING SUM(total_price) > 40000
ORDER BY Revenue DESC;
--insights: Thai Chicken Pizza, Barbecue Chicken Pizza,
-- and California Chicken Pizza generated revenue above 40,000,
-- making them premium high-performing products.

--CTE (Common Table Expression)
--Business Question: How much revenue does each pizza category generate?
WITH category_sales AS (
SELECT
    pizza_category,
    SUM(total_price) AS Revenue
FROM pizza_sales
GROUP BY pizza_category
)
SELECT * FROM category_sales;
-- Insight: Classic category generated the highest revenue (220,053.10),
-- followed by Supreme, Chicken, and Veggie categories.

--Business Question: How do all pizzas rank based on the revenue they generate?
SELECT
pizza_name,
ROUND(SUM(total_price),2) AS Revenue,
RANK() OVER(
ORDER BY SUM(total_price) DESC
) AS Revenue_Rank
FROM pizza_sales
GROUP BY pizza_name;
-- Insight: Thai Chicken Pizza ranked first in terms of revenue,
-- making it the highest revenue-generating product.