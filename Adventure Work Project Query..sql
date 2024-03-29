--Business Requirements

--- Question 1
--- Retrieve information about the products with colour values except null, red, silver/black, white and list price between
--- £75 and £750. Rename the column StandardCost to Price. Also, sort the results in descending order by list price.

---Solution.

SELECT ProductID, Name, ProductNumber, Color, StandardCost AS Price, ListPrice
FROM Production.Product
WHERE Color NOT IN ('red','silver','black', 'white') AND ListPrice NOT BETWEEN 75 AND 750
ORDER BY ListPrice DESC 


--- Question 2
--- Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and female employees
--- born between 1972 and 1975 and hire date greater 2001

--- Solution

SELECT GENDER, BirthDate, HireDate
FROM HumanResources.Employee
WHERE Gender = 'M' AND  
      BirthDate BETWEEN 
      CAST ('1962-01-01' as datetime) AND  CAST ('1970-01-01'as datetime) AND 
      HireDate >
      CAST ('2001-01-01' as datetime)
UNION
SELECT GENDER, BirthDate, HireDate
FROM HumanResources.Employee
WHERE Gender = 'F' AND  
	  BirthDate BETWEEN 
      CAST ('1972-01-01' as datetime) AND  CAST ('1975-01-01'as datetime) AND
	  HireDate >
      CAST ('2001-01-01' as datetime);



--- Question 3
--- Create a list of 10 most expensive products that have a product number beginning with BK. Include only the product
--- ID, Name, colour, ListPrice, ProductNumber.

--- Solution.

SELECT TOP(10) ProductID, NAME, Color, ListPrice, ProductNumber
FROM Production.Product
--WHERE ProductNumber = 'BK%'
ORDER BY ListPrice DESC;


--- Question 4
--- Return all product subcategories that take 3 days or longer to manufacture.

--- Solution

SELECT Production.ProductSubcategory.ProductSubcategoryID, 
       Production.ProductSubcategory .Name, 
	   DaysTOManufacture AS Days_To_Manufacture
FROM Production.ProductSubcategory
INNER JOIN Production.Product
ON Production.ProductSubcategory.ProductSubcategoryID = Production.Product.ProductSubcategoryID
WHERE DaysToManufacture >= 4;

--- Question 5
--- Create a list of product segmentation by defining criteria that places each item in a predefined segment as follows. If
--- price gets less than £200 then low value. If price is between £201 and £750 then mid value. If between £750 and £1250
--- then mid to high value else higher value. Filter the results only for black, silver and red color products.

--- Solution.

SELECT ProductID, Name, ProductNumber, Color, ListPrice,
CASE
     WHEN ListPrice < 200 THEN 'Low Value' 
	 WHEN ListPrice BETWEEN 201 AND 750 THEN 'Mid Value'
	 WHEN ListPrice BETWEEN 751 AND 1250 THEN 'Mid To High Value'
     ELSE 'High Value'
END AS Product_Segmentation
FROM Production.Product
WHERE Color IN ('Black', 'Silver', 'Red')
ORDER BY ListPrice DESC

--- Question 6
--- How many Distinct Job title is present in the Employee table?

--- Solution

SELECT COUNT( DISTINCT JobTitle) AS Number_OF_JobTitle 
FROM HumanResources.Employee

--- Question 7
--- Use employee table and calculate the ages of each employee at the time of hiring

--- Solution.
SELECT BirthDate, 
       HireDate, 
	   DATEDIFF (Year, BirthDate, HireDate) Employee_Age
FROM HumanResources.Employee
ORDER BY Employee_Age DESC


---- Question 8
--- Print the information about all the Sales.Person and their sales quota. For every Sales person you should provide their
--- FirstName, LastName, HireDate, SickLeaveHours.

--- Solution

SELECT Person.person.BusinessEntityID,
       FirstName,LastName, 
	   SalesQuota, HireDate, 
	   SickLeaveHours
FROM person.Person
INNER JOIN Sales.SalesPerson
ON Person.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID
INNER JOIN HumanResources.Employee
ON Sales.SalesPerson.BusinessEntityID = HumanResources.Employee.BusinessEntityID;


--- Question 9

--- Using adventure works, write a query to extract the following information.
--  Product name
--  Product category name
--  Product subcategory name
--  Sales person
--  Revenue
--  Month of transaction
--  Quarter of transaction
--  Region

--- Solution
SELECT Production.Product.ProductID, 
       Production.Product. Name As Product_Nane, 
	   Production.ProductCategory.Name AS Product_category_name, 
	   Production.ProductSubcategory.Name As Product_subcategory_name,
	   FirstName+' '+LastName As Sales_Person
FROM Production.Product
INNER JOIN Production.ProductSubcategory
ON Production.Product.ProductSubcategoryID = Production.ProductSubcategory.ProductSubcategoryID
INNER JOIN Production.ProductCategory
ON Production.Product.ProductSubcategoryID = Production.ProductCategory.ProductCategoryID
INNER JOIN Person.Person
ON Production.ProductCategory.ModifiedDate = Person.PERSON.ModifiedDate



--- Question 10
--- Display the information about the details of an order i.e. order number, order date, amount of order, which customer
--- gives the order and which salesman works for that customer and how much commission he gets for an order

--- Solution.

SELECT Sales.SalesOrderHeader.SalesOrderID, 
       SalesOrderNumber, 
	   OrderDate, 
	   CustomerID, 
	   LineTotal AS Amount_Of_Order,
	   FirstName+' '+LastName As Sales_Man,
	   CommissionPct
FROM Sales.SalesOrderHeader
INNER JOIN Sales.SalesOrderDetail
ON Sales.SalesOrderDetail.SalesOrderID =  Sales.SalesOrderDetail.SalesOrderID
INNER JOIN Sales.SalesPerson
ON Sales.SalesOrderDetail.ModifiedDate = Sales.SalesPerson.ModifiedDate
INNER JOIN Person.Person
ON Sales.SalesPerson.BusinessEntityID = Person.Person.BusinessEntityID
ORDER BY CommissionPct DESC



