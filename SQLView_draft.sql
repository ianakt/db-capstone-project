
--Task 1 week 2 Created Orders view
--CREATE VIEW OrdersView AS select OrderID, BillAmount, Quantity FROM Orders;

-- Orders, Bill Amount and Quantity, where quantity is more than 2
-- Please not that this returns an empty set 
-- because no quantity was greater than 2 with the data I have

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


-- Task 3 Week 2

-- The deliverable for task 3 is on lines 37 through 40, I didn't use a subquery, I selected from a view

-- A itemfreq is a view of menu items, and how often they appear from most frequent to least frequent
CREATE VIEW itemfreq AS
Select menuitems.Name, Count(*) as frequency
  FROM Orders 
  JOIN Menus ON Orders.MenuID = menus.MenuID
  JOIN menuitems ON menuitems.ItemID = menus.ItemID
GROUP BY menuitems.Name
ORDER BY Count(*) DESC;

-- TASK 3 week 2 deliverable
Select Name 
FROM itemfreq 
WHERE frequency > 2;

-- Max Quantity from Orders
CREATE PROCEDURE GetMaxQuantity()
SELECT Max(Quantity) AS "Max Quantity in Order" FROM Orders;

CALL GetMaxQuantity()


-- prepared statement for getting order detail
PREPARE GetOrderDetail FROM
'SELECT DISTINCT Orders.OrderID, Orders.BillAmount, Orders.Quantity
  FROM Orders 
  JOIN Menus ON Orders.MenuID = menus.MenuID
  JOIN menuitems ON menuitems.ItemID = menus.ItemID
  JOIN Bookings ON Orders.TableNo = Bookings.TableNo
  JOIN employees on employees.EmployeeID = Bookings.EmployeeID
WHERE employees.EmployeeID = ?';

SET @id = 1;
EXECUTE GetOrderDetail USING @id;



-- Cancel Order Procedure
DELIMITER //
CREATE PROCEDURE CancelOrder(IN OrderID INT)
BEGIN
DELETE FROM Orders WHERE OrderID = OrderID;
SELECT CONCAT("Order ", OrderID, " is cancelled") AS Confirmation;
END //
DELIMITER ;

-- BookingID, BookingDate, TableNumber ,CustomerID
-- 1, 2022-10-10, 5, 1
-- 2, 2022-11-12, 3, 3
-- 3, 2022-10-11, 2, 2
-- 4, 2022-10-13, 2 ,1

-- How to do Case When?
-- Shall we try other flow control functions IF()
-- https://dev.mysql.com/doc/refman/8.0/en/flow-control-functions.html


-- CheckBooking procedure
CREATE PROCEDURE CheckBooking(IN BookingTime TIME,IN TableNumber INT)
          SELECT 
          IF(count(*) > 0, CONCAT("Table ", TableNumber, " is already booked."), CONCAT("Table ", TableNumber, " is available")) AS "Booking Status"
          FROM Bookings 
          WHERE BookingSlot = BookingTime AND 
          TableNo = TableNumber;



-- AddValidBooking