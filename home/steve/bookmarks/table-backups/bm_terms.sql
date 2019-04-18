# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 45.55.154.177 (MySQL 5.7.19-0ubuntu0.16.04.1)
# Database: steveward
# Generation Time: 2017-07-31 18:32:13 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table bm_terms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bm_terms`;

CREATE TABLE `bm_terms` (
  `term_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `slug` varchar(200) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `term_group` bigint(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_id`),
  KEY `slug` (`slug`(191)),
  KEY `name` (`name`(191))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

LOCK TABLES `bm_terms` WRITE;
/*!40000 ALTER TABLE `bm_terms` DISABLE KEYS */;

INSERT INTO `bm_terms` (`term_id`, `name`, `slug`, `term_group`)
VALUES
	(1,'Uncategorised','uncategorised',0),
	(4,'Bookmark','bookmark',0),
	(5,'post-format-link','post-format-link',0),
	(6,'test','test',0),
	(7,'mysql','mysql',0),
	(8,'digitalocean','digitalocean',0),
	(9,'moving','moving',0),
	(10,'hotties','hotties',0),
	(11,'mini-mini','mini-mini',0),
	(12,'dns','dns',0),
	(13,'cloudflare','cloudflare',0),
	(14,'php','php',0),
	(15,'mac','mac',0);

/*!40000 ALTER TABLE `bm_terms` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
