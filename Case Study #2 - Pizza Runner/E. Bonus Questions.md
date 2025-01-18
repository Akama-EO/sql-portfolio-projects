# :pizza: Case Study #2: Pizza runner - Bonus Question

### If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

Supreme pizza has all toppings on it.

| topping_id | topping_name |
|------------|--------------|
| 1          | Bacon        |
| 2          | BBQ Sauce    |
| 3          | Beef         |
| 4          | Cheese       |
| 5          | Chicken      |
| 6          | Mushrooms    |
| 7          | Onions       |
| 8          | Pepperoni    |
| 9          | Peppers      |
| 10         | Salami       |
| 11         | Tomatoes     |
| 12         | Tomato Sauce |

We'd have to insert data into *pizza_names* and *pizza_recipes* tables.

***

```sql
INSERT INTO pizza_names VALUES(3, 'Supreme');


SELECT 
    *
FROM
    pizza_names;
``` 

#### Result set:
| pizza_id | pizza_name |
|----------|------------|
| 1        | Meatlovers |
| 2        | Vegetarian |
| 3        | Supreme    |

```sql
INSERT INTO pizza_recipes
VALUES(3, (SELECT GROUP_CONCAT(topping_id SEPARATOR ', ') FROM pizza_toppings));
``` 

```sql
SELECT 
    *
FROM
    pizza_recipes;
``` 

#### Result set:
| pizza_id | toppings                              |
|----------|---------------------------------------|
| 1        | 1, 2, 3, 4, 5, 6, 8, 10               |
| 2        | 4, 6, 7, 9, 11, 12                    |
| 3        | 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 |

*** 

```sql
SELECT 
    *
FROM
    pizza_names
        INNER JOIN
    pizza_recipes USING (pizza_id);
``` 

#### Result set:
| pizza_id | pizza_name | toppings                              |
|----------|------------|---------------------------------------|
| 1        | Meatlovers | 1, 2, 3, 4, 5, 6, 8, 10               |
| 2        | Vegetarian | 4, 6, 7, 9, 11, 12                    |
| 3        | Supreme    | 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 |

***

Click [here](https://github.com/Akama-EO/sql-portfolio-projects) to move back to the 8-Week-SQL-Challenge repository!