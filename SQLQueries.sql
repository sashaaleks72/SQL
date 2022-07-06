USE AdventureWorks2019;
﻿
--------------------------ДОМАШКА----------------------------

----------------------ЗАДАНИЕ №1-----------------------------
--Вывести всю информацию из таблицы Sales.Customer 
-------------------------------------------------------------
SELECT * FROM Sales.Customer;
GO

----------------------ЗАДАНИЕ №2-----------------------------
--Вывести всю информацию из таблицы Sales.Store отсортированную 
--по Name в алфавитном порядке
-------------------------------------------------------------

-----------------------ORDER BY------------------------------
SELECT * FROM Sales.Store ORDER BY Name;
GO

----------------------ЗАДАНИЕ №3-----------------------------
--Вывести из таблицы HumanResources.Employee всю информацию
--о десяти сотрудниках, которые родились позже 1989-09-28
-------------------------------------------------------------

SELECT TOP 10 * FROM HumanResources.Employee WHERE BirthDate > '1989-09-28';
GO

------------------------BETWEEN-------------------------------
SELECT TOP 10 * FROM HumanResources.Employee WHERE BirthDate BETWEEN '1978-01-01' AND '1989-09-28';
GO

------------------------LIKE---------------------------------
----------------------ЗАДАНИЕ №4-----------------------------
--Вывести из таблицы HumanResources.Employee сотрудников
--у которых последний символ LoginID является 0.
--Вывести только NationalIDNumber, LoginID, JobTitle.
--Данные должны быть отсортированы по JobTitle по убиванию
-------------------------------------------------------------

SELECT NationalIDNumber, LoginID, JobTitle FROM HumanResources.Employee WHERE LoginID LIKE '%0' ORDER BY JobTitle DESC;
GO

------------------------LIKE---------------------------------
----------------------ЗАДАНИЕ №5-----------------------------
--Вывести из таблицы Person.Person всю информацию о записях, которые были 
--обновлены в 2008 году (ModifiedDate) и MiddleName содержит
--значение и Title не содержит значение 
-------------------------------------------------------------

SELECT * FROM Person.Person WHERE CONVERT(varchar, ModifiedDate, 105) LIKE '%2008' AND MiddleName IS NOT NULL AND Title IS NULL;
GO

--------------------------INNER JOIN-------------------------
----------------------ЗАДАНИЕ №6-----------------------------
--Вывести название отдела (HumanResources.Department.Name) БЕЗ повторений
--в которых есть сотрудники
--Использовать таблицы HumanResources.EmployeeDepartmentHistory и HumanResources.Department
-------------------------------------------------------------

SELECT DISTINCT d.[Name] FROM HumanResources.EmployeeDepartmentHistory AS edh 
INNER JOIN HumanResources.Department AS d 
ON edh.DepartmentID = d.DepartmentID
WHERE edh.BusinessEntityID IS NOT NULL;
GO


---------------Aggregate func(sum)+GroupBy+Having------------
----------------------ЗАДАНИЕ №7-----------------------------
--Сгрупировать данные из таблицы Sales.SalesPerson по TerritoryID
--и вывести сумму CommissionPct, если она больше 0
-------------------------------------------------------------

SELECT TerritoryID, SUM(CommissionPct) AS SumOfCommissionPct FROM Sales.SalesPerson GROUP BY TerritoryID HAVING SUM(CommissionPct) > 0;
GO


-----------------------Subquery+agr(max)---------------------
----------------------ЗАДАНИЕ №8-----------------------------
--Вывести всю информацию о сотрудниках (HumanResources.Employee) 
--которые имеют самое большое кол-во 
--отпуска (HumanResources.Employee.VacationHours)
-------------------------------------------------------------

SELECT * FROM HumanResources.Employee WHERE VacationHours = (SELECT MAX(VacationHours) FROM HumanResources.Employee);
GO

----------------------------IN-------------------------------
----------------------ЗАДАНИЕ №9-----------------------------
--Вывести всю информацию о сотрудниках (HumanResources.Employee) 
--которые имеют позицию (HumanResources.Employee.JobTitle)
--'Sales Representative' или 'Network Administrator' или 'Network Manager'
-------------------------------------------------------------

SELECT * FROM HumanResources.Employee WHERE JobTitle IN ('Sales Representative', 'Network Administrator', 'Network Manager');
GO

------------------------LEFT JOIN----------------------------
----------------------ЗАДАНИЕ №10----------------------------
--Вывести всю информацию о сотрудниках (HumanResources.Employee) и 
--их заказах (Purchasing.PurchaseOrderHeader). ЕСЛИ У СОТРУДНИКА НЕТ
--ЗАКАЗОВ ОН ДОЛЖЕН БЫТЬ ВЫВЕДЕН ТОЖЕ!!!
-------------------------------------------------------------

SELECT * FROM HumanResources.Employee AS emp 
LEFT JOIN Purchasing.PurchaseOrderHeader AS o 
ON emp.BusinessEntityID = o.EmployeeID;
GO

------------------------FULL JOIN-----------------------------
SELECT * FROM Sales.ShoppingCartItem AS sci
FULL JOIN Production.Product AS p
ON sci.ProductID = p.ProductID;
GO

----------------ORDER BY (two fields)-------------------------
SELECT pc.[Name] AS CategoryName, ps.[Name] SubcategoryName  FROM Production.ProductCategory AS pc
INNER JOIN Production.ProductSubcategory AS ps
ON pc.ProductCategoryID = ps.ProductCategoryID
ORDER BY CategoryName ASC, SubcategoryName DESC

--------------------------UPDATE------------------------------
UPDATE Production.Product SET Color = 'White';
UPDATE Production.Product SET MakeFlag = 1 WHERE ProductID = 1;

--------------------------DELETE-------------------------
DELETE Sales.Store WHERE BusinessEntityID = 646;
DELETE Production.ProductSubcategory

----TRANSACTION----
DECLARE @emp INT;
SET @emp = 0;

DECLARE @loginId NVARCHAR(256);
SET @loginId = 'adventure-works\rob0';

DECLARE @jobTitle NVARCHAR(50);
SET @jobTitle = 'Vice President of Engineering'

BEGIN TRY

BEGIN TRANSACTION

   DELETE HumanResources.Employee WHERE BusinessEntityID = @emp;
   DELETE HumanResources.Employee WHERE LoginID = @loginId;
   DELETE HumanResources.Employee WHERE JobTitle = @jobTitle;

END TRY
	BEGIN CATCH		
		SELECT ERROR_MESSAGE() AS ErrorMsg
		RETURN
	END CATCH

COMMIT TRANSACTION

GO

DECLARE @loginId NVARCHAR(256);
SET @loginId = 'adventure-works\rob0';
DECLARE @emp INT;
SET @emp = 0;
DECLARE @jobTitle NVARCHAR(50);
SET @jobTitle = 'Vice President of Engineering'

SELECT * FROM HumanResources.Employee WHERE BusinessEntityID = @emp;
SELECT * FROM HumanResources.Employee WHERE LoginID = @loginId;
SELECT * FROM HumanResources.Employee WHERE JobTitle = @jobTitle;

