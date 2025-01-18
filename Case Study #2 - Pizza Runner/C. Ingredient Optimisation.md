# :pizza: Case Study #2: Pizza runner - Ingredient Optimisation (Work In Progress)

## Case Study Questions

1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

***

## Temporary tables created to solve the below queries

```sql
DROP TABLE row_split_customer_orders_temp;

CREATE TEMPORARY TABLE row_split_customer_orders_temp AS
SELECT t.row_num,
       t.order_id,
       t.customer_id,
       t.pizza_id,
       trim(j1.exclusions) AS exclusions,
       trim(j2.extras) AS extras,
       t.order_time
FROM
  (SELECT 
     *,
     row_number() over() AS row_num
   FROM customer_orders_temp) t
INNER JOIN json_table(trim(replace(json_array(t.exclusions), ',', '","')),
                      '$[*]' columns (exclusions varchar(50) PATH '$')) j1
INNER JOIN json_table(trim(replace(json_array(t.extras), ',', '","')),
                      '$[*]' columns (extras varchar(50) PATH '$')) j2 ;

SELECT *
FROM row_split_customer_orders_temp;
``` 

#### Result set:
| row_num | order_id | customer_id | pizza_id | exclusions | extras | order_time          |
|---------|----------|-------------|----------|------------|--------|---------------------|
| 1       | 1        | 101         | 1        | NULL       | NULL   | 2020-01-01 18:05:02 |
| 2       | 2        | 101         | 1        | NULL       | NULL   | 2020-01-01 19:00:52 |
| 3       | 3        | 102         | 1        | NULL       | NULL   | 2020-01-02 23:51:23 |
| 4       | 3        | 102         | 2        | NULL       | NULL   | 2020-01-02 23:51:23 |
| 5       | 4        | 103         | 1        | 4          | NULL   | 2020-01-04 13:23:46 |
| 6       | 4        | 103         | 1        | 4          | NULL   | 2020-01-04 13:23:46 |
| 7       | 4        | 103         | 2        | 4          | NULL   | 2020-01-04 13:23:46 |
| 8       | 5        | 104         | 1        | NULL       | 1      | 2020-01-08 21:00:29 |
| 9       | 6        | 101         | 2        | NULL       | NULL   | 2020-01-08 21:03:13 |
| 10      | 7        | 105         | 2        | NULL       | 1      | 2020-01-08 21:20:29 |
| 11      | 8        | 102         | 1        | NULL       | NULL   | 2020-01-09 23:54:33 |
| 12      | 9        | 103         | 1        | 4          | 1      | 2020-01-10 11:22:59 |
| 12      | 9        | 103         | 1        | 4          | 5      | 2020-01-10 11:22:59 |
| 13      | 10       | 104         | 1        | NULL       | NULL   | 2020-01-11 18:34:49 |
| 14      | 10       | 104         | 1        | 2          | 1      | 2020-01-11 18:34:49 |
| 14      | 10       | 104         | 1        | 2          | 4      | 2020-01-11 18:34:49 |
| 14      | 10       | 104         | 1        | 6          | 1      | 2020-01-11 18:34:49 |
| 14      | 10       | 104         | 1        | 6          | 4      | 2020-01-11 18:34:49 |


```sql
DROP TABLE row_split_pizza_recipes_temp;

CREATE TEMPORARY TABLE row_split_pizza_recipes_temp AS
SELECT 
	t.pizza_id,
     trim(j.topping) AS topping_id
FROM pizza_recipes t
JOIN json_table(trim(replace(json_array(t.toppings), ',', '","')),
                '$[*]' columns (topping varchar(50) PATH '$')) j ;

SELECT *
FROM row_split_pizza_recipes_temp;
```

#### Result set: 
| pizza_id | topping_id |
|----------|------------|
| 1        | 1          |
| 1        | 2          |
| 1        | 3          |
| 1        | 4          |
| 1        | 5          |
| 1        | 6          |
| 1        | 8          |
| 1        | 10         |
| 2        | 4          |
| 2        | 6          |
| 2        | 7          |
| 2        | 9          |
| 2        | 11         |
| 2        | 12         |


```sql
DROP TABLE IF EXISTS standard_ingredients;

CREATE TEMPORARY TABLE standard_ingredients AS
SELECT 
     pizza_id,
     pizza_name,
     group_concat(DISTINCT topping_name) 'standard_ingredients'
FROM row_split_pizza_recipes_temp
	INNER JOIN pizza_names USING (pizza_id)
	INNER JOIN pizza_toppings USING (topping_id)
GROUP BY pizza_id, pizza_name
ORDER BY pizza_id;

SELECT *
FROM standard_ingredients;
```

###  1. What are the standard ingredients for each pizza?

```sql
SELECT *
FROM standard_ingredients;
``` 
	
#### Result set:
| pizza_id | pizza_name | standard_ingredients                                           |
|----------|------------|----------------------------------------------------------------|
| 1        | Meatlovers | Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami |
| 2        | Vegetarian | Cheese,Mushrooms,Onions,Peppers,Tomato Sauce,Tomatoes          |

***

###  2. What was the most commonly added extra?

```sql
WITH CTE AS
  (SELECT 
	   trim(extras) AS extra_topping,
        count(*) AS purchase_counts
   FROM row_split_customer_orders_temp
   WHERE extras IS NOT NULL
   GROUP BY extras)
SELECT 
     topping_name,
     purchase_counts
FROM CTE
     INNER JOIN pizza_toppings 
     ON CTE.extra_topping = pizza_toppings.topping_id
LIMIT 1;

``` 
	
#### Result set:
| pizza_id | pizza_name | standard_ingredients                                           |
|----------|------------|----------------------------------------------------------------|
| 1        | Meatlovers | Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami |
| 2        | Vegetarian | Cheese,Mushrooms,Onions,Peppers,Tomato Sauce,Tomatoes          |

***

###  3. What was the most common exclusion?

```sql
WITH CTE AS
  (SELECT trim(exclusions) AS extra_topping,
          count(*) AS purchase_counts
   FROM row_split_customer_orders_temp
   WHERE exclusions IS NOT NULL
   GROUP BY exclusions)
SELECT topping_name,
       purchase_counts
FROM CTE
     INNER JOIN pizza_toppings 
     ON extra_count_cte.extra_topping = pizza_toppings.topping_id
LIMIT 1;
``` 
	
#### Result set:
| topping_name | purchase_counts |
|--------------|-----------------|
| Cheese       | 5               |

***

###  4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

```sql
WITH CTE AS
  (SELECT 
     pizza_name,
	row_num,
     order_id,
     customer_id,
     excluded_topping,
     t2.topping_name AS extras_topping
   FROM
     (SELECT 
		*,
	    topping_name AS excluded_topping
      FROM row_split_customer_orders_temp
		LEFT JOIN standard_ingredients USING (pizza_id)
		LEFT JOIN pizza_toppings ON topping_id = exclusions) t1
		LEFT JOIN pizza_toppings t2 ON t2.topping_id = extras)
SELECT 
	order_id,
	customer_id,
   CASE
	   WHEN excluded_topping IS NULL
			AND extras_topping IS NULL THEN pizza_name
	   WHEN extras_topping IS NULL
			AND excluded_topping IS NOT NULL THEN concat(pizza_name, ' - Exclude ', GROUP_CONCAT(DISTINCT excluded_topping))
	   WHEN excluded_topping IS NULL
			AND extras_topping IS NOT NULL THEN concat(pizza_name, ' - Include ', GROUP_CONCAT(DISTINCT extras_topping))
	   ELSE concat(pizza_name, ' - Include ', GROUP_CONCAT(DISTINCT extras_topping), ' - Exclude ', GROUP_CONCAT(DISTINCT excluded_topping))
   END AS order_item
FROM CTE
GROUP BY 
     order_id, 
     customer_id, 
     pizza_name, 
     excluded_topping, 
     extras_topping;
``` 
	
#### Result set:
| order_id | customer_id | order_item                                      |
|----------|-------------|-------------------------------------------------|
| 1        | 101         | Meatlovers                                      |
| 2        | 101         | Meatlovers                                      |
| 3        | 102         | Meatlovers                                      |
| 3        | 102         | Vegetarian                                      |
| 4        | 103         | Meatlovers - Exclude Cheese                     |
| 4        | 103         | Vegetarian - Exclude Cheese                     |
| 5        | 104         | Meatlovers - Include Bacon                      |
| 6        | 101         | Vegetarian                                      |
| 7        | 105         | Vegetarian - Include Bacon                      |
| 8        | 102         | Meatlovers                                      |
| 9        | 103         | Meatlovers - Include Bacon - Exclude Cheese     |
| 9        | 103         | Meatlovers - Include Chicken - Exclude Cheese   |
| 10       | 104         | Meatlovers                                      |
| 10       | 104         | Meatlovers - Include Bacon - Exclude BBQ Sauce  |
| 10       | 104         | Meatlovers - Include Cheese - Exclude BBQ Sauce |
| 10       | 104         | Meatlovers - Include Bacon - Exclude Mushrooms  |
| 10       | 104         | Meatlovers - Include Cheese - Exclude Mushrooms |

***

###  5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

```sql

``` 
	
#### Result set:

***

###  6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

```sql

``` 
	
#### Result set:

***

Click [here](https://github.com/Akama-EO/sql-portfolio-projects/blob/main/Case%20Study%20%23%202%20-%20Pizza%20Runner/D.%20Pricing%20and%20Ratings.md) to view the  solution for **D. Pricing and Ratings**.

Click [here](https://github.com/Akama-EO/sql-portfolio-projects) to move back to the 8-Week-SQL-Challenge repository!