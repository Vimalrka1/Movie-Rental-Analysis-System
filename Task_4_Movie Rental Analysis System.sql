--4.1 a) Database Creation: Create a database named MovieRental.
-- Database created : MovieRental

--4.1 b) Create table rental_data with columns:
create table rental_data(
MOVIE_ID integer primary key,
CUSTOMER_ID integer,
GENRE varchar(25),
RENTAL_DATE Date,
RETURN_DATE Date,
RENTAL_FEE numeric
)

--4.2 Data Creation: Insert 10–15 sample rental records.
insert into rental_data values 
(211    ,101    ,'Fiction'  ,'2025-04-20'	,'2025-04-25'	,300),
(222	,102	,'Humor'	,'2025-05-20'	,'2025-05-26'	,600),
(233	,103	,'Psychological' ,'2025-07-22'	,'2025-07-27'	,250),
(244	,104	,'Drama','2025-04-18' ,'2025-04-21'	,300),
(255	,105	,'Thriller'	,'2025-04-18'	,'2025-04-22'	,190),
(266	,106	,'Fantasy' 	,'2025-07-23'	,'2025-07-28'	,250),
(277	,107	,'Fantasy' 	,'2025-07-17'	,'2025-07-23'	,300),
(278	,102	,'Drama'	,'2025-04-25'	,'2025-04-30'	,600),
(279	,103	,'Drama'	,'2025-05-26'	,'2025-06-03'	,250),
(280	,104	,'Comedy'	,'2025-07-27'	,'2025-07-30'	,300),
(281	,105	,'Horror'	,'2025-04-21'	,'2025-04-29'	,190),
(282	,107	,'Adventure'	,'2025-04-22'	,'2025-04-26'	,300),
(283	,108	,'Comedy'	,'2025-07-28'	,'2025-08-03',190),
(284	,109	,'Horror'	,'2025-07-23'	,'2025-07-30'	,250),
(285	,110	,'Adventure'	,'2025-07-28'	,'2025-08-06'	,250),
(286	,110	,'Action'	,'2025-07-28'	,'2025-08-06'	,250)

--4.3 OLAP Operations:

--4.3 a) Drill Down: Analyze rentals from genre to individual movie level.

--Analyzing rentals at genre level
select GENRE,count(*) as Total_rentals,sum(RENTAL_FEE) as Revenue
from rental_data
group by GENRE
order by revenue desc;

-- Drilling down to individual movies within each genre
SELECT GENRE,MOVIE_ID,COUNT(*) AS movie_rentals,SUM(RENTAL_FEE) AS movie_revenue
FROM rental_data
GROUP BY GENRE, MOVIE_ID
ORDER BY GENRE, movie_revenue DESC;

--4.3 b)Rollup: Summarize total rental fees by genre and then overall.

SELECT GENRE, SUM(RENTAL_FEE) AS total_rental_fees
FROM rental_data
GROUP BY ROLLUP(GENRE)
ORDER BY GENRE;

--4.3 c) Cube: Analyze total rental fees across combinations of genre, rental date, and customer.

SELECT GENRE,RENTAL_DATE,CUSTOMER_ID,SUM(RENTAL_FEE) AS total_rental_fees
FROM rental_data
GROUP BY cube (GENRE,RENTAL_DATE,CUSTOMER_ID)
ORDER BY (GENRE,RENTAL_DATE,CUSTOMER_ID)

--4.3 d) Slice: Extract rentals only from the ‘Action’ genre.

SELECT GENRE, SUM(RENTAL_FEE) AS total_rental_fees
FROM rental_data
where GENRE = 'Action'
group by GENRE

--4.3 e) Dice: Extract rentals where GENRE = 'Action' or 'Drama' and RENTAL_DATE is in the last 3 months

SELECT MOVIE_ID,CUSTOMER_ID,GENRE,RENTAL_DATE,RETURN_DATE,RENTAL_FEE
FROM rental_data
WHERE (GENRE = 'Action' OR GENRE = 'Drama')
AND RENTAL_DATE >= CURRENT_DATE - INTERVAL '3 months';