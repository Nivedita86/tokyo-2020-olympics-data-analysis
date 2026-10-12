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

Create Table medals_total (
Rank_ int,
Country_Code varchar(30),
Gold_medal int,
Silver_medal int,
Bronze_medal int,
Total int,
Country	Varchar(30)
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

LOAD DATA local infile 'C:/SQL/DATA_Project1/medals_total.csv'
into Table medals_total
Fields terminated by ','
enclosed by '"'
Lines terminated by '\n'
IGNORE 1 ROWS; 


select * from athletes LIMIT 5;
select * from medals LIMIT 5 
;

-- total participation
SELECT COUNT(*) AS athletes_count
FROM (SELECT DISTINCT name, birth_date FROM athletes) AS unique_athletes;


-- total countries which participated
SELECT Count(distinct country) as country_count
from athletes;


-- Country-wise Participation
SELECT country, COUNT(*) AS total_athletes
FROM (SELECT DISTINCT name, birth_date, country FROM athletes) AS unique_athletes
GROUP BY country
ORDER BY total_athletes DESC;


-- gender-wise participation
SELECT gender, count(*) as gender_Cat_count
FROM (SELECT DISTINCT name, birth_date, gender FROM athletes) AS unique_athletes
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
SELECT SUM(Gold_medal) as Gold_tot, SUM(Silver_medal) as Silver_tot, SUM(Bronze_medal) as Bronze_tot
FROM medals_total;

DESCRIBE medals;
SELECT DISTINCT medal_type, medal_code FROM medals;

-- Total medals grouped by country
SELECT country, Total
FROM medals_total
; 


-- Total medals grouped by sport
SELECT discipline, COUNT(*) AS discipline_count
FROM (
    SELECT DISTINCT country, discipline, event_, medal_type
    FROM medals
) AS unique_medals
GROUP BY discipline
ORDER BY discipline_count DESC;


-- Count of gold medals won by each country in Athletics
SELECT country, COUNT(*) AS gold_count
FROM (
    SELECT DISTINCT country, discipline, event_, medal_type
    FROM medals
    WHERE medal_type = 'Gold Medal'
) AS unique_golds
GROUP BY country
ORDER BY gold_count DESC;


-- Rank countries by total medals using RANK()
SELECT country,
       total,
       RANK() OVER (ORDER BY total DESC) AS medal_rank
FROM medals_total
ORDER BY medal_rank;

    
-- the youngest athlete to win a medal
SELECT DISTINCT name, birth_date
FROM athletes
WHERE name IN (SELECT athlete_name FROM medals)
  AND birth_date = (
      SELECT MAX(birth_date)
      FROM athletes
      WHERE name IN (SELECT athlete_name FROM medals)
  );  


-- the oldest athlete to win a medal
SELECT DISTINCT name, birth_date
FROM athletes
WHERE name IN (SELECT athlete_name FROM medals)
  AND birth_date = (
      SELECT MIN(birth_date)
      FROM athletes
      WHERE name IN (SELECT athlete_name FROM medals)
        AND birth_date > '1900-01-01'
  );  
  
  
-- average number of medals won by athletes
select avg(medal_count) as AVERAGE_MEDALS
from
(SELECT athlete_name, athlete_link, count(*) as medal_count
from medals
group by athlete_name, athlete_link
) s
; 


-- athletes who won more medals than the average medals per athlete
SELECT athlete_name, medal_count
FROM (
    SELECT athlete_name, athlete_link, COUNT(*) AS medal_count
    FROM medals
    GROUP BY athlete_name, athlete_link
) AS athlete_medal_counts
WHERE medal_count > (
    SELECT AVG(medal_count)
    FROM (
        SELECT COUNT(*) AS medal_count
        FROM medals
        GROUP BY athlete_name, athlete_link
    ) AS avg_counts
)
ORDER BY medal_count DESC;




