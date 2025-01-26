## :technologist::woman_technologist: Case Study #4: Data Bank - Data Allocation Challenge

To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers would be allocated data using 3 different options:

- **Option 1**: data is allocated based off the amount of money at the end of the previous month
- **Option 2**: data is allocated on the average amount of money kept in the account in the previous 30 days
- **Option 3**: data is updated real-time


For this multi-part challenge question - you have been requested to generate the following data elements to help the Data Bank team estimate how much data will need to be provisioned for each option:
- running customer balance column that includes the impact each transaction
```sql
WITH cte_01 AS (
SELECT 
  *,
  month(txn_date) AS txn_month,
  sum(CASE
        WHEN txn_type="deposit" THEN txn_amount
        ELSE -txn_amount
      END) AS net_amount
FROM customer_transactions
GROUP BY customer_id, txn_date, txn_month, txn_type, txn_amount
ORDER BY customer_id, txn_date), cte_02 AS (
SELECT 
  customer_id,
  txn_month,
  sum(net_amount) over(PARTITION BY customer_id ORDER BY txn_month 
                       ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS net_balance
FROM cte_01)
SELECT *
FROM cte_02;
``` 
- customer balance at the end of each month

```sql
WITH cte_01 AS  (
SELECT 
  *,
  month(txn_date) AS txn_month,
  sum(CASE
        WHEN txn_type="deposit" THEN txn_amount
        ELSE -txn_amount
      END) AS net_amount
FROM customer_transactions
GROUP BY customer_id, txn_date, txn_month, txn_type, txn_amount
ORDER BY customer_id, txn_date), cte_02 AS (
SELECT 
  customer_id,
  txn_month,
  sum(net_amount) over(PARTITION BY customer_id ORDER BY txn_month 
                       ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS net_balance
FROM cte_01), cte_03 AS (
SELECT 
  customer_id,
  txn_month,
  last_value(net_balance) over(PARTITION BY customer_id, txn_month
                               ORDER BY txn_month) AS gross_balance
FROM cte_02
GROUP BY customer_id, txn_month, net_balance)
SELECT 
  *
FROM cte_03;
``` 
- minimum, average and maximum values of the running balance for each customer
```sql
WITH cte_01 AS (
SELECT 
  *,
  month(txn_date) AS txn_month,
  sum(CASE
        WHEN txn_type="deposit" THEN txn_amount
        ELSE -txn_amount
      END) AS net_amount
FROM customer_transactions
GROUP BY customer_id, txn_date, txn_month, txn_type, txn_amount
ORDER BY customer_id, txn_date), cte_02 AS (
SELECT 
  customer_id,
  txn_date,
  txn_month,
  txn_type,
  txn_amount,
  sum(net_amount) over(PARTITION BY customer_id ORDER BY txn_month 
                       ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS net_balance
FROM cte_01
GROUP BY customer_id, txn_date, txn_month, txn_type, txn_amount)
SELECT 
  customer_id,
  min(net_balance) AS min_balance,
  max(net_balance) AS max_balance,
  round(avg(net_balance), 2) AS avg_balance
FROM cte_02
GROUP BY customer_id
ORDER BY customer_id;
``` 


Using all of the data available - how much data would have been required for each option on a monthly basis?

###  **Option 1**: Data is allocated based off the amount of money at the end of the previous month
How much data would have been required on a monthly basis?

```sql
WITH cte_01 AS (
SELECT 
  *,
  month(txn_date) AS txn_month,
  sum(CASE
        WHEN txn_type="deposit" THEN txn_amount
        ELSE -txn_amount
      END) AS net_amount
FROM customer_transactions
GROUP BY customer_id, txn_date, txn_type, txn_amount
ORDER BY customer_id, txn_date), cte_02 AS (
SELECT 
  customer_id,
  txn_month,
  sum(net_amount) over(PARTITION BY customer_id
                       ORDER BY txn_month ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS net_balance
FROM cte_01), cte_03 AS (
SELECT 
  *,
  last_value(net_balance) over(PARTITION BY customer_id, txn_month
                               ORDER BY txn_month) AS gross_balance
FROM cte_02), cte_04 AS (
SELECT 
  customer_id,
  txn_month,
  gross_balance
FROM cte_03)
SELECT 
  txn_month,
  sum(gross_balance) AS data_required
FROM cte_04
GROUP BY txn_month
ORDER BY txn_month
``` 

#### Result set:
| txn_month | data_required |
|-----------|---------------|
| 1         | 100631        |
| 2         | -250274       |
| 3         | -1292510      |
| 4         | -553878       |

**Observed**: Data required per month is negative. This is caused due to negative account balance maintained by customers at the end of the month.

**Assumption**: Some customers do not maintain a positive account balance at the end of the month. I'm assuming that no data is allocated when the 
amount of money at the end of the previous month is negative. we can use **SUM(IF(gross_balance > 0, gross_balance, 0))** in the select clause to compute the total data requirement per month.

#### Result set:
| txn_month | data_required |
|-----------|---------------|
| 1         | 705799        |
| 2         | 938031        |
| 3         | 916949        |
| 4         | 438237        |

***

###  **Option 2**: Data is allocated on the average amount of money kept in the account in the previous 30 days
How much data would have been required on a monthly basis?

```sql
WITH cte_01 AS (
SELECT 
  *,
  month(txn_date) AS txn_month,
  sum(CASE
        WHEN txn_type="deposit" THEN txn_amount
        ELSE -txn_amount
      END) AS net_amount
FROM customer_transactions
GROUP BY customer_id, txn_date, txn_type, txn_amount
ORDER BY customer_id, txn_date), cte_02 AS (
SELECT 
  customer_id,
  txn_month,
  sum(net_amount) over(PARTITION BY customer_id ORDER BY txn_month 
                       ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS net_balance
FROM cte_01
GROUP BY customer_id, txn_month, net_amount), cte_03 AS (
SELECT 
  customer_id,
  txn_month,
  avg(net_balance) over(PARTITION BY customer_id) AS avg_balance
FROM cte_02
GROUP BY customer_id, txn_month, net_balance
ORDER BY customer_id)
SELECT 
  txn_month,
  round(sum(avg_balance)) AS data_required
FROM cte_03
GROUP BY txn_month;
``` 

#### Result set:
| txn_month | data_required |
|-----------|---------------|
| 1         | -247374       |
| 3         | -349094       |
| 2         | -143001       |
| 4         | -105369       |



###  **Option 3**: Data is updated real-time
How much data would have been required on a monthly basis?

```sql
WITH cte_01 AS (
SELECT 
  *,
  month(txn_date) AS txn_month,
  sum(CASE
        WHEN txn_type="deposit" THEN txn_amount
        ELSE -txn_amount
      END) AS net_amount
FROM customer_transactions
GROUP BY customer_id, txn_date, txn_type, txn_amount
ORDER BY customer_id, txn_date), cte_02 AS (
SELECT 
  customer_id,
  txn_month,
  sum(net_amount) over(PARTITION BY customer_id ORDER BY txn_month 
                       ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS net_balance
FROM cte_01)
SELECT 
  txn_month,
  sum(net_balance) AS data_required
FROM cte_02
GROUP BY txn_month;
``` 

#### Result set:
| txn_month | data_required |
|-----------|---------------|
| 1         | 420876        |
| 3         | -857461       |
| 2         | 64789         |
| 4         | -472282       |

***

Click [here](https://github.com/Akama-EO/sql-portfolio-projects) to move back to the 8-Week-SQL-Challenge repository!
