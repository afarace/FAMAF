-- Practico 2

-- 1.

use world;

-- Parte 1 - DDL

-- 2.

CREATE TABLE country(
	Code VARCHAR(3) PRIMARY KEY,
	Name VARCHAR(50),
	Continent VARCHAR(50),
	Region VARCHAR(50),
	SurfaceArea DECIMAL(10,2),
	indepYear SMALLINT NULL,
	Population INT,
	LifeExpectancy SMALLINT,
	GNP DECIMAL(15,2),
	GNPOld DECIMAL(15,2),
	LocalName VARCHAR(50),
	GovernmentForm VARCHAR(50),
	HeadOfState VARCHAR(50),
	Capital INT,
	Code2 VARCHAR(3)
);

CREATE TABLE city (
	ID INT AUTO_INCREMENT PRIMARY KEY,
	Name VARCHAR(50),
	CountryCode VARCHAR(3),
	District VARCHAR(50),
	Population INT,
	FOREIGN KEY (CountryCode) REFERENCES country(Code)
);

CREATE TABLE countrylanguage (
    CountryCode VARCHAR(3) NOT NULL,
    Language VARCHAR(50) NOT NULL,
    IsOfficial ENUM('T','F') NOT NULL,
    Percentage DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (CountryCode, Language),
    FOREIGN KEY (CountryCode) REFERENCES country(Code)
);

-- 4

CREATE TABLE Continent (
	Name VARCHAR(50),
	Area INT,
	TotalMass DECIMAL(5,2),
	MostPopulousCity INT,
	PRIMARY KEY (Name),
	FOREIGN KEY (MostPopulousCity) REFERENCES city(ID)
);

-- 5

/* 
 * Para obtener los Id's de las ciudades hice las siguientes queries:
 * SELECT ID FROM city WHERE Name = "Cairo";
 * SELECT ID FROM city WHERE Name = "McMurdo Station";
 * SELECT ID FROM city WHERE Name = "Mumbai";
 * SELECT ID FROM city WHERE Name = "Istanbul";
 * SELECT ID FROM city WHERE Name = "Ciudad de México";
 * SELECT ID FROM city WHERE Name = "Sydney";
 * SELECT ID FROM city WHERE Name = "São Paulo";
 * 
 * Para añadir McMurdo Station a la tabla ciry hice la siguiente query:
 * INSERT INTO city (Name, CountryCode, District, Population)
VALUES ("McMurdo Station", "ATA", "Ross Island", 1200);
 * 
 *  */

INSERT INTO Continent (Name, Area, TotalMass, MostPopulousCity) VALUES ('Africa', 30370000, 20.4, 608);
INSERT INTO Continent (Name, Area, TotalMass, MostPopulousCity) VALUES ('Antarctica', 14000000, 9.2, 4080);
INSERT INTO Continent (Name, Area, TotalMass, MostPopulousCity) VALUES ('Asia', 44579000, 29.5, 1024);
INSERT INTO Continent (Name, Area, TotalMass, MostPopulousCity) VALUES ('Europe', 10180000, 6.8, 3357);
INSERT INTO Continent (Name, Area, TotalMass, MostPopulousCity) VALUES ('North America', 24709000, 16.5, 2515);
INSERT INTO Continent (Name, Area, TotalMass, MostPopulousCity) VALUES ('Oceania', 8600000, 5.9, 130);
INSERT INTO Continent (Name, Area, TotalMass, MostPopulousCity) VALUES ('South America', 17840000, 12.0, 206);

-- 6

ALTER TABLE country
ADD CONSTRAINT fk_country_continent
FOREIGN KEY (Continent) REFERENCES Continent(Name);

-- Parte 2 - Consultas

-- 1

SELECT Name, Region FROM country
ORDER BY Name;

-- 2

SELECT Name, Population FROM city
ORDER BY Population DESC 
LIMIT 10;

-- 3

SELECT Name, Region, SurfaceArea, GovernmentForm
FROM country
ORDER BY SurfaceArea ASC
LIMIT 10;

-- 4

SELECT * FROM country
WHERE indepYear IS NULL;

-- 5

SELECT country.Name, countrylanguage.Percentage 
FROM country, countrylanguage 
WHERE countrylanguage.IsOfficial LIKE 'T';

-- 6

UPDATE
	countrylanguage
SET
	Percentage = 100.0
WHERE
	CountryCode = 'AIA'
	AND 'Language' = 'English';


-- 7

SELECT
	*
FROM
	city
WHERE
	District = 'Córdoba'
	AND CountryCode = 'ARG';

-- 8

DELETE
FROM
	city
WHERE
	District = 'Córdoba'
	AND NOT CountryCode = 'ARG';

-- 9

SELECT
	*
FROM
	country
WHERE
	headOfState LIKE "%John%";


-- 10

SELECT
	Name,
	Population
FROM
	country
WHERE
	Population BETWEEN 35000000 AND 45000000
ORDER BY
	Population DESC;

