# ⚽🏉🎱 Footbal Players Analysis (Part A)

## Case Study Questions
###  1. Write a query to find the top 5 players in the "Arizona" team.

```sql
select top 5 * from footballplayers
where Team='Arizona';
``` 
	
#### Result set:
| Year | Team    | Name             | No# | Pos | Ht   | Wt  | Age  | Exp | College        | FirstName | LastName  | Ft | In | Inches |
|------|---------|------------------|-----|-----|------|-----|------|-----|----------------|-----------|-----------|----|----|--------|
| 2022 | Arizona | Zach Allen       | 94  | DE  | 6-4  | 281 | 24   | 4   | Boston College | Zach      | Allen     | 6  | 4  | 76     |
| 2022 | Arizona | Stephen Anderson | 89  | TE  | 6-2  | 230 | 29   | 5   | California     | Stephen   | Anderson  | 6  | 2  | 74     |
| 2022 | Arizona | Marcell Ateman   | 84  | WR  | 6-4  | 215 | NULL | R   | Oklahoma State | Marcell   | Ateman    | 6  | 4  | 76     |
| 2022 | Arizona | Andre Baccellia  | 82  | WR  | 5-10 | 175 | 25   | 1   | Washington     | Andre     | Baccellia | 5  | 10 | 70     |
| 2022 | Arizona | Budda Baker      | 3   | S   | 5-10 | 195 | 26   | 6   | Washington     | Budda     | Baker     | 5  | 10 | 70     |

***

###  2. Write a query to find the top 5 players who play as a "WR" (Wide Receiver).

```sql
select top 5 * from footballplayers
where Pos='WR';
``` 
	
#### Result set:
| Year | Team        | Name            | No# | Pos | Ht   | Wt  | Age  | Exp | College        | FirstName | LastName  | Ft | In | Inches |
|------|-------------|-----------------|-----|-----|------|-----|------|-----|----------------|-----------|-----------|----|----|--------|
| 2022 | Arizona     | Marcell Ateman  | 84  | WR  | 6-4  | 215 | NULL | R   | Oklahoma State | Marcell   | Ateman    | 6  | 4  | 76     |
| 2022 | Arizona     | Andre Baccellia | 82  | WR  | 5-10 | 175 | 25   | 1   | Washington     | Andre     | Baccellia | 5  | 10 | 70     |
| 2022 | New Orleans | Kawaan Baker    | 87  | WR  | 6-1  | 215 | 23   | 1   | South Alabama  | Kawaan    | Baker     | 6  | 1  | 73     |
| 2022 | Arizona     | Victor Bolden   | 38  | WR  | 5-8  | 178 | 27   | 3   | Oregon State   | Victor    | Bolden    | 5  | 8  | 68     |
| 2022 | Arizona     | Marquise Brown  | 2   | WR  | 5-9  | 170 | 25   | 4   | Oklahoma       | Marquise  | Brown     | 5  | 9  | 69     |

***

###  3. Write a query to list all players taller than 6 feet 2 inches.

```sql
select * from footballplayers
where Ft > 6 and [In] > 2;
``` 
	
#### Result set: No data returnrd 

###  4. Write a query to find the first 5 players who attended the "Washington" college.

```sql
select * from footballplayers
where College = 'Washington';
``` 
	
#### Result set: 
| Year | Team        | Name              | No# | Pos | Ht   | Wt  | Age | Exp | College    | FirstName | LastName   | Ft | In | Inches |
|------|-------------|-------------------|-----|-----|------|-----|-----|-----|------------|-----------|------------|----|----|--------|
| 2022 | Arizona     | Andre Baccellia   | 82  | WR  | 5-10 | 175 | 25  | 1   | Washington | Andre     | Baccellia  | 5  | 10 | 70     |
| 2022 | Arizona     | Budda Baker       | 3   | S   | 5-10 | 195 | 26  | 6   | Washington | Budda     | Baker      | 5  | 10 | 70     |
| 2022 | Arizona     | Byron Murphy Jr.  | 7   | CB  | 5-11 | 190 | 24  | 4   | Washington | Byron     | Murphy Jr. | 5  | 11 | 71     |
| 2022 | Arizona     | Ezekiel Turner    | 47  | ILB | 6-2  | 214 | 26  | 5   | Washington | Ezekiel   | Turner     | 6  | 2  | 74     |
| 2022 | New Orleans | Dwayne Washington | 24  | RB  | 6-1  | 223 | 28  | 7   | Washington | Dwayne    | Washington | 6  | 1  | 73     |
| 2010 | New Orleans | Mark Brunell      | 11  | QB  | 6-1  | 217 | 39  | 17  | Washington | Mark      | Brunell    | 6  | 1  | 73     |

***

###  5. Write a query to list the first 5 players who are 25 years old or younger.

```sql
select top 5 * from footballplayers
where Age <= 25;
``` 
	
#### Result set:
| Year | Team        | Name              | No# | Pos | Ht   | Wt  | Age | Exp | College          | FirstName | LastName  | Ft | In | Inches |
|------|-------------|-------------------|-----|-----|------|-----|-----|-----|------------------|-----------|-----------|----|----|--------|
| 2022 | New Orleans | Paulson Adebo     | 29  | CB  | 6-1  | 192 | 23  | 2   | Stanford         | Paulson   | Adebo     | 6  | 1  | 73     |
| 2022 | Arizona     | Zach Allen        | 94  | DE  | 6-4  | 281 | 24  | 4   | Boston College   | Zach      | Allen     | 6  | 4  | 76     |
| 2022 | Arizona     | Andre Baccellia   | 82  | WR  | 5-10 | 175 | 25  | 1   | Washington       | Andre     | Baccellia | 5  | 10 | 70     |
| 2022 | New Orleans | Kawaan Baker      | 87  | WR  | 6-1  | 215 | 23  | 1   | South Alabama    | Kawaan    | Baker     | 6  | 1  | 73     |
| 2022 | Arizona     | Darrell Baker Jr. | 31  | CB  | 6-1  | 190 | 24  | R   | Georgia Southern | Darrell   | Baker Jr. | 6  | 1  | 73     |

***

###  6. Write a query to find all players with missing Age data.

```sql
select * from footballplayers
where Age is null;
``` 
	
#### Result set:
| Year | Team        | Name           | No# | Pos | Ht  | Wt  | Age  | Exp | College        | FirstName | LastName | Ft | In | Inches |
|------|-------------|----------------|-----|-----|-----|-----|------|-----|----------------|-----------|----------|----|----|--------|
| 2022 | New Orleans | Kiko Alonso    | 47  | OLB | 6-3 | 239 | NULL | R   | Oregon         | Kiko      | Alonso   | 6  | 3  | 75     |
| 2022 | Arizona     | Marcell Ateman | 84  | WR  | 6-4 | 215 | NULL | R   | Oklahoma State | Marcell   | Ateman   | 6  | 4  | 76     |

***

###  7. Write a query to find players who are rookies (Exp = 'R').

```sql
select top 5 * from footballplayers
where [Exp] = 'R';
``` 
	
#### Result set:
| 2022 | New Orleans | Kiko Alonso       | 47 | OLB | 6-3  | 239 | NULL | R | Oregon           | Kiko    | Alonso    | 6 | 3  | 75 |
|------|-------------|-------------------|----|-----|------|-----|------|---|------------------|---------|-----------|---|----|----|
| 2022 | Arizona     | Marcell Ateman    | 84 | WR  | 6-4  | 215 | NULL | R | Oklahoma State   | Marcell | Ateman    | 6 | 4  | 76 |
| 2022 | Arizona     | Darrell Baker Jr. | 31 | CB  | 6-1  | 190 | 24   | R | Georgia Southern | Darrell | Baker Jr. | 6 | 1  | 73 |
| 2022 | New Orleans | Josh Black        | 57 | DT  | 6-3  | 290 | 24   | R | Syracuse         | Josh    | Black     | 6 | 3  | 75 |
| 2022 | Arizona     | Tae Daley         | 48 | S   | 5-11 | 201 | 23   | R | Virginia Tech    | Tae     | Daley     | 5 | 11 | 71 |

***

###  8. Write a query to find the tallest player on the "New Orleans" team.

```sql
select * from footballplayers
where Inches in (select max(Inches) over(partition by Team) as Max_Ht from footballplayers)
and Team = 'New Orleans';
``` 
	
#### Result set:
| Year | Team        | Name             | No# | Pos | Ht  | Wt  | Age | Exp | College          | FirstName | LastName   | Ft | In | Inches |
|------|-------------|------------------|-----|-----|-----|-----|-----|-----|------------------|-----------|------------|----|----|--------|
| 2022 | New Orleans | Sage Doxtater    | 79  | OL  | 6-7 | 350 | 23  | R   | New Mexico State | Sage      | Doxtater   | 6  | 7  | 79     |
| 2022 | New Orleans | Tanoh Kpassagnon | 90  | DE  | 6-7 | 289 | 28  | 6   | Villanova        | Tanoh     | Kpassagnon | 6  | 7  | 79     |
| 2022 | New Orleans | Andrus Peat      | 75  | G/T | 6-7 | 316 | 28  | 8   | Stanford         | Andrus    | Peat       | 6  | 7  | 79     |
| 2022 | New Orleans | Trevor Penning   | 70  | OT  | 6-7 | 332 | 23  | R   | Northern Iowa    | Trevor    | Penning    | 6  | 7  | 79     |
| 2022 | New Orleans | Landon Young     | 67  | T   | 6-7 | 321 | 24  | 2   | Kentucky         | Landon    | Young      | 6  | 7  | 79     |
| 2010 | New Orleans | Zach Strief      | 64  | OT  | 6-7 | 320 | 26  | 4   | Northwestern     | Zach      | Strief     | 6  | 7  | 79     |

***

###  9. Write a query to find players weighing more than 250 pounds.

```sql
select top 5 * from footballplayers
where Wt > 250;
``` 
	
#### Result set:
| Year | Team        | Name           | No# | Pos | Ht  | Wt  | Age | Exp | College            | FirstName | LastName | Ft | In | Inches |
|------|-------------|----------------|-----|-----|-----|-----|-----|-----|--------------------|-----------|----------|----|----|--------|
| 2022 | Arizona     | Zach Allen     | 94  | DE  | 6-4 | 281 | 24  | 4   | Boston College     | Zach      | Allen    | 6  | 4  | 76     |
| 2022 | New Orleans | Josh Andrews   | 68  | G   | 6-2 | 298 | 31  | 7   | Oregon State       | Josh      | Andrews  | 6  | 2  | 74     |
| 2022 | Arizona     | Kelvin Beachum | 68  | OL  | 6-3 | 308 | 33  | 11  | Southern Methodist | Kelvin    | Beachum  | 6  | 3  | 75     |
| 2022 | New Orleans | Josh Black     | 57  | DT  | 6-3 | 290 | 24  | R   | Syracuse           | Josh      | Black    | 6  | 3  | 75     |
| 2022 | New Orleans | Taco Charlton  | 54  | DE  | 6-5 | 270 | 27  | 6   | Michigan           | Taco      | Charlton | 6  | 5  | 77     |

***

###  10. Write a query to calculate the average height of players at each position.

```sql
select top 10 Pos, avg(Inches) as Avg_Ht from footballplayers 
group by Pos;
``` 
	
#### Result set:
| Pos | Avg_Ht |
|-----|--------|
| C   | 75     |
| C/G | 76     |
| CB  | 71     |
| DB  | 72     |
| DE  | 76     |
| DL  | 75     |
| DT  | 74     |
| FB  | 71     |
| FS  | 69     |
| G   | 76     |

***




