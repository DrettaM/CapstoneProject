USE OnlineShop

DROP TABLE IF EXISTS Customer;
GO

DROP TABLE IF EXISTS Items;
GO

DROP TABLE IF EXISTS Orders;
GO

CREATE TABLE Customer (
    CustID int primary key,
	Name nvarchar(30),
	Email nvarchar(50),
	Address1 nvarchar(255),
	Address2 nvarchar(255) Null,
	City nvarchar(30),
	State nvarchar(2),
	PostalCode int ,
	Country nvarchar(30),
	Phone int
    );

CREATE TABLE Items (
    ItemSKU int primary key,
    Category nvarchar(50),
    ItemDesc nvarchar(255),
    PricePerUnit smallmoney,
    ItemStatus nvarchar(15)
    );

CREATE TABLE Orders (
    OrderID int primary key,
    CustID nchar(10),
    ItemSKU int,
    ItemsQuanity int,
    OrderAmt smallmoney,
    OrderDate datetime,
    ShipDate datetime,
    ShipVia varchar(4) NOT NULL,
    ShipCost smallmoney,
    ShipName nvarchar(30),
    ShipAddr1 nvarchar(255),
    ShipAddr2 nvarchar(255),
    ShipCity nvarchar(30),
    ShipState nvarchar(2),
    ShipPostalCode int(10),
    ShipCountry nvarchar(30)
    );