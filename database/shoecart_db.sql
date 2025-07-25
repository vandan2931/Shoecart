-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 25, 2025 at 06:31 AM
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
-- Database: `shoecart_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`cart_id`, `user_id`, `created_at`) VALUES
(5, 15, '2025-07-18 04:39:18'),
(6, 16, '2025-07-21 04:51:45');

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `cart_item_id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `size` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `name`, `description`) VALUES
(1, 'Running', 'Running shoes for all terrains'),
(2, 'Casual', 'Everyday comfortable shoes'),
(3, 'Sports', 'Sports and athletic shoes'),
(4, 'Formal', 'Formal and business shoes');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `total_amount` decimal(10,2) NOT NULL,
  `status` varchar(20) NOT NULL,
  `shipping_address` text NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `estimated_delivery` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `order_date`, `total_amount`, `status`, `shipping_address`, `payment_method`, `estimated_delivery`) VALUES
(20, 15, '2025-07-18 04:54:13', 24276.00, 'Processing', 'AHMEDABAD, GUJARAT', 'credit_card', '2025-07-21 04:54:13'),
(21, 15, '2025-07-18 05:07:54', 13995.00, 'Processing', 'AHMEDABAD, GUJARAT', 'credit_card', '2025-07-21 05:07:54'),
(22, 15, '2025-07-18 05:14:11', 13995.00, 'Shipped', 'AHMEDABAD, GUJARAT', 'credit_card', '2025-07-21 05:13:31'),
(23, 15, '2025-07-18 06:45:36', 12490.00, 'Processing', 'AHMEDABAD, GUJARAT', 'credit_card', '2025-07-21 06:45:36'),
(24, 15, '2025-07-18 06:47:37', 12746.00, 'Processing', 'AHMEDABAD, GUJARAT', 'credit_card', '2025-07-21 06:47:37'),
(25, 16, '2025-07-21 04:52:29', 13995.00, 'Processing', 'bareja, ahmedabad', 'credit_card', '2025-07-24 04:52:29');

-- --------------------------------------------------------

--
-- Table structure for table `order_history`
--

CREATE TABLE `order_history` (
  `history_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` varchar(20) NOT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_history`
--

INSERT INTO `order_history` (`history_id`, `order_id`, `timestamp`, `status`, `notes`) VALUES
(21, 20, '2025-07-18 04:54:13', 'Processing', 'Order created'),
(22, 21, '2025-07-18 05:07:54', 'Processing', 'Order created'),
(23, 22, '2025-07-18 05:13:31', 'Processing', 'Order created'),
(24, 22, '2025-07-18 05:14:11', 'Shipped', ''),
(25, 23, '2025-07-18 06:45:36', 'Processing', 'Order created'),
(26, 24, '2025-07-18 06:47:37', 'Processing', 'Order created'),
(27, 25, '2025-07-21 04:52:29', 'Processing', 'Order created');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `size` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `product_id`, `product_name`, `quantity`, `price`, `size`) VALUES
(25, 20, 11, 'Dior x Air Jordan 1 Retro High', 1, 24276.00, '6'),
(26, 21, 5, 'Nike Air Force 1 Low Retro', 1, 13995.00, '10'),
(27, 22, 5, 'Nike Air Force 1 Low Retro', 1, 13995.00, '10'),
(28, 23, 4, 'Executive Leather', 1, 12490.00, '7'),
(29, 24, 4, 'Executive Leather', 1, 12490.00, '7'),
(30, 24, 9, 'GEL-KAYANO 31', 1, 256.00, '8'),
(31, 25, 5, 'Nike Air Force 1 Low Retro', 1, 13995.00, '10');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `stock_quantity` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `name`, `description`, `price`, `image_path`, `category_id`, `stock_quantity`, `created_at`) VALUES
(1, 'Air Runner Pro', 'Lightweight running shoes with cushioning', 120.00, '/assets/images/products/product1.jpg', 1, 25, '2025-07-11 05:43:06'),
(2, 'Urban Walker', 'Comfortable casual shoes for everyday wear', 80.00, '/assets/images/products/product2.jpg', 2, 72, '2025-07-11 05:43:06'),
(3, 'Nike Vomero 18', 'High-performance basketball shoes', 13295.00, '/assets/images/products/product3.jpg', 3, 21, '2025-07-11 05:43:06'),
(4, 'Executive Leather', 'CRUST BROWN MEN TOE CAP OXFORD LACE UP SHOES | 5092CRUST BROWN', 12490.00, '/assets/images/product4.jpg', 4, 21, '2025-07-11 05:43:06'),
(5, 'Nike Air Force 1 Low Retro', 'Men\'s Shoes', 13995.00, '/assets/images/products/Nike Air Force 1 Low Retro.webp', 2, 21, '2025-07-16 06:56:06'),
(9, 'GEL-KAYANO 31', 'Men Running Shoes', 256.00, '/assets/images/products/hero-shoes.jpg', 1, 306, '2025-07-16 08:08:44'),
(10, 'Sneakers', 'Casual ColorsFlow Men Sneakers', 320.00, '/assets/images/products/product5.webp', 2, 113, '2025-07-17 05:57:15'),
(11, 'Dior x Air Jordan 1 Retro High', 'Dior x Air Jordan 1', 24276.00, '/assets/images/products/jordan.png', 2, 11, '2025-07-17 12:35:11'),
(12, 'Red Tape Men Colorblocked Off White Sneakers', 'Red Tape Men Color blocked Off White Sneakers \r\n', 99.00, '/assets/images/products/redtape.webp', 2, 15, '2025-07-18 05:19:53');

-- --------------------------------------------------------

--
-- Table structure for table `product_sizes`
--

CREATE TABLE `product_sizes` (
  `product_id` int(11) NOT NULL,
  `size` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_sizes`
--

INSERT INTO `product_sizes` (`product_id`, `size`) VALUES
(1, '10'),
(1, '7'),
(1, '8'),
(1, '9'),
(2, '10'),
(2, '7'),
(2, '8'),
(2, '9'),
(3, '10'),
(3, '8'),
(3, '9'),
(4, '10'),
(4, '7'),
(4, '8'),
(4, '9'),
(5, '10'),
(5, '6'),
(5, '7'),
(5, '8'),
(5, '9'),
(9, '10'),
(9, '8'),
(9, '9'),
(10, '7'),
(10, '8'),
(10, '9'),
(11, '10'),
(11, '6'),
(11, '7'),
(11, '8'),
(11, '9'),
(12, '10'),
(12, '7'),
(12, '8'),
(12, '9');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `role` enum('admin','customer') DEFAULT 'customer',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `password`, `phone`, `address`, `role`, `created_at`) VALUES
(14, 'manav s', 'man@gmail.com', 'PfcJYcnOEX1YHn6Gii1BjB9QcIU08IWh1ng4dWsW6a5EREcKfY0BpjlE/qeXgSX7', NULL, NULL, 'admin', '2025-07-18 04:29:16'),
(15, 'vandan shah', 'v@gmail.com', '0t4UWGhajaxa/Z9IwQEeUd9xyxNNYLrkqviN/iw5EYhs+KzGasovzBET9OgUegwo', '12345678901', 'ahmedabad', 'customer', '2025-07-18 04:39:11'),
(16, 'vshah', 'qq@gmail.com', '1v1MZXVIQ41LqLmaJpDocikWz2YxSPpMchs256XvhDUZ2wC21KaS3172kt/dukiF', NULL, NULL, 'customer', '2025-07-21 04:50:44');

-- --------------------------------------------------------

--
-- Table structure for table `wishlists`
--

CREATE TABLE `wishlists` (
  `wishlist_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`cart_item_id`),
  ADD KEY `cart_id` (`cart_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_history`
--
ALTER TABLE `order_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `product_sizes`
--
ALTER TABLE `product_sizes`
  ADD PRIMARY KEY (`product_id`,`size`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`wishlist_id`),
  ADD UNIQUE KEY `unique_wishlist_item` (`user_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `cart_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `order_history`
--
ALTER TABLE `order_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `wishlist_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`cart_id`),
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `order_history`
--
ALTER TABLE `order_history`
  ADD CONSTRAINT `order_history_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `product_sizes`
--
ALTER TABLE `product_sizes`
  ADD CONSTRAINT `product_sizes_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
