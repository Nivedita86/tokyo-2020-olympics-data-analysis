SHOW DATABASES;   -- lists all available databases
USE mydb;  -- switch to the one you want
SELECT database(); -- conf


Create Table athletes (
name varchar(50),
short_name varchar(30),
gender varchar(10),
birth_date DATE,
birth_place Varchar(30),
birth_country Varchar(30),
country	Varchar(30),
country_code Varchar(20) ,
discipline	Varchar(25),
discipline_code Varchar(5),
residence_place	Varchar(30),
residence_country Varchar(30),
height_mft Varchar(10),
url Varchar(70)
);


Create Table medals (
medal_type varchar(30),
medal_code varchar(2),
medal_date datetime,
athlete_short_name Varchar(20),
athlete_name Varchar(50),
athlete_sex Varchar(2),
athlete_link	Varchar(50),
country_code Varchar(5) ,
discipline_code Varchar(5),
event_	Varchar(20),
country Varchar(30),
discipline Varchar(10)
);


LOAD DATA local infile 'C:/SQL/DATA_Project1/athletes.csv'
into Table athletes
Fields terminated by ','
enclosed by '"'
Lines terminated by '\n'
IGNORE 1 ROWS; 

LOAD DATA local infile 'C:/SQL/DATA_Project1/medals.csv'
into Table medals
Fields terminated by ','
enclosed by '"' 
Lines terminated by '\n'
IGNORE 1 ROWS;


select * from athletes LIMIT 5;
select * from medals LIMIT 5 
;

-- total participation
SELECT Count(DISTINCT name) as athlete_counts
from athletes;

SELECT Count(*) 
from athletes;

-- total countries which participated
SELECT Count(distinct country) as country_count
from athletes;

-- Country-wise Participation
SELECT country, COUNT(DISTINCT name) AS total_athletes
FROM athletes
GROUP BY country
ORDER BY total_athletes DESC;


-- gender-wise participation
SELECT gender, count(gender) as gender_Cat_count
from athletes
group by gender;


-- all sports in which at least one female athlete has participated
select distinct discipline
from athletes
where gender = 'Female';


-- counts the number of sports for which females have participated
Select count(*) from
(select distinct discipline
from athletes
where gender = 'Female'
) t
;


-- names of all the disciples
select discipline
from athletes
group by discipline;


-- discipline counts
Select count(*)
from (select discipline
from athletes
group by discipline
) d
;


-- medal types and their counts
SELECT medal_type, medal_code, COUNT(*) AS medal_count
FROM medals
GROUP BY medal_type, medal_code
ORDER BY medal_count DESC;   


-- Total medals grouped by country
SELECT country, count(*) as country_count
FROM medals
Group by country
ORDER BY country_count DESC
; 


-- Total medals grouped by sport
select discipline, count(*) as discipline_count
from medals
group by discipline
order by discipline_count desc; 


-- Count of gold medals won by each country in Athletics
select country, count(*) as gold_count
From medals
where medal_type = 'Gold Medal'
group by country
order by gold_count desc
; 


-- Rank countries by total medals using RANK()
SELECT country,
       tot_medal,
       RANK() OVER (ORDER BY tot_medal DESC) AS medal_rank
FROM (
    SELECT country, COUNT(*) AS tot_medal
    FROM medals
    GROUP BY country
) t
ORDER BY medal_rank; 

    
-- the youngest athlete to win a medal
SELECT name, birth_date
FROM athletes
ORDER BY birth_date DESC
LIMIT 1; 


-- the oldest athlete to win a medal
SELECT name
FROM athletes
ORDER BY birth_date 
LIMIT 1; 


-- average number of medals won by athletes
select avg(medal_count) as AVERAGE_MEDALS
from
(SELECT athlete_name, count(*) as medal_count
from medals
group by athlete_name
) s
; 


-- athletes who won more medals than the average medals per athlete
select name, medal_count
from (
select name, count(*) as medal_count
from athletes
group by name) as athlete_medal_counts
where medal_count >
(select avg(medal_count) 
from (
SELECT count(*) as medal_count
from athletes
group by name
) as medal_counts
); 










