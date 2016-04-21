# 变量

- 变量定义
mysql存储过程中，定义变量有两种方式：
1. 会话变量
    使用set或select直接赋值，变量名以 @ 开头，可以在一个会话的任何地方声明，作用域是整个会话，称为会话变量。
    如:set @var=1;
2. 存储过程变量
    以 DECLARE 关键字声明的变量，只能在存储过程中使用，称为存储过程变量，主要用在存储过程中，或者是给存储传参数中。
    如：DECLARE var1 INT DEFAULT 0;

3. 两者的区别
	* 在调用存储过程时，以DECLARE声明的变量都会被初始化为 NULL。
	* 会话变量（即@开头的变量）则不会被再初始化，在一个会话内，只须初始化一次，之后在会话内都是对上一次计算的结果，就相当于在是这个会话内的全局变量。
	* 在存储过程中，使用动态语句，预处理时，动态内容必须赋给一个会话变量。


# 函数实例

- 查询是否有库存

```html
CREATE FUNCTION `sakila`.`inventory_in_stock`(p_inventory_id INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    #AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    #FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END
```


```html
CREATE FUNCTION `sakila`.`get_customer_balance`(p_customer_id INT, p_effective_date DATETIME) RETURNS DECIMAL(5,2)
    DETERMINISTIC
    READS SQL DATA
BEGIN

       #OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       #THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       #   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       #   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       #   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       #   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED

  DECLARE v_rentfees DECIMAL(5,2); #FEES PAID TO RENT THE VIDEOS INITIALLY
  DECLARE v_overfees INTEGER;      #LATE FEES FOR PRIOR RENTALS
  DECLARE v_payments DECIMAL(5,2); #SUM OF PAYMENTS MADE PREVIOUSLY

  SELECT IFNULL(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

  SELECT IFNULL(SUM(IF((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) > film.rental_duration,
        ((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) - film.rental_duration),0)),0) INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;


  SELECT IFNULL(SUM(payment.amount),0) INTO v_payments
    FROM payment

    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

  RETURN v_rentfees + v_overfees - v_payments;
END
```



# 存储过程

- 简单的

```html
DELIMITER $$

USE `sakila`$$

DROP PROCEDURE IF EXISTS `film_in_stock`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT FOUND_ROWS() INTO p_film_count;
END$$

DELIMITER ;
```

- 用到了临时表的存储过程

```html
DELIMITER $$

USE `sakila`$$

DROP PROCEDURE IF EXISTS `rewards_report`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rewards_report`(
    IN min_monthly_purchases TINYINT UNSIGNED
    , IN min_dollar_amount_purchased DECIMAL(10,2) UNSIGNED
    , OUT count_rewardees INT
)
    READS SQL DATA
    COMMENT 'Provides a customizable report on best customers'
proc: BEGIN

        DECLARE last_month_start DATE;
        DECLARE last_month_end DATE;
    
        /* Some sanity checks... */
        IF min_monthly_purchases = 0 THEN
            SELECT 'Minimum monthly purchases parameter must be > 0';
            LEAVE proc;
        END IF;
        IF min_dollar_amount_purchased = 0.00 THEN
            SELECT 'Minimum monthly dollar amount purchased parameter must be > $0.00';
            LEAVE proc;
        END IF;
    
        /* Determine start and end time periods */
        SET last_month_start = DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH);
        SET last_month_start = STR_TO_DATE(CONCAT(YEAR(last_month_start),'-',MONTH(last_month_start),'-01'),'%Y-%m-%d');
        SET last_month_end = LAST_DAY(last_month_start);
    
        /* 
            Create a temporary storage area for 
            Customer IDs.  
        */
        CREATE TEMPORARY TABLE tmpCustomer (customer_id SMALLINT UNSIGNED NOT NULL PRIMARY KEY);
    
        /* 
            Find all customers meeting the 
            monthly purchase requirements
        */
        INSERT INTO tmpCustomer (customer_id)
        SELECT p.customer_id 
        FROM payment AS p
        WHERE DATE(p.payment_date) BETWEEN last_month_start AND last_month_end
        GROUP BY customer_id
        HAVING SUM(p.amount) > min_dollar_amount_purchased
        AND COUNT(customer_id) > min_monthly_purchases;
    
        /* Populate OUT parameter with count of found customers */
        SELECT COUNT(*) FROM tmpCustomer INTO count_rewardees;
    
        /* 
            Output ALL customer information of matching rewardees.
            Customize output as needed.
        */
        SELECT c.* 
        FROM tmpCustomer AS t   
        INNER JOIN customer AS c ON t.customer_id = c.customer_id;
    
        /* Clean up */
        DROP TABLE tmpCustomer;
END$$

DELIMITER ;
```

- 用到了事务,可以回滚

```html
DELIMITER $$

USE `test`$$

DROP PROCEDURE IF EXISTS `SP_User_Batch_Insert`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_User_Batch_Insert`(IN _batchValues LONGTEXT CHARACTER SET utf8)
BEGIN
	DECLARE ErrorCode INT DEFAULT 1;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET ErrorCode = 0;
	START TRANSACTION;
	
	IF ErrorCode = 1 AND TRIM(_batchValues) <> "" THEN 
	   SET @composeSQL = CONCAT("INSERT INTO `test`.`user` (`uid`, `first`, `last`) VALUES ", _batchValues);
	   	
	   PREPARE executeSQL FROM @composeSQL;
	   EXECUTE executeSQL ;
	   DEALLOCATE PREPARE executeSQL;  
	END IF;
    
	IF ErrorCode <> 1 THEN
	   ROLLBACK;
	ELSE
	   COMMIT;
	END IF;
	SELECT ErrorCode; 
END$$

DELIMITER ;
```



# PREPARE, EXECUTE, and DEALLOCATE PREPARE Statements

```html
mysql> PREPARE stmt1 FROM 'SELECT SQRT(POW(?,2) + POW(?,2)) AS hypotenuse';
mysql> SET @a = 3;
mysql> SET @b = 4;
mysql> EXECUTE stmt1 USING @a, @b;
+------------+
| hypotenuse |
+------------+
|          5 |
+------------+
mysql> DEALLOCATE PREPARE stmt1;
```


# 触发器实例

```html
DELIMITER $$

USE `sakila`$$

DROP TRIGGER IF EXISTS `upd_film`$$

CREATE
    DEFINER = 'root'@'localhost'
    TRIGGER `upd_film` AFTER UPDATE ON `film` 
    FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END;
$$

DELIMITER ;
```


# full example from book

```html
DELIMITER $$
DROP PROCEDURE IF EXISTS mylibrary.categories_insert$$
CREATE PROCEDURE `mylibrary`.`categories_insert`(IN newcatname VARCHAR(60), IN parent INT, OUT newid INT)
proc: BEGIN

  DECLARE cnt INT;

  SET newid=-1;



  -- basic validation

  SELECT COUNT(*) FROM categories 

  WHERE parentCatID=parent INTO cnt;

  IF ISNULL(newcatname) OR TRIM(newcatname)="" OR cnt=0 THEN

    LEAVE proc;

  END IF;



  -- test if category already exists

  SELECT COUNT(*) FROM categories 

  WHERE parentCatID=parent AND catName=newcatname 

  INTO cnt;

  IF cnt=1 THEN 

    SELECT catID FROM categories 

    WHERE parentCatID=parent AND catName=newcatname 

    INTO newid;

    LEAVE proc; 

  END IF;



  -- actually insert new category

  INSERT INTO categories (catName, parentCatID)

  VALUES (newcatname, parent);

  SET newid = LAST_INSERT_ID();

END proc$$

DROP PROCEDURE IF EXISTS mylibrary.cursortest$$
CREATE PROCEDURE `mylibrary`.`cursortest`(OUT avg_len DOUBLE)
BEGIN

  DECLARE t, subt VARCHAR(100);

  DECLARE done INT DEFAULT 0;

  DECLARE n BIGINT DEFAULT 0;

  DECLARE cnt INT;



  DECLARE mycursor CURSOR FOR 

    SELECT title, subtitle FROM titles;



  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;



  SELECT COUNT(*) FROM titles INTO cnt;

  OPEN mycursor;

  myloop: LOOP

    FETCH mycursor INTO t, subt;

    IF done=1 THEN LEAVE myloop; END IF;

    SET n = n + CHAR_LENGTH(t);

    IF NOT ISNULL(subt) THEN

      SET n = n + CHAR_LENGTH(subt);

    END IF;

  END LOOP myloop;

  SET avg_len = n/cnt;

END$$
DROP FUNCTION IF EXISTS mylibrary.faculty$$
CREATE FUNCTION `mylibrary`.`faculty`(n BIGINT) RETURNS BIGINT
BEGIN

  IF n>=2 THEN

    RETURN n * faculty(n-1);

  ELSE

    RETURN n;

  END IF;

END$$

DROP PROCEDURE IF EXISTS mylibrary.find_subcategories$$
CREATE PROCEDURE `mylibrary`.`find_subcategories`(IN id INT, IN cname VARCHAR(60), IN catlevel INT, INOUT catrank INT)
BEGIN

  DECLARE done INT DEFAULT 0;

  DECLARE subcats CURSOR FOR 

    SELECT catID, catName FROM categories WHERE parentCatID=id

    ORDER BY catname;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;


  OPEN subcats;

  subcatloop: LOOP

    FETCH subcats INTO id, cname;

    IF done=1 THEN LEAVE subcatloop; END IF;

    SET catrank = catrank+1;

    INSERT INTO __subcats VALUES (catrank, catlevel, id, cname);

    CALL find_subcategories(id, cname, catlevel+1, catrank);

  END LOOP subcatloop;

  CLOSE subcats;

END$$
DROP PROCEDURE IF EXISTS mylibrary.get_parent_categories$$
CREATE PROCEDURE `mylibrary`.`get_parent_categories`(startid INT)
BEGIN

  DECLARE i, id, pid, cnt INT DEFAULT 0;

  DECLARE cname VARCHAR(60);



  DROP TABLE IF EXISTS __parent_cats;

  CREATE TEMPORARY TABLE __parent_cats 

    (LEVEL INT, catID INT, catname VARCHAR(60)) ENGINE = HEAP;



  main: BEGIN 

    -- test if startid is OK

    SELECT COUNT(*) FROM categories WHERE catID=startID INTO cnt;

    IF cnt=0 THEN LEAVE main; END IF;



    -- insert start category into new table

    SELECT catID, parentCatID, catName 

    FROM categories WHERE catID=startID 

    INTO id, pid, cname;

    INSERT INTO __parent_cats VALUES(i, id, cname);



    -- loop until root of categories is reached

    parentloop: WHILE NOT ISNULL(pid) DO

      SET i=i+1;

      SELECT catID, parentCatID, catName 

      FROM categories WHERE catID=pid 

      INTO id, pid, cname;

      INSERT INTO __parent_cats VALUES(i, id, cname);

    END WHILE parentloop;

  END main;



  SELECT catID, catname FROM __parent_cats ORDER BY LEVEL DESC;

  DROP TABLE __parent_cats;

END$$
DROP PROCEDURE IF EXISTS mylibrary.get_subcategories$$
CREATE PROCEDURE `mylibrary`.`get_subcategories`(IN startid INT, OUT n INT)
BEGIN

  DECLARE cnt INT;

  DECLARE cname VARCHAR(60);

  DROP TABLE IF EXISTS __subcats;

  CREATE TEMPORARY TABLE __subcats

    (rank INT, LEVEL INT, catID INT, catname VARCHAR(60)) ENGINE = HEAP;

  SELECT COUNT(*) FROM categories WHERE catID=startID INTO cnt;

  IF cnt=1 THEN 

    SELECT catname FROM categories WHERE catID=startID INTO cname;

    INSERT INTO __subcats VALUES(0, 0, startid, cname);

    CALL find_subcategories(startid, cname, 1, 0);

  END IF;

  SELECT COUNT(*) FROM __subcats INTO n;

END$$
DROP PROCEDURE IF EXISTS mylibrary.get_title$$
CREATE PROCEDURE `mylibrary`.`get_title`(IN id INT)
BEGIN

  SELECT title, subtitle, publName 

  FROM titles, publishers 

  WHERE titleID=id 

  AND titles.publID = publishers.publID;

END$$
DROP FUNCTION IF EXISTS mylibrary.shorten$$
CREATE FUNCTION `mylibrary`.`shorten`(s VARCHAR(255), n INT) RETURNS VARCHAR(255)
BEGIN
  IF ISNULL(s) THEN
    RETURN '';
  ELSEIF n<15 THEN
    RETURN LEFT(s, n);
  ELSE
    IF CHAR_LENGTH(s) <= n THEN
      RETURN s;
    ELSE
      RETURN CONCAT(LEFT(s, n-10), ' ... ', RIGHT(s, 5));
    END IF;
  END IF;
  
END$$
DROP FUNCTION IF EXISTS mylibrary.swap_name$$
CREATE FUNCTION `mylibrary`.`swap_name`(s VARCHAR(100)) RETURNS VARCHAR(100)
BEGIN

  DECLARE pos, clen INT;

  SET s = TRIM(s);

  SET clen = CHAR_LENGTH(s);

  SET pos =  LOCATE(" ", REVERSE(s));

  IF pos = 0 THEN RETURN s; END IF;

  SET pos = clen-pos;

  RETURN CONCAT(SUBSTR(s, pos+2), " ", LEFT(s, pos));

END$$
DROP PROCEDURE IF EXISTS mylibrary.titles_insert_all$$
CREATE PROCEDURE `mylibrary`.`titles_insert_all`(IN newtitle VARCHAR(100), IN publ VARCHAR(60), IN authList VARCHAR(255), OUT newID INT)
proc: BEGIN

  DECLARE cnt, pos INT;

  DECLARE aID, pblID, ttlID INT;

  DECLARE author VARCHAR(60);

  SET newID=-1;



  -- publisher

  SELECT COUNT(*) FROM publishers WHERE publname=publ INTO cnt;

  IF cnt=1 THEN

    SELECT publID FROM publishers WHERE publname=publ INTO pblID;

  ELSE

    INSERT INTO publishers (publName) VALUES (publ);

    SET pblID = LAST_INSERT_ID();

  END IF;



  -- insert title

  INSERT INTO titles (title, publID) VALUES (newtitle, pblID);

  SET ttlID = LAST_INSERT_ID();



  -- loop through all authors

  authloop: WHILE NOT (authList="") DO

    SET pos = LOCATE(";", authList);

    IF pos=0 THEN

      SET author = TRIM(authList);

      SET authList ="";

    ELSE

      SET author = TRIM(LEFT(authList, pos-1));

      SET authList = SUBSTR(authList, pos+1);

    END IF;

    IF author = "" THEN ITERATE authloop; END IF;



    -- find author or insert into authors table

    SELECT COUNT(*) FROM AUTHORS 

    WHERE authName=author OR authName=swap_name(author)

    INTO cnt;

    IF cnt>=1 THEN

      SELECT authID FROM AUTHORS 

      WHERE authName=author OR authName=swap_name(author)

      LIMIT 1 INTO aID;

    ELSE

      INSERT INTO AUTHORS (authName) VALUES (author);

      SET aID = LAST_INSERT_ID();

    END IF;



    -- update rel_title_authors

    INSERT INTO rel_title_author (titleID, authID)

    VALUES (ttlID, aID);

  END WHILE authloop;



  -- return value

  SET newID=ttlID;  

END proc$$

DELIMITER ;
```


# 参考
[官方说明](http://dev.mysql.com/doc/refman/5.7/en/create-procedure.html)