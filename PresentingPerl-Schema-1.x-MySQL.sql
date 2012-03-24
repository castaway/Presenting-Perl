-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sat Mar 24 11:21:52 2012
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `announcements`;

--
-- Table: `announcements`
--
CREATE TABLE `announcements` (
  `id` integer NOT NULL auto_increment,
  `made_at` datetime NOT NULL,
  `bucket_slug` text,
  INDEX `announcements_idx_bucket_slug` (`bucket_slug`),
  PRIMARY KEY (`id`),
  CONSTRAINT `announcements_fk_bucket_slug` FOREIGN KEY (`bucket_slug`) REFERENCES `buckets` (`slug`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `buckets`;

--
-- Table: `buckets`
--
CREATE TABLE `buckets` (
  `slug` text NOT NULL,
  `name` text NOT NULL,
  PRIMARY KEY (`slug`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `roles`;

--
-- Table: `roles`
--
CREATE TABLE `roles` (
  `id` integer NOT NULL auto_increment,
  `role` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `user_role`;

--
-- Table: `user_role`
--
CREATE TABLE `user_role` (
  `user_id` integer NOT NULL,
  `role_id` integer NOT NULL,
  INDEX `user_role_idx_role_id` (`role_id`),
  INDEX `user_role_idx_user_id` (`user_id`),
  PRIMARY KEY (`user_id`, `role_id`),
  CONSTRAINT `user_role_fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_role_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `users`;

--
-- Table: `users`
--
CREATE TABLE `users` (
  `id` integer NOT NULL auto_increment,
  `username` text,
  `password` varchar(255),
  `email_address` text,
  `first_name` text,
  `last_name` text,
  `active` integer,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `videos`;

--
-- Table: `videos`
--
CREATE TABLE `videos` (
  `slug` text NOT NULL,
  `bucket_slug` text NOT NULL,
  `name` text NOT NULL,
  `author` text NOT NULL,
  `details` text NOT NULL DEFAULT '',
  `announcement_id` integer NOT NULL,
  INDEX `videos_idx_announcement_id_bucket_slug` (`announcement_id`, `bucket_slug`),
  INDEX `videos_idx_bucket_slug` (`bucket_slug`),
  PRIMARY KEY (`slug`, `bucket_slug`),
  CONSTRAINT `videos_fk_announcement_id_bucket_slug` FOREIGN KEY (`announcement_id`, `bucket_slug`) REFERENCES `announcements` (`id`, `bucket_slug`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `videos_fk_bucket_slug` FOREIGN KEY (`bucket_slug`) REFERENCES `buckets` (`slug`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SET foreign_key_checks=1;


