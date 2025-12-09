-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 09, 2025 at 08:17 PM
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
-- Database: `db_ford-mustang`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_mustang_simple` (IN `p_name` VARCHAR(100), IN `p_release_year` INT, IN `p_generation` INT)   BEGIN
    INSERT INTO mustangs (
        name,
        release_year,
        generation
    ) VALUES (
        p_name,
        p_release_year,
        p_generation
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mustang_simple` (IN `p_id` INT, IN `p_name` VARCHAR(100), IN `p_release_year` INT, IN `p_generation` INT)   BEGIN
    UPDATE mustangs
    SET
        name = p_name,
        release_year = p_release_year,
        generation = p_generation
    WHERE id = p_id;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `mustang_age` (`p_release_year` INT) RETURNS INT(11) DETERMINISTIC BEGIN
    RETURN YEAR(CURDATE()) - p_release_year;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `mustangs`
--

CREATE TABLE `mustangs` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `release_year` int(11) DEFAULT NULL,
  `generation` int(11) DEFAULT NULL,
  `body_type` varchar(50) DEFAULT NULL,
  `transmission` varchar(20) DEFAULT NULL,
  `drivetrain` varchar(20) DEFAULT NULL,
  `car_engine` varchar(100) DEFAULT NULL,
  `horse_power` int(11) DEFAULT NULL,
  `torque` int(11) DEFAULT NULL,
  `top_speed` int(11) DEFAULT NULL,
  `zero_to_sixty` float DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mustangs`
--

INSERT INTO `mustangs` (`id`, `name`, `release_year`, `generation`, `body_type`, `transmission`, `drivetrain`, `car_engine`, `horse_power`, `torque`, `top_speed`, `zero_to_sixty`, `price`, `description`) VALUES
(1, 'Ford Mustang (1st Gen)', 1965, 1, 'Coupe', '3-speed manual', 'RWD', '2.8L Inline-6', 101, 207, 95, NULL, 2368, 'First-generation Mustang. Launched in 1964 but sold as the 1965 model year. Base model used a 2.8L inline-six engine.'),
(2, 'Ford Mustang II (2nd Gen)', 1974, 2, 'Coupe', '4-speed manual', 'RWD', '2.3L Inline-4', 88, 119, 90, NULL, 3579, 'Second-generation Mustang II introduced during the fuel crisis. Base trim used a 2.3L inline-four engine.'),
(3, 'Ford Mustang (3rd Gen Foxbody)', 1979, 3, 'Coupe', '4-speed manual', 'RWD', '2.3L Inline-4', 88, 119, 100, NULL, 4188, 'Third-generation Foxbody Mustang launched with a 2.3L inline-four as the standard powertrain.'),
(4, 'Ford Mustang (4th Gen SN95)', 1994, 4, 'Coupe', '5-speed manual', 'RWD', '3.8L V6', 145, 215, 115, 7.5, 13990, 'Fourth-generation Mustang debuted with a 3.8L V6 as the base engine, replacing the old Foxbody platform.'),
(5, 'Ford Mustang (5th Gen S197)', 2005, 5, 'Coupe', '5-speed manual', 'RWD', '4.0L V6', 210, 240, 115, 6.9, 19965, 'The S197 Mustang revived retro styling and launched with a 4.0L V6 as the base model.'),
(6, 'Ford Mustang (6th Gen S550)', 2015, 6, 'Coupe', '6-speed manual', 'RWD', '2.3L EcoBoost I4', 310, 320, 145, 5.6, 24000, 'The S550 introduced a global Mustang with an independent rear suspension and a turbocharged 2.3L EcoBoost as the main base engine.'),
(7, 'Ford Mustang (7th Gen S650)', 2024, 7, 'Coupe', '10-speed automatic', 'RWD', '2.3L EcoBoost I4', 315, 350, 145, 5.5, 30200, 'The S650 Mustang continues the EcoBoost tradition, offering modern tech and improved base performance.'),
(9, 'Ford Mustang GT Dark Horse (7th Gen S650)', 2024, 7, 'None', 'None', 'None', 'None', 0, 0, 0, 0, 0, 'None');

--
-- Triggers `mustangs`
--
DELIMITER $$
CREATE TRIGGER `mustang_after_delete` AFTER DELETE ON `mustangs` FOR EACH ROW BEGIN
    INSERT INTO mustang_delete_history (
        mustang_id,
        name,
        release_year,
        generation,
        deleted_at
    ) VALUES (
        OLD.id,
        OLD.name,
        OLD.release_year,
        OLD.generation,
        NOW()
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `mustang_basic_view`
-- (See below for the actual view)
--
CREATE TABLE `mustang_basic_view` (
`id` int(11)
,`name` varchar(100)
,`release_year` int(11)
,`generation` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `mustang_delete_history`
--

CREATE TABLE `mustang_delete_history` (
  `id` int(11) NOT NULL,
  `mustang_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `release_year` int(11) DEFAULT NULL,
  `generation` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mustang_delete_history`
--

INSERT INTO `mustang_delete_history` (`id`, `mustang_id`, `name`, `release_year`, `generation`, `deleted_at`) VALUES
(1, 10, 'Ford Mustang GT Dark Horse (7th Gen S650)', 2024, 7, '2025-12-10 01:54:34');

-- --------------------------------------------------------

--
-- Structure for view `mustang_basic_view`
--
DROP TABLE IF EXISTS `mustang_basic_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mustang_basic_view`  AS SELECT `mustangs`.`id` AS `id`, `mustangs`.`name` AS `name`, `mustangs`.`release_year` AS `release_year`, `mustangs`.`generation` AS `generation` FROM `mustangs` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `mustangs`
--
ALTER TABLE `mustangs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mustang_delete_history`
--
ALTER TABLE `mustang_delete_history`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `mustangs`
--
ALTER TABLE `mustangs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `mustang_delete_history`
--
ALTER TABLE `mustang_delete_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
