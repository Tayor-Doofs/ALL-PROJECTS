-- Queries to solve questions

CREATE SCHEMA RSVP;  # create the RSVP database

-- The 'Table Data Import Wizard' was used to import each table here. Each table was saved in a CSV file.

USE rsvp;

-- Some Data Cleaning
# Convert values that are blank to be read as null
# movies table cleaning

UPDATE movies
SET country = NULL
WHERE country = "";

UPDATE movies
SET worlwide_gross_income = NULL
WHERE worlwide_gross_income = "";

UPDATE movies
SET languages = NULL
WHERE languages = "";

UPDATE movies
SET production_company = NULL
WHERE production_company = "";

# names table cleaning

UPDATE names
SET height = NULL
WHERE height = "";

UPDATE names
SET date_of_birth = NULL
WHERE date_of_birth = "";

UPDATE names
SET known_for_movies = NULL
WHERE known_for_movies = "";

ALTER TABLE names   #This changes the datatype of the height coloumn from text to int
MODIFY height int;

select * from names;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*)
FROM director_mapping; #There are 3,867 rows in the director_mapping table

SELECT COUNT(*)
FROM genre; #There are 14,662 rows in the genre table

SELECT COUNT(*)
FROM movies; #There are 7,997 rows in the movies table

SELECT COUNT(*)
FROM names; #There are 25,735 rows in the names table

SELECT COUNT(*)
FROM ratings; #There are 7,997 rows in the ratings table

SELECT COUNT(*)
FROM role_mapping; #There are 15,615 rows in the role_mapping table


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT COUNT(*) - COUNT(id) id_null_value_count, COUNT(*) - COUNT(title) title_null_value_count, COUNT(*) - COUNT(year) year_null_value_count, COUNT(*) - COUNT(date_published) date_published_null_value_count,
COUNT(*) - COUNT(duration) duration_null_count, COUNT(*) - COUNT(country) country_null_value_count, COUNT(*) - COUNT(worlwide_gross_income) worlwide_gross_income_null_value_count_count,
COUNT(*) - COUNT(languages) languages_null_value_count, COUNT(*) - COUNT(production_company) production_company_null_value_count 
FROM movies;

# Therefore, columns: country, worlwide_gross_income, languages, production_company have 20; 3,724; 194; 528 null values respectively



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

# First Part Code -- Number of movies produced each year
SELECT year Year, COUNT(*) number_of_movies
FROM movies
GROUP BY 1;

# Second Part Code -- Monthly Trend
SELECT EXTRACT(month from STR_TO_DATE(date_published, '%d/%m/%Y')) month_num, COUNT(*) number_of_movies
FROM movies
GROUP BY 1
ORDER BY 1;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT count(*) number_of_movies_produced_in_the_USA_or_India_in_2019
FROM movies
WHERE year = 2019
AND country IN ('USA', 'India');


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre list_of_unique_genres
FROM genre;



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, count(*) number_of_movies_produced_overall
FROM movies m
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- OR

SELECT genre genre_with_highest_produced_movies
FROM movies m
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY 1
ORDER BY count(*) DESC
LIMIT 1;



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(*) movies_with_one_genre_only
FROM (SELECT movie_id, COUNT(*)
      FROM genre
	  GROUP BY 1
	  HAVING COUNT(*) = 1) genre_count_per_movie;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, AVG(duration) avg_duration
FROM movies m
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY 1;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT *
FROM (SELECT genre, COUNT(*) movie_count, RANK() OVER(ORDER BY COUNT(*) DESC) genre_rank
	  FROM movies m
	  INNER JOIN genre g
	  ON m.id = g.movie_id
	  GROUP BY 1) genre_rank
WHERE genre = "Thriller";


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating) min_avg_rating, MAX(avg_rating) max_avg_rating, MIN(total_votes) min_total_votes, MAX(total_votes) max_total_votes, MIN(median_rating) min_median_rating, MAX(median_rating) max_median_rating
FROM ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT title, avg_rating, RANK() OVER(ORDER BY avg_rating DESC) movie_rank
FROM movies m
INNER JOIN ratings r
on m.id = r.movie_id
LIMIT 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating, COUNT(*) movie_count
FROM movies m
INNER JOIN ratings r
ON m.id = r.movie_id
GROUP BY 1
ORDER BY 1;








/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, COUNT(*) movie_count, RANK() OVER(ORDER BY COUNT(*) DESC) prod_company_rank
FROM movies m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE avg_rating > 8
AND production_company IS NOT NULL
GROUP BY 1
LIMIT 1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, COUNT(*) movie_count
FROM movies m
INNER JOIN genre g
ON m.id = g.movie_id
LEFT JOIN ratings r
ON m.id = r.movie_id
WHERE year = 2017
AND EXTRACT(month FROM STR_TO_DATE(date_published, '%d/%m/%Y')) = 3
AND country ='USA'
AND total_votes > 1000
GROUP BY 1;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, avg_rating, genre
FROM movies m
LEFT JOIN ratings r
ON m.id = r.movie_id
LEFT JOIN genre g
ON m.id = g.movie_id
WHERE avg_rating > 8
AND lower(title) LIKE 'The%';


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating, COUNT(*) movie_count
FROM movies m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE STR_TO_DATE(date_published, '%d/%m/%Y') BETWEEN '2018-04-01' AND '2019-04-01'
AND median_rating = 8
GROUP BY 1;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT CASE WHEN LOWER(languages) LIKE '%german%' THEN 'German'
			WHEN LOWER(languages) LIKE '%italian%' THEN 'Italian'
	   END language, SUM(total_votes) total_num_of_votes
FROM movies m
INNER JOIN ratings r
ON m.id = r.movie_id
GROUP BY 1
HAVING language IS NOT NULL;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT COUNT(*) - COUNT(name) name_nulls, COUNT(*) - COUNT(height) height_nulls, COUNT(*) - COUNT(date_of_birth) date_of_birth_nulls, COUNT(*) - COUNT(known_for_movies) known_for_movies_nulls
FROM names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH director_names as (
	SELECT name director_name, d.movie_id, genre
	FROM names n
	INNER JOIN director_mapping d
	ON n.id = d.name_id
	INNER JOIN movies m
	ON m.id = d.movie_id
	INNER JOIN genre g
	USING (movie_id)
    INNER JOIN ratings r
	ON m.id = r.movie_id
	WHERE avg_rating > 8
    ),
    
top_3_genres as (
	SELECT genre
	FROM movies m
	INNER JOIN genre g
	ON m.id = g.movie_id
	INNER JOIN ratings r
	ON m.id = r.movie_id
	WHERE avg_rating > 8
	GROUP BY 1
	ORDER BY COUNT(*) DESC
	LIMIT 3
    )
    
    SELECT director_name, COUNT(movie_id) movie_count
    FROM director_names
    WHERE genre IN (SELECT genre FROM top_3_genres)
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 3;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name actor_name, COUNT(r.movie_id) movie_count
FROM names n
INNER JOIN role_mapping rm
ON n.id = rm.name_id
INNER JOIN ratings r
ON rm.movie_id = r.movie_id
WHERE category = 'actor'
AND median_rating >= 8
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, SUM(total_votes) vote_count, RANK() OVER(ORDER BY SUM(total_votes) DESC) prod_comp_rank
FROM movies m
INNER JOIN ratings r
ON m.id = r.movie_id
GROUP BY 1
LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_metrics as (
	SELECT name actor_name, SUM(total_votes) total_votes, COUNT(DISTINCT movie_id) movie_count, ROUND(SUM(avg_rating*total_votes)/SUM(total_votes), 2) actor_avg_rating
	FROM names n
	INNER JOIN role_mapping rm
	ON n.id = rm.name_id
	INNER JOIN movies m
    ON rm.movie_id = m.id
    INNER JOIN ratings r
    USING (movie_id)
	WHERE category = 'actor'
    AND LOWER(country) LIKE '%india%'
    GROUP BY 1
    HAVING COUNT(movie_id) >= 5
    )
    
    SELECT actor_name, total_votes, movie_count, actor_avg_rating, RANK() OVER(ORDER BY actor_avg_rating DESC, total_votes DESC) actor_rank
    FROM actor_metrics;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_metrics as (
	SELECT name actress_name, SUM(total_votes) total_votes, COUNT(DISTINCT movie_id) movie_count, ROUND(SUM(avg_rating*total_votes)/SUM(total_votes), 2) actress_avg_rating
	FROM names n
	INNER JOIN role_mapping rm
	ON n.id = rm.name_id
	INNER JOIN movies m
    ON rm.movie_id = m.id
    INNER JOIN ratings r
    USING (movie_id)
	WHERE category = 'actress'
    AND LOWER(country) LIKE '%india%'
    GROUP BY 1
    HAVING COUNT(movie_id) >= 3
    )
    
    SELECT actress_name, total_votes, movie_count, actress_avg_rating, RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes DESC) actress_rank
    FROM actress_metrics
    LIMIT 5;


# NOTE: Taapsee Pannu only tops when "The actresses should have acted in at least five Indian movies." not three as stated in the question




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.*, CASE WHEN avg_rating > 8 THEN 'Superhit movies'
							  WHEN avg_rating between 7 and 8 THEN 'Hit movies'
                              WHEN avg_rating between 5 AND 6 THEN 'One-time-watch movies'
						 ELSE 'Flop movies' END movie_category
FROM movies m
INNER JOIN ratings r
ON m.id = r.movie_id
INNER JOIN genre g
ON m.id = g.movie_id
WHERE genre = 'Thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_stats as (
	SELECT genre, AVG(duration) avg_duration, SUM(duration) total_duration, ROW_NUMBER() OVER(ORDER BY genre) row_num
	FROM movies m
	INNER JOIN genre g
	ON m.id = g.movie_id
	INNER JOIN ratings r
	USING (movie_id)
	GROUP BY 1
    ),
    
RunningTotal AS (
    SELECT gs1.genre, gs1.avg_duration, gs1.total_duration, SUM(gs2.total_duration) AS running_total_duration
    FROM genre_stats gs1
    JOIN genre_stats gs2
    ON gs1.row_num >= gs2.row_num
    GROUP BY gs1.genre, gs1.avg_duration
    ),

MovingAverage AS (
    SELECT genre, avg_duration, running_total_duration, ROUND(AVG(avg_duration) OVER (ORDER BY genre ROWS BETWEEN 4 PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
    FROM RunningTotal
    )
    
    SELECT genre, avg_duration, running_total_duration, moving_avg_duration
	FROM MovingAverage
	ORDER BY genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH highest_grossing_movies as (
	SELECT genre, year, title movie_name, worlwide_gross_income worldwide_gross_income,
    ROW_NUMBER() OVER(PARTITION BY year ORDER BY year, CAST(TRIM(REPLACE(worlwide_gross_income, '$ ','')) AS signed) DESC) movie_rank
    FROM movies m
    INNER JOIN genre g
    ON m.id = g.movie_id
    ),
    
top_3_genres as (
	SELECT genre
	FROM movies m
	INNER JOIN genre g
	ON m.id = g.movie_id
	INNER JOIN ratings r
	ON m.id = r.movie_id
	GROUP BY 1
	ORDER BY COUNT(*) DESC
	LIMIT 3
    )
    
    SELECT h.*
    FROM highest_grossing_movies h
    WHERE movie_rank <=5;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH multilingual_movies AS (
	SELECT production_company, CASE WHEN POSITION(',' IN languages)>0 THEN 'multi' ELSE 'uni' END num_of_lang
	FROM movies m
	INNER JOIN ratings r
	ON m.id = r.movie_id
	WHERE median_rating >= 8
    AND languages IS NOT NULL
    AND production_company IS NOT NULL
    )
    
    SELECT production_company,  COUNT(CASE WHEN num_of_lang = 'multi' THEN 1 END) movie_count, RANK() OVER(ORDER BY COUNT(CASE WHEN num_of_lang = 'multi' THEN 1 END) DESC) prod_comp_rank
    FROM multilingual_movies
    GROUP BY 1
    LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_met AS (
	SELECT name actress_name, SUM(total_votes) total_votes, COUNT(m.id) movie_count, AVG(avg_rating) actress_avg_rating
	FROM names n
	INNER JOIN role_mapping rm
	ON n.id = rm.name_id
	INNER JOIN movies m
	ON rm.movie_id = m.id
	INNER JOIN ratings r
	ON m.id = r.movie_id
	INNER JOIN genre g
	ON m.id = g.movie_id
	WHERE category = 'actress'
	AND avg_rating > 8
	AND genre = 'Drama'
	GROUP BY 1
    )
    
    SELECT am.*, RANK() OVER(ORDER BY actress_avg_rating DESC) actress_rank
    FROM actress_met am
    LIMIT 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_metrics AS (
	SELECT n.id director_id, n.name director_name, d.movie_id movieid, m.date_published, 
    DATEDIFF(STR_TO_DATE(m.date_published, '%d/%m/%Y'), LAG(STR_TO_DATE(m.date_published, '%d/%m/%Y')) OVER (PARTITION BY n.id ORDER BY STR_TO_DATE(m.date_published, '%d/%m/%Y'))) inter_movie_days,
    m.duration, r.*
	FROM names n
	INNER JOIN director_mapping d
	ON n.id = d.name_id
	INNER JOIN movies m
	ON d.movie_id = m.id
	INNER JOIN ratings r
	ON m.id = r.movie_id
    ),
    
metrics_summary AS (
	SELECT director_id, director_name, COUNT(movieid) number_of_movies, ROUND(AVG(inter_movie_days),0) avg_inter_movie_days, 
    ROUND(AVG(avg_rating),2) avg_rating, SUM(total_votes) total_votes, MIN(avg_rating) min_rating, MAX(avg_rating) mac_rating, SUM(duration) toal_duration
    FROM director_metrics
    GROUP BY 1, 2
    )
    
    SELECT *
    FROM metrics_summary
    ORDER BY 3 DESC
    LIMIT 9;





