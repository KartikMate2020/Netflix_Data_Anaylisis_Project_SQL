DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);


   COPY
   netflix(show_id, type, title, director, casts, country, date_added, release_year, rating, duration, listed_in, description)
   FROM'‪C:\Users\kartik dipak mate\Downloads\netflix_titles.csv'
   DELIMITER ','
   CSV HEADER;

  SELECT * FROM netflix;


 -- 1) Count the Number of Movies And TV Shows 

        SELECT type, COUNT(*) AS total_count FROM netflix
		GROUP BY type;

-- 2) Find the most common rating for movies and Tivies
      SELECT type,rating FROM ( SELECT type,rating,COUNT(*),ROW_NUMBER() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS row_rank FROM netflix
	  GROUP BY type,rating)
	  WHERE row_rank=1;

-- 3) List all movies Released in Specific Year ex(2020)

	   SELECT * FROM netflix
	   WHERE type='Movie' AND release_year='2020';

-- 4) Find the top Five Countries with the Most content on netflix

	   SELECT country,COUNT(*) AS most_content
	   FROM netflix
	   GROUP BY country
	   ORDER BY most_content DESC;

     -- Spilit the country 
	   SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS new_country ,COUNT(*) AS total_count 
	   FROM netflix
	   GROUP BY new_country
	   ORDER BY total_count DESC
	   LIMIT 5 ;
	   
-- 5) Identify The Longest Movie

      SELECT * FROM netflix
	  WHERE type='Movie' AND duration= (SELECT MAX(duration) FROM netflix);

-- 6) Find content Added In The Last Five Years

      SELECT * FROM netflix
	  WHERE TO_DATE(date_added,'MONTH-DD-YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7) Find all Movies/Tv Shows by Director Rajiv Chilaka

     SELECT * FROM netflix
	 WHERE director='Rajiv Chilaka';

-- 8) List all TV Shows more than 5 Seasons

	  SELECT * FROM netflix
	  WHERE type='TV Show' AND SPLIT_PART(duration,' ',1)::numeric >5

-- 9) Count the number of contents items in each genere

     SELECT listed_in,COUNT(*)
	 FROM netflix
     GROUP BY listed_in


	 SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genere,COUNT(*) 
	 FROM netflix
	 GROUP BY genere
	 ORDER BY COUNT(*) DESC

-- 10) Find the each year and the average numbers of content release by india on netflix
--     return top 5 year with higest content average  release


	  SELECT EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD-YYYY')) AS dte, 
	                 COUNT(*) AS total_count,
					 ROUND(COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM netflix WHERE country='India')*100,3)AS avg_content
	  FROM netflix
	  WHERE country='India'
	  GROUP BY dte

-- 11) List all movies that are documentries

		SELECT * FROM netflix
		WHERE listed_in LIKE '%Documentaries%' AND type='Movie'

-- 12) Find All Content Without Director

	    SELECT * FROM netflix
		WHERE director IS NULL;

-- 13) Find how many movies actor "Salman Khan" Appeared In the Last 10 Years

        SELECT * FROM netflix
        WHERE casts ILIKE '%Salman Khan%'
		AND release_year>EXTRACT(YEAR FROM CURRENT_DATE)-10;

-- 14) Find The Top 10 Actors Who Have Appeared In The Higest Number Of Movies 
--     Produced In India:

	   SELECT UNNEST(STRING_TO_ARRAY(casts,',')),
	   COUNT(*) AS total_count 
	   FROM netflix 
	   WHERE country ILIKE '%india%'
	   GROUP BY 1
	   ORDER BY 2 DESC
	   LIMIT 10

-- 15) Ctegorized The Content Based On the Presence Of The Keywords 'kill' AND 'Voilence'
--     In the description field,Label Containing These Kewords as 'Bad' and all other content
--     as 'good',Count how Many items fall into each category.
       
	   WITH CTE AS ( 
                      SELECT *, CASE
	                                WHEN description ILIKE'%kill%' OR
					                description ILIKE'%voilence' THEN 'Good'
					                ELSE'Bad Content'
					                END as Category
					                FROM netflix
				    )
			        SELECT Category,COUNT(*) FROM CTE
					GROUP BY Category;
					
					  
					  

	  
	   
		

	
     

	 

    

      

      

      

	   
       

       



		
        
        



  





   
