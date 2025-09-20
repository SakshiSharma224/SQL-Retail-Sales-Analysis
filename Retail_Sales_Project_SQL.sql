-- SQL Retail Sales Analysis Project
CREATE DATABASE Retail_Sales_Analysis;
drop database retail_sales_analysis;
CREATE TABLE retail_sales(
             transaction_id int primary key,
             sale_date DATE,
             sale_time TIME,
             customer_id INT,
	         gender VARCHAR(20),
             age INT,
             category VARCHAR(20),
             quantiy INT,
             price_per_unit FLOAT,
			 cogs FLOAT,
             total_sale FLOAT
);

SELECT * FROM retail_sales;

SELECT COUNT(*) 
FROM retail_sales;

-- DATA CLEANING
SELECT * FROM retail_sales
WHERE
	transaction_id IS NULL
    OR
	sale_date IS NULL
    OR
	sale_time IS NULL
    OR
    customer_id IS NULL
    OR
	gender IS NULL
    OR
	age IS NULL
    OR
	category IS NULL
    OR
	quantiy  IS NULL
    OR
	price_per_unit IS NULL
    OR
	cogs IS NULL
    OR
	total_sale IS NULL;
	
DELETE FROM retail_sales
WHERE
	transaction_id IS NULL
    OR
	sale_date IS NULL
    OR
	sale_time IS NULL
    OR
    customer_id IS NULL
    OR
	gender IS NULL
    OR
	age IS NULL
    OR
	category IS NULL
    OR
	quantiy  IS NULL
    OR
	price_per_unit IS NULL
    OR
	cogs IS NULL
    OR
	total_sale IS NULL;

-- DATA EXPLORATION

# HOW MANY SALES DO WE HAVE?
SELECT COUNT(*) AS TOTAL_SALES FROM retail_sales;

# HOW MANY UNIQUE CUSTOMERS DO WE HAVE?
SELECT COUNT(DISTINCT customer_id) total_customers from retail_sales;

# HOW MANY UNIQUE CATEGORIES DO WE HAVE?
SELECT COUNT(DISTINCT category) total_categories from retail_sales;
SELECT	DISTINCT category FROM retail_sales;


# DATA ANALYSIS AND BUSINESS KEY PROBLEMS:

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = "2022-11-05";

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is 4 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE category="clothing"
AND DATE_FORMAT(sale_date, '%Y') = "2022"
AND quantity = 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,SUM(total_sale) as net_sale
FROM retail_sales 
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2)
FROM retail_sales 
where category="beauty";

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
      category, 
      gender,
      COUNT(*) AS total_trans
FROM retail_sales
GROUP BY
      category, 
      gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * 
FROM (
	SELECT
       Year(sale_date) as year,
	   month(sale_date) as month,
	   Avg(total_sale) as avg_sale,
       RANK() OVER (PARTITION BY Year(sale_date) ORDER BY AVG(total_sale) DESC) as rnk
  FROM retail_sales
 Group BY Year(sale_date), month(sale_date)
 ) AS t1
 Where rnk = 1;
        
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
group by customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
      category, 
      COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
Group By category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale as
(
SELECT *,
 CASE 
     WHEN HOUR(sale_time) < 12 THEN "Morning"
     WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN "Afternoon"
     ELSE "Evening"
END AS shift
FROM retail_sales)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- END OF THE PROJECT




