-- Data import
CREATE TABLE moves (id INT AUTO_INCREMENT PRIMARY KEY, amount INT, from_stack INT, to_stack INT);
LOAD DATA LOCAL INFILE '/path/to/input/file' INTO TABLE moves FIELDS TERMINATED BY ' ' LINES TERMINATED BY '\n' IGNORE 10 LINES (@dummy, amount, @dummy, from_stack, @dummy, to_stack);

-- Data setup
CREATE TABLE stacks (stack_num INT, stack VARCHAR(50));
INSERT INTO stacks VALUES -- MANUAL INPUT OF INITIAL STACKS
	(1, ''),
	(2, ''),
	(3, ''),
	(4, ''),
	(5, ''),
	(6, ''),
	(7, ''),
	(8, ''),
	(9, '')
	;
    
-- Part 1
DELIMITER //
CREATE PROCEDURE Part1()
BEGIN
	CREATE TABLE stacks_c LIKE stacks;
    INSERT INTO stacks_c SELECT * FROM stacks;
    
	SET @i = 0;
    lp : LOOP
		SET @i = @i + 1;
        
		SET @amount = (SELECT amount FROM moves WHERE id=@i);
        SET @from = (SELECT from_stack FROM moves WHERE id=@i);
        SET @to = (SELECT to_stack FROM moves WHERE id=@i);
        
        SET @mov = (SELECT RIGHT(stack, @amount) FROM stacks_c WHERE stack_num=@from);
		UPDATE stacks_c SET stack=LEFT(stack, LENGTH(stack)-@amount) WHERE stack_num=@from;
		UPDATE stacks_c SET stack=CONCAT(stack, REVERSE(@mov)) WHERE stack_num=@to;
        
        IF @i < (SELECT COUNT(*) FROM moves) THEN
			ITERATE lp;
        END IF;
		LEAVE lp;
    END LOOP lp;

    SELECT GROUP_CONCAT(RIGHT(stack, 1) SEPARATOR '') as 'Part 1' FROM stacks_c;
    DROP TABLE stacks_c;
END//
DELIMITER ;
CALL Part1;

-- Part 2
DELIMITER //
CREATE PROCEDURE Part2()
BEGIN
	CREATE TABLE stacks_c LIKE stacks;
    INSERT INTO stacks_c SELECT * FROM stacks;
    
	SET @i = 0;
    lp : LOOP
		SET @i = @i + 1;
        
		SET @amount = (SELECT amount FROM moves WHERE id=@i);
        SET @from = (SELECT from_stack FROM moves WHERE id=@i);
        SET @to = (SELECT to_stack FROM moves WHERE id=@i);
        
        SET @mov = (SELECT RIGHT(stack, @amount) FROM stacks_c WHERE stack_num=@from);
		UPDATE stacks_c SET stack=LEFT(stack, LENGTH(stack)-@amount) WHERE stack_num=@from;
		UPDATE stacks_c SET stack=CONCAT(stack, @mov) WHERE stack_num=@to;
        
        IF @i < (SELECT COUNT(*) FROM moves) THEN
			ITERATE lp;
        END IF;
		LEAVE lp;
    END LOOP lp;

    SELECT GROUP_CONCAT(RIGHT(stack, 1) SEPARATOR '') as 'Part 2' FROM stacks_c;
    DROP TABLE stacks_c;
END//
DELIMITER ;
CALL Part2;

-- Finish
DROP PROCEDURE Part1;
DROP PROCEDURE Part2;
DROP TABLE moves;
DROP TABLE stacks;