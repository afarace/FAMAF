-- Parcial I - Farace, Agustín

USE northwind;

-- Ejercicio 1

SELECT
	c.CustomerID,
	c.ContactName,
	incomes.total
FROM
	Customers c
JOIN (
	SELECT
		c2.CustomerID,
		SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) AS total
	FROM
		Customers c2
	JOIN Orders o
	  ON
		o.CustomerID = c2.CustomerID
	JOIN `Order Details` od
	  ON
		od.OrderID = o.OrderID
	GROUP BY
		CustomerID
	ORDER BY
		total DESC) AS incomes
ON
	c.CustomerID = incomes.CustomerID
ORDER BY
	incomes.total DESC
LIMIT 5;

-- Ejercicio 2

SELECT c.CategoryName, p.ProductName, order_product.total
FROM Products p
INNER JOIN Categories c
ON p.CategoryID = c.CategoryID
INNER JOIN (
	SELECT od.ProductID, SUM(od.Quantity) AS total
	FROM `Order Details` od
	GROUP BY ProductID
	) AS order_product
ON p.ProductID = order_product.ProductID;
	
	
-- Ejercicio 3

SELECT c.CategoryName, sum(order_product.total) AS total_sales
FROM Products p
INNER JOIN Categories c
ON p.CategoryID = c.CategoryID
INNER JOIN (
	SELECT od.ProductID, SUM(od.Quantity) AS total
	FROM `Order Details` od
	GROUP BY ProductID
	) AS order_product
ON p.ProductID = order_product.ProductID
GROUP BY CategoryName;

-- Ejercicio 4

CREATE OR REPLACE VIEW top_selling_employee
	WITH sales_by_employee_year AS (
		SELECT
			CONCAT(e.FirstName, ' ', e.LastName) AS name,
			YEAR(o.OrderDate) AS `year`,
			COUNT(o.OrderID) AS total_orders
		FROM Employees e
		INNER JOIN Orders o
		ON e.EmployeeID = o.EmployeeID
		INNER JOIN `Order Details` od
		ON o.OrderID = od.OrderID
		GROUP BY name, `year`
	)

	SELECT s1.name, s1.`year`, s1.total_orders
	FROM sales_by_employee_year s1
	INNER JOIN (
		SELECT `year`, MAX(total_orders) AS max_orders
		FROM sales_by_employee_year
		GROUP BY `year`
	) s2
	ON s1.`year` = s2.`year` AND s1.total_orders = s2.max_orders
	ORDER BY s1.`year` ASC;

-- Ejercicio 5

CREATE TRIGGER decrease_stock
AFTER INSERT ON `Order Details`
FOR EACH ROW 
BEGIN
	UPDATE Products p
	SET p.UnitsInStock = p.UnitsInStock - NEW.Quantity
	WHERE NEW.ProductID = p.ProductID;
END;

-- Ejercicio 6

CREATE ROLE admin;

GRANT INSERT ON northwind.Customers TO admin;

GRANT UPDATE (Phone) ON northwind.Customers TO admin;

