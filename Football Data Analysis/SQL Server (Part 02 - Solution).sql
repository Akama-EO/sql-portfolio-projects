-- Football Players Data (Part 02) - SQL Questions

-- 01 - Write a query to find the heaviest player for each position.
select * from footballplayers as a
inner join 
(select Pos, max(Wt) as Max_Wt from footballplayers group by Pos) as b
on a.Pos=b.Pos and a.Wt=b.Max_Wt;

-- 02 - Write a query to rank players by age within their team. If two players have the same age, rank them by their weight.
select [Name], Age, Wt, dense_rank() over(order by Age, Wt) as ranking from footballplayers;

-- 03 - Write a query to calculate the average height (in inches) for all players older than 25 years.
select sum([In])/count([In]) as Avg_In from footballplayers where Age > 25;
select avg([In]) as Avg_In from footballplayers where Age > 25;

-- 04 - Write a query to find all players whose height is greater than the average height of their respective team.
select [Name], a.Team, a.Inches, b.Avg_Inches from footballplayers as a
inner join
(select Team, avg(Inches) as Avg_Inches from footballplayers group by Team) as b
on a.Team = b.Team and a.Inches > b.Avg_Inches;

-- 05 - Write a query to find all players who share the same last name.
with CTE as (
    select LastName from footballplayers
    group by LastName
    having count(*) > 1
)
select FirstName, LastName from footballplayers
where LastName IN (select LastName from CTE)
order by LastName, FirstName;

-- 06 - Write a query to find the players with the minimum height for each position.
select [Name], a.Pos, a.Inches, b.Min_Inches from footballplayers as a
inner join
(select Pos, avg(Inches) as Min_Inches from footballplayers group by Pos) as b
on a.Pos = b.Pos and a.Inches = b.Min_Inches;

-- 07 - Write a query to get the number of players for each team grouped by their experience level.
select Team, [Exp], count(*) AS Player_Count from  footballplayers
group by Team, [Exp]
order by Team, [Exp];

-- 08 - Write a query to find the tallest and shortest players from each college.
with Ranked_Players as (
    select FirstName, LastName, College, Inches,
        row_number() over(partition by College order by Inches desc) as Descending_Rank,
        row_number() over (partition by College order by Inches asc) as Ascending_Rank
    FROM footballplayers
)
select FirstName, LastName, College, Inches,
    case
        when Descending_Rank = 1 then 'Tallest'
        when Ascending_Rank = 1 then 'Shortest'
    end as Player_Type
from Ranked_Players
where Descending_Rank = 1 or Ascending_Rank = 1
order by College, Player_Type desc;

-- 09 - Write a query to find all players whose weight is above the average weight for their respective position.
select [Name], Age, Team, b.Pos, Wt, b.Avg_Wt from footballplayers as a
inner join
(select Pos, avg(Wt) as Avg_Wt from footballplayers group by Pos) as b
on a.Pos = b.Pos and b.Avg_Wt > a.Wt;

-- 10 - Write a query to calculate the percentage of players in each position for every team.
select Team, Pos, 
	count(*) as Player_Count,
	str(100.0 * count(*)/sum(count(*)) over (partition by Team), 4, 2) as Player_Percentage 
from footballplayers 
group by Team, Pos;

