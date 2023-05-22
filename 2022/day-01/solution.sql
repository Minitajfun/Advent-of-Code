-- Data import
CREATE TABLE elves (cals INT NULL, elv_num INT);
LOAD DATA LOCAL INFILE '/path/to/input/file' INTO TABLE elves;

-- Part 1
SELECT en as 'Elf Number', SUM(c) as 'Carried calories' FROM (SELECT @elv_num := @elv_num + (cals=0) as en, cals as c FROM elves, (SELECT @elv_num := 0) m) x GROUP BY en ORDER BY SUM(C) DESC LIMIT 1;

-- Part 2
SELECT SUM(j) FROM (SELECT en, SUM(c) as j FROM (SELECT @elv_num := @elv_num + (cals=0) as en, cals as c FROM elves, (SELECT @elv_num := 0) m) x GROUP BY en ORDER BY SUM(C) DESC LIMIT 3) b;