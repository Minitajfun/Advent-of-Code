-- Data import
CREATE TABLE input (val VARCHAR(100), id INT PRIMARY KEY AUTO_INCREMENT);
LOAD DATA LOCAL INFILE '/path/to/input/file' INTO TABLE input;

-- Data setup
CREATE TABLE elf_assig (elf1_sec_start INT, elf1_sec_end INT, elf2_sec_start INT, elf2_sec_end INT);
INSERT INTO elf_assig SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(val, ',', 1), '-', 1), SUBSTRING_INDEX(SUBSTRING_INDEX(val, ',', 1), '-', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(val, ',', -1), '-', 1), SUBSTRING_INDEX(SUBSTRING_INDEX(val, ',', -1), '-', -1) FROM input;

-- Part 1
SELECT COUNT(*) FROM elf_assig WHERE (elf1_sec_start >= elf2_sec_start AND elf1_sec_end <= elf2_sec_end) OR (elf1_sec_start <= elf2_sec_start AND elf1_sec_end >= elf2_sec_end);

-- Part 2
SELECT COUNT(*) FROM elf_assig WHERE (elf1_sec_start BETWEEN elf2_sec_start AND elf2_sec_end) OR (elf1_sec_end BETWEEN elf2_sec_start AND elf2_sec_end) OR (elf2_sec_start BETWEEN elf1_sec_start AND elf1_sec_end) OR (elf2_sec_end BETWEEN elf1_sec_start AND elf1_sec_end);

-- Finish
DROP TABLE input;
DROP TABLE elf_assig;