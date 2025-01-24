# :avocado: Case Study #3: Foodie-Fi - Data Analysis Questions

## Case Study Questions
1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

***

###  1. How many customers has Foodie-Fi ever had?

```sql
SELECT 
    count(DISTINCT customer_id) AS customer_subscriptions
FROM subscriptions;
``` 
	
#### Result set:
| customer_subscriptions |
|------------------------|
| 1000                   |

***

###  2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

```sql
SELECT 
    extract(month FROM start_date) AS month_number,
    count(DISTINCT customer_id) AS monthly_distribution
FROM subscriptions
JOIN plans USING (plan_id)
WHERE plan_id = 0
GROUP BY month_number;
``` 
	
#### Result set:
| month_number | monthly_distribution |
|--------------|----------------------|
| 1            | 88                   |
| 2            | 68                   |
| 3            | 94                   |
| 4            | 81                   |
| 5            | 88                   |
| 6            | 79                   |
| 7            | 89                   |
| 8            | 88                   |
| 9            | 87                   |
| 10           | 79                   |
| 11           | 75                   |
| 12           | 84                   |

***

###  3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

```sql
SELECT 
    plan_id,
    plan_name,
    count(*) AS total_subscriptions
FROM subscriptions
JOIN plans USING (plan_id)
WHERE extract(year FROM start_date) > 2020
GROUP BY plan_id, plan_name
ORDER BY plan_id;
``` 
	
#### Result set:
| plan_id | plan_name     | total_subscriptions |
|---------|---------------|---------------------|
| 1       | basic monthly | 8                   |
| 2       | pro monthly   | 60                  |
| 3       | pro annual    | 63                  |
| 4       | churn         | 71                  |

***

###  4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```sql
SELECT 
    plan_name,
    count(DISTINCT customer_id) as churn_count,
    concat(round(100 * count(DISTINCT customer_id) / (SELECT count(DISTINCT customer_id) FROM subscriptions), 1), ' %') as churn_percentage
FROM subscriptions
JOIN plans USING (plan_id)
WHERE plan_id = 4
GROUP BY plan_id, plan_name;
``` 
	
#### Result set:
| plan_name | churn_count | churn_percentage |
|-----------|-------------|------------------|
| churn     | 307         | 30.0 %           |

***

###  5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```sql
WITH cte AS
(
  SELECT
      customer_id, plan_id, 
      lead(plan_id, 1) over(PARTITION BY customer_id
                            ORDER BY start_date) AS next_plan
   FROM subscriptions
)
SELECT 
    count(customer_id) AS churn_count,
    concat(round(100 * count(customer_id) / (SELECT count(DISTINCT customer_id) FROM subscriptions), 1), ' %') AS churn_percentage
FROM cte
WHERE next_plan = 4 AND plan_id = 0;
``` 
	
#### Result set:
| churn_count | churn_percentage |
|-------------|------------------|
| 92          | 9.0 %            |

***

###  6. What is the number and percentage of customer plans after their initial free trial?

```sql
WITH cte AS
(
  SELECT 
      customer_id, 
      plan_id, 
      plan_name,
      lag(plan_id, 1) over(PARTITION BY customer_id ORDER BY start_date) AS previous_plan
   FROM subscriptions
   JOIN plans USING (plan_id)
)
SELECT 
    plan_id,
    plan_name,
    count(distinct customer_id) AS customer_count,
    concat(round(100 * count(distinct customer_id) / (SELECT count(distinct customer_id) FROM subscriptions), 1), ' %') AS customer_percentage
FROM cte
WHERE previous_plan = 0
GROUP BY plan_id, plan_name
ORDER BY plan_id;
```
#### Result set:
| plan_id | plan_name     | customer_count | customer_percentage |
|---------|---------------|----------------|---------------------|
| 1       | basic monthly | 546            | 54.0 %              |
| 2       | pro monthly   | 325            | 32.0 %              |
| 3       | pro annual    | 37             | 3.0 %               |
| 4       | churn         | 92             | 9.0 %               |

***

###  7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

```sql
SELECT 
    plan_id,
    plan_name,
    count(distinct customer_id) AS customer_count,
	  concat(round(100 * count(distinct customer_id) / (SELECT count(distinct customer_id) FROM subscriptions), 1), ' %') AS customer_percentage
FROM subscriptions
JOIN plans USING (plan_id)
WHERE start_date <='2020-12-31' 
GROUP BY plan_id, plan_name
ORDER BY plan_id;
``` 
	
#### Result set:
| plan_id | plan_name     | customer_count | customer_percentage |
|---------|---------------|----------------|---------------------|
| 0       | trial         | 1000           | 100.0 %             |
| 1       | basic monthly | 538            | 53.0 %              |
| 2       | pro monthly   | 479            | 47.0 %              |
| 3       | pro annual    | 195            | 19.0 %              |
| 4       | churn         | 236            | 23.0 %              |

***

###  8. How many customers have upgraded to an annual plan in 2020?

```sql
SELECT 
    plan_id,
    plan_name,
    count(distinct customer_id) AS customer_count,
    concat(round(100 * count(distinct customer_id) / (SELECT count(distinct customer_id) FROM subscriptions), 1), ' %') AS customer_percentage
FROM subscriptions
JOIN plans USING (plan_id)
WHERE plan_id = 3 AND extract(year FROM start_date) = 2020
GROUP BY plan_id, plan_name;
```

#### Result set:
| plan_id | plan_name  | customer_count | customer_percentage |
|---------|------------|----------------|---------------------|
| 3       | pro annual | 195            | 19.0 %              |

  
***

###  9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

```sql
WITH cte_01 AS
(
  SELECT *
  FROM subscriptions
  JOIN plans USING (plan_id)
  WHERE plan_id = 0
), cte_02 AS
(
  SELECT *
  FROM subscriptions
  JOIN plans USING (plan_id)
  WHERE plan_id = 3
)
SELECT round(avg((cte_02.start_date - cte_01.start_date)), 2) AS average_conversion
FROM cte_01
INNER JOIN cte_02 USING (customer_id);
``` 

#### Result set:
| average_conversion |
|--------------------|
| 104.62             |

***

###  10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
- The days between trial start date and the annual plan start date is computed.
- The days are bucketed in 30 day period by dividing the number of days obtained by 30.

```sql
WITH cte AS
(
  SELECT 
    *,
    lead(start_date, 1) over(PARTITION BY customer_id ORDER BY start_date) AS next_start_date,
    lead(plan_id, 1) over(PARTITION BY customer_id ORDER BY start_date) AS next_plan
  FROM subscriptions
)
SELECT
  (next_start_date - start_date) / 30 AS window_30_days,
  count(start_date) AS customer_count
FROM cte
WHERE next_plan=3
GROUP BY window_30_days
ORDER BY window_30_days;
``` 
	
#### Result set:
| window_30_days | customer_count |
|----------------|----------------|
| 0              | 52             |
| 1              | 37             |
| 2              | 38             |
| 3              | 37             |
| 4              | 45             |
| 5              | 33             |
| 6              | 16             |

***

###  11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```sql
WITH cte AS
(
  SELECT 
    plan_id, 
    start_date,
    lead(plan_id, 1) over(PARTITION BY customer_id ORDER BY start_date) AS next_plan
  FROM subscriptions
)
SELECT count(*) AS downgrade_count
FROM cte
WHERE plan_id = 2 AND next_plan = 1 AND extract(year FROM start_date) = 2020;
``` 
	
#### Result set:
| downgrade_count |
|-----------------|
| 0               |

***

Click [here](https://github.com/Akama-EO/sql-portfolio-projects/blob/main/Case%20Study%20%233%20-%20Foodie-Fi/C.%20Challenge%20Payment%20Question.md) to view the solution for **C. Challenge Payment Question**.

Click [here](https://github.com/Akama-EO/sql-portfolio-projects) to move back to the 8-Week-SQL-Challenge repository!
