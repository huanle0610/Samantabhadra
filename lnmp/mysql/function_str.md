## 字符串操作
- concat substring_index instr

    ```html
    mysql> select concat('abc',"-def") as mn;
    +---------+
    | mn      |
    +---------+
    | abc-def |
    +---------+
    1 row in set (0.00 sec)
    ```

- substring_index

    ```html
    mysql> select substring_index('abc-abc-ccc','-',1) as mn;
    +-----+
    | mn  |
    +-----+
    | abc |
    +-----+
    1 row in set (0.00 sec)
    
    mysql> select substring_index('abc-abc-ccc','-',2) as mn;
    +---------+
    | mn      |
    +---------+
    | abc-abc |
    +---------+
    1 row in set (0.00 sec)
    
    mysql> select substring_index('abc-abc-ccc','-',3) as mn;
    +-------------+
    | mn          |
    +-------------+
    | abc-abc-ccc |
    +-------------+
    1 row in set (0.00 sec)
    ```

- instr

    ```html
    mysql> select instr('abc-def-hello','hel');
    +------------------------------+
    | instr('abc-def-hello','hel') |
    +------------------------------+
    |                            9 |
    +------------------------------+
    1 row in set (0.00 sec)
    ```

- find_in_set

    ```html
    MariaDB [(none)]> select find_in_set(4, '1,2,4');
    +-------------------------+
    | find_in_set(4, '1,2,4') |
    +-------------------------+
    |                       3 |
    +-------------------------+
    1 row in set (0.00 sec)
    
    MariaDB [(none)]> select find_in_set(1, '1,2,4');
    +-------------------------+
    | find_in_set(1, '1,2,4') |
    +-------------------------+
    |                       1 |
    +-------------------------+
    1 row in set (0.00 sec)
    
    MariaDB [(none)]> select find_in_set(11, '1,2,4');
    +--------------------------+
    | find_in_set(11, '1,2,4') |
    +--------------------------+
    |                        0 |
    +--------------------------+
    1 row in set (0.00 sec)
    ```