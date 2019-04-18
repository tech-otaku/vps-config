# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 45.55.154.177 (MySQL 5.7.19-0ubuntu0.16.04.1)
# Database: steveward
# Generation Time: 2017-07-31 18:33:47 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table bm_postmeta
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bm_postmeta`;

CREATE TABLE `bm_postmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `meta_key` varchar(255) COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `meta_value` longtext COLLATE utf8mb4_unicode_520_ci,
  PRIMARY KEY (`meta_id`),
  KEY `post_id` (`post_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

LOCK TABLES `bm_postmeta` WRITE;
/*!40000 ALTER TABLE `bm_postmeta` DISABLE KEYS */;

INSERT INTO `bm_postmeta` (`meta_id`, `post_id`, `meta_key`, `meta_value`)
VALUES
	(1,11,'_edit_last','1'),
	(4,11,'_edit_lock','1501525679:1'),
	(41,21,'_edit_last','1'),
	(44,21,'_edit_lock','1501525532:1'),
	(45,19,'_edit_last','1'),
	(48,19,'_edit_lock','1501525589:1'),
	(49,20,'_edit_last','1'),
	(52,20,'_edit_lock','1501525561:1'),
	(53,18,'_edit_last','1'),
	(56,18,'_edit_lock','1501525606:1'),
	(57,17,'_edit_last','1'),
	(60,17,'_edit_lock','1501525627:1'),
	(61,14,'_edit_last','1'),
	(64,14,'_edit_lock','1501525640:1'),
	(65,13,'_edit_last','1'),
	(68,13,'_edit_lock','1501525651:1'),
	(69,12,'_edit_last','1'),
	(72,12,'_edit_lock','1501525669:1');

/*!40000 ALTER TABLE `bm_postmeta` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
