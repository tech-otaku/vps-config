# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 45.55.154.177 (MySQL 5.7.19-0ubuntu0.16.04.1)
# Database: steveward
# Generation Time: 2017-07-31 18:32:55 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table bm_term_relationships
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bm_term_relationships`;

CREATE TABLE `bm_term_relationships` (
  `object_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `term_taxonomy_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `term_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`object_id`,`term_taxonomy_id`),
  KEY `term_taxonomy_id` (`term_taxonomy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

LOCK TABLES `bm_term_relationships` WRITE;
/*!40000 ALTER TABLE `bm_term_relationships` DISABLE KEYS */;

INSERT INTO `bm_term_relationships` (`object_id`, `term_taxonomy_id`, `term_order`)
VALUES
	(11,4,0),
	(11,5,0),
	(11,6,0),
	(11,14,0),
	(12,4,0),
	(12,5,0),
	(12,6,0),
	(12,15,0),
	(13,4,0),
	(13,5,0),
	(13,6,0),
	(13,7,0),
	(14,4,0),
	(14,5,0),
	(14,6,0),
	(14,14,0),
	(17,4,0),
	(17,5,0),
	(17,6,0),
	(17,12,0),
	(17,13,0),
	(18,4,0),
	(18,5,0),
	(18,6,0),
	(18,10,0),
	(19,4,0),
	(19,5,0),
	(19,6,0),
	(19,10,0),
	(19,11,0),
	(20,4,0),
	(20,5,0),
	(20,6,0),
	(20,9,0),
	(21,4,0),
	(21,5,0),
	(21,6,0),
	(21,7,0),
	(21,8,0);

/*!40000 ALTER TABLE `bm_term_relationships` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
