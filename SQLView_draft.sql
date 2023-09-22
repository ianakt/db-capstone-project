
--Task 1 week 2 Created Orders view
--CREATE VIEW OrdersView AS select OrderID, BillAmount, Quantity FROM Orders;


CREATE VIEW OrdersView AS 
SELECT DISTINCT Orders.OrderID, Orders.Quantity, Orders.BillAmount
  FROM Orders 
  JOIN Menus ON Orders.MenuID = menus.MenuID
  JOIN menuitems ON menuitems.ItemID = menus.ItemID
  JOIN Bookings ON Orders.TableNo = Bookings.TableNo
  WHERE 
    Orders.Quantity > 2

-- Task 2 Week 2  
SELECT DISTINCT Orders.OrderID, Orders.BillAmount, employees.Name, employees.EmployeeID, menus.Cuisine, menuitems.Name
  FROM Orders 
  JOIN Menus ON Orders.MenuID = menus.MenuID
  JOIN menuitems ON menuitems.ItemID = menus.ItemID
  JOIN Bookings ON Orders.TableNo = Bookings.TableNo
  JOIN employees on employees.EmployeeID = Bookings.EmployeeID


-- Task 3 Week 3
Select * 
  FROM Orders 
  JOIN Menus ON Orders.MenuID = menus.MenuID
  JOIN menuitems ON menuitems.ItemID = menus.ItemID
