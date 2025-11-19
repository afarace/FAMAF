-- Recuperatorio 1 - Farace, Agustín

USE northwind;

-- Ejercicio 1

SELECT
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantitySold
FROM 
    `Order Details` od
JOIN 
    Products p ON od.ProductID = p.ProductID
GROUP BY 
    p.ProductName
ORDER BY 
    TotalQuantitySold DESC
LIMIT 10;

-- Ejercicio 2

SELECT
    e.FirstName,
    e.LastName,
    COUNT(o.OrderID) AS TotalOrdersManaged
FROM 
    Employees e
LEFT JOIN 
    Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY 
    e.EmployeeID
ORDER BY 
    TotalOrdersManaged DESC;

-- Ejercicio 3

SELECT
    c.ContactName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalBilledAmount
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    `Order Details` od ON o.OrderID = od.OrderID
GROUP BY 
    c.ContactName
ORDER BY 
    TotalBilledAmount DESC;

-- Ejercicio 4

DELIMITER //
CREATE TRIGGER SetShipCountryBeforeInsert
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE customerCountry VARCHAR(50);
    SELECT Country INTO customerCountry
    FROM Customers
    WHERE CustomerID = NEW.CustomerID;
    SET NEW.ShipCountry = customerCountry;
END;
//
DELIMITER ;

-- Ejercicio 5

CREATE ROLE analyst;
GRANT SELECT ON northwind.* TO 'analyst';
GRANT CREATE VIEW ON northwind.* TO 'analyst';