## :technologist::woman_technologist: Case Study #4: Data Bank - Customer Nodes Exploration

## Case Study Questions

1. How many unique nodes are there on the Data Bank system?
2. What is the number of nodes per region?
3. How many customers are allocated to each region?
4. How many days on average are customers reallocated to a different node?
5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

***

###  1. How many unique nodes are there on the Data Bank system?

```sql
SELECT 
	count(DISTINCT node_id) AS unique_nodes
FROM customer_nodes;
``` 
	
#### Result set:
| unique_nodes |
|--------------|
| 5            |

***

###  2. What is the number of nodes per region?

```sql
SELECT 
	region_id,
	region_name,
	count(DISTINCT node_id) AS node_count
FROM customer_nodes
INNER JOIN regions USING(region_id)
GROUP BY region_id, region_name;
``` 
	
#### Result set:
| region_id | region_name | node_count |
|-----------|-------------|------------|
| 1         | Australia   | 5          |
| 2         | America     | 5          |
| 3         | Africa      | 5          |
| 4         | Asia        | 5          |
| 5         | Europe      | 5          |

***

###  3. How many customers are allocated to each region?

```sql
SELECT 
	region_id,
	region_name,
	count(DISTINCT customer_id) AS customer_count
FROM customer_nodes
INNER JOIN regions USING(region_id)
GROUP BY region_id, region_name
ORDER BY region_id, region_name;
``` 
	
#### Result set:
| region_id | region_name | customer_count |
|-----------|-------------|----------------|
| 1         | Australia   | 110            |
| 2         | America     | 105            |
| 3         | Africa      | 102            |
| 4         | Asia        | 95             |
| 5         | Europe      | 88             |

***

###  4. How many days on average are customers reallocated to a different node?

```sql
WITH cte AS
(
	SELECT 
		customer_id, 
		node_id,
		sum(datediff(end_date, start_date)) AS days_spent
	FROM customer_nodes
	WHERE end_date != '9999-12-31'
	GROUP BY customer_id, node_id
)
SELECT 
	round(avg(days_spent), 0) AS average_days_spent
FROM cte;
``` 
	
#### Result set:
| average_days_spent |
|--------------------|
| 24                 |

***

###  5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
- reallocation days metric: days taken to reallocate to a different node
- Percentile is a statistical metric used to partition data into 100 equal chunks or bins. For this use case, we will partition the dataset by regions and arranging it in ascending order of reallocation_days
- For example, 95th percentile -> 95% of the values are less than or equal to the current value.

```sql
WITH cte_01 AS
(
	SELECT 
		customer_id,
    region_id,
    region_name,
		node_id,
		sum(datediff(end_date, start_date)) AS days_spent
	FROM customer_nodes
  INNER JOIN regions USING (region_id)
	WHERE end_date != '9999-12-31'
	GROUP BY customer_id, node_id, region_id, region_name
), cte_02 AS
(
	SELECT 
		region_id,
		region_name,
		days_spent,
        row_number() OVER(PARTITION BY region_id order by days_spent) AS row_index
	FROM cte_01
), cte_03 AS
(
	SELECT 
		region_id,
        region_name,
		max(row_index) AS max_row_index
	FROM cte_02
  GROUP BY region_id, region_name
), cte_04 AS
(
	SELECT 
		region_id,
		cte_02.region_name,
		days_spent,
		row_index,
		round(max_row_index * 0.50) AS 50th_percentile,
		round(max_row_index * 0.80) AS 80th_percentile,
		round(max_row_index * 0.95) AS 95th_percentile
	FROM cte_02
	INNER JOIN cte_03 USING (region_id)
)
SELECT 
	region_id,
	region_name,
	days_spent,
    CASE
		WHEN row_index = 50th_percentile THEN '50th'
    WHEN row_index = 80th_percentile THEN '80th'
    WHEN row_index = 95th_percentile THEN '95th'
	END percentile
FROM cte_04
WHERE row_index IN (50th_percentile, 80th_percentile, 95th_percentile)
``` 
	
#### Result set:
| region_id | region_name | days_spent | percentile |
|-----------|-------------|------------|------------|
| 1         | Australia   | 21         | 50th       |
| 1         | Australia   | 34         | 80th       |
| 1         | Australia   | 51         | 95th       |
| 2         | America     | 22         | 50th       |
| 2         | America     | 34         | 80th       |
| 2         | America     | 54         | 95th       |
| 3         | Africa      | 22         | 50th       |
| 3         | Africa      | 35         | 80th       |
| 3         | Africa      | 54         | 95th       |
| 4         | Asia        | 22         | 50th       |
| 4         | Asia        | 34         | 80th       |
| 4         | Asia        | 52         | 95th       |
| 5         | Europe      | 23         | 50th       |
| 5         | Europe      | 34         | 80th       |
| 5         | Europe      | 51         | 95th       |

***


Click [here](https://github.com/Akama-EO/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%204%20-%20Data%20Bank/B.%20Customer%20Transactions.md) to view the solution of **B. Customer Transactions**.

Click [here](https://github.com/Akama-EO/sql-portfolio-projects) to move back to the 8-Week-SQL-Challenge repository!


