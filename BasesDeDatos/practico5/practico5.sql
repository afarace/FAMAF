USE sakila;

-- Consultas

--  Ejercicio 1

CREATE TABLE directors (
	director_id int NOT NULL AUTO_INCREMENT ,
	Name varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	NumberOfMovies int,
	
	PRIMARY KEY (director_id)
);

-- Ejercicio 2

INSERT
	INTO
	directors (Name,
	LastName,
	NumberOfMovies)
SELECT
	actor.first_name,
	actor.last_name,
	top5.cf
FROM
	actor
INNER JOIN 
(
	SELECT
		actor_id,
		count(film_id) AS cf
	FROM
		film_actor
	GROUP BY
		actor_id
	ORDER BY
		cf DESC
	LIMIT 5) AS top5
ON
	actor.actor_id = top5.actor_id;

-- Ejercicio 3

ALTER TABLE customer
ADD premium_customer enum('T',
'F') DEFAULT 'F';

-- Ejercicio 4

UPDATE
	customer
SET
	premium_customer = 'T'
WHERE
	customer_id IN (
	SELECT
		customer_id
	FROM
		(
		SELECT
			p.customer_id
		FROM
			payment p
		GROUP BY
			p.customer_id
		ORDER BY
			SUM(p.amount) DESC
		LIMIT 10
    ) AS top_customers
);

-- Ejercicio 5

SELECT
	film.rating,
	COUNT(film.film_id) AS amount
FROM
	film
GROUP BY
	film.rating
ORDER BY
	amount DESC;

-- Ejercicio 6

SELECT
	min(payment_date),
	max(payment_date)
FROM
	payment;

-- Ejercicio 7

SELECT
	MONTH(payment_date) AS `month`,
	count(amount)
FROM
	payment
GROUP BY
	`month`;

-- Ejercicio 8

WITH district_by_customer AS
(
SELECT
	district,
	c.customer_id
FROM
	(address AS a
INNER JOIN customer AS c ON
	a.address_id = c.address_id))
SELECT
	district,
	count(*) AS rentals
FROM
	(district_by_customer AS dc
INNER JOIN rental AS r ON
	dc.customer_id = r.customer_id)
GROUP BY
	district
ORDER BY 
	rentals 
DESC
LIMIT 10;

-- Ejercicio 9

ALTER TABLE inventory
ADD stock int DEFAULT 5;

-- Ejercicio 10

CREATE TRIGGER update_stock
AFTER
INSERT
	ON
	rental
FOR EACH ROW 
BEGIN 
	UPDATE
	inventory
SET
	stock = stock - 1
WHERE
	inventory_id = NEW.inventory_id;
END

-- Ejercicio 11

CREATE TABLE fines (
	rental_id int NOT NULL AUTO_INCREMENT,
	amount decimal(5,2),
	
	PRIMARY KEY (rental_id),
	FOREIGN KEY (rental_id) REFERENCES rental(rental_id)
);

-- Ejercicio 12

CREATE PROCEDURE check_date_and_fine ()
BEGIN
	INSERT
	INTO
	fines (rental_id,
	amount)
	
	(
	SELECT
		rental_id,
		DATEDIFF(return_date, rental_date) * 1.5
	FROM
		rental
	WHERE
		(DATEDIFF(return_date, rental_date)) > 3
	);
END

CALL check_date_and_fine();

-- Ejercicio 13

CREATE ROLE employee;
GRANT INSERT, DELETE, UPDATE ON sakila.rental TO employee;

-- Ejercicio 14





