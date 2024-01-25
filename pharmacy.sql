-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 22, 2024 at 06:00 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pharmacy`
--

-- --------------------------------------------------------

--
-- Table structure for table `capital`
--

CREATE TABLE `capital` (
  `CAPITAL_ID` int(11) NOT NULL,
  `CAPITAL_AMOUNT` double NOT NULL,
  `DATE` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `capital`
--

INSERT INTO `capital` (`CAPITAL_ID`, `CAPITAL_AMOUNT`, `DATE`) VALUES
(1, 3799.25, '2024-01-01'),
(2, 10500, '2024-02-01'),
(3, 10100, '2024-05-04'),
(4, 12000, '2024-06-05');

-- --------------------------------------------------------

--
-- Stand-in structure for view `current_capital_view`
-- (See below for the actual view)
--
CREATE TABLE `current_capital_view` (
`CAPITAL_ID` int(11)
,`CAPITAL_AMOUNT` double
,`CAPITAL_DATE` date
);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `CUSTOMER_ID` int(11) NOT NULL,
  `FIRST_NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `LAST_NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `DOB` date NOT NULL,
  `URNC` bigint(13) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`CUSTOMER_ID`, `FIRST_NAME`, `LAST_NAME`, `DOB`, `URNC`) VALUES
(1, 'Ana', 'Ivanović', '1990-05-15', 703966112461),
(2, 'Marko', 'Jovanović', '1985-08-22', 220885117384),
(3, 'Jovana', 'Nikolić', '1978-12-03', 312782119873),
(4, 'Nenad', 'Petrović', '1995-04-28', 280495911377),
(5, 'Milica', 'Stojanović', '1982-07-17', 170782211721),
(6, 'Stefan', 'Đorđević', '1998-11-10', 101198811596),
(7, 'Ivana', 'Kovačević', '1973-02-25', 250273811825),
(8, 'Nikola', 'Simić', '1991-06-30', 300691117384),
(9, 'Teodora', 'Milić', '1987-09-14', 140987711674),
(10, 'Luka', 'Vasić', '1996-03-07', 703966112411);

--
-- Triggers `customers`
--
DELIMITER $$
CREATE TRIGGER `before_insert_checkURNC_customers` BEFORE INSERT ON `customers` FOR EACH ROW BEGIN
    IF LENGTH(NEW.URNC) <> 12 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'URNC MUST INCLUDE 13 NUMBERS';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `drugs`
--

CREATE TABLE `drugs` (
  `DRUG_ID` int(11) NOT NULL,
  `NAME` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `TYPE` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `DOSE` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `SELLING_PRICE` double UNSIGNED NOT NULL,
  `EXPIRATION_DATE` date NOT NULL,
  `QUANTITY` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `drugs`
--

INSERT INTO `drugs` (`DRUG_ID`, `NAME`, `TYPE`, `DOSE`, `SELLING_PRICE`, `EXPIRATION_DATE`, `QUANTITY`) VALUES
(1, 'Aspirin', 'Painkiller', '100mg', 220.3, '2024-12-31', 149),
(2, 'Amoxicillin', 'Antibiotic', '500mg', 80.4, '2024-08-15', 17),
(3, 'Ibuprofen', 'Anti-Inflammatory', '200mg', 1550, '2023-11-30', 35),
(4, 'Simvastatin', 'Cholesterol Medicati', '20mg', 150.75, '2024-05-20', 248),
(5, 'Lisinopril', 'Blood Pressure Medic', '10mg', 94.8, '2024-09-10', 156),
(6, 'Metformin', 'Diabetes Medication', '500mg', 110.3, '2023-06-25', 80),
(7, 'Omeprazole', 'Acid Reducer', '20mg', 82.45, '2024-04-15', 14),
(8, 'Hydrochlorothiazide', 'Diuretic', '25mg', 100.6, '2024-10-05', 111),
(9, 'Atorvastatin', 'Cholesterol Medicati', '40mg', 190.2, '2024-02-28', 98),
(10, 'Prednisone', 'Corticosteroid', '5mg', 366.75, '2024-07-12', 64);

-- --------------------------------------------------------

--
-- Table structure for table `financial_transactions`
--

CREATE TABLE `financial_transactions` (
  `TRANSACTION_ID` int(11) NOT NULL,
  `TRANSACTION_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `TYPE` enum('PROFIT','EXPENSE') NOT NULL,
  `AMOUNT` decimal(10,2) NOT NULL,
  `CAPITAL_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `financial_transactions`
--

INSERT INTO `financial_transactions` (`TRANSACTION_ID`, `TRANSACTION_DATE`, `TYPE`, `AMOUNT`, `CAPITAL_ID`) VALUES
(1, '2024-01-22 15:39:17', 'EXPENSE', 375.00, 1),
(2, '2024-01-22 15:39:17', 'EXPENSE', 203.00, 1),
(3, '2024-01-22 15:39:17', 'EXPENSE', 1470.00, 1),
(4, '2024-01-22 15:39:17', 'EXPENSE', 108.00, 1),
(5, '2024-01-22 15:39:17', 'EXPENSE', 1500.00, 1),
(6, '2024-01-22 15:39:17', 'EXPENSE', 205.00, 1),
(7, '2024-01-22 15:39:17', 'EXPENSE', 3100.00, 1),
(8, '2024-01-22 15:39:17', 'EXPENSE', 552.00, 1),
(9, '2024-01-22 15:39:17', 'EXPENSE', 1104.00, 1),
(10, '2024-01-22 15:39:17', 'EXPENSE', 412.50, 1),
(15, '2024-01-22 15:47:06', 'PROFIT', 241.20, 1),
(16, '2024-01-22 15:47:06', 'PROFIT', 189.60, 1),
(17, '2024-01-22 15:47:06', 'PROFIT', 402.40, 1),
(18, '2024-01-22 15:47:06', 'PROFIT', 220.30, 1),
(19, '2024-01-22 15:47:06', 'PROFIT', 474.00, 1),
(20, '2024-01-22 15:47:06', 'PROFIT', 380.40, 1),
(21, '2024-01-22 15:47:06', 'PROFIT', 474.00, 1),
(22, '2024-01-22 15:47:06', 'PROFIT', 82.45, 1),
(23, '2024-01-22 15:47:06', 'PROFIT', 301.50, 1),
(24, '2024-01-22 15:47:06', 'PROFIT', 1467.00, 1),
(25, '2024-01-22 15:51:32', 'PROFIT', 1467.00, 1),
(26, '2024-01-22 15:54:07', 'PROFIT', 1833.75, 1),
(27, '2024-01-22 15:58:20', 'PROFIT', 2200.50, 1),
(28, '2024-01-22 16:04:15', 'PROFIT', 2567.25, 1),
(29, '2024-01-22 16:05:02', 'PROFIT', 2567.25, 1),
(30, '2024-01-22 16:05:02', 'PROFIT', 2567.25, 1),
(31, '2024-01-22 16:06:21', 'EXPENSE', 337.50, 1);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_history`
--

CREATE TABLE `purchase_history` (
  `PURCHASE_ID` int(11) UNSIGNED NOT NULL,
  `CUSTOMER_ID` int(11) NOT NULL,
  `DRUG_ID` int(11) NOT NULL,
  `PURCHASE_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `QUANTITY_SOLD` int(11) NOT NULL,
  `TOTAL_BILL` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_history`
--

INSERT INTO `purchase_history` (`PURCHASE_ID`, `CUSTOMER_ID`, `DRUG_ID`, `PURCHASE_DATE`, `QUANTITY_SOLD`, `TOTAL_BILL`) VALUES
(11, 1, 2, '2024-01-22 15:47:06', 3, 241.20),
(12, 3, 5, '2024-01-22 15:47:06', 2, 189.60),
(13, 7, 8, '2024-01-22 15:47:06', 4, 402.40),
(14, 4, 1, '2024-01-22 15:47:06', 1, 220.30),
(15, 10, 5, '2024-01-22 15:47:06', 5, 474.00),
(16, 2, 9, '2024-01-22 15:47:06', 2, 380.40),
(17, 5, 5, '2024-01-22 15:47:06', 5, 474.00),
(18, 9, 7, '2024-01-22 15:47:06', 1, 82.45),
(19, 8, 4, '2024-01-22 15:47:06', 2, 301.50),
(20, 6, 10, '2024-01-22 15:47:06', 4, 1467.00),
(21, 6, 10, '2024-01-22 15:47:06', 5, 1833.75),
(22, 6, 10, '2024-01-22 15:47:06', 6, 2200.50),
(23, 6, 10, '2024-01-22 15:47:06', 7, 2567.25),
(24, 6, 10, '2024-01-22 15:47:06', 7, 2567.25),
(25, 6, 10, '2024-01-22 15:47:06', 7, 2567.25);

--
-- Triggers `purchase_history`
--
DELIMITER $$
CREATE TRIGGER `after_purchase_history_delete_quantity_update` AFTER DELETE ON `purchase_history` FOR EACH ROW BEGIN
    -- Povećanje količine u tablici `drugs` za odgovarajuću količinu
    UPDATE `pharmacy`.`drugs`
    SET `QUANTITY` = COALESCE(`QUANTITY`, 0) + OLD.`QUANTITY_SOLD`
    WHERE `DRUG_ID` = OLD.`DRUG_ID`;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_purchase_history_insertC2` AFTER INSERT ON `purchase_history` FOR EACH ROW BEGIN
    DECLARE capital_id_val INT;

    SET capital_id_val = (SELECT `capital_id` FROM `pharmacy`.`capital` WHERE `date` = DATE_FORMAT(NOW(), '%Y-%m-01'));

    -- Update Capital
    UPDATE `pharmacy`.`capital`
    SET `capital_amount` = `capital_amount` + NEW.TOTAL_BILL
    WHERE `capital_id` = capital_id_val;

    -- Insert Financial Transaction
    INSERT INTO `pharmacy`.`financial_transactions` (`TRANSACTION_DATE`, `TYPE`, `AMOUNT`, `capital_id`)
    VALUES (NOW(), 'PROFIT', NEW.TOTAL_BILL, capital_id_val);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_purchase_history_insert_quantity_update` AFTER INSERT ON `purchase_history` FOR EACH ROW BEGIN
    -- Smanjivanje količine u tablici `drugs` za odgovarajuću količinu
    UPDATE `pharmacy`.`drugs`
    SET `QUANTITY` = COALESCE(`QUANTITY`, 0) - NEW.`QUANTITY_SOLD`
    WHERE `DRUG_ID` = NEW.`DRUG_ID`;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_purchase_history_updateCapital` AFTER INSERT ON `purchase_history` FOR EACH ROW BEGIN
    -- Update capital_amount in the capital table
    UPDATE `pharmacy`.`capital`
    SET `capital_amount` = `capital_amount` - NEW.TOTAL_BILL
    WHERE `capital_id` = (SELECT `capital_id` FROM `pharmacy`.`capital` WHERE `date` = DATE_FORMAT(NOW(), '%Y-%m-01'));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_purchase_history_insert_check_quantity_and_expiry` BEFORE INSERT ON `purchase_history` FOR EACH ROW BEGIN
    -- Provjera dostupnosti dovoljne količine
    DECLARE available_quantity INT;
    DECLARE expiry_date DATE;

    SELECT `QUANTITY`, `EXPIRATION_DATE`
    INTO available_quantity, expiry_date
    FROM `pharmacy`.`drugs`
    WHERE `DRUG_ID` = NEW.`DRUG_ID`;

    IF available_quantity IS NULL OR available_quantity < NEW.`QUANTITY_SOLD` THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient quantity available for the selected drug.';
    END IF;

    -- Provjera datuma isteka
    IF expiry_date IS NOT NULL AND expiry_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Selected drug has expired.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_purchase_history_insert_total_bill` BEFORE INSERT ON `purchase_history` FOR EACH ROW BEGIN
    SET NEW.`TOTAL_BILL` = NEW.`QUANTITY_SOLD` * (SELECT `SELLING_PRICE` FROM `pharmacy`.`drugs` WHERE `DRUG_ID` = NEW.`DRUG_ID`);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `SUPPLIER_ID` int(11) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `EMAIL` varchar(255) NOT NULL,
  `PHONE` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`SUPPLIER_ID`, `NAME`, `EMAIL`, `PHONE`) VALUES
(1, 'PharmaSupplier1', 'supplier1@example.com', '123-456-789'),
(2, 'MediCo', 'medico@gmail.com', '987-654-321'),
(3, 'HealthPro', 'healthpro@company.com', '555-123-456'),
(4, 'PharmaNet', 'pharmanet@example.net', '777-888-999'),
(5, 'MedicineHub', 'medicinehub@mail.com', '111-222-333'),
(6, 'PharmaLink', 'pharmalink@pharmacylink.com', '333-444-555'),
(7, 'GlobalMeds', 'globalmeds@global.com', '666-777-888'),
(8, 'MedSupply', 'medsupply@supplyco.net', '999-000-111'),
(9, 'DrugWorld', 'drugworld@world.com', '444-555-666');

-- --------------------------------------------------------

--
-- Table structure for table `supplier_purchases`
--

CREATE TABLE `supplier_purchases` (
  `SUPPLIER_PURCHASE_ID` int(11) NOT NULL,
  `SUPPLIER_ID` int(11) NOT NULL,
  `DRUG_ID` int(11) NOT NULL,
  `PURCHASE_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `QUANTITY_BROUGHT` int(11) NOT NULL,
  `COST_PRICE` decimal(10,2) NOT NULL,
  `TOTAL_COST` decimal(10,2) GENERATED ALWAYS AS (`QUANTITY_BROUGHT` * `COST_PRICE`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `supplier_purchases`
--

INSERT INTO `supplier_purchases` (`SUPPLIER_PURCHASE_ID`, `SUPPLIER_ID`, `DRUG_ID`, `PURCHASE_DATE`, `QUANTITY_BROUGHT`, `COST_PRICE`) VALUES
(1, 2, 1, '2024-01-22 15:39:17', 150, 2.50),
(2, 4, 3, '2024-01-22 15:39:17', 35, 5.80),
(3, 1, 5, '2024-01-22 15:39:17', 168, 8.75),
(4, 3, 7, '2024-01-22 15:39:17', 15, 7.20),
(5, 5, 9, '2024-01-22 15:39:17', 100, 15.00),
(6, 2, 2, '2024-01-22 15:39:17', 20, 10.25),
(7, 1, 4, '2024-01-22 15:39:17', 250, 12.40),
(8, 3, 6, '2024-01-22 15:39:17', 80, 6.90),
(9, 5, 8, '2024-01-22 15:39:17', 115, 9.60),
(10, 4, 10, '2024-01-22 15:39:17', 55, 7.50),
(11, 4, 10, '2024-01-22 15:39:17', 45, 7.50);

--
-- Triggers `supplier_purchases`
--
DELIMITER $$
CREATE TRIGGER `after_supplier_purchase_addDrug` AFTER INSERT ON `supplier_purchases` FOR EACH ROW BEGIN
  UPDATE `pharmacy`.`drugs`
  SET `QUANTITY` = IFNULL(`QUANTITY`, 0) + NEW.`QUANTITY_BROUGHT`
  WHERE `DRUG_ID` = NEW.`DRUG_ID`;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_supplier_purchases_insert_Expense` AFTER INSERT ON `supplier_purchases` FOR EACH ROW BEGIN
    INSERT INTO `pharmacy`.`financial_transactions` (`TRANSACTION_DATE`, `TYPE`, `AMOUNT`, `capital_id`)
    VALUES (NOW(), 'EXPENSE', NEW.TOTAL_COST, (SELECT `capital_id` FROM `pharmacy`.`capital` WHERE `date` = DATE_FORMAT(NOW(), '%Y-%m-01')));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_supplier_purchases_updateCapital` AFTER INSERT ON `supplier_purchases` FOR EACH ROW BEGIN
    -- Update capital_amount in the capital table
    UPDATE `pharmacy`.`capital`
    SET `capital_amount` = `capital_amount` - NEW.TOTAL_COST
    WHERE `capital_id` = (SELECT `capital_id` FROM `pharmacy`.`capital` WHERE `date` = DATE_FORMAT(NOW(), '%Y-%m-01'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `USER_ID` int(11) UNSIGNED NOT NULL,
  `NAME` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `DOB` date NOT NULL,
  `PASSWORD` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `TYPE` enum('Admin','Employee') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`USER_ID`, `NAME`, `DOB`, `PASSWORD`, `TYPE`) VALUES
(1, 'admin', '2002-01-24', 'admin', 'Admin'),
(2, 'ahmed', '2024-01-02', 'ahmed', 'Employee'),
(3, 'hatab', '1976-02-01', 'hatab1', 'Employee'),
(4, 'omer', '1997-04-02', 'omer123', 'Employee');

-- --------------------------------------------------------

--
-- Structure for view `current_capital_view`
--
DROP TABLE IF EXISTS `current_capital_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `current_capital_view`  AS SELECT `c`.`CAPITAL_ID` AS `CAPITAL_ID`, `c`.`CAPITAL_AMOUNT` AS `CAPITAL_AMOUNT`, `c`.`DATE` AS `CAPITAL_DATE` FROM `capital` AS `c` WHERE `c`.`DATE` = (select max(`capital`.`DATE`) from `capital` where `capital`.`DATE` <= curdate()) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `capital`
--
ALTER TABLE `capital`
  ADD PRIMARY KEY (`CAPITAL_ID`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`CUSTOMER_ID`),
  ADD UNIQUE KEY `URNC` (`URNC`);

--
-- Indexes for table `drugs`
--
ALTER TABLE `drugs`
  ADD PRIMARY KEY (`DRUG_ID`);

--
-- Indexes for table `financial_transactions`
--
ALTER TABLE `financial_transactions`
  ADD PRIMARY KEY (`TRANSACTION_ID`),
  ADD KEY `fk_capital_id_capital_idx` (`CAPITAL_ID`);

--
-- Indexes for table `purchase_history`
--
ALTER TABLE `purchase_history`
  ADD PRIMARY KEY (`PURCHASE_ID`),
  ADD KEY `fk_drugs_purchase_history_idx` (`DRUG_ID`),
  ADD KEY `fk_customers_purchase_history_idx` (`CUSTOMER_ID`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`SUPPLIER_ID`);

--
-- Indexes for table `supplier_purchases`
--
ALTER TABLE `supplier_purchases`
  ADD PRIMARY KEY (`SUPPLIER_PURCHASE_ID`),
  ADD KEY `fk_drugs_supplier_purchases_idx` (`DRUG_ID`),
  ADD KEY `fk_suppliers_supplier_purchases_idx` (`SUPPLIER_ID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`USER_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `capital`
--
ALTER TABLE `capital`
  MODIFY `CAPITAL_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `CUSTOMER_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `drugs`
--
ALTER TABLE `drugs`
  MODIFY `DRUG_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `financial_transactions`
--
ALTER TABLE `financial_transactions`
  MODIFY `TRANSACTION_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `purchase_history`
--
ALTER TABLE `purchase_history`
  MODIFY `PURCHASE_ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `SUPPLIER_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `supplier_purchases`
--
ALTER TABLE `supplier_purchases`
  MODIFY `SUPPLIER_PURCHASE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `USER_ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `financial_transactions`
--
ALTER TABLE `financial_transactions`
  ADD CONSTRAINT `fk_capital_id_capital` FOREIGN KEY (`CAPITAL_ID`) REFERENCES `capital` (`CAPITAL_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `purchase_history`
--
ALTER TABLE `purchase_history`
  ADD CONSTRAINT `fk_customers_purchase_history` FOREIGN KEY (`CUSTOMER_ID`) REFERENCES `customers` (`CUSTOMER_ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_drugs_purchases` FOREIGN KEY (`DRUG_ID`) REFERENCES `drugs` (`DRUG_ID`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `supplier_purchases`
--
ALTER TABLE `supplier_purchases`
  ADD CONSTRAINT `fk_drugs_supplier_purchases` FOREIGN KEY (`DRUG_ID`) REFERENCES `drugs` (`DRUG_ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_suppliers_supplier_purchases` FOREIGN KEY (`SUPPLIER_ID`) REFERENCES `suppliers` (`SUPPLIER_ID`) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
