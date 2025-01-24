## :avocado: Case Study #3: Foodie-Fi - Customer Journey

Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

***

###  Join the dataset using plan_id

```sql
SELECT 
    customer_id,
    plan_id,
    plan_name,
    start_date
FROM subscriptions
JOIN plans USING (plan_id)
LIMIT 5
``` 
	
#### Result set:
| customer_id | plan_id | plan_name     | start_date |
|-------------|---------|---------------|------------|
| 1           | 0       | trial         | 2020-08-01 |
| 1           | 1       | basic monthly | 2020-08-08 |
| 2           | 0       | trial         | 2020-09-20 |
| 2           | 3       | pro annual    | 2020-09-27 |
| 3           | 0       | trial         | 2020-01-13 |

***

### Check the earliest and latest subsciption dates

```sql
SELECT 
    min(start_date) AS min_start_date,
    max(start_date) AS max_start_date
FROM subscriptions
JOIN plans USING (plan_id);
```

#### Result set:
| min_start_date | max_start_date |
|----------------|----------------|
| 2020-01-01     | 2021-04-30     |

***

###  Number of distinct customers in each plan

```sql
SELECT 
    plan_id,
    plan_name,
    count(distinct(customer_id)) AS subscriptions
FROM subscriptions
JOIN plans USING (plan_id)
GROUP BY plan_id, plan_name
ORDER BY plan_id;
``` 

#### Result set:
| plan_id | plan_name     | subsciptions |
|---------|---------------|--------------|
| 0       | trial         | 1000         |
| 1       | basic monthly | 546          |
| 2       | pro monthly   | 539          |
| 3       | pro annual    | 258          |
| 4       | churn         | 307          |

***

### Overview of the top 10 customer journeys 

```sql
SELECT 
    customer_id,
    plan_id,
    plan_name,
    start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id BETWEEN 1 AND 10
ORDER BY customer_id;
```

#### Result set:
| customer_id | plan_id | plan_name     | start_date |
|-------------|---------|---------------|------------|
| 1           | 0       | trial         | 2020-08-01 |
| 1           | 1       | basic monthly | 2020-08-08 |
| 2           | 0       | trial         | 2020-09-20 |
| 2           | 3       | pro annual    | 2020-09-27 |
| 3           | 0       | trial         | 2020-01-13 |
| 3           | 1       | basic monthly | 2020-01-20 |
| 4           | 0       | trial         | 2020-01-17 |
| 4           | 1       | basic monthly | 2020-01-24 |
| 4           | 4       | churn         | 2020-04-21 |
| 5           | 0       | trial         | 2020-08-03 |
| 5           | 1       | basic monthly | 2020-08-10 |
| 6           | 0       | trial         | 2020-12-23 |
| 6           | 1       | basic monthly | 2020-12-30 |
| 6           | 4       | churn         | 2021-02-26 |
| 7           | 0       | trial         | 2020-02-05 |
| 7           | 1       | basic monthly | 2020-02-12 |
| 7           | 2       | pro monthly   | 2020-05-22 |
| 8           | 0       | trial         | 2020-06-11 |
| 8           | 1       | basic monthly | 2020-06-18 |
| 8           | 2       | pro monthly   | 2020-08-03 |
| 9           | 0       | trial         | 2020-12-07 |
| 9           | 3       | pro annual    | 2020-12-14 |
| 10          | 0       | trial         | 2020-09-19 |
| 10          | 2       | pro monthly   | 2020-09-26 |

***

### Overview of customer on-boarding journey

1. There are 1,000 distinct customers on-boarded from January 01, 2020 through to April 30, 2021.
2. There are 5 distinct subscription plans, starting off with the *trial plan*.
3. There was a progressive reduction in customer subscriptions on paid plans - 546/1000 basic monthly, 539/1000 pro monthly, and 258/1000 pro annual subscribers.
4. There was an approximate 30% churn rate (307 from 1,000 customers).
5. The preliminary analysis of the top 10 customers showed 2 customers churned from the *basic monthly* plan.

Click [here](https://github.com/Akama-EO/sql-portfolio-projects/blob/main/Case%20Study%20%233%20-%20Foodie-Fi/B.%20Data%20Analysis%20Questions.md) to view the solution solution of **B. Data Analysis Questions**

Click [here](https://github.com/Akama-EO/sql-portfolio-projects) to move back to the 8-Week-SQL-Challenge repository!


