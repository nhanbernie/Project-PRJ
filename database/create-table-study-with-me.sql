DROP DATABASE IF EXISTS `study-with-me`;
CREATE DATABASE IF NOT EXISTS `study-with-me`;
USE `study-with-me`;

CREATE TABLE IF NOT EXISTS `user` (
	`id` BIGINT AUTO_INCREMENT,
	`username` VARCHAR(255) NOT NULL UNIQUE,
	`password` VARCHAR(255) NOT NULL,
	`role` ENUM("ADMIN", "USER") DEFAULT 'USER',
	`email` VARCHAR(255) NOT NULL UNIQUE,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `user_info` (
	`id` BIGINT AUTO_INCREMENT,
	`phone` VARCHAR(255) UNIQUE,
	`address` TEXT,
	`fullName` VARCHAR(255),
	`birthDate` DATE,
	`sex` ENUM("MALE", "FEMALE", "OTHER"),
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`avatar` VARCHAR(255),
	`userId` BIGINT UNIQUE,
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `category` (
	`id` BIGINT AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL UNIQUE,
	`description` TEXT,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `posts` (
	`id` BIGINT AUTO_INCREMENT,
	`title` VARCHAR(255) NOT NULL,
	`content` LONGTEXT NOT NULL,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE", "DRAFT") DEFAULT 'ACTIVE',
	`banner` VARCHAR(255),
	`categoryId` BIGINT,
	`numberAccess` BIGINT DEFAULT 0,
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `comment` (
	`id` BIGINT AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`email` VARCHAR(255) NOT NULL,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	`website` VARCHAR(255),
	`postId` BIGINT,
	`message` TEXT,
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `web_setting` (
	`id` BIGINT AUTO_INCREMENT,
	`content` LONGTEXT NOT NULL,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	`type` VARCHAR(50),
	`image` VARCHAR(255),
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `ads` (
	`id` BIGINT AUTO_INCREMENT,
	`images` VARCHAR(255),
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	`width` INT,
	`height` INT,
	`position` VARCHAR(255),
	`url` VARCHAR(255),
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `messages` (
	`id` BIGINT AUTO_INCREMENT,
	`subject` VARCHAR(255) NOT NULL,
	`email` VARCHAR(255) NOT NULL,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	`message` TEXT,
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `history` (
	`id` BIGINT AUTO_INCREMENT,
	`ipAddress` VARCHAR(255),
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`types` VARCHAR(255),
	`mappingId` BIGINT,
	PRIMARY KEY(`id`)
);

ALTER TABLE `user_info`
ADD FOREIGN KEY(`userId`) REFERENCES `user`(`id`)
ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE `posts`
ADD FOREIGN KEY(`categoryId`) REFERENCES `category`(`id`)
ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE `comment`
ADD FOREIGN KEY(`postId`) REFERENCES `posts`(`id`)
ON UPDATE NO ACTION ON DELETE CASCADE;

INSERT INTO `messages` (`id`, `subject`, `email`, `createdDate`, `updatedDate`, `createdBy`, `updatedBy`, `status`, `message`) VALUES
    (1, 'Code Review Issue 1', 'developer1@example.com', '2021-05-01 10:15:42', '2021-05-01 10:45:12', 'admin', NULL, 'ACTIVE', 'Refactor the authentication module for better performance.'),
    (2, 'Code Review Issue 2', 'developer2@example.com', '2021-06-15 11:22:33', '2021-06-15 11:40:20', 'admin', NULL, 'ACTIVE', 'Fix memory leak in the data processing function.'),
    (3, 'Code Review Issue 3', 'developer3@example.com', '2021-07-10 12:30:54', '2021-07-10 13:05:00', 'admin', NULL, 'ACTIVE', 'Update API endpoints to match the new specification.'),
    (4, 'Code Review Issue 4', 'developer4@example.com', '2021-08-05 14:40:23', '2021-08-05 15:15:10', 'admin', NULL, 'ACTIVE', 'Implement error handling for database connection failures.'),
    (5, 'Code Review Issue 5', 'developer5@example.com', '2021-09-20 16:55:00', '2021-09-20 17:30:25', 'admin', NULL, 'ACTIVE', 'Optimize the front-end code for faster page load times.'),
    (6, 'Code Review Issue 6', 'developer6@example.com', '2022-01-15 09:10:45', '2022-01-15 09:40:55', 'admin', NULL, 'ACTIVE', 'Fix UI layout issues on mobile devices.'),
    (7, 'Code Review Issue 7', 'developer7@example.com', '2022-03-22 10:20:12', '2022-03-22 10:50:25', 'admin', NULL, 'ACTIVE', 'Address security vulnerabilities in user input validation.'),
    (8, 'Code Review Issue 8', 'developer8@example.com', '2022-05-30 11:30:55', '2022-05-30 12:00:40', 'admin', NULL, 'ACTIVE', 'Refactor the logging system to use structured logging.'),
    (9, 'Code Review Issue 9', 'developer9@example.com', '2022-07-15 13:45:22', '2022-07-15 14:20:30', 'admin', NULL, 'ACTIVE', 'Update third-party library dependencies to the latest versions.'),
    (10, 'Code Review Issue 10', 'developer10@example.com', '2022-09-01 15:55:12', '2022-09-01 16:25:50', 'admin', NULL, 'ACTIVE', 'Add unit tests for newly implemented features.'),
    (11, 'Code Review Issue 11', 'developer11@example.com', '2023-01-10 09:00:00', '2023-01-10 09:30:00', 'admin', NULL, 'ACTIVE', 'Review the API rate limiting implementation.'),
    (12, 'Code Review Issue 12', 'developer12@example.com', '2023-03-20 10:15:30', '2023-03-20 10:45:00', 'admin', NULL, 'ACTIVE', 'Improve the code documentation for the payment module.'),
    (13, 'Code Review Issue 13', 'developer13@example.com', '2023-05-15 11:20:45', '2023-05-15 11:55:20', 'admin', NULL, 'ACTIVE', 'Optimize the SQL queries for better performance.'),
    (14, 'Code Review Issue 14', 'developer14@example.com', '2023-07-25 12:35:00', '2023-07-25 13:10:25', 'admin', NULL, 'ACTIVE', 'Fix cross-browser compatibility issues in the user dashboard.'),
    (15, 'Code Review Issue 15', 'developer15@example.com', '2023-09-10 13:50:15', '2023-09-10 14:25:40', 'admin', NULL, 'ACTIVE', 'Implement rate limiting for the API to prevent abuse.'),
    (16, 'Code Review Issue 16', 'developer16@example.com', '2024-01-20 15:05:30', '2024-01-20 15:40:10', 'admin', NULL, 'ACTIVE', 'Address usability issues in the admin panel.'),
    (17, 'Code Review Issue 17', 'developer17@example.com', '2024-03-18 16:20:45', '2024-03-18 16:55:30', 'admin', NULL, 'ACTIVE', 'Refactor the authentication flow to improve security.'),
    (18, 'Code Review Issue 18', 'developer18@example.com', '2024-05-22 17:35:00', '2024-05-22 18:10:15', 'admin', NULL, 'ACTIVE', 'Update the error handling mechanism for better user feedback.'),
    (19, 'Code Review Issue 19', 'developer19@example.com', '2024-06-30 18:50:15', '2024-06-30 19:25:00', 'admin', NULL, 'ACTIVE', 'Implement a caching layer for frequently accessed data.'),
    (20, 'Code Review Issue 20', 'developer20@example.com', '2024-07-15 20:05:30', '2024-07-15 20:45:00', 'admin', NULL, 'ACTIVE', 'Ensure compliance with the latest coding standards.'),
 (21, 'Code Review Issue 21', 'developer21@example.com', '2024-07-27 08:05:30', '2024-07-27 08:10:30', 'admin', NULL, 'ACTIVE', 'Review the recent updates to the authentication service.'),
    (22, 'Code Review Issue 22', 'developer22@example.com', '2024-07-27 08:20:45', '2024-07-27 08:25:00', 'admin', NULL, 'ACTIVE', 'Fix the bug in the payment gateway integration.'),
    (23, 'Code Review Issue 23', 'developer23@example.com', '2024-07-27 08:45:12', '2024-07-27 08:50:30', 'admin', NULL, 'ACTIVE', 'Improve logging for the user session management module.'),
    (24, 'Code Review Issue 24', 'developer24@example.com', '2024-07-26 09:15:00', '2024-07-26 09:45:30', 'admin', NULL, 'ACTIVE', 'Address performance issues in the search functionality.'),
    (25, 'Code Review Issue 25', 'developer25@example.com', '2024-07-26 10:30:22', '2024-07-26 11:00:00', 'admin', NULL, 'ACTIVE', 'Update the database schema for the new feature set.'),
    (26, 'Code Review Issue 26', 'developer26@example.com', '2024-07-25 11:45:30', '2024-07-25 12:10:15', 'admin', NULL, 'ACTIVE', 'Implement new caching strategy for API responses.'),
    (27, 'Code Review Issue 27', 'developer27@example.com', '2024-07-24 14:05:10', '2024-07-24 14:30:00', 'admin', NULL, 'ACTIVE', 'Fix the UI issues in the dashboard page.'),
    (28, 'Code Review Issue 28', 'developer28@example.com', '2024-07-23 15:20:00', '2024-07-23 15:45:30', 'admin', NULL, 'ACTIVE', 'Enhance the security of the user profile section.'),
    (29, 'Code Review Issue 29', 'developer29@example.com', '2024-07-22 16:35:20', '2024-07-22 17:00:15', 'admin', NULL, 'ACTIVE', 'Update the API documentation to reflect recent changes.'),
        (31, 'Code Review Issue 2911', 'developer29@example.com1', '2024-07-27 23:35:20', '2024-07-27 23:41:15', 'admin', NULL, 'ACTIVE', 'Update the API documentation to reflect recent changes.');
