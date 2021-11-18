/* SalesAnalytics.sql
 * Author: Mildretta Martin
 * Date Created: 10/29/2021
 * Last Revision: 11/17/2021
 * Description: Sales analytics for Online Shop
 *
 * Tables: 
 *			Customer (CustID, CompanyName, FirstName, LastName, Email, Addr1, Addr2, City, State_Province, PostalCode, Country, Phone) 
 *			Inventory (ItemSKU, Category, ItemDesc, UOM, PricePerUnit)
 *			Orders (OrderID, CustID, ItemSKU, Item1Qty, Item2SKU, Item2Qty, TotQty, OrderAmt, OrderDate)
 *
 * Stored Procedures:
			1. ImportData - Imports data from csv files into tables
			2. CreateSalesReport - Displays by inventory category, the number of items sold and to whom
			3. CreateRevenueReport - Displays sales totals by month and year
			4. PopularItems - Displays items that have more than 500 units purchased
		
 *    
*/

/*************************************************************************
*************************   DROP & CREATE DB  ***************************
**************************************************************************/

USE Master;
GO

IF DATABASEPROPERTYEX ('OnlineShop','Version') IS NOT NULL
BEGIN
	ALTER DATABASE OnlineShop SET SINGLE_USER
	WITH ROLLBACK IMMEDIATE;
	DROP DATABASE OnlineShop;
END
GO

CREATE DATABASE OnlineShop;
GO

USE OnlineShop;
GO

DROP SCHEMA IF EXISTS Sales;
GO

CREATE SCHEMA Sales;
GO

/*************************************************************************
***********************   DROP & CREATE TABLES  **************************
**************************************************************************/

DROP TABLE IF EXISTS Orders;
GO

DROP TABLE IF EXISTS Customer;
GO

DROP TABLE IF EXISTS Inventory;
GO

CREATE TABLE Customer (
    CustID int PRIMARY KEY,
	CompanyName varchar(35) NULL,
	FirstName varchar(35) NOT NULL,
	LastName varchar(35) NOT NULL,
	Email varchar(50),
	Addr1 varchar(255),
	Addr2 varchar(255) Null,
	City varchar(30),
	State_Province varchar(2),
	PostalCode int ,
	Country varchar(30),
	Phone int,
	DateCreated datetime NOT NULL DEFAULT GETDATE()
    );

CREATE TABLE Inventory (
    ItemSKU nvarchar(25) PRIMARY KEY,
    Category varchar(50),
    ItemDesc varchar(255),
    OnHand int,
	UOM varchar(25),
	PricePerUnit smallmoney
	);

CREATE TABLE Orders (
    OrderID int PRIMARY KEY,
    CustID int FOREIGN KEY(CustID) REFERENCES Customer(CustID) ,
    ItemSKU nvarchar(25) FOREIGN KEY(ItemSKU) REFERENCES Inventory(ItemSKU),
    Item1Qty int,
	Item2SKU nvarchar(25) FOREIGN KEY(Item2SKU) REFERENCES Inventory(ItemSKU),
    TotQty int,
	OrderAmt smallmoney,
    OrderDate datetime NOT NULL DEFAULT GETDATE(),
    );

/*************************************************************************
**************************** INDEXES *************************************
**************************************************************************/


CREATE NONCLUSTERED INDEX IX_InventoryItem ON [Inventory] (ItemSKU)
GO


CREATE NONCLUSTERED INDEX IX_CustomerName ON [Customer] (LastName)
GO


/*************************************************************************
*********************** STORED PROCEDURES ********************************
**************************************************************************/


--CREATE OR ALTER PROCEDURE ImportData
--AS

BULK INSERT Customer 
FROM 'C:\Data\Temp\SalesAnalytics\Customers.csv' 
WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK );

BULK INSERT Inventory 
FROM 'C:\Data\Temp\SalesAnalytics\Inventory.csv' 
WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK );

BULK INSERT Orders 
FROM 'C:\Data\Temp\SalesAnalytics\Orders.csv' 
WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK );

GO

/*CREATE OR ALTER PROCEDURE CreateSalesReport
@Category varchar(255)
AS
SELECT SUM(so.SalesAmount) AS 'SalesAmount'
	   ,spl.LevelName AS 'Level'
	   ,CONCAT(sp.LastName,', ',sp.FirstName) AS 'FullName' 
FROM Sales.SalesPerson sp
LEFT OUTER JOIN Sales.SalesOrder so ON so.SalesPerson = sp.Id
LEFT OUTER JOIN Sales.SalesPersonLevel spl ON spl.Id = sp.LevelId
WHERE spl.LevelName = @LevelName
GROUP BY spl.LevelName, sp.LastName, sp.FirstName;
GO */