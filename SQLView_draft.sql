CREATE VIEW OrdersView AS select OrderID, BillAmount, Quantity FROM Orders;

SELECT column_name.tableAlias, column_name.tableAlias
  FROM database 
  INNER JOIN table_ AS tableAlias ON t1.name = t2.name;

  
-- Create an Orders Table with the following columns:
--   EmployeeID

-- Add employeeID to Orders

-- Add menu name to menus tables, what should menu id look like?

-- How to link Bookings and Orders Tables?

-- SELECT * 
-- FROM Bookings 
--   JOIN Orders ON Orders.TableNo = Bookings.TableNo



-- SELECT *
-- FROM menus
--   JOIN menuitems ON menuitems.ItemID = menus.ItemID

-- SELECT * 
-- FROM Orders 
--   JOIN Menus ON Orders.MenuID = menus.MenuID
--   JOIN menuitems ON menuitems.ItemID = menus.ItemID
--   JOIN Bookings ON Orders.TableNo = Bookings.TableNo

-- SELECT Orders.OrderID, Orders.Quantity, Orders.BillAmount, menuitems.Price
-- FROM Orders 
--   JOIN Menus ON Orders.MenuID = menus.MenuID
--   JOIN menuitems ON menuitems.ItemID = menus.ItemID
--   JOIN Bookings ON Orders.TableNo = Bookings.TableNo


CREATE VIEW OrdersView AS 
SELECT DISTINCT Orders.OrderID, Orders.Quantity, Orders.BillAmount
  FROM Orders 
  JOIN Menus ON Orders.MenuID = menus.MenuID
  JOIN menuitems ON menuitems.ItemID = menus.ItemID
  JOIN Bookings ON Orders.TableNo = Bookings.TableNo
  WHERE 
    Orders.Quantity > 2
