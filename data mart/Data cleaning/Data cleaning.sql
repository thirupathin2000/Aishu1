/*Data Cleansing 
Data cleansing, also known as data cleaning or data scrubbing, is the process of detecting and correcting (or removing) inaccurate, incomplete, or irrelevant data from a dataset. 
The goal of data cleansing is to improve the quality of the data, making it more reliable and suitable for analysis, reporting, and decision-making purposes.
Steps:
In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:
1.	Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2, etc.
2.	Add a month_number with the calendar month for each week_date value as the 3rd column
3.	Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
4.	Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value
segment	age_band
1	Young Adults
2	Middle Aged
3 or 4	Retirees
5.	Add a new demographic column using the following mapping for the first letter in the segment values:
segment | demographic |
C | Couples |
F | Families |

6.	Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns
7.	Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record */
--QUERY:
CREATE TABLE clean_weekly_sales AS
SELECT
  week_date,
  TO_NUMBER(TO_CHAR(week_date, 'WW')) AS week_number,
  TO_NUMBER(TO_CHAR(week_date, 'MM')) AS month_number,
  TO_NUMBER(TO_CHAR(week_date, 'YYYY')) AS calendar_year,
  region,
  platform,
  CASE
    WHEN segment = 'null' THEN 'Unknown'
    ELSE segment
  END AS segment,
  CASE
    WHEN SUBSTR(segment, -1) = '1' THEN 'Young Adults'
    WHEN SUBSTR(segment, -1) = '2' THEN 'Middle Aged'
    WHEN SUBSTR(segment, -1) IN ('3', '4') THEN 'Retirees'
    ELSE 'Unknown'
  END AS age_band,
  CASE
    WHEN SUBSTR(segment, 1, 1) = 'C' THEN 'Couples'
    WHEN SUBSTR(segment, 1, 1) = 'F' THEN 'Families'
    ELSE 'Unknown'
  END AS demographic,
  customer_type,
  transactions,
  sales,
  ROUND(sales / transactions, 2) AS avg_transaction
FROM weekly_sales;
