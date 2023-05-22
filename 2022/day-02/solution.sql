-- Data setup
CREATE TABLE rpc (en_choice CHAR, my_choice CHAR);
LOAD DATA LOCAL INFILE '/path/to/input/file' INTO TABLE rpc FIELDS TERMINATED BY ' ' LINES TERMINATED BY '\n';
UPDATE rpc SET en_choice=1 WHERE en_choice='A';
UPDATE rpc SET en_choice=2 WHERE en_choice='B';
UPDATE rpc SET en_choice=3 WHERE en_choice='C';
UPDATE rpc SET my_choice=1 WHERE my_choice='X';
UPDATE rpc SET my_choice=2 WHERE my_choice='Y';
UPDATE rpc SET my_choice=3 WHERE my_choice='Z';

-- Part 1
SELECT SUM(CASE WHEN en_choice=my_choice THEN 3 WHEN en_choice=(my_choice-1) OR en_choice=(my_choice+2) THEN 6 ELSE 0 END + my_choice ) as Part1 FROM rpc;

-- Part 2
SELECT SUM((my_choice-1)*3 + IF(en_choice+my_choice-2=0, 3, IF(en_choice+my_choice-2=4, 1, en_choice+my_choice-2))) as Part2 FROM rpc;