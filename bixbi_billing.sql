CREATE TABLE IF NOT EXISTS `bixbi_billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `senderjob` varchar(20) COLLATE utf8mb4_bin NOT NULL,
  `reason` varchar(200) COLLATE utf8mb4_bin NOT NULL,
  `target` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `amount` int(8) NOT NULL,
  `time` varchar(15) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
