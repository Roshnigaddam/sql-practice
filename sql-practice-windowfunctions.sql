/*1. I need total Population in zipcode 94085 (Sunnyvale CA)
 #Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
*/

SELECT SUM(Population) as total_population
FROM   `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
WHERE  population IS NOT NULL
       AND zipcode IS NOT NULL
       AND gender IS NOT NULL
       AND minimum_age IS NOT NULL
       AND maximum_age IS NOT NULL
       AND zipcode = '94085'; 

/*---------------------------------------------------------------------------------------------*/
/*2. I need number of Male and Female head count in zipcode 94085 (Sunnyvale CA)
 #Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
 */

WITH sq AS
(
       SELECT *
       FROM   `bigquery-PUBLIC-data.census_bureau_usa.population_by_zip_2010`
       WHERE  population IS NOT NULL
       AND    zipcode IS NOT NULL
       AND    gender IS NOT NULL
       AND    minimum_age IS NOT NULL
       AND    maximum_age IS NOT NULL)
SELECT   SUM(Population),
         gender
FROM     sq
WHERE    zipcode = '94085'
GROUP BY gender     


/*---------------------------------------------------------------------------------------------*/
/*3. I want which Age group has max headcount for both male and female genders combine (zipcode 94085 (Sunnyvale CA))
#Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
*/

#revised
WITH sq2 AS (
    SELECT *
    FROM `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
    WHERE population IS NOT NULL
      AND zipcode IS NOT NULL
      AND gender IS NOT NULL
      AND maximum_age IS NOT NULL
),
age_group_headcounts AS (
    SELECT 
        SUM(population) AS headcount,
        maximum_age
    FROM sq2
    WHERE zipcode = '94085'
    GROUP BY maximum_age
    ORDER BY headcount DESC
),
ranks_of_headcounts AS (
SELECT 
    rank() over (order by headcount desc) as rank_headcount,maximum_age 
FROM age_group_headcounts order by rank_headcount asc)

select maximum_age from ranks_of_headcounts where rank_headcount=1
;



/*----------------------------------------------------------------------------------------*/
/*4. I want age group for male gender which has max male population zipcode 94085 (Sunnyvale CA))

#Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
*/

WITH sq2 AS (
    SELECT *
    FROM `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
    WHERE population IS NOT NULL 
      AND zipcode IS NOT NULL 
      AND gender IS NOT NULL 
      AND minimum_age IS NOT NULL 
      AND maximum_age IS NOT NULL
),
age_group_headcounts AS (
    SELECT 
        SUM(population) AS headcount, gender,
        maximum_age
    FROM sq2  
    WHERE zipcode = '94085' group by gender,maximum_age order by headcount desc
    
)
,ranks_of_headcounts AS (
SELECT 
    rank() over (order by headcount desc) as rank_headcount,headcount,maximum_age,gender 
FROM age_group_headcounts order by rank_headcount asc)

select maximum_age from ranks_of_headcounts where rank_headcount = (select min(rank_headcount) from ranks_of_headcounts where gender='male')
;

/*----------------------------------------------------------------------------------------*/
/*5. I want age group for female gender which has max male population zipcode 94085 (Sunnyvale CA))

 Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
 */

 WITH sq2 AS (
    SELECT *
    FROM `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
    WHERE population IS NOT NULL 
      AND zipcode IS NOT NULL 
      AND gender IS NOT NULL 
      AND minimum_age IS NOT NULL 
      AND maximum_age IS NOT NULL
),
age_group_headcounts AS (
    SELECT 
        SUM(population) AS headcount, gender,
        maximum_age
    FROM sq2  
    WHERE zipcode = '94085' group by gender,maximum_age order by headcount desc
    
)
,ranks_of_headcounts AS (
SELECT 
    rank() over (order by headcount desc) as rank_headcount,headcount,maximum_age,gender 
FROM age_group_headcounts order by rank_headcount asc)

select maximum_age from ranks_of_headcounts where rank_headcount = (select min(rank_headcount) from ranks_of_headcounts where gender='female')
;


/*---------------------------------------------------------------------------------------------*/
/*#6. I want zipcode which has highest male and female population in USA

 Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
 */


WITH population_by_zip AS (
    SELECT 
        zipcode,
        SUM(population) AS total_population
    FROM 
        `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
    WHERE 
        population IS NOT NULL 
      AND zipcode IS NOT NULL 
      AND gender IS NOT NULL 
      AND minimum_age IS NOT NULL 
      AND maximum_age IS NOT NULL
    GROUP BY 
        zipcode
),
ranks_of_population_by_zipcode AS (
SELECT 
    rank() over (order by total_population desc) as rank_population,zipcode
FROM population_by_zip order by rank_population asc
)
select zipcode from ranks_of_population_by_zipcode where rank_population = 1;


/*---------------------------------------------------------------------------------------------*/
/*7 . I want first five age groups which has highest male and female population in USA

 Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
 */



WITH sq2 AS (
    SELECT *
    FROM `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
    WHERE population IS NOT NULL 
      AND zipcode IS NOT NULL 
      AND gender IS NOT NULL 
      AND minimum_age IS NOT NULL 
      AND maximum_age IS NOT NULL
),
age_group_headcounts AS (
    SELECT 
        SUM(population) AS headcount, gender,
        maximum_age
    FROM sq2  
    WHERE zipcode = '94085' group by gender,maximum_age order by headcount desc
    
)
,ranks_of_headcounts AS (
SELECT 
    rank() over (order by headcount desc) as rank_headcount,headcount,maximum_age,gender 
FROM age_group_headcounts order by rank_headcount asc)

select maximum_age,gender from ranks_of_headcounts where rank_headcount in(1,2,3,4,5)
;

 /*first five age groups with highest male population*/

WITH sq2 AS (
    SELECT *
    FROM `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
    WHERE population IS NOT NULL 
      AND zipcode IS NOT NULL 
      AND gender IS NOT NULL 
      AND minimum_age IS NOT NULL 
      AND maximum_age IS NOT NULL
),
age_group_headcounts AS (
    SELECT 
        SUM(population) AS headcount, gender,
        maximum_age
    FROM sq2  
    WHERE zipcode = '94085' group by gender,maximum_age order by headcount desc
    
)
,ranks_of_headcounts AS (
SELECT 
    rank() over (order by headcount desc) as rank_headcount,headcount,maximum_age,gender 
FROM age_group_headcounts where gender ='male' order by rank_headcount asc)

select maximum_age,gender from ranks_of_headcounts where rank_headcount in(1,2,3,4,5)
;

 /*first five age groups with highest female population*/
WITH sq2 AS (
    SELECT *
    FROM `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
    WHERE population IS NOT NULL 
      AND zipcode IS NOT NULL 
      AND gender IS NOT NULL 
      AND minimum_age IS NOT NULL 
      AND maximum_age IS NOT NULL
),
age_group_headcounts AS (
    SELECT 
        SUM(population) AS headcount, gender,
        maximum_age
    FROM sq2  
    WHERE zipcode = '94085' group by gender,maximum_age order by headcount desc
    
)
,ranks_of_headcounts AS (
SELECT 
    rank() over (order by headcount desc) as rank_headcount,headcount,maximum_age,gender 
FROM age_group_headcounts where gender ='female' order by rank_headcount asc)

select maximum_age,gender from ranks_of_headcounts where rank_headcount in(1,2,3,4,5)
;

/*---------------------------------------------------------------------------------------------*/
/*8 I want first five zipcodes which has highest female population in entire USA

 Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
 */
 
WITH population_by_zip AS (
    SELECT 
        zipcode,
        SUM(population) AS total_population,gender
    FROM 
        `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
    WHERE 
        population IS NOT NULL 
      AND zipcode IS NOT NULL 
      AND gender IS NOT NULL 
      AND minimum_age IS NOT NULL 
      AND maximum_age IS NOT NULL
    GROUP BY 
        zipcode,gender
),
ranks_of_population_by_zipcode AS (
SELECT 
    rank() over (order by total_population desc) as rank_population,zipcode,gender
FROM population_by_zip where gender = 'female' order by rank_population asc
)
select zipcode from ranks_of_population_by_zipcode where rank_population in (1,2,3,4,5) ;


/*---------------------------------------------------------------------------------------------*/
/*9 I want first 10 which has lowest male population in entire USA

 #Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
*/

 
WITH population_by_zip AS (
    SELECT 
        zipcode,
        SUM(population) AS total_population,gender
    FROM 
        `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
    WHERE 
        population IS NOT NULL 
      AND zipcode IS NOT NULL 
      AND gender IS NOT NULL 
      AND minimum_age IS NOT NULL 
      AND maximum_age IS NOT NULL
    GROUP BY 
        zipcode,gender
),
ranks_of_population_by_zipcode AS (
SELECT 
    rank() over (order by total_population asc) as rank_population,zipcode,gender
FROM population_by_zip where gender = 'male' order by rank_population asc
)
select zipcode from ranks_of_population_by_zipcode where rank_population in (1,2,3,4,5,7,8,9,10) ;
