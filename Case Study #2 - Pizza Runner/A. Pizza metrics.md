# :pizza: Case Study #2: Pizza runner - Pizza Metrics

## Case Study Questions

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

***

###  1. How many pizzas were ordered?

```sql
SELECT 
    count(pizza_id) AS "total_pizzas_ordered"
FROM pizza_runner.customer_orders;
``` 
	
#### Result set:
| total_pizzas_ordered |
|----------------------|
| 14                   |

***

###  2. How many unique customer orders were made?

```sql
SELECT 
  COUNT(DISTINCT order_id) AS 'unique_pizzas_orders'
FROM customer_orders_temp;
``` 
	
#### Result set:
| unique_pizzas_orders |
|----------------------|
| 10                   |

***

###  3. How many successful orders were delivered by each runner?

```sql
SELECT
    runner_id,
    count(order_id) AS 'total_successful_orders'
FROM pizza_runner.runner_orders_temp
WHERE cancellation IS NULL
GROUP BY runner_id;
``` 
	
#### Result set:
| runner_id | total_successful_orders |
|-----------|-------------------------|
| 1         | 4                       |
| 2         | 3                       |
| 3         | 1                       |

***

###  4. How many of each type of pizza was delivered?

```sql
SELECT 
    pizza_id,
    pizza_name,
    count(pizza_id) AS 'total_pizzas_delivered'
FROM pizza_runner.runner_orders_temp
    INNER JOIN customer_orders_temp USING (order_id)
    INNER JOIN pizza_names USING (pizza_id)
WHERE cancellation IS NULL
GROUP BY pizza_id, pizza_name;
``` 
	
#### Result set:
| pizza_id | pizza_name | total_pizzas_delivered |
|----------|------------|------------------------|
| 1        | Meatlovers | 9                      |
| 2        | Vegetarian | 3                      |

***

###  5. How many Vegetarian and Meatlovers were ordered by each customer?

```sql
SELECT customer_id,
       pizza_name,
       count(pizza_id) AS 'total_pizzas_delivered'
FROM customer_orders_temp
    INNER JOIN pizza_names USING (pizza_id)
GROUP BY customer_id,
         pizza_id
ORDER BY customer_id ;
``` 
	
#### Result set:
| customer_id | pizza_name | total_pizzas_delivered |
|-------------|------------|------------------------|
| 101         | Meatlovers | 2                      |
| 101         | Vegetarian | 1                      |
| 102         | Meatlovers | 2                      |
| 102         | Vegetarian | 1                      |
| 103         | Meatlovers | 3                      |
| 103         | Vegetarian | 1                      |
| 104         | Meatlovers | 3                      |
| 105         | Vegetarian | 1                      |

- The counts of the Meat lover and Vegetarian pizzas ordered by the customers is not discernable.

```sql
SELECT 
    customer_id,
    SUM(CASE
            WHEN pizza_id = 1 THEN 1
            ELSE 0
        END) AS 'Meat lover Pizza Count',
    SUM(CASE
            WHEN pizza_id = 2 THEN 1
            ELSE 0
        END) AS 'Vegetarian Pizza Count'
FROM customer_orders_temp
GROUP BY customer_id
ORDER BY customer_id;
``` 
	
#### Result set:
| customer_id | Meat lover Pizza Count | Vegetarian Pizza Count |
|-------------|------------------------|------------------------|
| 101         | 2                      | 1                      |
| 102         | 2                      | 1                      |
| 103         | 3                      | 1                      |
| 104         | 3                      | 0                      |
| 105         | 0                      | 1                      |

***

###  6. What was the maximum number of pizzas delivered in a single order?

```sql
SELECT 
    customer_id,
    order_id,
    count(order_id) AS pizza_count
FROM customer_orders_temp
GROUP BY customer_id, order_id
ORDER BY pizza_count DESC
LIMIT 1;
``` 
	
#### Result set:
| customer_id | order_id | pizza_count |
|-------------|----------|-------------|
| 103         | 4        | 3           |

***

###  7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
- at least 1 change -> either exclusion or extras 
- no changes -> exclusion and extras are NULL

```sql
SELECT 
    customer_id,
    SUM(CASE
            WHEN (exclusions IS NOT NULL
                    OR extras IS NOT NULL) THEN 1
            ELSE 0
        END) AS change_in_pizza,
    SUM(CASE
            WHEN (exclusions IS NULL
                    AND extras IS NULL) THEN 1
            ELSE 0
        END) AS no_change_in_pizza
FROM customer_orders_temp
    INNER JOIN runner_orders_temp USING (order_id)
WHERE cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id;
``` 

#### Result set:
| customer_id | change_in_pizza | no_change_in_pizza |
|-------------|-----------------|--------------------|
| 101         | 0               | 2                  |
| 102         | 0               | 3                  |
| 103         | 3               | 0                  |
| 104         | 2               | 1                  |
| 105         | 1               | 0                  |

***

###  8. How many pizzas were delivered that had both exclusions and extras?

```sql

SELECT 
    customer_id,
    SUM(CASE
            WHEN (exclusions IS NOT NULL
                    AND extras IS NOT NULL) THEN 1
            ELSE 0
        END) AS both_change_in_pizza
FROM customer_orders_temp
    INNER JOIN runner_orders_temp USING (order_id)
WHERE cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id;
``` 
	
#### Result set:
| customer_id | both_change_in_pizza |
|-------------|----------------------|
| 101         | 0                    |
| 102         | 0                    |
| 103         | 0                    |
| 104         | 1                    |
| 105         | 0                    |

***

###  9. What was the total volume of pizzas ordered for each hour of the day?

```sql
SELECT 
    hour(order_time) AS 'order_hour',
    count(order_id) AS 'total_pizzas_ordered',
    round(100*count(order_id) /sum(count(order_id)) over(), 2) AS '%_pizzas_ordered'
FROM pizza_runner.customer_orders_temp
GROUP BY 1
ORDER BY 1;
``` 
	
#### Result set:
| order_hour | total_pizzas_ordered | %_pizzas_ordered |
|------------|----------------------|------------------|
| 11         | 1                    | 7.14             |
| 13         | 3                    | 21.43            |
| 18         | 3                    | 21.43            |
| 19         | 1                    | 7.14             |
| 21         | 3                    | 21.43            |
| 23         | 3                    | 21.43            |

***

###  10. What was the volume of orders for each day of the week?
- The DAYOFWEEK() function returns the weekday index for a given date ( 1=Sunday, 2=Monday, 3=Tuesday, 4=Wednesday, 5=Thursday, 6=Friday, 7=Saturday )
- DAYNAME() returns the name of the week day 

```sql
SELECT 
    dayname(order_time) AS 'day_of_week',
    count(order_id) AS 'total_pizzas_ordered',
    round(100*count(order_id) /sum(count(order_id)) over(), 2) AS '%_pizzas_ordered'
FROM pizza_runner.customer_orders_temp
GROUP BY 1
ORDER BY 2 DESC;
``` 
	
#### Result set:
| day_of_week | total_pizzas_ordered | %_pizzas_ordered |
|-------------|----------------------|------------------|
| Wednesday   | 5                    | 35.71            |
| Saturday    | 5                    | 35.71            |
| Thursday    | 3                    | 21.43            |
| Friday      | 1                    | 7.14             |

***

Click [here](https://github.com/Akama-EO/sql-portfolio-projects/blob/main/Case%20Study%20%23%202%20-%20Pizza%20Runner/B.%20Runner%20and%20Customer%20Experience.md) to view the solution for **B. Runner and Customer Experience**.

Click [here](https://github.com/Akama-EO/sql-portfolio-projects) to move back to the 8-Week-SQL-Challenge repository!
