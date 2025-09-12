USE world;

-- Parte 1 - Consultas

-- 1

SELECT
	city.Name AS "City name",
	country.Name AS "Country name",
	country.Region,
	country.GovernmentForm
FROM
	city
INNER JOIN country ON
	city.CountryCode = country.Code
ORDER BY
	city.Population DESC
LIMIT 10;

-- 2

SELECT
	country.Name AS "Country name",
	city.Name AS "Capital"
FROM
	country
LEFT JOIN city ON
	country.Capital = city.ID
ORDER BY
	(country.Population) ASC
LIMIT 10;

-- 3

SELECT
	country.Name,
	country.Continent,
	countrylanguage.Language
FROM
	country
INNER JOIN countrylanguage ON
	countrylanguage.CountryCode = country.Code
WHERE
	countrylanguage.IsOfficial = 'T';

-- 4
SELECT
	country.Name,
	city.Name AS "Capital"
FROM
	country
INNER JOIN city
ON
	country.Capital = city.ID
ORDER BY
	country.SurfaceArea DESC
LIMIT 20;

-- 5
SELECT
	city.Name,
	countrylanguage.Language,
	countrylanguage.Percentage
FROM
	city
INNER JOIN countrylanguage
ON
	city.CountryCode = countrylanguage.CountryCode
WHERE
	countrylanguage.IsOfficial = 'T'
ORDER BY
	city.Population;

-- 6
(
SELECT
	country.Name,
	country.Population
FROM
	country
WHERE
	country.Population >= 100
ORDER BY
	country.Population DESC
LIMIT 10
)

UNION

(
SELECT
	country.Name,
	country.Population
FROM
	country
WHERE
	country.Population >= 100
ORDER BY
	country.Population ASC
LIMIT 10
);

-- 7
(
SELECT
	country.Name
FROM
	country
INNER JOIN countrylanguage ON
	countrylanguage.CountryCode = country.Code
WHERE
	countrylanguage.Language = 'English'
	AND countrylanguage.IsOfficial = 'T'
)

INTERSECT

(
SELECT
	country.Name
FROM
	country
INNER JOIN countrylanguage ON
	countrylanguage.CountryCode = country.Code
WHERE
	countrylanguage.Language = 'French'
	AND countrylanguage.IsOfficial = 'T'
)

-- 8
(
SELECT
	country.Name
FROM
	country
INNER JOIN countrylanguage ON
	countrylanguage.CountryCode = country.Code
WHERE
	countrylanguage.Language = 'English')

EXCEPT

(
SELECT
	country.Name
FROM
	country
INNER JOIN countrylanguage ON
	countrylanguage.CountryCode = country.Code
WHERE
	countrylanguage.Language = 'Spanish');

-- Parte 2 - Preguntas

-- 1
/* Si, devuelven lo mismo. en un INNER JOIN, poner la condición country.Name = 'Argentina'
 * en la cláusula ON o en el WHERE es equivalente:
 * en ambos casos solo se conservan las filas donde 
 *  - city.CountryCode = country.Code 
 * y
 *  - country.Name = 'Argentina'.
 * */

-- 2
/* En este caso no devuelven lo mismo. Al ser un LEFT JOIN devuelve todas las filas
 * de city además de las que cumplen la condición. */
