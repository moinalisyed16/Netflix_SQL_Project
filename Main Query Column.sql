SELECT * FROM netflix ; 

SELECT COUNT(*) as total_count FROM netflix;

SELECT DISTINCT type FROM netflix;

-- Q1 Count no of movies vs tv shows

-- My Solution

SELECT COUNT(*) FROM netflix
WHERE type = 'Movie';

SELECT COUNT(*) FROM netflix
WHERE type = 'TV Show';

-- Zero Analyst Solution

SELECT type, COUNT(*) as total_count 
FROM netflix
GROUP BY type;

-- Q2 Find most common rating for movie & tv shows

-- My Solution

SELECT type,rating, COUNT(*) as total_count 
FROM netflix
GROUP BY type,rating
ORDER BY total_count DESC;

-- Q3 List all movies released in a specific year (e.g. 2020)

-- My solution 

SELECT title, release_year, type
FROM netflix
WHERE release_year= 2020
GROUP BY release_year,title, type
HAVING type = 'Movie';

-- Zero Analyst Solution
-- Using And


-- Q4 Find top 5 countries with most content on netflix

-- My Solution

SELECT country, COUNT(title) as total
FROM netflix
GROUP BY country
ORDER BY total DESC;

-- Zero Analyst Solution

SELECT 
UNNEST (STRING_TO_ARRAY(country,',')) as new_country,
COUNT(show_id) as total_content
FROM netflix 
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;

-- Q5 Identify longest Movie?

SELECT * FROM netflix
WHERE
type='Movie'
AND
duration = (SELECT MAX(duration) FROM netflix);


-- Q6 Find content added in last 5 years?

-- My solution

SELECT release_year, title
FROM netflix
WHERE release_year > 2020; 

-- Zero Analyst Sol

SELECT * FROM netflix
WHERE 
TO_DATE(date_added, ' Month DD, YYYY') >= CURRENT_DATE - INTERVAL'5 year'; 


-- Q7 Find all movies/TV Shows by director 

--My Sol

SELECT title, director
FROM netflix
WHERE director='Rajiv Chilaka';

-- Zero Analyst Sol

SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';


-- Q8 List all TV shows with more than 5 seasons

--Zero Analyst Sol

SELECT *
FROM netflix
WHERE type= 'TV Show'
AND
SPLIT_PART(duration,' ',1)::numeric>5;


-- Q9 Count the number of content items in each genre

SELECT COUNT(*), UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre
FROM netflix
GROUP BY genre;


-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !

-- My Sol 

-- SELECT UNNEST(STRING_TO_ARRAY(country,',')) as country, AVG(COUNT(*)) as mean,year
-- FROM netflix
--WHERE country ILIKE '%India%'
--GROUP BY year,country
--ORDER BY mean DESC
--LIMIT 5;

--Zero Analyst Sol

SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5;

-- Q11 List all movies that are documentaries

SELECT COUNT(*) AS count, genre
FROM (
    SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
    FROM netflix
    WHERE type = 'Movie'
) subquery
WHERE genre = 'Documentaries'
GROUP BY genre;

























