/*Data Exploration:
Data exploration refers to the process of examining and understanding the structure, content, and relationships within a dataset using SQL queries. 
It involves querying the data to gain insights, identify patterns, detect anomalies, and understand the characteristics of the dataset.
*/
--1. Total number of transactions were there for each year in the dataset?
SELECT calendar_year,SUM(transactions) AS total_transactions
FROM clean_weekly_sales group by calendar_year;

--2. Total sales for each region for each month?
SELECT month_number, region,SUM(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY month_number, region
ORDER BY month_number, region;

--3.Total count of transactions for each platform
SELECT platform,SUM(transactions) AS total_transactions
FROM clean_weekly_sales GROUP BY platform;

--4.Percentage of sales for Retail vs Shopify for each month?
WITH cte_monthly_platform_sales AS (
  SELECT month_number,calendar_year,  platform, SUM(sales) AS monthly_sales
  FROM clean_weekly_sales
  GROUP BY month_number,calendar_year, platform
)
SELECT month_number,calendar_year,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Retail' THEN monthly_sales ELSE NULL END) /SUM(monthly_sales),2) AS retail_percentage,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Shopify' THEN monthly_sales ELSE NULL END) /SUM(monthly_sales), 2 ) AS shopify_percentage
FROM cte_monthly_platform_sales
GROUP BY month_number,calendar_year
ORDER BY month_number,calendar_year;

--5.Percentage of sales by demographic for each year in the dataset?
SELECT calendar_year, demographic,SUM(SALES) AS yearly_sales,
  ROUND(
    (100 * SUM(sales)/ SUM(SUM(SALES)) OVER (PARTITION BY demographic) ),2
  ) AS percentage
FROM clean_weekly_sales
GROUP BY calendar_year,demographic
ORDER BY calendar_year,demographic;

--6.Which age_band and demographic values contribute the most to Retail sales?
SELECT age_band,demographic,SUM(sales) AS total_sales
FROM clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY total_sales DESC;

