# :pizza: Case Study #2: Pizza runner - Runner and Customer Experience

## Case Study Questions

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

***

###  1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
- Returned week number is between 0 and 52 or 0 and 53.
- Default mode of the week =0 -> First day of the week is Sunday
- Extract week -> WEEK(registration_date) or EXTRACT(week from registration_date)

```sql
SELECT
  Week(registration_date) as 'Week of registration',
  COUNT(runner_id) as 'total_runners'
FROM pizza_runner.runners
GROUP BY 1;
``` 
	
#### Result set:
| week_of_registration | total_runners |
|----------------------|---------------|
| 0                    | 1             |
| 1                    | 2             |
| 2                    | 1             |

***

###  2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql
SELECT runner_id,
       TIMESTAMPDIFF(MINUTE, order_time, pickup_time) AS runner_pickup_time,
       round(avg(TIMESTAMPDIFF(MINUTE, order_time, pickup_time)), 2) avg_runner_pickup_time
FROM runner_orders_temp
INNER JOIN customer_orders_temp USING (order_id)
WHERE cancellation IS NULL
GROUP BY runner_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164702992-fbc50aa6-7e66-45c7-8e77-7e906a77e004.png)

***

###  3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

```sql
WITH CTE AS
  (SELECT 
    order_id,
    COUNT(order_id) AS total_pizzas_ordered,
    TIMESTAMPDIFF(MINUTE, order_time, pickup_time) AS prep_time
   FROM runner_orders_temp
	INNER JOIN customer_orders_temp USING (order_id)
    WHERE cancellation IS NULL
    GROUP BY order_id, order_time, pickup_time)
SELECT 
  total_pizzas_ordered,
  round(avg(prep_time), 2) AS avg_prep_time
FROM CTE
GROUP BY total_pizzas_ordered;
``` 
	
#### Result set:
| total_pizzas_ordered | avg_prep_time |
|----------------------|---------------|
| 1                    | 12.00         |
| 2                    | 18.00         |
| 3                    | 29.00         |

***

###  4. What was the average distance travelled for each customer?

```sql
SELECT 
  customer_id,
  round(avg(distance), 2) AS avg_distance_travelled
FROM runner_orders_temp
  INNER JOIN customer_orders_temp USING (order_id)
WHERE cancellation IS NULL
GROUP BY customer_id;
``` 
	
#### Result set:
| customer_id | avg_distance_travelled |
|-------------|------------------------|
| 101         | 20                     |
| 102         | 16.73                  |
| 103         | 23.4                   |
| 104         | 10                     |
| 105         | 25                     |

***

###  5. What was the difference between the longest and shortest delivery times for all orders?

```sql
SELECT 
  MIN(duration) minimum_duration,
  MAX(duration) AS maximum_duration,
  MAX(duration) - MIN(duration) AS maximum_difference
FROM runner_orders_temp;
``` 
	
#### Result set:
| minimum_duration | maximum_duration | maximum_difference |
|------------------|------------------|--------------------|
| 10               | 40               | 30                 |

***

###  6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql
SELECT 
	runner_id,
	distance AS distance_km,
  round(duration/60, 2) AS duration_hr,
  round(distance*60/duration, 2) AS average_speed
FROM runner_orders_temp
WHERE cancellation IS NULL
ORDER BY runner_id;
``` 
	
#### Result set:
| runner_id | distance_km | duration_hr | average_speed |
|-----------|-------------|-------------|---------------|
| 1         | 20          | 0.53        | 37.5          |
| 1         | 20          | 0.45        | 44.44         |
| 1         | 13.4        | 0.33        | 40.2          |
| 1         | 10          | 0.17        | 60            |
| 2         | 23.4        | 0.67        | 35.1          |
| 2         | 25          | 0.42        | 60            |
| 2         | 23.4        | 0.25        | 93.6          |
| 3         | 10          | 0.25        | 40            |

***

###  7. What is the successful delivery percentage for each runner?

```sql
SELECT
	runner_id,
	COUNT(pickup_time) AS delivered_orders,
	COUNT(*) AS total_orders,
	ROUND(100 * COUNT(pickup_time) / COUNT(*)) AS delivery_success_percentage
FROM runner_orders_temp
GROUP BY runner_id
ORDER BY runner_id;
``` 
	
#### Result set:
| runner_id | delivered_orders | total_orders | delivery_success_percentage |
|-----------|------------------|--------------|-----------------------------|
| 1         | 4                | 4            | 100                         |
| 2         | 3                | 4            | 75                          |
| 3         | 1                | 2            | 50                          |

***

Click [here](https://github.com/Akama-EO/sql-portfolio-projects/blob/main/Case%20Study%20%23%202%20-%20Pizza%20Runner/C.%20Ingredient%20Optimisation.md) to view the solution for **C. Ingredient Optimisation**.

Click [here](https://github.com/Akama-EO/sql-portfolio-projects) to move back to the 8-Week-SQL-Challenge repository!

