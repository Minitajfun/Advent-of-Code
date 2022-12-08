-- Data import
CREATE TABLE dummy (d BOOLEAN);
LOAD DATA LOCAL INFILE '/path/to/input/file' INTO TABLE dummy (@input);

-- Create common procedure
DELIMITER //
CREATE PROCEDURE FindUniq(input VARCHAR(5000), uniq_needed INT)
BEGIN
	SET @i = 0;
	CREATE TABLE ecode(c CHAR);
    lf : LOOP
		SET @i = @i + 1;
		INSERT INTO ecode VALUES (SUBSTR(input, @i, 1));
        IF @i!=uniq_needed THEN
			ITERATE lf;
        END IF;
		LEAVE lf;
    END LOOP lf;
    SET @l = LENGTH(input);
    lp : LOOP
        IF (SELECT COUNT(DISTINCT c) FROM ecode)=uniq_needed THEN
			LEAVE lp;
        END IF;
		SET @i = @i + 1;
        DELETE FROM ecode LIMIT 1;
        INSERT INTO ecode(c) VALUES (SUBSTR(input, @i, 1));
		ITERATE lp;
    END LOOP lp;
	DROP TABLE ecode;
	SELECT @i AS 'Output';
END//
DELIMITER ;

-- Part 1
CALL FindUniq(@input, 4);

-- Part 2
CALL FindUniq(@input, 14);

-- Finish
DROP PROCEDURE FindUniq;
DROP TABLE dummy;