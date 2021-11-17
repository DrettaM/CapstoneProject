/* SalesAnalytics.sql
 * Author: Mildretta Martin
 * Date Created: 10/29/2021
 * Description: Sales analytics for Online Shop
 *
 * Tables: 
			Customer (CustID, Name, Email, Address1, Address2, City, State, PostalCode, Country, Phone) 
			Items (ItemSKU, Category, ItemDesc, PricePerUnit, ItemStatus)
			Orders (OrderID, CustID, ItemSKU, ItemsQty, OrderAmt, OrderDate, ShipDate, ShipVia, ShipCost, ShipName, ShipAddr1, ShipAddr2, ShipCity, ShipState, ShipPostalCode, ShipCountry)
 *
 * Stored Procedures:
 *    
*/

/*************************************************************************
*************************   DROP & CREATE   ********************************
**************************************************************************/

--CREATE DATABASE OnlineShop;

USE OnlineShop

DROP TABLE IF EXISTS Orders;
GO

DROP TABLE IF EXISTS Customer;
GO

DROP TABLE IF EXISTS Items;
GO

CREATE TABLE Customer (
    CustID int PRIMARY KEY,
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
    ItemSKU int PRIMARY KEY,
    Category nvarchar(50),
    ItemDesc nvarchar(255),
    PricePerUnit smallmoney,
    ItemStatus nvarchar(15)
    );

CREATE TABLE Orders (
    OrderID int PRIMARY KEY,
    CustID int FOREIGN KEY(CustID) REFERENCES Customer(CustID) ,
    ItemSKU int FOREIGN KEY(ItemSKU) REFERENCES Items(ItemSKU),
    ItemsQty int,
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
    ShipPostalCode int,
    ShipCountry nvarchar(30)
    );

/*************************************************************************
*********************** STORED PROCEDURES ********************************
**************************************************************************/