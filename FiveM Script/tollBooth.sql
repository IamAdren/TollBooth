CREATE TABLE IF NOT EXISTS `toll_booth_stats` (
  `id` int(11) NOT NULL,
  `stolen` int(11) NOT NULL DEFAULT 0,
  `failure` int(11) NOT NULL DEFAULT 0,
  `successful` int(11) NOT NULL DEFAULT 0,
  `name` char(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELETE FROM `toll_booth_stats`;
INSERT INTO `toll_booth_stats` (`id`, `stolen`, `failure`, `successful`, `name`) VALUES
	(1, 0, 0, 0, 'Great Ocean Toll Booth'),
	(2, 0, 0, 0, 'Route 13 Toll Booth'),
	(3, 0, 0, 0, 'Route 15 Toll Booth');