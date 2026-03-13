---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 06 - Set Operators
-- � Itzik Ben-Gan 
---------------------------------------------------------------------




---------------------------------------------------------------------
-- The UNION Operator
---------------------------------------------------------------------


-- The UNION ALL Multiset Operator
SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee
UNION ALL
SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer;


-- The UNION Distinct Set Operator
SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee
UNION
SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer;


---------------------------------------------------------------------
-- The INTERSECT Operator
---------------------------------------------------------------------


-- The INTERSECT Distinct Set Operator
SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee
INTERSECT
SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer;


-- The INTERSECT ALL Multiset Operator (Optional, Advanced)
SELECT
  ROW_NUMBER() 
    OVER(PARTITION BY EmployeeCountry, EmployeeRegion, EmployeeCity
         ORDER     BY (SELECT 0)) AS rownum,
  EmployeeCountry, EmployeeRegion, EmployeeCity
FROM HumanResources.Employee


INTERSECT


SELECT
  ROW_NUMBER() 
    OVER(PARTITION BY CustomerCountry, CustomerRegion, CustomerCity
         ORDER     BY (SELECT 0)),
  CustomerCountry, CustomerRegion, CustomerCity
FROM Sales.Customer;


WITH INTERSECT_ALL
AS
(
  SELECT
    ROW_NUMBER() 
      OVER(PARTITION BY EmployeeCountry, EmployeeRegion, EmployeeCity
           ORDER     BY (SELECT 0)) AS rownum,
    EmployeeCountry, EmployeeRegion, EmployeeCity
  FROM HumanResources.Employee


  INTERSECT


  SELECT
    ROW_NUMBER() 
      OVER(PARTITION BY CustomerCountry, CustomerRegion, CustomerCity
           ORDER     BY (SELECT 0)),
    CustomerCountry, CustomerRegion, CustomerCity
  FROM Sales.Customer
)
SELECT EmployeeCountry, EmployeeRegion, EmployeeCity
FROM INTERSECT_ALL;


---------------------------------------------------------------------
-- The EXCEPT Operator
---------------------------------------------------------------------


-- The EXCEPT Distinct Set Operator


-- Employees EXCEPT Customers
SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee
EXCEPT
SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer;


-- Customers EXCEPT Employees
SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer
EXCEPT
SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee;


-- The EXCEPT ALL Multiset Operator (Optional, Advanced)
WITH EXCEPT_ALL
AS
(
  SELECT
    ROW_NUMBER() 
      OVER(PARTITION BY EmployeeCountry, EmployeeRegion, EmployeeCity
           ORDER     BY (SELECT 0)) AS rownum,
    EmployeeCountry, EmployeeRegion, EmployeeCity
  FROM HumanResources.Employee


  EXCEPT


  SELECT
    ROW_NUMBER() 
      OVER(PARTITION BY CustomerCountry, CustomerRegion, CustomerCity
           ORDER     BY (SELECT 0)),
    CustomerCountry, CustomerRegion, CustomerCity
  FROM Sales.Customer
)
SELECT EmployeeCountry, EmployeeRegion, EmployeeCity
FROM EXCEPT_ALL;


---------------------------------------------------------------------
-- Precedence
---------------------------------------------------------------------


-- INTERSECT Precedes EXCEPT
SELECT SupplierCountry, SupplierRegion, SupplierCity FROM Production.Supplier
EXCEPT
SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee
INTERSECT
SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer;


-- Using Parenthesis
(SELECT SupplierCountry, SupplierRegion, SupplierCity FROM Production.Supplier
 EXCEPT
 SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee)
INTERSECT
SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer;


---------------------------------------------------------------------
-- Circumventing Unsupported Logical Phases
-- (Optional, Advanced)
---------------------------------------------------------------------


-- Number of distinct locations
-- that are either employee or customer locations in each country
SELECT EmployeeCountry, COUNT(*) AS numlocations
FROM (SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee
      UNION
      SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer) AS U
GROUP BY EmployeeCountry;


-- Two most recent orders for employees 3 and 5
SELECT EmployeeId, OrderId, OrderDate
FROM (SELECT TOP (2) EmployeeId, OrderId, OrderDate
      FROM Sales.[Order]
      WHERE EmployeeId = 3
      ORDER BY OrderDate DESC, OrderId DESC) AS D1


UNION ALL


SELECT EmployeeId, OrderId, OrderDate
FROM (SELECT TOP (2) EmployeeId, OrderId, OrderDate
      FROM Sales.[Order]
      WHERE EmployeeId = 5
      ORDER BY OrderDate DESC, OrderId DESC) AS D2;
