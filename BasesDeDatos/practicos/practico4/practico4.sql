USE world;

-- Parte I - Consultas

-- 1)

SELECT
	city.Name AS "Ciudad",
	country.Name AS "Pais"
FROM
	city
INNER JOIN country ON
	city.CountryCode = country.Code
WHERE
	country.Population < 10000;

-- Version con subquery

SELECT
	city.Name AS "Ciudad",
	country.Name AS "Pais"
FROM
	city
INNER JOIN country ON
	city.CountryCode = country.Code
WHERE
	country.Code IN (
		SELECT
			Code
		FROM
			country
		WHERE
			Population < 10000);
			
-- 2)
		
SELECT
	Name AS "Ciudad"
FROM
	city
WHERE
	Population > (
		SELECT
			AVG(Population)
		FROM
			city);

-- 3)

SELECT
	no_asian_city.Name AS "Ciudad"
FROM
	(
	SELECT
		city.Name,
		city.Population
	FROM
		city
	INNER JOIN country
	  ON
		city.CountryCode = country.Code
	WHERE
		country.Continent != 'Asia') AS no_asian_city
WHERE
	no_asian_city.Population >= 
    SOME (
	SELECT
		Population
	FROM
		country
	WHERE
		country.Continent = 'Asia'
	     );
		
-- 4)
	     
SELECT
	c.Name,
	cl.`Language`
FROM
	country AS c
INNER JOIN countrylanguage AS cl
ON
	cl.CountryCode = c.Code
WHERE
	cl.IsOfficial = 'F'
	AND cl.Percentage > ALL (
	SELECT
		ofi.Percentage
	FROM
		countrylanguage AS ofi
	WHERE
		ofi.CountryCode = c.Code
	AND ofi.IsOfficial = 'T'
	);
		
-- 5) Sin subquery

SELECT
	DISTINCT Region
FROM
	country
INNER JOIN city
ON
	country.Code = city.CountryCode
WHERE
	country.SurfaceArea < 1000
	AND city.Population > 100000;

-- Con subquery

SELECT
	DISTINCT Region
FROM
	country AS co
WHERE
	co.SurfaceArea < 1000
	AND EXISTS (
	SELECT
		1
	FROM
		city
	WHERE
		city.CountryCode = co.Code
		AND city.Population > 100000
);

-- 6) Usando consultas escalares

SELECT
	c.Name,
	(
	SELECT
		MAX(ci.Population)
	FROM
		city ci
	WHERE
		c.Code = ci.CountryCode
) AS most_populated_city
FROM
	country c;

-- Usando agrupaciones

SELECT
	c.Name,
	MAX(ci.Population)
FROM
	country c
INNER JOIN city ci
ON
	c.Code = ci.CountryCode
GROUP BY
	c.Code;

-- 7)

SELECT
	c.Name,
	cl.`Language`
FROM
	country c
INNER JOIN countrylanguage cl
ON
	cl.CountryCode = c.Code
WHERE
	cl.IsOfficial = 'F'
	AND cl.Percentage > (
		SELECT
			AVG(cl2.Percentage) 
		FROM
			countrylanguage cl2
		WHERE
			cl2.IsOfficial = 'T'
		AND 
			cl2.Countrycode = c.Code
	);

-- 8)

SELECT
	c.continent,
	sum(c.Population) AS habitantes
FROM
	country c
GROUP BY
	continent
ORDER BY
	habitantes DESC;

-- 9)

SELECT
	c.continent,
	AVG(c.LifeExpectancy) AS avg_life_expectancy
FROM
	country c
GROUP BY
	continent
HAVING
	avg_life_expectancy BETWEEN 40 AND 70;

-- 10)

SELECT
	c.continent,
	MAX(c.Population),
	MIN(c.Population),
	AVG(c.Population),
	SUM(c.Population)
FROM
	country c
GROUP BY
	continent;

-- Parte II - Preguntas

-- 1)

SELECT
	c.name AS Pais , 
		(
	SELECT
		max(ci.Population)
	FROM
		city ci
	WHERE
		ci.CountryCode = c.Code) AS maxPop,
		(
	SELECT
		ci.Name
	FROM
		city ci
	WHERE
		ci.Population = maxPop
		AND ci.CountryCode = c.Code) AS Nombre
FROM
	country c
ORDER BY
	maxPop DESC;

		
