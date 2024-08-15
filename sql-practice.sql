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


/*----------------------------------------------------------------------------------------*/
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



/*----------------------------------------------------------------------------------------*/
/*3. I want which Age group has max headcount for both male and female genders combine (zipcode 94085 (Sunnyvale CA))
#Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
*/


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
)
SELECT 
    maximum_age,
    headcount
FROM age_group_headcounts
ORDER BY headcount DESC
LIMIT 1;


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
        SUM(population) AS headcount, 
        maximum_age
    FROM sq2  
    WHERE zipcode = '94085' and gender = 'male'
    GROUP BY maximum_age
    ORDER BY headcount DESC
)
SELECT 
    maximum_age, 
    headcount
FROM age_group_headcounts
ORDER BY headcount DESC
LIMIT 1;


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
        SUM(population) AS headcount, 
        maximum_age
    FROM sq2  
    WHERE zipcode = '94085' and gender = 'female'
    GROUP BY maximum_age
    ORDER BY headcount DESC
)
SELECT 
    maximum_age, 
    headcount
FROM age_group_headcounts
ORDER BY headcount DESC
LIMIT 1;


/*----------------------------------------------------------------------------------------*/

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
)
SELECT 
    zipcode, 
    total_population
FROM 
    population_by_zip
ORDER BY 
    total_population DESC
LIMIT 1;


/*----------------------------------------------------------------------------------------*/

/*7 . I want first five age groups which has highest male and female population in USA

 Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
 */


WITH population_by_age AS (
    SELECT 
        maximum_age,
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
        maximum_age
)
SELECT 
   
    maximum_age, 
    total_population
FROM 
    population_by_age
ORDER BY 
    total_population DESC
LIMIT 5;


/*------------------------------------------------------------------------------------------*/

/*8 I want first five zipcodes which has highest female population in entire USA

 Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
 */
 

WITH population_by_zip AS (
    SELECT 
        zipcode,
        SUM(population) AS female_population
    FROM 
        `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
    WHERE 
        population IS NOT NULL 
      AND zipcode IS NOT NULL 
      AND gender = 'female'
      AND minimum_age IS NOT NULL 
      AND maximum_age IS NOT NULL
    GROUP BY 
        zipcode
)
SELECT 
    zipcode, 
    female_population
FROM 
    population_by_zip
ORDER BY 
    female_population DESC
LIMIT 1;

/*----------------------------------------------------------------------------------------*/

/*9 I want first 10 which has lowest male population in entire USA

 #Table = `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
*/

WITH population_by_zip AS (
    SELECT 
        zipcode,
        SUM(population) AS male_population
    FROM 
        `bigquery-public-data.census_bureau_usa.population_by_zip_2010`
    WHERE 
        population IS NOT NULL 
      AND zipcode IS NOT NULL 
      AND gender = 'male'
      AND minimum_age IS NOT NULL 
      AND maximum_age IS NOT NULL
    GROUP BY 
        zipcode
)
SELECT 
    zipcode, male_population
FROM 
    population_by_zip
order by male_population asc limit 10