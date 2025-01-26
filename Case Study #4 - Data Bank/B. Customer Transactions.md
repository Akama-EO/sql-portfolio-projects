## :technologist::woman_technologist: Case Study #4: Data Bank - Customer Transactions

## Case Study Questions

1. What is the unique count and total amount for each transaction type?
2. What is the average total historical deposit counts and amounts for all customers?
3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
4. What is the closing balance for each customer at the end of the month?
5. What is the percentage of customers who increase their closing balance by more than 5%?

***

###  1. What is the unique count and total amount for each transaction type?

```sql
SELECT 
  txn_type,
  count(*) AS unique_count,
  sum(txn_amount) AS total_amont
FROM customer_transactions
GROUP BY txn_type;
``` 
	
#### Result set:
| txn_type   | unique_count | total_amont |
|------------|--------------|-------------|
| deposit    | 2671         | $ 1359168   |
| withdrawal | 1580         | $ 793003    |
| purchase   | 1617         | $ 806537    |

***

###  2. What is the average total historical deposit counts and amounts for all customers?

```sql
SELECT 
  round(count(customer_id) /
    (SELECT count(DISTINCT customer_id)
     FROM customer_transactions)) AS average_count,
  concat('$', round(avg(txn_amount), 2)) AS average_amount
FROM customer_transactions
WHERE txn_type = "deposit";
``` 
	
#### Result set:
| average_count | average_amount |
|---------------|----------------|
| 5             | $508.86        |

***

###  3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

```sql
WITH cte AS
(
  SELECT customer_id,
    month(txn_date) AS txn_month,
    sum(IF(txn_type="deposit", 1, 0)) AS deposit_count,
    sum(IF(txn_type="withdrawal", 1, 0)) AS withdrawal_count,
    sum(IF(txn_type="purchase", 1, 0)) AS purchase_count
   FROM customer_transactions
   GROUP BY customer_id, month(txn_date)
)
SELECT 
  txn_month,
  count(DISTINCT customer_id) as customer_count
FROM cte
WHERE deposit_count>1
  AND (purchase_count = 1
  OR withdrawal_count = 1)
GROUP BY txn_month;
``` 
	
#### Result set:
| txn_month | customer_count |
|-----------|----------------|
| 1         | 115            |
| 2         | 108            |
| 3         | 113            |
| 4         | 50             |

***

###  4. What is the closing balance for each customer at the end of the month?

#### Method 01 - Using common table expressions

```sql
WITH cte_01 AS
(
	SELECT 
		customer_id,
		txn_type,
		txn_amount,
		month(txn_date) AS txn_month,
		sum(CASE
		      WHEN txn_type="deposit" THEN txn_amount
			    ELSE -txn_amount
			  END) AS net_amount
	FROM customer_transactions
	GROUP BY customer_id, txn_type, txn_amount, month(txn_date)
	ORDER BY customer_id
), cte_02 AS
(
	SELECT 
		customer_id,
		txn_type,
		txn_month,
		net_amount,
		sum(net_amount) over(PARTITION BY customer_id ORDER BY txn_month 
                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS closing_balance,
		row_number() over(partition by customer_id, txn_month order by txn_month) as row_index,
    count(txn_month) over(partition by customer_id, txn_month order by txn_month) as month_count
	FROM cte_01
)
select customer_id, txn_month, closing_balance 
from cte_02
where row_index = month_count;
``` 

#### Method 01 - Without using common table expressions

```sql
SELECT 
	customer_id,
    txn_month,
    sum(net_amount) OVER(PARTITION BY customer_id ORDER BY txn_month) as closing_balance 
FROM (
		SELECT 
			customer_id,
			month(txn_date) as txn_month, 
			sum(CASE 
            WHEN txn_type = 'deposit' THEN txn_amount
            ELSE -txn_amount
					END) as net_amount 
		FROM customer_transactions
		GROUP BY txn_month, customer_id
		ORDER BY customer_id, txn_month
	  ) AS tbl
LIMIT 10;
```

#### Result set:
| customer_id | txn_month | closing_balance |
|-------------|-----------|-----------------|
| 1           | 1         | 312             |
| 1           | 3         | -640            |
| 2           | 1         | 549             |
| 2           | 3         | 610             |
| 3           | 1         | 144             |
| 3           | 2         | -821            |
| 3           | 3         | -1222           |
| 3           | 4         | -729            |
| 4           | 1         | 848             |
| 4           | 3         | 655             |

***

###  5. What is the percentage of customers who increase their closing balance by more than 5%?

#### Assumption: We weren't told if the metric should be calculated based on the first month, successive months (i.e month-on-month) or full duration between the initial and final months. Subsequently, we assumed month 1 and 4 are references to the initial and final months.

- **Option 1**: Based on customers who increase their closing balance by more than 5% *after the first month*.
- **Option 2**: Based on customers who increase their closing balance by more than 5% *between the iniatial and final months*.

#### Option 1: Based on customers who increase their closing balance by more than 5% *after the first month*.

```sql

WITH cte_01 AS (
SELECT 
	customer_id,
    txn_month,
    sum(net_amount) OVER(PARTITION BY customer_id ORDER BY txn_month) as closing_balance 
FROM 
(
	SELECT 
		customer_id,
		month(txn_date) as txn_month, 
		sum(CASE 
				WHEN txn_type = 'deposit' THEN txn_amount
				ELSE -txn_amount
				END
			) as net_amount 
	FROM customer_transactions
	GROUP BY txn_month, customer_id
	ORDER BY customer_id, txn_month
) AS tbl_01
), cte_02 AS (
SELECT 
	customer_id,
	txn_month,
	closing_balance
FROM cte_01
)
SELECT 
	round(100.0 * sum(CASE WHEN (net_balance > 1.05 * closing_balance) THEN 1 ELSE 0 END) /
	    nullif(sum(CASE WHEN net_balance IS NOT NULL THEN 1 ELSE 0 END), 0), 2) AS met_criteria
FROM 
(
	SELECT
		closing_balance,
		CASE 
			WHEN txn_month = 1 THEN lead(closing_balance) OVER (PARTITION BY customer_id ORDER BY txn_month) 
		END AS net_balance
	FROM cte_02 AS t
	WHERE txn_month IN (1, 4)
) AS tbl_02;
``` 
	
#### Result set:
| met_criteria |
|--------------|
| 32.36        |

#### Option 2: Based on customers who increase their closing balance by more than 5% *between the iniatial and final months*.

```sql

WITH cte_01 AS (
SELECT 
	customer_id,
  txn_month,
  sum(net_amount) OVER(PARTITION BY customer_id ORDER BY txn_month) AS closing_balance 
FROM 
(
	SELECT 
		customer_id,
		month(txn_date) as txn_month, 
		sum(CASE 
				WHEN txn_type = 'deposit' THEN txn_amount
				ELSE -txn_amount
			END) AS net_amount 
	FROM customer_transactions
	GROUP BY txn_month, customer_id
	ORDER BY customer_id, txn_month
) AS tbl
), cte_02 AS (
SELECT 
	customer_id,
	txn_month,
	closing_balance
FROM cte_01
)
SELECT 
	round(100.0 * sum(CASE WHEN (net_balance > 1.05 * closing_balance) THEN 1 ELSE 0 END) /
		sum(CASE WHEN net_balance IS NOT NULL THEN 1 ELSE 0 END), 2) AS met_criteria
FROM 
(
	SELECT 
		closing_balance,
		CASE 
			WHEN txn_month >= 1 THEN sum(closing_balance) OVER (PARTITION BY customer_id ORDER BY txn_month)
		END AS net_balance
	FROM cte_02 AS t
	WHERE txn_month IN (1, 4)
) AS tbl_02;
``` 
	
#### Result set:
| met_criteria |
|--------------|
| 47.10        |

***

Click [here](https://github.com/Akama-EO/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%204%20-%20Data%20Bank/C.%20Data%20Allocation%20Challenge.md) to view the solution of **C. Data Allocation Challenge**.

Click [here](https://github.com/Akama-EO/sql-portfolio-projects) to move back to the 8-Week-SQL-Challenge repository!
