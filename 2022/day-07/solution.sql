USE AoC;

DROP TABLE IF EXISTS inputtable;
DROP TABLE IF EXISTS dirs;
DROP TABLE IF EXISTS files;
DROP PROCEDURE IF EXISTS FillTables;
DROP PROCEDURE IF EXISTS SetDirSizes;
CREATE TEMPORARY TABLE inputtable (id INT PRIMARY KEY AUTO_INCREMENT, input VARCHAR(200));
LOAD DATA LOCAL INFILE '/path/to/input' INTO TABLE inputtable FIELDS TERMINATED BY 'extremelylongstringpreventingfieldseparation' IGNORE 1 LINES (input);

CREATE TABLE dirs(id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(50), parent INT, size INT DEFAULT 0);
CREATE TABLE files(id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(50), location INT, size INT NOT NULL DEFAULT 0);

DELIMITER //

-- Part 1
CREATE PROCEDURE FillTables ()
BEGIN
	SET @i = 0;
    SET @len = (SELECT COUNT(*) FROM inputtable);
    SET @pos = 1;
    INSERT INTO dirs(name, parent) VALUES ('/', -1);
    lf : LOOP
		SET @i = @i + 1;
        SET @str = (SELECT input FROM inputtable WHERE id=@i);
        IF @str LIKE '$ cd %' THEN
			IF @str='$ cd ..' THEN
				SELECT parent INTO @pos FROM dirs WHERE id=@pos LIMIT 1;
            ELSE
				SELECT id INTO @pos FROM dirs WHERE parent=@pos AND name=SUBSTRING(@str, 6);
			END IF;
		ELSEIF @str LIKE '$ ls' THEN
			ITERATE lf;
		ELSEIF @str LIKE 'dir %' THEN
			INSERT INTO dirs(name, parent) VALUES (SUBSTRING(@str, 5), @pos);
		ELSE
            INSERT INTO files(name, location, size) VALUES (SUBSTRING_INDEX(@str, ' ', -1), @pos, SUBSTRING_INDEX(@str, ' ', 1));
        END IF;
        IF @i<@len THEN
			ITERATE lf;
        END IF;
		LEAVE lf;
    END LOOP lf;
END//

CREATE PROCEDURE SetDirSizes(IN dirid VARCHAR(50), OUT dirsize INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE output INT DEFAULT 0;
    SET @@SESSION.max_sp_recursion_depth = 255;
	SET output=IFNULL((SELECT SUM(size) FROM files WHERE location=dirid), 0);
    SELECT COUNT(*) INTO i FROM dirs WHERE parent=dirid;
    lp : LOOP
		SET i = i-1;
        IF i<0 THEN
			LEAVE lp;
        END IF;
        CALL SetDirSizes((SELECT id FROM dirs WHERE parent=dirid LIMIT 1 OFFSET i), @childsize);
--      IF output=0 THEN
-- 			SELECT selname, output, output+@childsize;
-- 		END IF;
        SET output=output+@childsize;
        ITERATE lp;
    END LOOP lp;
    SET dirsize = output;
    UPDATE dirs SET size=output WHERE id=dirid;
END//

DELIMITER ;

CALL FillTables;
CALL SetDirSizes(1, @_);

SELECT SUM(size) AS 'Part 1' FROM dirs WHERE size <= 100000;
SELECT size AS 'Part 2' FROM dirs WHERE size >= (SELECT 30000000 - (70000000 - size) FROM dirs WHERE id=1) ORDER BY size ASC LIMIT 1;