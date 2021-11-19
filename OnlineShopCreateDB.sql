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
 * SProcs:
			1. AddCategory: @CategoryID, @Description
			2. DeleteCategory: @CategoryID, @Description
			3. TopCustomer: @State_Province
			4. SalesByCategory: Displays by inventory category, the number of items sold and to whom
		
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

DROP TABLE IF EXISTS ItemCategory;
GO

DROP TABLE IF EXISTS Orders;
GO

DROP TABLE IF EXISTS LineItems;
GO

DROP TABLE IF EXISTS Customers;
GO

DROP TABLE IF EXISTS Inventory;
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

CREATE TABLE Orders (
    OrderID int PRIMARY KEY NOT NULL,
    Customer varchar(4) FOREIGN KEY(Customer) REFERENCES Customers(CustID) ,
	Item varchar(10),
   	OrderAmt smallmoney NULL,
    OrderDate datetime2 NOT NULL
    );

CREATE TABLE LineItems(
	LineID varchar(10) PRIMARY KEY NOT NULL,
	OrderID int FOREIGN KEY(OrderID) REFERENCES Orders(OrderID), 
	CustID varchar(4) FOREIGN KEY(CustID) REFERENCES Customers(CustID),
	ItemSKU int FOREIGN KEY(ItemSKU) REFERENCES Inventory(ItemSKU),
	Quantity int,
	OrderDate datetime2 NOT NULL
	);



/*************************************************************************
*******************      NONCLUSTERED INDEXES   ***************************
**************************************************************************/


CREATE NONCLUSTERED INDEX IX_InventoryItem ON [Orders] (OrderID)
GO


CREATE NONCLUSTERED INDEX IX_CustomerName ON [Customers] (CustID)
GO


/*************************************************************************
*********************** STORED PROCEDURES ********************************
**************************************************************************/


CREATE OR ALTER PROCEDURE AddCategory
	@CategoryID int,
	@Description varchar (35)
AS
BEGIN
	INSERT INTO [ItemCategory] ([CategoryID], [Description])
		VALUES (@CategoryID, @Description)
END
GO

---------------------------------------------------------------------------------------------------
--a DML statement that UPDATES a set of rows with a WHERE clause. The values used in the WHERE clause should be a variable
CREATE OR ALTER PROCEDURE DeleteCategory
	@CategoryID int,
	@Description varchar (35)
AS
BEGIN
	DELETE FROM ItemCategory 
	WHERE CategoryID = @CategoryID
END
GO

---------------------------------------------------------------------------------------------------

--	a SELECT query that uses a WHERE clause.
CREATE OR ALTER PROCEDURE TopCustomer
@State_Province varchar(2)
AS
SELECT c.CustID, sum(li.Quantity) AS 'TotalQuantity',
	UPPER(c.State_Province) AS 'Location',
	CONCAT(c.LastName, ',',  c.FirstName) AS 'FullName' 
FROM LineItems li
LEFT JOIN Customers c ON c.CustID = li.CustID
WHERE c.State_Province = @State_Province
GROUP BY c.CustID, c.LastName, c.FirstName, c.State_Province;
GO

---------------------------------------------------------------------------------------------------

--A SELECT query that utilizes an ORDER BY clause
CREATE OR ALTER PROCEDURE SalesbyCategory

AS 
SELECT ic.Description AS 'Category',
	sum(li.Quantity) AS 'TotalQuantity', 
	CONCAT(c.LastName,', ', c.FirstName) AS 'FullName' 
FROM LineItems li
LEFT JOIN Inventory i ON i.ItemSKU = li.ItemSKU
LEFT JOIN Orders o ON o.Customer = li.CustID
LEFT JOIN Customers c ON c.CustID = o.Customer
LEFT JOIN ItemCategory ic ON ic.CategoryID = i.CategoryID
WHERE li.Quantity > 0 
GROUP BY ic.Description, li.Quantity, c.CustID, c.LastName, c.FirstName
ORDER BY sum(li.Quantity) DESC;
GO 

