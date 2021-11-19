/* SalesAnalytics.sql
 * Author: Mildretta Martin
 * Date Created: 10/29/2021
 * Last Revision: 11/17/2021
 * Description: Sales analytics for Online Shop
 *
 * Tables: 
 *			Customers (CustID, CompanyName, FirstName, LastName, Email, Addr1, Addr2, City, State_Province, PostalCode, Country, Phone) 
 *			Inventory (ItemSKU, CategoryID, ItemDesc, UOM, PricePerUnit)
 *			ItemCategory (CategoryID, Description)
 *			Orders (OrderID, CustID, Item1, Item1Qty, Item2, Item2Qty, TotQty, OrderAmt, OrderDate)
 *
 * Stored Procedures:
			1. AddCategory: @CategoryID, @Description
			2. TopCustomer: @State_Province
			3. - Displays by inventory category, the number of items sold and to whom
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


/*************************************************************************
***********************   DROP & CREATE TABLES  **************************
**************************************************************************/

DROP TABLE IF EXISTS Orders;
GO

DROP TABLE IF EXISTS LineItems;
GO

DROP TABLE IF EXISTS Customers;
GO

DROP TABLE IF EXISTS Inventory;
GO

DROP TABLE IF EXISTS ItemCategory;
GO

CREATE TABLE Customers (
    CustID varchar(4) PRIMARY KEY,
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
	Phone varchar(15),
	DateCreated datetime2
    );

CREATE TABLE ItemCategory (
	CategoryID int PRIMARY KEY,
	Description varchar(35)
	);

CREATE TABLE Inventory (
    ItemSKU int PRIMARY KEY,
    CategoryID int FOREIGN KEY(CategoryID) REFERENCES ItemCategory(CategoryID),
    ItemDesc varchar(255),
    OnHand int,
	UOM varchar(25),
	PricePerUnit smallmoney
	);

CREATE TABLE LineItems(
	LineID varchar(10) PRIMARY KEY NOT NULL,
	OrderID int, 
	CustID varchar(4) FOREIGN KEY(CustID) REFERENCES Customers(CustID),
	ItemSKU int FOREIGN KEY(ItemSKU) REFERENCES Inventory(ItemSKU),
	Quantity int,
	OrderDate datetime2 NOT NULL
	);

CREATE TABLE Orders (
    OrderID int PRIMARY KEY NOT NULL,
    Customer varchar(4) FOREIGN KEY(Customer) REFERENCES Customers(CustID) ,
	Item varchar(10) FOREIGN KEY(Item) REFERENCES LineItems(LineID),
    --Item1 int FOREIGN KEY(Item1) REFERENCES Inventory(ItemSKU),
    --Item1Qty int,
	--Item2 int NULL,
	--Item2Qty int,
	--TotQty int,
	OrderAmt smallmoney NULL,
    OrderDate datetime2 NOT NULL
    );

/*************************************************************************
**************************** INDEXES *************************************
**************************************************************************/


CREATE NONCLUSTERED INDEX IX_InventoryItem ON [Inventory] (ItemSKU)
GO


CREATE NONCLUSTERED INDEX IX_CustomerName ON [Customers] (CustID)
GO


/*************************************************************************
*********************** STORED PROCEDURES ********************************
**************************************************************************/


CREATE OR ALTER PROCEDURE AddCategory
	@CategoryID int,
	@Description date
AS
BEGIN
	INSERT INTO [ItemCategory] ([CategoryID], [Description])
		VALUES (@CategoryID, @Description)
END
GO

CREATE OR ALTER PROCEDURE TopCustomer
@State_Province varchar(2)
AS
SELECT customer, sum(o.TotQty) AS 'TotalQuantity',
	UPPER(c.State_Province) AS 'Location',
	CONCAT(c.LastName, ',',  c.FirstName) AS 'FullName' 
FROM Orders o 
LEFT JOIN Customers c ON c.CustID = o.Customer
WHERE c.State_Province = @State_Province
GROUP BY o.Customer, c.LastName, c.FirstName, c.State_Province;
GO

/*--CREATE OR ALTER PROCEDURE SalesbyCategory
--@Category varchar(255)
--AS
SELECT sum(o.totqty) AS 'TotalQuantity', 
	ic.Description AS 'Category',
	CONCAT(c.LastName,', ', c.FirstName) AS 'FullName' 
FROM Orders o
LEFT JOIN Inventory i ON i.ItemSKU = o.Item1
--LEFT JOIN Customer c ON c.CustID = o.Customer
--LEFT JOIN ItemCategory ic ON ic. = sp.LevelId
WHERE ic.Description = @Category
GROUP BY spl.LevelName, sp.LastName, sp.FirstName;
GO */