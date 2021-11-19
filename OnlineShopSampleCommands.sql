-- SalesAnalytics.sql
-- Author: Mildretta Martin
-- Date Created: 10/29/2021
-- Last Revision: 11/19/2021
-- Description: Sales analytics for Online Shop

/*************************************************************************
*********************** Queries & Sample Statements *************************
**************************************************************************/

USE OnlineShop
GO

--Add a new line to the ItemCategory table by adding an int value for the @CategoryID and a varchar (35) value for the @Description
EXECUTE AddCategory @CategoryID = '5', @Description = 'GHOSTS';

--View your new addition
SELECT * FROM ItemCategory;
GO

--Delete the line that you just added from the ItemCategory
EXECUTE DeleteCategory @CategoryID = '5', @Description = 'GHOSTS';
GO

SELECT * FROM ItemCategory;
GO

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

/*Query Customers by state using any of the following: Alaska (AK), Louisiana (LA), Michigan (MI), New Jersey (NJ), Ohio (OH), Illinois (IL),
California (CA), South Dakota (SD), or Maryland (MD)*/
EXECUTE TopCustomer @State_Province = 'AK'; 
GO

SELECT State_Province FROM Customers;
GO

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

EXECUTE SalesByCategory;
GO

