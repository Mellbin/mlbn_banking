USE `fivem2337`;

CREATE TABLE `loans` (

  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  "loan" int(11) NOT NULL,
  "creditValue" INT(11) NOT NULL,
  "amountPayedBack" INT(11) NOT NULL,

  PRIMARY KEY (`id`)
);
