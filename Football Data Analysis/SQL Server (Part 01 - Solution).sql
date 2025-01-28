-- Football Players Data (Part 01) - SQL Questions

-- 01 - Write a query to find all the players in the "Arizona" team.
select * from footballplayers
where Team='Arizona';

-- 02 - Write a query to find all the players who play as a "WR" (Wide Receiver).
select * from footballplayers
where Pos='WR';

-- 03 - Write a query to list all players taller than 6 feet 2 inches.
select * from footballplayers
where Ft > 6 and [In] > 2;

-- 04 - Write a query to find all players who attended the "Washington" college.
select * from footballplayers
where College = 'Washington';

-- 05 - Write a query to list players who are 25 years old or younger.
select * from footballplayers
where Age <= 25;

-- 06 - Write a query to find all players with missing Age data.
select * from footballplayers
where Age is null;

-- 07 - Write a query to find players who are rookies (Exp = 'R').
select * from footballplayers
where [Exp] = 'R';

-- 08 - Write a query to find the tallest player on the "New Orleans" team.
select * from footballplayers
where Inches in (select max(Inches) over(partition by Team) as Max_Ht from footballplayers)
and Team = 'New Orleans';

-- 09 - Write a query to find players weighing more than 250 pounds.
select * from footballplayers
where Wt > 250;

-- 10 - Write a query to calculate the average height of players at each position.
select Pos, avg(Inches) as Avg_Ht from footballplayers 
group by Pos;

