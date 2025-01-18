# :pizza: Case Study #2: Pizza runner - Pricing and Ratings

## Case Study Questions

1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

***

###  1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

```sql
SELECT
	CONCAT('$', SUM(CASE
					   WHEN pizza_id = 1 THEN 12
					   ELSE 10
				   END)) AS total_revenue
FROM customer_orders_temp
	INNER JOIN pizza_names USING (pizza_id)
	INNER JOIN runner_orders_temp USING (order_id)
WHERE cancellation IS NULL;
``` 
	
#### Result set:
| total_revenue |
|---------------|
| $138          |

***

###  2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra

```sql
SELECT 
	CONCAT('$', topping_revenue+ pizza_revenue) AS total_revenue
FROM
  (SELECT 
	  SUM(CASE
		  WHEN pizza_id = 1 THEN 12
			  ELSE 10
		  END) AS pizza_revenue,
    SUM(topping_count) AS topping_revenue
   FROM
     (SELECT 
		 *,
		 length(extras) - length(replace(extras, ",", "")) + 1 AS topping_count
      FROM customer_orders_temp
		INNER JOIN pizza_names USING (pizza_id)
		INNER JOIN runner_orders_temp USING (order_id)
      WHERE cancellation IS NULL
      ORDER BY order_id)t1) t2;
``` 
	
#### Result set:
| total_revenue |
|---------------|
| $142          |

***

###  3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

```sql
DROP TABLE IF EXISTS runner_rating;

CREATE TABLE runner_rating (order_id INTEGER, rating INTEGER, review VARCHAR(100)) ;

-- Order 6 and 9 were cancelled
INSERT INTO runner_rating
VALUES ('1', '1', 'Really bad service'),
       ('2', '1', NULL),
       ('3', '4', 'Took too long...'),
       ('4', '1', 'Runner was lost, delivered it AFTER an hour. Pizza arrived cold' ),
       ('5', '2', 'Good service'),
       ('7', '5', 'It was great, good service and fast'),
       ('8', '2', 'He tossed it on the doorstep, poor service'),
       ('10', '5', 'Delicious!, he delivered it sooner than expected too!');

SELECT *
FROM runner_rating;
``` 
	
#### Result set:
| order_id | rating | review                                                          |
|----------|--------|-----------------------------------------------------------------|
| 1        | 1      | Really bad service                                              |
| 2        | 1      | NULL                                                            |
| 3        | 4      | Took too long...                                                |
| 4        | 1      | Runner was lost, delivered it AFTER an hour. Pizza arrived cold |
| 5        | 2      | Good service                                                    |
| 7        | 5      | It was great, good service and fast                             |
| 8        | 2      | He tossed it on the doorstep, poor service                      |
| 10       | 5      | Delicious!, he delivered it sooner than expected too!           |

***

###  4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas

```sql
SELECT customer_id,
       order_id,
       runner_id,
       rating,
       order_time,
       pickup_time,
       TIMESTAMPDIFF(MINUTE, order_time, pickup_time) pick_up_time,
       duration AS delivery_duration,
       round(distance*60/duration, 2) AS average_speed,
       count(pizza_id) AS total_pizza_count
FROM customer_orders_temp
INNER JOIN runner_orders_temp USING (order_id)
INNER JOIN runner_rating USING (order_id)
GROUP BY order_id ;
``` 
	
#### Result set:
| customer_id | order_id | runner_id | rating | total_pizza_count | order_time          | pickup_time         | pick_up_time | delivery_duration | avg_delivery_speed |
|-------------|----------|-----------|--------|-------------------|---------------------|---------------------|--------------|-------------------|--------------------|
| 101         | 1        | 1         | 1      | 1                 | 2020-01-01 18:05:02 | 2020-01-01 18:15:34 | 10           | 32                | 37.5               |
| 101         | 2        | 1         | 1      | 1                 | 2020-01-01 19:00:52 | 2020-01-01 19:10:54 | 10           | 27                | 44.44              |
| 102         | 3        | 1         | 4      | 1                 | 2020-01-02 23:51:23 | 2020-01-03 00:12:37 | 21           | 20                | 40.2               |
| 102         | 3        | 1         | 4      | 1                 | 2020-01-02 23:51:23 | 2020-01-03 00:12:37 | 21           | 20                | 40.2               |
| 103         | 4        | 2         | 1      | 2                 | 2020-01-04 13:23:46 | 2020-01-04 13:53:03 | 29           | 40                | 35.1               |
| 103         | 4        | 2         | 1      | 1                 | 2020-01-04 13:23:46 | 2020-01-04 13:53:03 | 29           | 40                | 35.1               |
| 104         | 5        | 3         | 2      | 1                 | 2020-01-08 21:00:29 | 2020-01-08 21:10:57 | 10           | 15                | 40                 |
| 105         | 7        | 2         | 5      | 1                 | 2020-01-08 21:20:29 | 2020-01-08 21:30:45 | 10           | 25                | 60                 |
| 102         | 8        | 2         | 2      | 1                 | 2020-01-09 23:54:33 | 2020-01-10 00:15:02 | 20           | 15                | 93.6               |
| 104         | 10       | 1         | 5      | 2                 | 2020-01-11 18:34:49 | 2020-01-11 18:50:20 | 15           | 10                | 60                 |

***

###  5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```sql
SELECT 
	concat('$', round(sum(t2.total_pizza_cost - t2.free_delivery_cost), 2)) AS pizza_runner_revenue
FROM
  (SELECT
		  t1.order_id, 
      t1.pizza_id, 
      t1.distance, 
      t1.pizza_cost,
      sum(t1.pizza_cost) AS total_pizza_cost,
      round(0.30 * t1.distance, 2) AS free_delivery_cost
   FROM
     (SELECT 
        order_id, pizza_id, distance,
        (CASE
          WHEN pizza_id = 1 THEN 12
          ELSE 10
        END) AS pizza_cost
      FROM customer_orders_temp
        INNER JOIN pizza_names USING (pizza_id)
        INNER JOIN runner_orders_temp USING (order_id)
      WHERE cancellation IS NULL
      ORDER BY order_id) AS t1
   GROUP BY t1.order_id, t1.pizza_id, t1.distance, t1.pizza_cost
   ORDER BY order_id) AS t2;
``` 
	
#### Result set:
| pizza_runner_revenue |
|----------------------|
| $83.4                |

***

Click [here](https://github.com/Akama-EO/sql-portfolio-projects/blob/main/Case%20Study%20%23%202%20-%20Pizza%20Runner/E.%20Bonus%20Questions.md) to view the solution of E. Bonus Questions!

Click [here](https://github.com/Akama-EO/sql-portfolio-projects) to move back to the 8-Week-SQL-Challenge repository!

