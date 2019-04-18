# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 45.55.154.177 (MySQL 5.7.19-0ubuntu0.16.04.1)
# Database: steveward
# Generation Time: 2017-07-31 18:33:24 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table bm_posts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bm_posts`;

CREATE TABLE `bm_posts` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_author` bigint(20) unsigned NOT NULL DEFAULT '0',
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext NOT NULL,
  `post_title` text NOT NULL,
  `post_excerpt` text NOT NULL,
  `post_status` varchar(20) NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) NOT NULL DEFAULT 'open',
  `post_password` varchar(255) NOT NULL DEFAULT '',
  `post_name` varchar(200) NOT NULL DEFAULT '',
  `to_ping` text NOT NULL,
  `pinged` text NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` longtext NOT NULL,
  `post_parent` bigint(20) unsigned NOT NULL DEFAULT '0',
  `guid` varchar(255) NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT '0',
  `post_type` varchar(20) NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `post_name` (`post_name`(191)),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
  KEY `post_parent` (`post_parent`),
  KEY `post_author` (`post_author`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

LOCK TABLES `bm_posts` WRITE;
/*!40000 ALTER TABLE `bm_posts` DISABLE KEYS */;

INSERT INTO `bm_posts` (`ID`, `post_author`, `post_date`, `post_date_gmt`, `post_content`, `post_title`, `post_excerpt`, `post_status`, `comment_status`, `ping_status`, `post_password`, `post_name`, `to_ping`, `pinged`, `post_modified`, `post_modified_gmt`, `post_content_filtered`, `post_parent`, `guid`, `menu_order`, `post_type`, `post_mime_type`, `comment_count`)
VALUES
	(11,1,'2017-07-30 16:50:50','2017-07-30 15:50:50','<a href=\"http://php.net/manual/en/function.parse-ini-file.php\" target=\"_blank\" rel=\"noopener\">http://php.net/manual/en/function.parse-ini-file.php</a>','PHP: parse_ini_file - Manual','','publish','closed','open','','php-parse-ini-file-manual','','','2017-07-31 19:27:59','2017-07-31 18:27:59','',0,'',0,'post','',0),
	(12,1,'2017-07-30 16:51:59','2017-07-30 15:51:59','<a href=\"https://www.macrumors.com/\" target=\"_blank\" rel=\"noopener\">https://www.macrumors.com/</a>','Mac Rumors: Apple Mac iOS Rumors and News You Care About','','publish','closed','open','','mac-rumors-apple-mac-ios-rumors-and-news-you-care-about','','','2017-07-31 19:27:49','2017-07-31 18:27:49','',0,'',0,'post','',0),
	(13,1,'2017-07-30 16:52:36','2017-07-30 15:52:36','<a href=\"https://mattstauffer.co/blog/how-to-disable-mysql-strict-mode-on-laravel-forge-ubuntu\" target=\"_blank\" rel=\"noopener\">https://mattstauffer.co/blog/how-to-disable-mysql-strict-mode-on-laravel-forge-ubuntu</a>','How to disable MySQL strict mode on Laravel Forge (Ubuntu) - Matt Stauffer on Laravel, PHP, Frontend development','','publish','closed','open','','how-to-disable-mysql-strict-mode-on-laravel-forge-ubuntu-matt-stauffer-on-laravel-php-frontend-development','','','2017-07-31 19:27:31','2017-07-31 18:27:31','',0,'',0,'post','',0),
	(14,1,'2017-07-30 16:53:49','2017-07-30 15:53:49','<a href=\"https://stackoverflow.com/questions/2418771/remove-encoding-using-php\" target=\"_blank\" rel=\"noopener\">https://stackoverflow.com/questions/2418771/remove-encoding-using-php</a>','encode - Remove encoding using PHP - Stack Overflow','','publish','closed','open','','encode-remove-encoding-using-php-stack-overflow','','','2017-07-31 19:27:20','2017-07-31 18:27:20','',0,'',0,'post','',0),
	(17,1,'2017-07-30 17:17:38','2017-07-30 16:17:38','<a href=\"https://www.cloudflare.com/a/dns/steveward.me.uk\" target=\"_blank\" rel=\"noopener\">https://www.cloudflare.com/a/dns/steveward.me.uk</a>','DNS: steveward.me.uk | Cloudflare - Web Performance &amp; Security','','publish','closed','open','','dns-steveward-me-uk-cloudflare-web-performance-security','','','2017-07-31 19:27:07','2017-07-31 18:27:07','',0,'',0,'post','',0),
	(18,1,'2017-07-30 17:28:16','2017-07-30 16:28:16','<a href=\"http://i.dailymail.co.uk/i/pix/2016/06/05/23/34F093A000000578-3626488-image-m-91_1465166941179.jpg\" target=\"_blank\" rel=\"noopener\">http://i.dailymail.co.uk/i/pix/2016/06/05/23/34F093A000000578-3626488-image-m-91_1465166941179.jpg</a>','Garbine Muguruza','','publish','closed','open','','garbine-muguruza','','','2017-07-31 19:26:46','2017-07-31 18:26:46','',0,'',0,'post','',0),
	(19,1,'2017-07-30 17:40:17','2017-07-30 16:40:17','<a href=\"http://minimini.jp/bookimg/00010011/Simg/009133.jpg\" target=\"_blank\" rel=\"noopener\">http://minimini.jp/bookimg/00010011/Simg/009133.jpg</a>','Yoshimi - Mini-Mini Machiya','','publish','closed','open','','yoshimi-mini-mini-machiya','','','2017-07-31 19:26:29','2017-07-31 18:26:29','',0,'',0,'post','',0),
	(20,1,'2017-07-30 17:48:19','2017-07-30 16:48:19','<a href=\"http://tokyohelpinghands.com/\" target=\"_blank\" rel=\"noopener\">http://tokyohelpinghands.com/</a>','Moving in Tokyo - Men with van service - TokyoHelpingHands! - Tokyo Moving Company','','publish','closed','open','','moving-in-tokyo-men-with-van-service-tokyohelpinghands-tokyo-moving-company','','','2017-07-31 19:26:01','2017-07-31 18:26:01','',0,'',0,'post','',0),
	(21,1,'2017-07-30 17:55:16','2017-07-30 16:55:16','<a href=\"https://www.digitalocean.com/community/questions/mysql-server-stops-very-frequently\" target=\"_blank\" rel=\"noopener\">https://www.digitalocean.com/community/questions/mysql-server-stops-very-frequently</a>','Mysql server stops very frequently | DigitalOcean','','publish','closed','open','','mysql-server-stops-very-frequently-digitalocean','','','2017-07-31 19:25:32','2017-07-31 18:25:32','',0,'',0,'post','',0);

/*!40000 ALTER TABLE `bm_posts` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
