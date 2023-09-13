-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema little_lemon_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema little_lemon_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `little_lemon_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `little_lemon_db` ;

-- -----------------------------------------------------
-- Table `little_lemon_db`.`bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`bookings` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `TableNo` INT NULL DEFAULT NULL,
  `GuestFirstName` VARCHAR(100) NOT NULL,
  `GuestLastName` VARCHAR(100) NOT NULL,
  `BookingSlot` TIME NOT NULL,
  `EmployeeID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`BookingID`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`employees` (
  `EmployeeID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(244) NULL DEFAULT NULL,
  `Role` VARCHAR(244) NULL DEFAULT NULL,
  `Address` VARCHAR(244) NULL DEFAULT NULL,
  `Contact_Number` INT NULL DEFAULT NULL,
  `Email` VARCHAR(244) NULL DEFAULT NULL,
  `Annual_Salary` VARCHAR(244) NULL DEFAULT NULL,
  `bookings_BookingID` INT NOT NULL,
  PRIMARY KEY (`EmployeeID`, `bookings_BookingID`),
  INDEX `fk_employees_bookings1_idx` (`bookings_BookingID` ASC) VISIBLE,
  CONSTRAINT `fk_employees_bookings1`
    FOREIGN KEY (`bookings_BookingID`)
    REFERENCES `little_lemon_db`.`bookings` (`BookingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`orders` (
  `OrderID` INT NOT NULL,
  `TableNo` INT NOT NULL,
  `MenuID` INT NULL DEFAULT NULL,
  `BookingID` INT NULL DEFAULT NULL,
  `BillAmount` INT NULL DEFAULT NULL,
  `Quantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`OrderID`, `TableNo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`menus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`menus` (
  `MenuID` INT NOT NULL,
  `ItemID` INT NOT NULL,
  `Cuisine` VARCHAR(100) NULL DEFAULT NULL,
  `orders_OrderID` INT NOT NULL,
  `orders_TableNo` INT NOT NULL,
  PRIMARY KEY (`MenuID`, `ItemID`),
  INDEX `fk_menus_orders1_idx` (`orders_OrderID` ASC, `orders_TableNo` ASC) VISIBLE,
  CONSTRAINT `fk_menus_orders1`
    FOREIGN KEY (`orders_OrderID` , `orders_TableNo`)
    REFERENCES `little_lemon_db`.`orders` (`OrderID` , `TableNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`menuitems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`menuitems` (
  `ItemID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(200) NULL DEFAULT NULL,
  `Type` VARCHAR(100) NULL DEFAULT NULL,
  `Price` INT NULL DEFAULT NULL,
  `menus_MenuID` INT NOT NULL,
  `menus_ItemID` INT NOT NULL,
  PRIMARY KEY (`ItemID`),
  INDEX `fk_menuitems_menus_idx` (`menus_MenuID` ASC, `menus_ItemID` ASC) VISIBLE,
  CONSTRAINT `fk_menuitems_menus`
    FOREIGN KEY (`menus_MenuID` , `menus_ItemID`)
    REFERENCES `little_lemon_db`.`menus` (`MenuID` , `ItemID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 18
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`bookings_has_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`bookings_has_orders` (
  `bookings_BookingID` INT NOT NULL,
  `orders_OrderID` INT NOT NULL,
  `orders_TableNo` INT NOT NULL,
  PRIMARY KEY (`bookings_BookingID`, `orders_OrderID`, `orders_TableNo`),
  INDEX `fk_bookings_has_orders_orders1_idx` (`orders_OrderID` ASC, `orders_TableNo` ASC) VISIBLE,
  INDEX `fk_bookings_has_orders_bookings1_idx` (`bookings_BookingID` ASC) VISIBLE,
  CONSTRAINT `fk_bookings_has_orders_bookings1`
    FOREIGN KEY (`bookings_BookingID`)
    REFERENCES `little_lemon_db`.`bookings` (`BookingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_bookings_has_orders_orders1`
    FOREIGN KEY (`orders_OrderID` , `orders_TableNo`)
    REFERENCES `little_lemon_db`.`orders` (`OrderID` , `TableNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `little_lemon_db` ;

-- -----------------------------------------------------
-- procedure BasicSalesReport
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `BasicSalesReport`()
BEGIN
    SELECT sum(BillAmount) as "Total Sales",
    avg(BillAmount) as "Average Sales",
    min(BillAmount) as "Minimum bill paid",
    max(BillAmount) as "Maximum bill paid"
    FROM Orders;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GuestStatus
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GuestStatus`()
BEGIN

SELECT 
    CONCAT(GuestFirstName, GuestLastName) AS "Guest Fullname",
    (CASE 
        WHEN Employees.Role = "Manager" OR Employees.Role = "Assistant Manager"
            THEN "Ready to pay"
        WHEN Employees.Role = "Head Chef"
            THEN "Ready to serve"
        WHEN Employees.Role = "Assistant Chef"
            THEN "Preparing Order"
        WHEN Employees.Role = "Head Waiter"
            THEN "Order served"
    END) AS "Order Status"

FROM Employees LEFT JOIN Bookings ON Employees.EmployeeID = Bookings.EmployeeID;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PeakHours
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PeakHours`()
BEGIN

SELECT 
    HOUR(BookingSlot),
    COUNT(BookingID)

FROM Bookings
GROUP BY HOUR(BookingSlot)
ORDER BY COUNT(BookingID) DESC;

END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
