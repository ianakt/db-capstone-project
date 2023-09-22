
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

-- A itemfreq is a view of menu items, and how often they appear from most frequent to least frequent
-- The deliverable for task 3 is on lines 37 through 40

CREATE VIEW itemfreq AS
Select menuitems.Name, Count(*) as frequency
  FROM Orders 
  JOIN Menus ON Orders.MenuID = menus.MenuID
  JOIN menuitems ON menuitems.ItemID = menus.ItemID
GROUP BY menuitems.Name
ORDER BY Count(*) DESC;

-- TASK 3 week 3 deliverable
Select Name 
FROM itemfreq 
WHERE frequency > 2;



-- GROUP BY menuitems.Name
-- ORDER BY Count(*) DESC
-- WHERE Count(*) > 2
