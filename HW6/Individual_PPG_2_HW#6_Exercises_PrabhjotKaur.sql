/*======================================================================================================================================================================================================================================================
  PROPOSITIONS                                                                                                                                                                                                     
  ======================================================================================================================================================================================================================================================
  Proposition 1 (UNION OPERATOR): We have a case were our manager wants a single list that shows all the cities where we have employees or customers. They are tired of having to check two seperate list.         
  Solution 1: Using the UNION operator, we can combine the employee's and customers locations into one single list. Union will also help us by removing all duplicate cicites so it stays clean and organized.  
  
  Proposition 2 (INTERSECT OPERATOR): We can imagine a scenario were our manager created a public events team that wants to know which cities have both employees and cusotmers so they can plan there events there.   
  Solution 2: We can use the INTERSECT operator to comapre the employees and customer locations so that it can only return cities that appear in both of the tables.
 
  Proposition 3 (EXCEPT OPERATOR): Our managers sales team wants to know which cities have employees but no customers so they know where to look for creating new business. 
  Solution 3: The EXCEPT operator will take the employees location and remove any cities that laready have cusotmers in them. It will return only the cities that have no customers again allowing us to know where to go for new business. 
  
  Proposition 4 (Precedence): Our manager wants to know our suppliers location and match there customers location but not there employees location. We want to make sure that the SQL runs the logic in the correct order or our results will be wrong 
  Solution 4: We can use both INTERSECT and EXCEPT together siunce intersect runs before except. We then can use parentheses to control the order and makre sure the query does what out manager wants.
  
  Proposition 5 (Circumventing Unsupported Logical Phases): Our boss wants a number of unqiue locations per country and the two most recent orders for specific employees. Additionally, set operators do not support GROUP BY or ORDER by directly.
  Solution 5: We can wrap our UNION queries inside subqueries so we can then apply the GROUP BY and ORDER BY on the outside of it. This allows us to get around the limitation applied to us while still giving our boss what they asked for. 
  ======================================================================================================================================================================================================================================================
 */

--======================================================================================================================================================================================================================================================
-- CHAPTER 6 - SET OPERATORS - EXERCISES
--======================================================================================================================================================================================================================================================

-- EXERCISE 1
/* 
   Explain the difference between the UNION ALL and UNION operators
   In what cases are they equivalent?
   When they are equivalent, which one should you use?

  [EXERCISE 1 SOLUTION:]
  UNION ALL returns everything form both tables including duplicates.
  UNION returns everything as well but removes duplicates.
  They would be equivalent when the data for both of the tables both dont have duplicates.
  Even though they are equivalent, it is better to use UNION ALL as it is fadter since SQL does not have to do the extra work of removing duplicates. 
*/

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* EXERCISE 2 
   Generate numbers 1 through 10 without using a table
   Desired output
   n
   
   1
   2
   3
   4
   5
   6
   7
   8
   9
   10

   (10 row(s) affected)
   [EXERCISE 2 SOLUTION:] */

SELECT 1 AS n  --label 1 as n
UNION ALL SELECT 2 --add each number onto list
UNION ALL SELECT 3
UNION ALL SELECT 4
UNION ALL SELECT 5
UNION ALL SELECT 6
UNION ALL SELECT 7
UNION ALL SELECT 8
UNION ALL SELECT 9
UNION ALL SELECT 10; --UNION ALL keeps all numbers no dupes

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* EXERCISE 3 
   Write a query that returns customer and employee pairs 
   that had order activity in January 2016 but not in February 2016
   Tables involved: TSQLV4 database, Orders table


  Desired output
custid      empid
----------- -----------
1           1
3           3
5           8
5           9
6           9
7           6
9           1
12          2
16          7
17          1
20          7
24          8
25          1
26          3
32          4
38          9
39          3
40          2
41          2
42          2
44          8
47          3
47          4
47          8
49          7
55          2
55          3
56          6
59          8
63          8
64          9
65          3
65          8
66          5
67          5
70          3
71          2
75          1
76          2
76          5
80          1
81          1
81          3
81          4
82          6
84          1
84          3
84          4
88          7
89          4


(50 row(s) affected)
[EXERCISE 3 SOLUTION:] */

SELECT MIN(OrderDate), MAX(OrderDate) FROM Sales.[Order]; --this is the years northwinds database works with. Below is the question answer

SELECT CustomerId, EmployeeId
FROM Sales.[Order]
WHERE OrderDate >= '2016-01-01' AND OrderDate < '2016-02-01'  --only january
EXCEPT -- remove pairs
SELECT CustomerId, EmployeeId --same customerid and employee id
FROM Sales.[Order] --only february
WHERE OrderDate >= '2021-02-01' AND OrderDate < '2021-03-01';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* EXERCISE 4 
   Write a query that returns customer and employee pairs 
   that had order activity in both January 2016 and February 2016
   Tables involved: TSQLV4 database, Orders table


  Desired output
custid      empid
----------- -----------
20          3
39          9
46          5
67          1
71          4


(5 row(s) affected)
[EXERCISE 4 SOLUTION:] */

SELECT CustomerId, EmployeeId
FROM Sales.[Order]
WHERE OrderDate >= '2021-01-01' AND OrderDate < '2021-02-01' --only january
INTERSECT --keep pairs that appear in both
SELECT CustomerId, EmployeeId --same customerid and employee id
FROM Sales.[Order] -- only february
WHERE OrderDate >= '2021-02-01' AND OrderDate < '2021-03-01';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* EXERCISE 5 
   Write a query that returns customer and employee pairs 
   that had order activity in both January 2016 and February 2016
   but not in 2015
   Tables involved: TSQLV4 database, Orders table


  Desired output
custid      empid
----------- -----------
67          1
46          5


(2 row(s) affected)
[EXERCISE 5 SOLUTION:] */

SELECT CustomerId, EmployeeId
FROM Sales.[Order]
WHERE OrderDate >= '2021-01-01' AND OrderDate < '2021-02-01' --only january
INTERSECT --keep pairs in both january and february
SELECT CustomerId, EmployeeId --same customerid and employee id
FROM Sales.[Order]
WHERE OrderDate >= '2021-02-01' AND OrderDate < '2021-03-01' --only february
EXCEPT --remove pairs also in 2020
SELECT CustomerId, EmployeeId --same customerid and employee id
FROM Sales.[Order] 
WHERE OrderDate >= '2020-01-01' AND OrderDate < '2021-01-01'; --start of 2020

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
