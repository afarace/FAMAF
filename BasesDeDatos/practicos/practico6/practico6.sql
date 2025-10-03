USE classicmodels;

-- Consultas

-- Ejercicio 1

SELECT
	e.officeCode,
	COUNT(e.employeeNumber) AS amount
FROM
	employees e
GROUP BY
	e.officeCode
ORDER BY
	amount DESC
LIMIT 1;

-- Ejercicio 2

-- Promedio de ordener hechas por oficina

SELECT
	AVG(offices_orders.amount)
FROM
	(
	SELECT
		o.officeCode,
		COUNT(orders.orderNumber) AS amount
	FROM
		orders
	INNER JOIN customers c
	ON
		orders.customerNumber = c.customerNumber
	INNER JOIN employees e
	ON
		c.salesRepEmployeeNumber = e.employeeNumber
	INNER JOIN offices o
	ON
		e.officeCode = o.officeCode
	GROUP BY
		o.officeCode
) AS offices_orders;
    
-- Oficina que vendió la mayor cantidad de productos

SELECT
	o.officeCode,
	COUNT(orders.orderNumber) AS amount
FROM
	orders
INNER JOIN customers c
	ON
		orders.customerNumber = c.customerNumber
INNER JOIN employees e
	ON
		c.salesRepEmployeeNumber = e.employeeNumber
INNER JOIN offices o
	ON
		e.officeCode = o.officeCode
GROUP BY
		o.officeCode
ORDER BY
	amount DESC
LIMIT 1;
   
-- Ejercicio 3

SELECT
	YEAR(payments.paymentDate) AS `year`,
	MONTH(payments.paymentDate) AS `month`,
	AVG(payments.amount),
	MAX(payments.amount),
	MIN(payments.amount)
FROM
	payments
GROUP BY
	`month`,
	`year`
ORDER BY
	`year`,
	`month`;


-- Ejercicio 4

CREATE PROCEDURE update_credit (IN new_limit decimal(10,2), IN customer_number int)
BEGIN
	UPDATE customers
	SET creditLimit = new_limit
	WHERE customers.customerNumber = customer_number;
END;

-- Ejercicio 5

CREATE VIEW premium_customers AS
	SELECT c.customerName, c.city, spent.total
	FROM customers c
	INNER JOIN
		(SELECT p.customerNumber, SUM(p.amount) AS total
		FROM payments p
		INNER JOIN customers c2
		ON c2.customerNumber = p.customerNumber
		GROUP BY c2.customerNumber
		) AS spent
	ON c.customerNumber = spent.customerNumber
	ORDER BY spent.total DESC 
	LIMIT 10;

-- Ejercicio 6

CREATE FUNCTION employee_of_the_month(chosenMonth INT, chosenYear INT)
RETURNS VARCHAR(255)
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE employeeName VARCHAR(100);
	DECLARE maxOrderCount INT;
	
    SELECT CONCAT(e.firstName, ' ' , e.lastName) AS name, COUNT(*) orderCount
    INTO employeeName, maxOrderCount
	FROM ((orders o
		INNER JOIN customers c ON o.customerNumber = c.customerNumber)
		INNER JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber)
	WHERE MONTH(o.orderDate) = chosenMonth AND YEAR(o.orderDate) = chosenYear
	GROUP BY name
	ORDER BY orderCount DESC LIMIT 1;

	RETURN employeeName;
END;

-- Ejercicio 7

CREATE TABLE productrefillment (
	refillmentID INT NOT NULL AUTO_INCREMENT,
	productCode VARCHAR(15) NOT NULL,
	orderDate date NOT NULL,
	quantity INT NOT NULL,
	
	PRIMARY KEY (refillmentID),
	FOREIGN KEY (productCode) REFERENCES products(productCode)
);

-- Ejercicio 8

CREATE TRIGGER restock_product
AFTER INSERT ON orderdetails
FOR EACH ROW 
BEGIN
	DECLARE quantity_in_stock INT;
	
	SELECT quantityInStock INTO quantity_in_stock
	FROM products 
	WHERE p.productCode = NEW.productCode;
	
	IF (amountStock - NEW.quantityOrdered < 10) THEN
		INSERT INTO refillment (productCode, orderDate, quantity)
		VALUES (NEW.productCode, CURDATE(), 10);
	END IF;
END;


-- Ejercicio 9

CREATE ROLE empleado;

GRANT SELECT, CREATE VIEW ON classicmodels.* TO empleado;
