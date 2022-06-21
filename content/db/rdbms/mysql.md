+++
title = "MySQL"
date =  2020-11-29T18:25:50+05:30
weight = 1
pre = "<i class='devicon-mysql-plain'></i> "
+++


## SQL (Structured Query Language)
- Always case-insensitive (even table and attributes names)
- Semicolon `;` to indicate command termination are _mandatory_ in MySQL terminal
- Use `--` for single-line comment
- `/* */` (multi-line commnents)
- Declarative language

### Glossary 
- **Relation** (Table)
- **Attributes**, **Fields** (Columns), **Degree** (no. of attributes)
- **Tuple** (Rows), **Cardinality** (no. of tuples)

### Types of Commands
- DDL (create, alter, truncate) (modifies schema)
- DML (insert, delete, update) (modifies table data)
- DCL (grant, revoke)
- DQL (select)
- TCL (rollback, commit, savepoint)

### Storage Engines
https://www.mysqltutorial.org/understand-mysql-table-types-innodb-myisam.aspx

The internal engine that runs stuff and we can leverage many features of different engines available. We can also specify a different engine to use for different tables.

A total of 9 storage engines are available in MySQL. Postgres has only 1.

Default is: **InnoDB**

### Logging into the MySQL Server
```sh
$ mysql -u username -p
Enter Password: ******** 
```

### Databses
```sql
CREATE DATABASE [IF NOT EXISTS] db_name;
DROP DATABASE [IF EXISTS] db_name;

SHOW DATABASES;

USE db_name;
```

#### Importing an external DB
`SOURCE c:\path\to\db_name.sql`

### Data Types
https://www.tutorialspoint.com/mysql/mysql-data-types.htm

### CREATE TABLE

```sql
CREATE TABLE [IF NOT EXISTS] table_name(
   column_1_definition,
   column_2_definition,
   ...,
   table_constraints
) ENGINE=storage_engine;
```

```sql
CREATE TABLE employee(
emp_id INT PRIMARY KEY,
emp_name VARCHAR(50),
doj DATE,
);
```

```sql
CREATE TABLE t_name(
serial_no INT NOT NULL AUTO_INCREMENT, -- PRIMARY KEY (alternatively)
emp_id INT NOT NULL,
emp_name VARCHAR(25) NOT NULL,
doj DATE,
PRIMARY KEY (emp_id)    --single column only, multiple => CONSTRAINT combined_pk_alias PRIMARY KEY (ID,LastName)
);
```

#### CREATE TABLE AS
```sql
CREATE TABLE TestTable AS
SELECT customername, contactname
FROM customers;
```
(\*Creating one table from another by projection, this copies row data too)
```sql
CREATE TABLE emp1 AS
SELECT * FROM emp 
WHERE 1=2;  --false condition; no data from where clause
```
(\*Copying only the schema)

### DROP TABLE 
`DROP TABLE [IF EXISTS] t_name, t2_name;` or simply `DROP TABLE t_name;`
(delete data as well as schema)

### TRUNCATE
`TRUNCATE TABLE t_name;`
(delete all data but keep schema)

### DESCRIBE
`DESCRIBE table_name;` 
(display the schema of the table)

### ALTER TABLE
```sql
ALTER TABLE t_name
ADD c_name varchar(10)
[ FIRST | AFTER column_name],
ADD c2_name varchar(100)
[ FIRST | AFTER column_name];
```
```sql
ALTER TABLE t_name
MODIFY c_name varchar(20),
MODIFY c2_name varchar(90);
```
```sql
ALTER TABLE t_name
CHANGE COLUMN old_name new_name
[ FIRST | AFTER column_name];
```
```sql
ALTER TABLE t_name
DROP COLUMN c_name;
```
```sql
ALTER TABLE t_name
RENAME TO new_t_name;
```

In Postgres, `MODIFY` isn't avaialble but `RENAME COLUMN`, `ADD COLUMN`, `ALTER COLUMN` are. Differs slightly based on different providers.

### RENAME TABLE
`RENAME TABLE old_table_name TO new_table_name;`

(\*for renaming temporary tables use ALTER TABLE RENAME TO)

### INSERT INTO
```sql
INSERT INTO t_name(attrib1, attrib2, ... attribN)
VALUES
(v11,v12,...), 
(v21,v22,...), 
... 
(vnn,vn2,...);

-- No need to specify attribute list if filling all attributes:
INSERT INTO t_name VALUES (value1, value2, ... valueN);
```

### SELECT
```sql
SELECT [DISTINCT] Attribute_List FROM T1,T2…TM
[WHERE condition1 [AND/OR... condition2]]
[GROUP BY (Attributes)[HAVING condition]]
[ORDER BY(Attributes)[ASC/DESC]];
```

(Uses `ASC` by default)

**Operators in WHERE** <br>
   - **Relational** (=, !=, <, >, <=, >=) <br>
   - condition1 **AND/OR/NOT** condition2 ... and so on.. <br>
   - **LIKE/NOT LIKE** `SELECT * FROM Customers WHERE City LIKE 's%';` (`%` = \*, `_` = .) Case-insensitive`ILIKE` also available in Postgres. Escape sequences can also be used `LIKE '__\%'`, matches `99%` <br>

   - **BETWEEN, NOT BETWEEN** `SELECT * FROM Products WHERE Price BETWEEN 50 AND 60;` <br>
   - **IN/NOT IN** `SELECT * FROM Customers WHERE City IN ('Paris','London');` (Ex - `IN (subquery)`) <br>
   - **IS NULL/IS NOT NULL** `SELECT column_names FROM table_name WHERE column_name IS NULL;` <br> 

### LIMIT / OFFSET
It limits the result-set (`WHERE` clause's output) which may or may not be the final output (projection).

```sql
SELECT field1, field2,...fieldN 
FROM table_name1, table_name2...
[WHERE Clause]
[LIMIT N] [OFFSET M ]
```

```sql
SELECT field1, field2,...fieldN 
FROM table_name1, table_name2...
[WHERE Clause]
LIMIT [offset_value,] limit_value
```

```sql
select long_w from station 
where lat_n > 38 order by lat_n asc limit 1;

-- selects long_w for a (single) smallest lat_n greater than 38
```

### FETCH
Same effect as `OFFSET` and `LIMIT`. Requires `ORDER BY` clause in order to to get consistent output. No commas just like `LIMIT OFFSET`.
```sql
ORDER BY foo,   -- required
OFFSET m {ROW | ROWS}
FETCH [FIRST | NEXT] n {ROW | ROWS} ONLY;
```

### UPDATE
```sql
UPDATE table_name 
SET field1 = value1, 
field2 = value2
[WHERE Clause]
```
### DELETE FROM
```sql
DELETE FROM table_name 
[WHERE Clause]
```
### Aggregate Functions
- **MIN(), MAX()** `SELECT MIN(marks_maths) FROM RESULT-2020 WHERE BATCH='OP1'`
    ```sql
    SELECT MIN(Price) AS SmallestPrice
    FROM Products; 
    ```
- **COUNT(), AVG(), SUM()**
 
### Arithmetic Operations
```sql
SELECT name, price * 0.25 from items;
SELECT name, ROUND(price - (price * 0.25), 2) from items;   -- scale = 2, ROUND(expr, scale)

SELECT name, ROUND(price - (price * 0.25), 2) AS discounted_price from items;   -- aliasing column
```

### COALESCE()
Returns first non-null value from the left among the arguments.
```sql
SELECT COALESCE(null, null, 1, 10) from customers;      -- 1

SELECT COALESCE(is_smoker, 'No') from customers;
```

### ALIAS

```sql
# Column Aliases
SELECT price AS cost FROM table;

SELECT price cost FROM table;        -- ommitting AS
```

```sql
# Table Aliases
SELECT item, price FROM table AS t;

SELECT item, price FROM table t;     -- ommitting AS
```

### GROUP BY 
Used in conjunction with aggregate functions. To group their results together based on a particular column.

```sql
SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country    -- count() is grouped
```
(\*we can skip `Country` from projection but that doesn't make any sense)

### HAVING
The `WHERE` clause places conditions on the selected table columns, whereas the `HAVING` clause places conditions on groups (query result columns) created by the `GROUP BY` clause or aggregate functions. We can't have `HAVING` without `GROUP BY`.
```sql
SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country
HAVING Country = 'USA'
ORDER BY COUNT(CustomerID) DESC;
```

### ORDER BY
Orders by any column(s). It sorts the result-set (`WHERE` clause's output) and not the final projection, thus the columns in `ORDER BY` clause need not be present in the final projection attribute list.
```sql
select long_w from station 
where lat_n < 137 order by lat_n desc limit 1;

-- gets the (single) maximum lat_n less than 137 and displays corresponding long_w
```

### EXISTS
The `EXISTS` operator returns true if the subquery returns one or more records, else false.
```sql
SELECT SupplierName
FROM Suppliers
WHERE EXISTS (SELECT ProductName FROM Products WHERE Products.SupplierID = Suppliers.supplierID AND Price < 20);
```
### ANY, ALL
They return actual value if even one match is there in subquery and all matches in subquery respectively.
```sql
SELECT ProductName 
FROM Products
WHERE ProductID >= ANY (SELECT ProductID FROM OrderDetails WHERE Quantity = 10);
```

### REGEXP
```sql
SELECT first_name FROM person_tbl WHERE first_name REGEXP '^a.*';
```
### SELECT INTO
Insert attributes into new table from an existing one.
```sql
SELECT column1, column2, column3, ...
INTO newtable [IN externaldb]
FROM oldtable
WHERE condition;
```
### INSERT INTO SELECT
Insert data from matching corresponding attributes from one table to another.
```sql
INSERT INTO table2 (column1, column2, column3, ...)
SELECT column1, column2, column3, ...
FROM table1
WHERE condition;
```
### CASE
```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END
```
```sql
SELECT OrderID, Quantity,
CASE WHEN Quantity > 30 THEN 'The quantity is greater than 30'
WHEN Quantity = 30 THEN 'The quantity is 30'
ELSE 'The quantity is under 30'
END AS QuantityText
FROM OrderDetails;
```

### JOINS
- Inner
- Outer
    - Left
    - Right
    - Full
 - Self
  
https://www.mysqltutorial.org/mysql-join/
https://www.geeksforgeeks.org/sql-join-set-1-inner-left-right-and-full-joins/
https://www.geeksforgeeks.org/sql-join-cartesian-join-self-join/

### UNION, UNION ALL, INTERSECT, MINUS 
```sql
SELECT column_name(s) FROM table1
UNION / UNION ALL
SELECT column_name(s) FROM table2;
```
(\* `UNION ALL` keeps duplicate tuples whereas `UNION` does not)

- Each SELECT statement within UNION must have the same number of columns
- The columns must also have similar data types
- The columns in each SELECT statement must also be in the same order

```sql
SELECT City, Country FROM Customers
WHERE Country='Germany'
UNION
SELECT City, Country FROM Suppliers
WHERE Country='Germany'
ORDER BY City;	--applies to whole union-ed table
```

### DCL
```sql
savepoint save_name;
rollback to save_name;
rollback;   --rolls back to latest savepoint
commit;     --cannot rollback after a commit
```

### SQL Constraints
Around 9 constraints are listed below.

- **PRIMARY KEY** (Not Null + Unique)
```sql
CREATE TABLE demo(
id int NOT NULL PRIMARY KEY,	--column level since single PK
name varchar(20)
);
```

```sql
CREATE TABLE demo(
id int,
name varchar(20),
PRIMARY KEY(id)
);
```
```sql
CREATE TABLE demo(
name varchar(20),
id int NOT NULL,
[CONSTRAINT key_alias] PRIMARY KEY(name, id) 		--table level since multiple PK, single also allowed
);
```

- **FOREIGN KEY** (Uniquely identifies a row/record in another table)

```sql
PersonID int FOREIGN KEY REFERENCES Persons(PersonID)       -- column level

FOREIGN KEY (PersonID) REFERENCES Persons(PersonID)         -- table level; same effect as above

CONSTRAINT FK_PersonOrder FOREIGN KEY (PersonID) REFERENCES Persons(PersonID)   -- same but uses CONSTRAINT keyword; table level 
```

- **UNIQUE**
- **NOT NULL**
- **CHECK** (Ensures that all values satisfy a specific condition)
 `CHECK(salary >= 3)` 
```sql
Age int CHECK(Age >= 18)       -- column level; single column check

CONSTRAINT CHK_Person CHECK (Age >= 18 AND City = 'Seattle')   -- table level; multiple column check
```
- **DEFAULT** (Sets a default value for a column when no value is specified)
  `DEFAULT "John Doe"`
- **INDEX**
- **ENUM** or **SET** (Only values in enum or set are allowed)

```sql
CREATE TABLE t_name (
    col1 int NOT NULL UNIQUE,
    col2 varchar(255) DEFAULT 3,
    col3 varchar(255),
    col4 int,
    
);
```

#### ALTER TABLE to apply Constraints later
```sql
ALTER  TABLE demo 
ADD PRIMARY KEY(id);

ALTER TABLE Persons
ADD CHECK (Age >= 18);

ALTER TABLE demo
DROP PRIMARY KEY;
```


### Built-in Functions
- `left(str, n)` and `right(str, n)`: Substringing from left and right respectively.
- `round(expr, scale)`: Rounding decimal
- `abs(expr)`: Returns absolute value
- `pow(expr, exponent)`: Raise expression to exponent power

### Aggregation

### Indexes

### Foreign Key Constraint, Joins, Normalization