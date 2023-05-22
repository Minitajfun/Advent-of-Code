-- Data setup
CREATE TABLE rucksack (items VARCHAR(100), num INT PRIMARY KEY AUTO_INCREMENT);
LOAD DATA LOCAL INFILE '/path/to/input/file' INTO TABLE rucksack;
CREATE TABLE rucksack_split (top VARCHAR(50), bottom VARCHAR(50), num INT PRIMARY KEY AUTO_INCREMENT, cib CHAR, cib2 CHAR);
INSERT INTO rucksack_split(top, bottom) SELECT LEFT(items, LENGTH(items)/2), RIGHT(items, LENGTH(items)/2) FROM rucksack;

-- Part 1
DELIMITER //
CREATE PROCEDURE Part1()
BEGIN
	CREATE TABLE top_char_split (c CHAR);
	CREATE TABLE bottom_char_split (c CHAR);
    SET @sum = 0;
    SET @i = 0;
    fl: LOOP
		SET @j = 0;
        SET @i = @i + 1;
		DELETE FROM top_char_split;
		DELETE FROM bottom_char_split;
        sl: LOOP
			SET @j = @j + 1;
            INSERT INTO top_char_split(c) VALUES ((SELECT SUBSTR(top, @j, 1) FROM rucksack_split WHERE num=@i LIMIT 1));
            INSERT INTO bottom_char_split(c) VALUES ((SELECT SUBSTR(bottom, @j, 1) FROM rucksack_split WHERE num=@i LIMIT 1));
            IF @j < (SELECT LENGTH(top) FROM rucksack_split WHERE num=@i LIMIT 1) THEN
				ITERATE sl;
            END IF;
            LEAVE sl;
        END LOOP sl;
        IF EXISTS (SELECT 1 FROM top_char_split t INNER JOIN bottom_char_split b ON t.c=b.c COLLATE utf8mb4_bin) THEN
			UPDATE rucksack_split SET cib=(SELECT t.c FROM top_char_split t INNER JOIN bottom_char_split b ON t.c=b.c COLLATE utf8mb4_bin LIMIT 1) WHERE num=@i;
			SET @sum = @sum + (SELECT ASCII(t.c)-IF(ASCII(t.c)>96, 96, 38) FROM top_char_split t INNER JOIN bottom_char_split b ON t.c=b.c COLLATE utf8mb4_bin LIMIT 1);
        END IF;
		IF @i < (SELECT COUNT(*) FROM rucksack_split) THEN
			ITERATE fl;
		END IF;
        LEAVE fl;
    END LOOP fl;
    DROP TABLE top_char_split;
    DROP TABLE bottom_char_split;
	SELECT @sum;
END//
DELIMITER ;
CALL Part1;

-- Part 2
DELIMITER //
CREATE PROCEDURE Part2()
BEGIN
	CREATE TABLE rs_one (c CHAR);
	CREATE TABLE rs_two (c CHAR);
	CREATE TABLE rs_tre (c CHAR);
    SET @sum = 0;
    SET @i = 0;
    fl: LOOP
		DELETE FROM rs_one;
		DELETE FROM rs_two;
		DELETE FROM rs_tre;
        SET @i = @i + 1;
		SET @j = 0;
        fo: LOOP
			SET @j = @j + 1;
            INSERT INTO rs_one(c) VALUES ((SELECT SUBSTR(items, @j, 1) FROM rucksack WHERE num=@i LIMIT 1));
            IF @j < (SELECT LENGTH(items) FROM rucksack WHERE num=@i LIMIT 1) THEN
				ITERATE fo;
            END IF;
            LEAVE fo;
        END LOOP fo;
        SET @i = @i + 1;
		SET @j = 0;
        ft: LOOP
			SET @j = @j + 1;
            INSERT INTO rs_two(c) VALUES ((SELECT SUBSTR(items, @j, 1) FROM rucksack WHERE num=@i LIMIT 1));
            IF @j < (SELECT LENGTH(items) FROM rucksack WHERE num=@i LIMIT 1) THEN
				ITERATE ft;
            END IF;
            LEAVE ft;
        END LOOP ft;
        SET @i = @i + 1;
		SET @j = 0;
        fr: LOOP
			SET @j = @j + 1;
            INSERT INTO rs_tre(c) VALUES ((SELECT SUBSTR(items, @j, 1) FROM rucksack WHERE num=@i LIMIT 1));
            IF @j < (SELECT LENGTH(items) FROM rucksack WHERE num=@i LIMIT 1) THEN
				ITERATE fr;
            END IF;
            LEAVE fr;
        END LOOP fr;
		IF EXISTS (SELECT 1 FROM rs_one _one INNER JOIN rs_two _two ON _one.c=_two.c COLLATE utf8mb4_bin INNER JOIN rs_tre _tre ON _two.c=_tre.c COLLATE utf8mb4_bin) THEN
			SET @sum = @sum + (SELECT ASCII(_one.c)-IF(ASCII(_one.c)>96, 96, 38) FROM rs_one _one INNER JOIN rs_two _two ON _one.c=_two.c COLLATE utf8mb4_bin INNER JOIN rs_tre _tre ON _two.c=_tre.c COLLATE utf8mb4_bin LIMIT 1);
        END IF;
		IF @i < (SELECT COUNT(*) FROM rucksack_split) THEN
			ITERATE fl;
		END IF;
        LEAVE fl;
    END LOOP fl;
	DROP TABLE rs_one;
	DROP TABLE rs_two;
	DROP TABLE rs_tre;
	SELECT @sum;
END//
DELIMITER ;
CALL Part2;

-- Finish
DROP TABLE rucksack;
DROP TABLE rucksack_split;
DROP PROCEDURE IF EXISTS Part1;
DROP PROCEDURE IF EXISTS Part2;