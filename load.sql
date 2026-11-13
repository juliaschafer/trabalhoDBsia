SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';   -- deve mostrar ON

use dbsia;

LOAD DATA LOCAL INFILE '/Users/juliakellerschafer/Documents/datasus/PARS2607.csv'
INTO TABLE pars
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM pars;