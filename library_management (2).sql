-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 02, 2023 at 06:40 PM
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
-- Database: `library management`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ListBooksByCategory` (IN `category` VARCHAR(255))   BEGIN
    SELECT b.Category, b.BDescription, ba.Author
    FROM books b
    JOIN books_author ba ON b.Document_ID = ba.Document_ID
    WHERE b.Category = category
    ORDER BY ba.Author;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListMemberLoans` (IN `memberId` INT, IN `dueDate` DATE)   BEGIN
    SELECT l.Loan_ID, l.Start_date, l.Due_Date, l.Total_Rent
    FROM loans l
    JOIN members m ON l.Member_ID = m.Member_ID
    WHERE m.Member_ID = memberId AND l.Due_Date <= dueDate
    ORDER BY l.Total_Rent DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalRentByMember` (IN `minTotalRent` DECIMAL(10,2))   BEGIN
    SELECT m.Member_ID, CONCAT(m.First_Name, ' ', m.Last_Name) AS FullName, SUM(l.Total_Rent) AS TotalRent
    FROM members m
    JOIN loans l ON m.Member_ID = l.Member_ID
    GROUP BY m.Member_ID
    HAVING SUM(l.Total_Rent) > minTotalRent
    ORDER BY TotalRent DESC;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `AverageRating` (`documentId` INT) RETURNS DECIMAL(10,2)  BEGIN
    DECLARE avgRating DECIMAL(10,2);

    SELECT AVG(Rating) INTO avgRating
    FROM review_comments
    WHERE Document_ID = documentId;
    
    IF avgRating IS NULL THEN
        RETURN 0;
    ELSE
        RETURN avgRating;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `CalculateFine` (`daysLate` INT, `dailyFine` DECIMAL(10,2)) RETURNS DECIMAL(10,2)  BEGIN
    DECLARE totalFine DECIMAL(10,2);
    
    IF daysLate > 0 THEN
        SET totalFine = daysLate * dailyFine;
    ELSE
        SET totalFine = 0;
    END IF;

    RETURN totalFine;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `CheckBorrowLimit` (`memberId` INT, `limitCount` INT) RETURNS TINYINT(1)  BEGIN
    DECLARE borrowCount INT;
    SELECT COUNT(*) INTO borrowCount
    FROM loans
    WHERE Member_ID = memberId;
    
    IF borrowCount > limitCount THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `Category` varchar(255) DEFAULT NULL,
  `BDescription` varchar(255) DEFAULT NULL,
  `Document_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`Category`, `BDescription`, `Document_ID`) VALUES
('Classic Fiction', 'A classic novel set in the American South.', 11),
('Dystopian Fiction', 'A dystopian novel depicting a totalitarian regime.', 12),
('American Classic', 'A story of love and loss during the Roaring Twenties.', 13),
('Magical Realism', 'A multi-generational family saga in Macondo.', 14),
('Romance', 'A novel of manners in early 19th-century England.', 15),
('Historical Fiction', 'An epic tale set during the Napoleonic Wars.', 16),
('Coming-of-Age Fiction', 'A story about adolescent angst and alienation.', 17),
('Fantasy', 'A fantasy novel about a hobbit on a quest.', 18),
('Psychological Fiction', 'A novel exploring themes of guilt and redemption.', 19),
('Adventure Fiction', 'A whaling voyage and the obsession with a whale.', 20);

-- --------------------------------------------------------

--
-- Table structure for table `books_author`
--

CREATE TABLE `books_author` (
  `Author` varchar(20) NOT NULL,
  `Document_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books_author`
--

INSERT INTO `books_author` (`Author`, `Document_ID`) VALUES
('F. Scott Fitzgerald', 13),
('Fyodor Dostoevsky', 19),
('Gabriel Garcia Marqu', 14),
('George Orwell', 12),
('Harper Lee', 11),
('Herman Melville', 20),
('J.D. Salinger', 17),
('J.R.R. Tolkien', 18),
('Jane Austen', 15),
('Leo Tolstoy', 16);

-- --------------------------------------------------------

--
-- Table structure for table `book_copies`
--

CREATE TABLE `book_copies` (
  `Due_Date` date NOT NULL,
  `BStatus` varchar(50) DEFAULT NULL,
  `Copy_ID` int(11) NOT NULL,
  `Num` int(11) NOT NULL,
  `Inventory_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `book_copies`
--

INSERT INTO `book_copies` (`Due_Date`, `BStatus`, `Copy_ID`, `Num`, `Inventory_ID`) VALUES
('2023-12-31', 'Available', 1, 12, 1),
('2023-12-31', 'Checked Out', 2, 8, 2),
('2023-12-31', 'Available', 3, 3, 3),
('2023-12-31', 'Under Repair', 4, 7, 4),
('2023-12-31', 'Lost', 5, 14, 5),
('2023-12-31', 'Available', 6, 1, 6),
('2023-12-31', 'Checked Out', 7, 1, 7),
('2023-12-31', 'Available', 8, 1, 8),
('2023-12-31', 'Under Repair', 9, 3, 9),
('2023-12-31', 'Lost', 10, 3, 10),
('2023-12-31', 'Available', 11, 8, 11),
('2023-12-31', 'Checked Out', 12, 8, 12),
('2023-12-31', 'Available', 13, 14, 13),
('2023-12-31', 'Under Repair', 14, 12, 14),
('2023-12-31', 'Lost', 15, 14, 15),
('2023-12-31', 'Available', 16, 34, 16),
('2023-12-31', 'Checked Out', 17, 34, 1),
('2023-12-31', 'Available', 18, 7, 2),
('2023-12-31', 'Under Repair', 19, 3, 3),
('2023-12-31', 'Lost', 20, 7, 4);

--
-- Triggers `book_copies`
--
DELIMITER $$
CREATE TRIGGER `AfterNewBookCopyInsert` AFTER INSERT ON `book_copies` FOR EACH ROW BEGIN
    UPDATE inventory
    SET Quantity = Quantity + NEW.Num
    WHERE Inventory_ID = NEW.Inventory_ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `DName` varchar(255) NOT NULL,
  `Document_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `documents`
--

INSERT INTO `documents` (`DName`, `Document_ID`) VALUES
('American Journal of Sociology', 1),
('Nature - International Journal of Science', 2),
('The Lancet - Medical Journal', 3),
('Journal of Artificial Intelligence Research', 4),
('IEEE Transactions on Robotics', 5),
('Journal of Political Economy', 6),
('Astronomy and Astrophysics Review', 7),
('Annual Review of Psychology', 8),
('Journal of Financial Economics', 9),
('Cell - Molecular and Cellular Biology', 10),
('To Kill a Mockingbird by Harper Lee', 11),
('1984 by George Orwell', 12),
('The Great Gatsby by F. Scott Fitzgerald', 13),
('One Hundred Years of Solitude by Gabriel Garcia Marquez', 14),
('Pride and Prejudice by Jane Austen', 15),
('War and Peace by Leo Tolstoy', 16),
('The Catcher in the Rye by J.D. Salinger', 17),
('The Hobbit by J.R.R. Tolkien', 18),
('Crime and Punishment by Fyodor Dostoevsky', 19),
('Moby Dick by Herman Melville', 20);

-- --------------------------------------------------------

--
-- Table structure for table `documents_language`
--

CREATE TABLE `documents_language` (
  `dlanguage` varchar(255) NOT NULL,
  `Document_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `documents_language`
--

INSERT INTO `documents_language` (`dlanguage`, `Document_ID`) VALUES
('Chinese', 8),
('English', 1),
('English', 3),
('English', 5),
('English', 6),
('English', 7),
('English', 9),
('English', 12),
('English', 13),
('English', 14),
('English', 18),
('English', 20),
('French', 2),
('German', 11),
('Italian', 17),
('Japanese', 4),
('Korean', 15),
('Vietnamese', 10),
('Vietnamese', 16),
('Vietnamese', 19);

-- --------------------------------------------------------

--
-- Table structure for table `edition`
--

CREATE TABLE `edition` (
  `Num` int(11) NOT NULL,
  `eYear` year(4) NOT NULL,
  `Pages` int(11) NOT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  `Document_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `edition`
--

INSERT INTO `edition` (`Num`, `eYear`, `Pages`, `Price`, `Document_ID`) VALUES
(1, '1960', 324, 15.99, 11),
(3, '1951', 234, 12.99, 17),
(7, '1967', 417, 25.99, 14),
(7, '0000', 1225, 35.99, 16),
(8, '1937', 310, 22.99, 18),
(11, '1925', 208, 20.99, 13),
(12, '1949', 328, 19.99, 12),
(14, '0000', 671, 28.99, 19),
(24, '0000', 927, 30.99, 20),
(34, '0000', 279, 18.99, 15);

-- --------------------------------------------------------

--
-- Table structure for table `includeb`
--

CREATE TABLE `includeb` (
  `BStatus` char(255) DEFAULT NULL,
  `Loan_ID` int(11) NOT NULL,
  `Copy_ID` int(11) NOT NULL,
  `Num` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `includeb`
--

INSERT INTO `includeb` (`BStatus`, `Loan_ID`, `Copy_ID`, `Num`) VALUES
('Available', 1, 1, 12),
('Checked Out', 1, 2, 8),
('Available', 2, 3, 3),
('Under Repair', 2, 4, 7),
('Lost', 3, 5, 14),
('Available', 3, 6, 1),
('Checked Out', 4, 7, 1),
('Available', 4, 8, 1),
('Under Repair', 5, 9, 3),
('Lost', 5, 10, 3),
('Available', 6, 11, 8),
('Checked Out', 6, 12, 8),
('Available', 7, 13, 14),
('Under Repair', 7, 14, 12),
('Lost', 8, 15, 14),
('Available', 8, 16, 34),
('Checked Out', 9, 17, 34),
('Available', 9, 18, 7),
('Under Repair', 10, 19, 3),
('Lost', 10, 20, 7),
('Available', 11, 1, 12),
('Checked Out', 11, 2, 8),
('Checked Out', 12, 7, 1),
('Available', 12, 8, 1),
('Under Repair', 13, 9, 3),
('Lost', 13, 10, 3),
('Available', 14, 11, 8),
('Checked Out', 14, 12, 8),
('Available', 15, 13, 14),
('Under Repair', 15, 14, 12),
('Lost', 16, 15, 14),
('Available', 16, 16, 34),
('Checked Out', 17, 17, 34),
('Available', 17, 18, 7);

-- --------------------------------------------------------

--
-- Table structure for table `includev`
--

CREATE TABLE `includev` (
  `Quantity` int(11) DEFAULT NULL,
  `Loan_ID` int(11) NOT NULL,
  `VNo` int(11) NOT NULL,
  `Document_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `includev`
--

INSERT INTO `includev` (`Quantity`, `Loan_ID`, `VNo`, `Document_ID`) VALUES
(1, 18, 1, 1),
(2, 18, 2, 2),
(3, 19, 3, 3),
(1, 19, 4, 4),
(1, 20, 5, 5),
(2, 20, 6, 6),
(2, 21, 7, 7),
(1, 21, 8, 8),
(2, 22, 9, 9),
(1, 22, 10, 10),
(1, 23, 1, 1),
(1, 23, 2, 2),
(1, 24, 3, 3),
(1, 24, 4, 4),
(3, 25, 5, 5),
(3, 25, 6, 6),
(3, 26, 7, 7),
(2, 26, 8, 8),
(2, 27, 9, 9),
(2, 27, 10, 10),
(2, 28, 1, 1),
(1, 28, 2, 2),
(1, 29, 3, 3),
(2, 29, 4, 4);

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `Address` varchar(255) DEFAULT NULL,
  `Phone_Number` char(10) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `IName` varchar(20) NOT NULL,
  `Inventory_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`Address`, `Phone_Number`, `Email`, `IName`, `Inventory_ID`) VALUES
('102 Phạm Ngũ Lão, Q3, TPHCM', '0905136941', 'izumin@gmail.com', 'Elizabeth', 1),
('123 Maple St', '0123456789', 'maplestore@example.com', 'Maple Store', 2),
('456 Oak Ave', '0234567891', 'oaklibrary@example.net', 'Oak Library', 3),
('789 Pine Rd', '0345678912', 'pinebranch@example.org', 'Pine Branch', 4),
('321 Birch Ln', '0456789123', 'birchsupplies@example.com', 'Birch Supplies', 5),
('654 Palm Dr', '0567891234', 'palmservices@example.net', 'Palm Services', 6),
('987 Cedar Blvd', '0678912345', 'cedarproducts@example.org', 'Cedar Products', 7),
('159 Willow Way', '0789123456', 'willowgoods@example.com', 'Willow Goods', 8),
('753 Elm St', '0891234567', 'elmsolutions@example.net', 'Elm Solutions', 9),
('951 Spruce Path', '0912345678', 'sprucepartners@example.org', 'Spruce Partners', 10),
('357 Redwood Cir', '1023456789', 'redwoodfurnishings@example.com', 'Redwood Furnishings', 11),
('258 Sequoia Ct', '1134567890', 'sequoiadecor@example.net', 'Sequoia Decor', 12),
('654 Magnolia Ave', '1245678901', 'magnoliabooks@example.org', 'Magnolia Books', 13),
('321 Sycamore Ln', '1356789012', 'sycamoreelectronics@example.com', 'Sycamore Electronics', 14),
('456 Dogwood Dr', '1467890123', 'dogwoodapparel@example.net', 'Dogwood Apparel', 15),
('789 Fir Ct', '1578901234', 'firfurniture@example.org', 'Fir Furniture', 16);

-- --------------------------------------------------------

--
-- Table structure for table `journals`
--

CREATE TABLE `journals` (
  `Published_Place` varchar(255) NOT NULL,
  `First_Publish_Date` date NOT NULL,
  `Document_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `journals`
--

INSERT INTO `journals` (`Published_Place`, `First_Publish_Date`, `Document_ID`) VALUES
('International', '2021-01-01', 1),
('United Kingdom', '2021-02-01', 2),
('USA', '2021-03-01', 3),
('USA', '2021-04-01', 4),
('USA', '2021-05-01', 5),
('USA', '2021-06-01', 6),
('International', '2021-07-01', 7),
('USA', '2021-08-01', 8),
('USA', '2021-09-01', 9),
('International', '2021-10-01', 10);

-- --------------------------------------------------------

--
-- Table structure for table `loans`
--

CREATE TABLE `loans` (
  `Loan_ID` int(11) NOT NULL,
  `Total_Rent` decimal(10,2) DEFAULT NULL,
  `Due_Date` date DEFAULT NULL,
  `Return_Date` date DEFAULT NULL,
  `Start_date` date DEFAULT NULL CHECK (`Start_date` < `Return_Date`),
  `Member_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `loans`
--

INSERT INTO `loans` (`Loan_ID`, `Total_Rent`, `Due_Date`, `Return_Date`, `Start_date`, `Member_ID`) VALUES
(1, 10.00, '2023-12-31', '2024-01-10', '2023-11-30', 2123123),
(2, 12.00, '2023-12-31', '2024-01-10', '2023-11-30', 2123123),
(3, 10.00, '2023-12-31', '2024-01-10', '2023-11-30', 2131569),
(4, 12.00, '2023-12-31', '2024-01-10', '2023-11-30', 2131569),
(5, 10.50, '2023-12-15', '2023-12-14', '2023-12-01', 2152081),
(6, 8.75, '2023-12-17', '2023-12-16', '2023-12-03', 2152916),
(7, 15.20, '2023-12-19', '2023-12-18', '2023-12-05', 2153343),
(8, 12.00, '2023-12-21', '2023-12-20', '2023-12-07', 2153372),
(9, 9.99, '2023-12-23', '2023-12-22', '2023-12-09', 2319313),
(10, 7.50, '2023-12-25', '2023-12-24', '2023-12-11', 2323369),
(11, 10.25, '2023-12-27', '2023-12-26', '2023-12-13', 2152081),
(12, 6.80, '2023-12-29', '2023-12-28', '2023-12-15', 2152916),
(13, 11.00, '2023-12-31', '2023-12-30', '2023-12-17', 2153343),
(14, 8.50, '2024-01-02', '2024-01-01', '2023-12-19', 2153372),
(15, 10.50, '2023-12-15', '2023-12-14', '2023-12-01', 2323369),
(16, 8.75, '2023-12-17', '2023-12-16', '2023-12-03', 2819282),
(17, 15.20, '2023-12-19', '2023-12-18', '2023-12-05', 3921023),
(18, 12.00, '2023-12-21', '2023-12-20', '2023-12-07', 4123876),
(19, 9.99, '2023-12-23', '2023-12-22', '2023-12-09', 4212492),
(20, 7.50, '2023-12-25', '2023-12-24', '2023-12-11', 4896578),
(21, 10.25, '2023-12-27', '2023-12-26', '2023-12-13', 5693241),
(22, 6.80, '2023-12-29', '2023-12-28', '2023-12-15', 5698327),
(23, 11.00, '2023-12-31', '2023-12-30', '2023-12-17', 6513487),
(24, 8.50, '2024-01-02', '2024-01-01', '2023-12-19', 7120123),
(25, 9.25, '2024-01-04', '2024-01-03', '2023-12-21', 7381931),
(26, 7.80, '2024-01-06', '2024-01-05', '2023-12-23', 8271271),
(27, 12.50, '2024-01-08', '2024-01-07', '2023-12-25', 8271271),
(28, 11.99, '2024-01-10', '2024-01-09', '2023-12-27', 4212492),
(29, 8.00, '2024-01-12', '2024-01-11', '2023-12-29', 6513487);

--
-- Triggers `loans`
--
DELIMITER $$
CREATE TRIGGER `AfterLoanReturnUpdate` AFTER UPDATE ON `loans` FOR EACH ROW BEGIN
    IF OLD.Return_Date IS NULL AND NEW.Return_Date IS NOT NULL THEN
        UPDATE book_copies
        SET BStatus = 'Available'
        WHERE Copy_ID = (SELECT Copy_ID FROM includeb WHERE Loan_ID = NEW.Loan_ID LIMIT 1);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeforeLoanInsertOrUpdate` BEFORE INSERT ON `loans` FOR EACH ROW BEGIN
    IF NEW.Start_date > NEW.Due_Date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Start date cannot be after the due date.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `Member_ID` int(11) NOT NULL,
  `First_Name` varchar(20) NOT NULL,
  `Last_Name` varchar(20) NOT NULL,
  `Gender` char(1) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`Member_ID`, `First_Name`, `Last_Name`, `Gender`, `Email`) VALUES
(2123123, 'John', 'Doe', 'M', 'john.doe@gmail.com'),
(2131569, 'Jane', 'Smith', 'F', 'jane.smith@gmail.com'),
(2152081, 'Minh', 'Hoàng', 'M', 'maluoihoc@gmail.com'),
(2152916, 'Anh', 'Quân', 'M', 'honganhquan@hcmut.edu.vn'),
(2153343, 'Minh', 'Hiếu', 'M', 'hieu.nguyenminh@gmail.com'),
(2153372, 'Quang', 'Huy', 'M', 'bhqhuy1205@gmail.com'),
(2319313, 'Vinh', 'Hữu', 'M', 'vinh.tranhuu@hcmut.edu.vn'),
(2323369, 'Wayne', 'Rooney', 'M', NULL),
(2819282, 'Monkey D', 'Luffy', 'M', 'mugiwara29@yahoo.com'),
(3921023, 'Kim', 'Minji', 'F', 'kiminji@yahoo.com'),
(4123876, 'Taylor', 'Swift', 'F', NULL),
(4212492, 'San-hyeok', 'Lee', 'M', 'faker444@gmail.com'),
(4896578, 'Haibara', 'Ai', 'F', 'aihaibara281@gmail.com'),
(5693241, 'James', 'Reece', 'M', 'james241@gmail.com'),
(5698327, 'Selena', 'Gomez', 'F', NULL),
(6513487, 'Hà', 'Christine', 'F', NULL),
(7120123, 'Shinobu', 'Kocho', 'F', 'shinobukocho429@gmail.com'),
(7381931, 'Roronoa', 'Zoro', 'M', 'roronoazoro@gmail.com'),
(8271271, 'Torres', 'Fernando', 'M', 'torres1205@gmail.com'),
(9813721, 'Nhi', 'Nguyễn Phương', 'F', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `members_phone`
--

CREATE TABLE `members_phone` (
  `Phone` char(10) NOT NULL,
  `Member_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `members_phone`
--

INSERT INTO `members_phone` (`Phone`, `Member_ID`) VALUES
('0345621101', 2152916),
('0345678123', 2152916),
('0345678901', 2152916),
('0461190123', 2152081),
('0467552131', 2152081),
('0567883123', 2323369),
('0567893187', 4123876),
('0689012345', 2123123),
('0689015545', 3921023),
('0689044445', 5698327),
('0689125345', 7120123),
('0689211245', 3921023),
('0801234567', 2819282),
('0801277767', 2153372),
('0901212467', 2131569),
('0901234567', 2131569);

-- --------------------------------------------------------

--
-- Table structure for table `published_by`
--

CREATE TABLE `published_by` (
  `Document_ID` int(11) NOT NULL,
  `Publisher_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `published_by`
--

INSERT INTO `published_by` (`Document_ID`, `Publisher_ID`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- --------------------------------------------------------

--
-- Table structure for table `publishers`
--

CREATE TABLE `publishers` (
  `Publisher_ID` int(11) NOT NULL,
  `pname` varchar(20) DEFAULT NULL,
  `Year_of_Publication` year(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `publishers`
--

INSERT INTO `publishers` (`Publisher_ID`, `pname`, `Year_of_Publication`) VALUES
(1, 'Alpha Publishing', '2018'),
(2, 'Beta Books', '2019'),
(3, 'Gamma Media', '2020'),
(4, 'Delta Publications', '2021'),
(5, 'Epsilon Press', '2022'),
(6, 'Zeta Publishers', '2017'),
(7, 'Eta Press', '2018'),
(8, 'Theta Publications', '2019'),
(9, 'Iota Media', '2020'),
(10, 'Kappa Publishing', '2021');

-- --------------------------------------------------------

--
-- Table structure for table `review_comments`
--

CREATE TABLE `review_comments` (
  `Comments` varchar(255) DEFAULT NULL,
  `NumOfRating_D` int(11) NOT NULL,
  `Rating` decimal(10,2) NOT NULL,
  `Member_ID` int(11) NOT NULL,
  `Document_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `review_comments`
--

INSERT INTO `review_comments` (`Comments`, `NumOfRating_D`, `Rating`, `Member_ID`, `Document_ID`) VALUES
('Very interesting read', 1, 4.50, 2123123, 1),
('Excellent research material', 2, 5.00, 2131569, 2),
('Great for beginners', 3, 4.00, 2152081, 3),
('A bit outdated', 4, 3.50, 2152916, 4),
('Highly recommended', 5, 4.80, 2153343, 5),
('Informative and detailed', 6, 4.20, 2153372, 6),
('A classic piece', 7, 4.90, 2319313, 7),
('Needs more depth', 8, 3.80, 2323369, 8),
('Well-researched', 9, 4.70, 2819282, 9),
('Comprehensive and clear', 10, 4.80, 3921023, 10);

--
-- Triggers `review_comments`
--
DELIMITER $$
CREATE TRIGGER `BeforeReviewInsert` BEFORE INSERT ON `review_comments` FOR EACH ROW BEGIN
    IF NEW.Rating < 0 OR NEW.Rating > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Rating must be between 0 and 5.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `volumes`
--

CREATE TABLE `volumes` (
  `Title_Volume` varchar(255) NOT NULL,
  `VNo` int(11) NOT NULL,
  `Number_of_initial_pages` int(11) NOT NULL,
  `Quantity_of_vol` int(11) NOT NULL,
  `VDate` date NOT NULL,
  `Document_ID` int(11) NOT NULL,
  `Inventory_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `volumes`
--

INSERT INTO `volumes` (`Title_Volume`, `VNo`, `Number_of_initial_pages`, `Quantity_of_vol`, `VDate`, `Document_ID`, `Inventory_ID`) VALUES
('Volume 1', 1, 100, 200, '2021-01-01', 1, 1),
('Volume 2', 2, 120, 150, '2021-02-01', 2, 2),
('Volume 3', 3, 110, 180, '2021-03-01', 3, 3),
('Volume 4', 4, 130, 160, '2021-04-01', 4, 4),
('Volume 5', 5, 105, 200, '2021-05-01', 5, 5),
('Volume 6', 6, 115, 170, '2021-06-01', 6, 6),
('Volume 7', 7, 125, 180, '2021-07-01', 7, 7),
('Volume 8', 8, 135, 160, '2021-08-01', 8, 8),
('Volume 9', 9, 95, 200, '2021-09-01', 9, 9),
('Volume 10', 10, 140, 150, '2021-10-01', 10, 10);

-- --------------------------------------------------------

--
-- Table structure for table `volumes_subject`
--

CREATE TABLE `volumes_subject` (
  `VSubject` varchar(20) NOT NULL,
  `VNo` int(11) NOT NULL,
  `Document_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `volumes_subject`
--

INSERT INTO `volumes_subject` (`VSubject`, `VNo`, `Document_ID`) VALUES
('Artificial Intellige', 3, 3),
('Astronomy', 7, 7),
('Biology', 10, 10),
('Financial Economics', 9, 9),
('Medical', 2, 2),
('Political Economy', 5, 5),
('Psychology', 8, 8),
('Robotics', 4, 4),
('Science', 1, 1),
('Sociology', 6, 6);

-- --------------------------------------------------------

--
-- Table structure for table `volumes_writer`
--

CREATE TABLE `volumes_writer` (
  `Writer` varchar(20) NOT NULL,
  `VNo` int(11) NOT NULL,
  `Document_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `volumes_writer`
--

INSERT INTO `volumes_writer` (`Writer`, `VNo`, `Document_ID`) VALUES
('Dr. Alice Johnson', 1, 1),
('Dr. Brian Stewart', 2, 2),
('Dr. Christine Yang', 3, 3),
('Dr. David Kim', 4, 4),
('Dr. Frank Moore', 6, 6),
('Dr. Grace Lee', 7, 7),
('Dr. Irene Smith', 9, 9),
('Dr. Jacob White', 10, 10),
('Prof. Emily Clark', 5, 5),
('Prof. Henry Brown', 8, 8);

-- --------------------------------------------------------

--
-- Table structure for table `vouchers`
--

CREATE TABLE `vouchers` (
  `Expiration_Date` date DEFAULT NULL,
  `Discount_Value` decimal(10,2) NOT NULL CHECK (`Discount_Value` > 0),
  `Voucher_ID` int(11) NOT NULL,
  `Member_ID` int(11) NOT NULL,
  `Loan_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vouchers`
--

INSERT INTO `vouchers` (`Expiration_Date`, `Discount_Value`, `Voucher_ID`, `Member_ID`, `Loan_ID`) VALUES
('2024-12-31', 5.00, 1, 2123123, 1),
('2024-12-31', 14.00, 2, 2123123, 2),
('2024-12-31', 15.01, 3, 2131569, 3),
('2024-12-31', 34.65, 4, 2131569, 4),
('2024-12-31', 12.00, 5, 2152081, 5),
('2024-12-31', 4.00, 6, 2152916, 6),
('2024-12-31', 4.41, 7, 2153343, 7),
('2024-12-31', 6.00, 8, 2153372, 8),
('2024-12-31', 7.00, 9, 2319313, 9),
('2024-12-31', 8.00, 10, 2323369, 10),
('2024-12-31', 9.12, 11, 2152081, 11),
('2024-12-31', 11.00, 12, 2152916, 12),
('2024-12-31', 12.00, 13, 2153343, 13),
('2024-12-31', 3.00, 14, 2153372, 14),
('2024-12-31', 1.00, 15, 2323369, 15),
('2024-12-31', 7.21, 16, 2819282, 16),
('2024-12-31', 7.41, 17, 3921023, 17),
('2024-12-31', 7.51, 18, 4123876, 18),
('2024-12-31', 7.21, 19, 4212492, 19),
('2024-12-31', 7.35, 20, 4896578, 20),
('2024-12-31', 6.02, 21, 5693241, 21),
('2024-12-31', 6.51, 22, 5698327, 22),
('2024-12-31', 6.25, 23, 6513487, 23),
('2024-12-31', 6.52, 24, 7120123, 24),
('2024-12-31', 6.32, 25, 7381931, 25),
('2024-12-31', 8.00, 26, 8271271, 26),
('2024-12-31', 8.72, 27, 8271271, 27),
('2024-12-31', 8.21, 28, 4212492, 28),
('2024-12-31', 8.52, 29, 6513487, 29);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`Document_ID`);

--
-- Indexes for table `books_author`
--
ALTER TABLE `books_author`
  ADD PRIMARY KEY (`Author`,`Document_ID`),
  ADD KEY `books_author_ibfk_1` (`Document_ID`);

--
-- Indexes for table `book_copies`
--
ALTER TABLE `book_copies`
  ADD PRIMARY KEY (`Copy_ID`,`Num`),
  ADD KEY `book_copies_ibfk_1` (`Num`),
  ADD KEY `book_copies_ibfk_2` (`Inventory_ID`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`Document_ID`);

--
-- Indexes for table `documents_language`
--
ALTER TABLE `documents_language`
  ADD PRIMARY KEY (`dlanguage`,`Document_ID`),
  ADD KEY `documents_language_ibfk_1` (`Document_ID`);

--
-- Indexes for table `edition`
--
ALTER TABLE `edition`
  ADD PRIMARY KEY (`Num`,`Document_ID`),
  ADD KEY `edition_ibfk_1` (`Document_ID`);

--
-- Indexes for table `includeb`
--
ALTER TABLE `includeb`
  ADD PRIMARY KEY (`Loan_ID`,`Copy_ID`,`Num`),
  ADD KEY `includeb_ibfk_2` (`Copy_ID`,`Num`);

--
-- Indexes for table `includev`
--
ALTER TABLE `includev`
  ADD PRIMARY KEY (`Loan_ID`,`VNo`,`Document_ID`),
  ADD KEY `includev_ibfk_2` (`VNo`,`Document_ID`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`Inventory_ID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `journals`
--
ALTER TABLE `journals`
  ADD PRIMARY KEY (`Document_ID`);

--
-- Indexes for table `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`Loan_ID`),
  ADD KEY `loans_ibfk_1` (`Member_ID`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`Member_ID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `members_phone`
--
ALTER TABLE `members_phone`
  ADD PRIMARY KEY (`Phone`,`Member_ID`),
  ADD KEY `Member_ID` (`Member_ID`);

--
-- Indexes for table `published_by`
--
ALTER TABLE `published_by`
  ADD PRIMARY KEY (`Document_ID`,`Publisher_ID`),
  ADD KEY `published_by_ibfk_2` (`Publisher_ID`);

--
-- Indexes for table `publishers`
--
ALTER TABLE `publishers`
  ADD PRIMARY KEY (`Publisher_ID`);

--
-- Indexes for table `review_comments`
--
ALTER TABLE `review_comments`
  ADD PRIMARY KEY (`NumOfRating_D`),
  ADD KEY `review_comments_ibfk_1` (`Member_ID`),
  ADD KEY `review_comments_ibfk_2` (`Document_ID`);

--
-- Indexes for table `volumes`
--
ALTER TABLE `volumes`
  ADD PRIMARY KEY (`VNo`,`Document_ID`),
  ADD KEY `volumes_ibfk_1` (`Document_ID`),
  ADD KEY `volumes_ibfk_2` (`Inventory_ID`);

--
-- Indexes for table `volumes_subject`
--
ALTER TABLE `volumes_subject`
  ADD PRIMARY KEY (`VSubject`,`VNo`,`Document_ID`),
  ADD KEY `volumes_subject_ibfk_1` (`VNo`,`Document_ID`);

--
-- Indexes for table `volumes_writer`
--
ALTER TABLE `volumes_writer`
  ADD PRIMARY KEY (`Writer`,`VNo`,`Document_ID`),
  ADD KEY `volumes_writer_ibfk_1` (`VNo`,`Document_ID`);

--
-- Indexes for table `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`Voucher_ID`),
  ADD KEY `vouchers_ibfk_1` (`Member_ID`),
  ADD KEY `vouchers_ibfk_2` (`Loan_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `edition`
--
ALTER TABLE `edition`
  MODIFY `Num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `loans`
--
ALTER TABLE `loans`
  MODIFY `Member_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8271272;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `Member_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9813722;

--
-- AUTO_INCREMENT for table `members_phone`
--
ALTER TABLE `members_phone`
  MODIFY `Member_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7120124;

--
-- AUTO_INCREMENT for table `review_comments`
--
ALTER TABLE `review_comments`
  MODIFY `NumOfRating_D` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `vouchers`
--
ALTER TABLE `vouchers`
  MODIFY `Member_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8271272;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`Document_ID`) REFERENCES `documents` (`Document_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `books_author`
--
ALTER TABLE `books_author`
  ADD CONSTRAINT `books_author_ibfk_1` FOREIGN KEY (`Document_ID`) REFERENCES `books` (`Document_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `book_copies`
--
ALTER TABLE `book_copies`
  ADD CONSTRAINT `book_copies_ibfk_1` FOREIGN KEY (`Num`) REFERENCES `edition` (`Num`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `book_copies_ibfk_2` FOREIGN KEY (`Inventory_ID`) REFERENCES `inventory` (`Inventory_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `documents_language`
--
ALTER TABLE `documents_language`
  ADD CONSTRAINT `documents_language_ibfk_1` FOREIGN KEY (`Document_ID`) REFERENCES `documents` (`Document_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `edition`
--
ALTER TABLE `edition`
  ADD CONSTRAINT `edition_ibfk_1` FOREIGN KEY (`Document_ID`) REFERENCES `books` (`Document_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `includeb`
--
ALTER TABLE `includeb`
  ADD CONSTRAINT `includeb_ibfk_1` FOREIGN KEY (`Loan_ID`) REFERENCES `loans` (`Loan_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `includeb_ibfk_2` FOREIGN KEY (`Copy_ID`,`Num`) REFERENCES `book_copies` (`Copy_ID`, `Num`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `includev`
--
ALTER TABLE `includev`
  ADD CONSTRAINT `includev_ibfk_1` FOREIGN KEY (`Loan_ID`) REFERENCES `loans` (`Loan_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `includev_ibfk_2` FOREIGN KEY (`VNo`,`Document_ID`) REFERENCES `volumes` (`VNo`, `Document_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `journals`
--
ALTER TABLE `journals`
  ADD CONSTRAINT `journals_ibfk_1` FOREIGN KEY (`Document_ID`) REFERENCES `documents` (`Document_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loans_ibfk_1` FOREIGN KEY (`Member_ID`) REFERENCES `members` (`Member_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `published_by`
--
ALTER TABLE `published_by`
  ADD CONSTRAINT `published_by_ibfk_1` FOREIGN KEY (`Document_ID`) REFERENCES `documents` (`Document_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `published_by_ibfk_2` FOREIGN KEY (`Publisher_ID`) REFERENCES `publishers` (`Publisher_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `review_comments`
--
ALTER TABLE `review_comments`
  ADD CONSTRAINT `review_comments_ibfk_1` FOREIGN KEY (`Member_ID`) REFERENCES `members` (`Member_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `review_comments_ibfk_2` FOREIGN KEY (`Document_ID`) REFERENCES `documents` (`Document_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `volumes`
--
ALTER TABLE `volumes`
  ADD CONSTRAINT `volumes_ibfk_1` FOREIGN KEY (`Document_ID`) REFERENCES `journals` (`Document_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `volumes_ibfk_2` FOREIGN KEY (`Inventory_ID`) REFERENCES `inventory` (`Inventory_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `volumes_subject`
--
ALTER TABLE `volumes_subject`
  ADD CONSTRAINT `volumes_subject_ibfk_1` FOREIGN KEY (`VNo`,`Document_ID`) REFERENCES `volumes` (`VNo`, `Document_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `volumes_writer`
--
ALTER TABLE `volumes_writer`
  ADD CONSTRAINT `volumes_writer_ibfk_1` FOREIGN KEY (`VNo`,`Document_ID`) REFERENCES `volumes` (`VNo`, `Document_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `vouchers`
--
ALTER TABLE `vouchers`
  ADD CONSTRAINT `vouchers_ibfk_1` FOREIGN KEY (`Member_ID`) REFERENCES `members` (`Member_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `vouchers_ibfk_2` FOREIGN KEY (`Loan_ID`) REFERENCES `loans` (`Loan_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
