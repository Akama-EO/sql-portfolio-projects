# :football :ball Footbal Players Analysis (Part B)

## Case Study Questions
###  1. Write a query to find the heaviest player for each position.

```sql
select top 5 * from footballplayers as a
inner join 
(select Pos, max(Wt) as Max_Wt from footballplayers group by Pos) as b
on a.Pos=b.Pos and a.Wt=b.Max_Wt;
``` 
	
#### Result set:
| Year | Team        | Name            | No# | Pos   | Ht  | Wt  | Age | Exp | College              | FirstName | LastName | Ft | In | Inches | Pos   | Max_Wt |
|------|-------------|-----------------|-----|-------|-----|-----|-----|-----|----------------------|-----------|----------|----|----|--------|-------|--------|
| 2022 | New Orleans | Deonte Harty    | 11  | WR/RS | 5-6 | 170 | 24  | 4   | Assumption College   | Deonte    | Harty    | 5  | 6  | 66     | WR/RS | 170    |
| 2010 | New Orleans | Marques Colston | 12  | WR    | 6-4 | 225 | 26  | 4   | Hofstra              | Marques   | Colston  | 6  | 4  | 76     | WR    | 225    |
| 2010 | Arizona     | Anthony Becht   | 84  | TE    | 6-6 | 270 | 32  | 10  | West Virginia        | Anthony   | Becht    | 6  | 6  | 78     | TE    | 270    |
| 2022 | New Orleans | Landon Young    | 67  | T     | 6-7 | 321 | 24  | 2   | Kentucky             | Landon    | Young    | 6  | 7  | 79     | T     | 321    |
| 2010 | Arizona     | Adrian Wilson   | 24  | S     | 6-3 | 226 | 30  | 9   | North Carolina State | Adrian    | Wilson   | 6  | 3  | 75     | S     | 226    |

***

###  2. Write a query to rank players by age within their team. If two players have the same age, rank them by their weight.

```sql
select [Name], Age, Wt, dense_rank() over(order by Age, Wt) as ranking from footballplayers;
``` 
	
#### Result set:
| Name            | Age  | Wt  | ranking |
|-----------------|------|-----|---------|
| Marcell Ateman  | NULL | 215 | 1       |
| Kiko Alonso     | NULL | 239 | 2       |
| Beanie Wells    | 21   | 228 | 3       |
| Haggai Ndubuisi | 21   | 298 | 4       |
| Rondale Moore   | 22   | 180 | 5       |

***

###  3.  Write a query to calculate the average height (in inches) for all players older than 25 years.

```sql
select sum([In])/count([In]) as Avg_In from footballplayers where Age > 25;
select avg([In]) as Avg_In from footballplayers where Age > 25;
``` 
	
#### Result set: No data returnrd 
| Avg_In |
|--------|
| 4      |

###  4. Write a query to find all players whose height is greater than the average height of their respective team.

```sql
select top 5 [Name], a.Team, a.Inches, b.Avg_Inches from footballplayers as a
inner join
(select Team, avg(Inches) as Avg_Inches from footballplayers group by Team) as b
on a.Team = b.Team and a.Inches > b.Avg_Inches;
``` 
	
#### Result set: 
| Name             | Team    | Inches | Avg_Inches |
|------------------|---------|--------|------------|
| Zach Allen       | Arizona | 76     | 73         |
| Stephen Anderson | Arizona | 74     | 73         |
| Marcell Ateman   | Arizona | 76     | 73         |
| Kelvin Beachum   | Arizona | 75     | 73         |
| Aaron Brewer     | Arizona | 77     | 73         |

***

###  5.  Write a query to find all players who share the same last name.

```sql
with CTE as (
    select LastName from footballplayers
    group by LastName
    having count(*) > 1
)
select top 5 FirstName, LastName from footballplayers
where LastName IN (select LastName from CTE)
order by LastName, FirstName;
``` 
	
#### Result set:
| FirstName | LastName |
|-----------|----------|
| Budda     | Baker    |
| Kawaan    | Baker    |
| Cody      | Brown    |
| Jammal    | Brown    |
| Levi      | Brown    |

***

###  6. Write a query to find the players with the minimum height for each position.

```sql
select top 5 [Name], a.Pos, a.Inches, b.Min_Inches from footballplayers as a
inner join
(select Pos, avg(Inches) as Min_Inches from footballplayers group by Pos) as b
on a.Pos = b.Pos and a.Inches = b.Min_Inches;
``` 
	
#### Result set:
| Name          | Pos | Inches | Min_Inches |
|---------------|-----|--------|------------|
| Nick Leckey   | C   | 75     | 75         |
| Lyle Sendlein | C   | 75     | 75         |
| Erik McCoy    | C/G | 76     | 76         |
| Cesar Ruiz    | C/G | 76     | 76         |
| Bradley Roby  | CB  | 71     | 71         |

***

###  Write a query to get the number of players for each team grouped by their experience level.

```sql
select top 5 Team, [Exp], count(*) AS Player_Count from  footballplayers
group by Team, [Exp]
order by Team, [Exp];
``` 
	
#### Result set:
| Team    | Exp | Player_Count |
|---------|-----|--------------|
| Arizona | 1   | 8            |
| Arizona | 10  | 8            |
| Arizona | 11  | 3            |
| Arizona | 12  | 5            |
| Arizona | 13  | 2            |

***

###  8. Write a query to find the tallest and shortest players from each college.

```sql
with Ranked_Players as (
  select FirstName, LastName, College, Inches,
      row_number() over(partition by College order by Inches desc) as Descending_Rank,
      row_number() over (partition by College order by Inches asc) as Ascending_Rank
  FROM footballplayers
)
select top 5 FirstName, LastName, College, Inches,
  case
      when Descending_Rank = 1 then 'Tallest'
      when Ascending_Rank = 1 then 'Shortest'
  end as Player_Type
from Ranked_Players
where Descending_Rank = 1 or Ascending_Rank = 1
order by College, Player_Type desc;
``` 
	
#### Result set:
| FirstName | LastName  | College           | Inches | Player_Type |
|-----------|-----------|-------------------|--------|-------------|
| Jordan    | Jackson   | Air Force         | 77     | Tallest     |
| Jeremy    | Clark     | Alabama           | 75     | Tallest     |
| Mark      | Ingram II | Alabama           | 69     | Shortest    |
| D'Marco   | Jackson   | Appalachian State | 73     | Tallest     |
| Mike      | Bell      | Arizona           | 72     | Tallest     |

***

###  9. Write a query to find all players whose weight is above the average weight for their respective position.

```sql
select top 5 [Name], Age, Team, b.Pos, Wt, b.Avg_Wt from footballplayers as a
inner join
(select Pos, avg(Wt) as Avg_Wt from footballplayers group by Pos) as b
on a.Pos = b.Pos and b.Avg_Wt > a.Wt;
``` 
	
#### Result set:
| Name             | Age | Team        | Pos | Wt  | Avg_Wt |
|------------------|-----|-------------|-----|-----|--------|
| Mike Leach       | 33  | Arizona     | C   | 238 | 293    |
| Nick Leckey      | 27  | New Orleans | C   | 291 | 293    |
| Erik McCoy       | 24  | New Orleans | C/G | 303 | 309    |
| Breon Borders    | 27  | Arizona     | CB  | 189 | 190    |
| Antonio Hamilton | 29  | Arizona     | CB  | 188 | 190    |

***

###  10. Write a query to calculate the percentage of players in each position for every team.

```sql
select Team, Pos, 
	count(*) as Player_Count,
	str(100.0 * count(*)/sum(count(*)) over (partition by Team), 4, 2) as Player_Percentage 
from footballplayers 
group by Team, Pos;
``` 
	
#### Result set:
| Team    | Pos | Player_Count | Player_Percentage |
|---------|-----|--------------|-------------------|
| Arizona | C   | 3            | 2.00              |
| Arizona | CB  | 16           | 10.7              |
| Arizona | DE  | 10           | 6.67              |
| Arizona | DT  | 10           | 6.67              |
| Arizona | FB  | 2            | 1.33              |

***




