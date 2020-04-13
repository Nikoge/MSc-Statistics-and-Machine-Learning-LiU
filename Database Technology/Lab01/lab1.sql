/*
Lab 1 report <Thijs Quast (thiqu264), Lennart Schilling (lensc874) > 
*/

/*
Drop all user created tables that have been created when solving the lab
*/

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Own_table CASCADE;
DROP VIEW IF EXISTS debit_costs1 CASCADE;
DROP VIEW IF EXISTS debit_costs2 CASCADE;
DROP VIEW IF EXISTS cheap_items CASCADE;
DROP TABLE IF EXISTS jbcity CASCADE;
DROP TABLE IF EXISTS jbdebit CASCADE;
DROP TABLE IF EXISTS jbdept CASCADE;
DROP TABLE IF EXISTS jbemployee CASCADE;
DROP TABLE IF EXISTS jbitem CASCADE;
DROP TABLE IF EXISTS jbparts CASCADE;
DROP TABLE IF EXISTS jbsale CASCADE;
DROP VIEW IF EXISTS jbsale_supply CASCADE;
DROP TABLE IF EXISTS jbstore CASCADE;
DROP TABLE IF EXISTS jbsupplier CASCADE;
DROP TABLE IF EXISTS jbsupply CASCADE;
SET FOREIGN_KEY_CHECKS = 1;

/* Have the source scripts in the file so it is easy to recreate!*/

SOURCE company_schema.sql;
SOURCE company_data.sql;

/*1) List all employees, i.e. all tuples in the jbemployee relation.*/

SELECT name 
FROM jbemployee;

/*
+--------------------+
| name               |
+--------------------+
| Ross, Stanley      |
| Ross, Stuart       |
| Edwards, Peter     |
| Thompson, Bob      |
| Smythe, Carol      |
| Hayes, Evelyn      |
| Evans, Michael     |
| Raveen, Lemont     |
| James, Mary        |
| Williams, Judy     |
| Thomas, Tom        |
| Jones, Tim         |
| Bullock, J.D.      |
| Collins, Joanne    |
| Brunet, Paul C.    |
| Schmidt, Herman    |
| Iwano, Masahiro    |
| Smith, Paul        |
| Onstad, Richard    |
| Zugnoni, Arthur A. |
| Choy, Wanda        |
| Wallace, Maggie J. |
| Bailey, Chas M.    |
| Bono, Sonny        |
| Schwarz, Jason B.  |
+--------------------+
25 rows in set (0.00 sec)


2) List the name of all departments in alphabetical order. 
   Note: by “name” we mean the name attribute for all tuples in the jbdept relation. */

SELECT name
FROM jbdept
ORDER BY name;

/* 
The output from first version of the lab (including the distint statement) is shown.
Unfortunately, we have not been able to update the output within this file as a comment.
The reason is that the ThinLinc-connection could not be performed successfully.
However, as you can see in the SQL-statement itself, running this script returns you the correct output in which names can appear more than one time.
+------------------+
| name             |
+------------------+
| Bargain          |
| Book             |
| Candy            |
| Children's       |
| Furniture        |
| Giftwrap         |
| Jewelry          |
| Junior Miss      |
| Junior's         |
| Linens           |
| Major Appliances |
| Men's            |
| Sportswear       |
| Stationary       |
| Toys             |
| Women's          |
+------------------+
16 rows in set (0.00 sec)

3) What parts are not in store, i.e. qoh = 0? (qoh = Quantity On Hand)*/

SELECT name
FROM jbparts
WHERE qoh = 0;

/*
+-------------------+
| name              |
+-------------------+
| card reader       |
| card punch        |
| paper tape reader |
| paper tape punch  |
+-------------------+
4 rows in set (0.01 sec)*/

/*4) Which employees have a salary between 9000 (included) and 10000 (included)?*/

SELECT name 
FROM jbemployee 
WHERE salary >= 9000 
AND salary <= 10000;

/*
+----------------+
| name           |
+----------------+
| Edwards, Peter |
| Smythe, Carol  |
| Williams, Judy |
| Thomas, Tom    |
+----------------+
4 rows in set (0.00 sec)

5) What was the age of each employee when they started working (startyear)?*/

SELECT name,  startyear-birthyear as age_at_start
FROM jbemployee;

/*
+--------------------+--------------+
| name               | age_at_start |
+--------------------+--------------+
| Ross, Stanley      |           18 |
| Ross, Stuart       |            1 |
| Edwards, Peter     |           30 |
| Thompson, Bob      |           40 |
| Smythe, Carol      |           38 |
| Hayes, Evelyn      |           32 |
| Evans, Michael     |           22 |
| Raveen, Lemont     |           24 |
| James, Mary        |           49 |
| Williams, Judy     |           34 |
| Thomas, Tom        |           21 |
| Jones, Tim         |           20 |
| Bullock, J.D.      |            0 |
| Collins, Joanne    |           21 |
| Brunet, Paul C.    |           21 |
| Schmidt, Herman    |           20 |
| Iwano, Masahiro    |           26 |
| Smith, Paul        |           21 |
| Onstad, Richard    |           19 |
| Zugnoni, Arthur A. |           21 |
| Choy, Wanda        |           23 |
| Wallace, Maggie J. |           19 |
| Bailey, Chas M.    |           19 |
| Bono, Sonny        |           24 |
| Schwarz, Jason B.  |           15 |
+--------------------+--------------+
25 rows in set (0.00 sec)

6) Which employees have a last name ending with “son”?*/

SELECT name 
FROM jbemployee
WHERE name like '%son,%';

/*
+---------------+
| name          |
+---------------+
| Thompson, Bob |
+---------------+
1 row in set (0.00 sec)

7) Which items (note items, not parts) have been delivered by a supplier called Fisher-Price? 
   Formulate this query using a subquery in the where-clause.*/

SELECT name
FROM jbitem
WHERE supplier in 
(SELECT id FROM jbsupplier WHERE name like 'Fisher-Price');

/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
3 rows in set (0.00 sec)

8) Formulate the same query as above, but without a subquery.*/

SELECT jbitem.name
FROM jbitem, jbsupplier
WHERE jbitem.supplier = jbsupplier.id
AND jbsupplier.name LIKE 'Fisher-Price';

/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
3 rows in set (0.00 sec)

9) Show all cities that have suppliers located in them. Formulate this query using a subquery in the where-clause.*/

SELECT name
FROM jbcity
WHERE id in
(SELECT city FROM jbsupplier);

/*
+----------------+
| name           |
+----------------+
| Amherst        |
| Boston         |
| New York       |
| White Plains   |
| Hickville      |
| Atlanta        |
| Madison        |
| Paxton         |
| Dallas         |
| Denver         |
| Salt Lake City |
| Los Angeles    |
| San Diego      |
| San Francisco  |
| Seattle        |
+----------------+
15 rows in set (0.00 sec)

10) What is the name and color of the parts that are heavier than a card reader? 
    Formulate this query using a subquery in the where-clause. 
    (The SQL query must not contain the weight as a constant.)*/

SELECT name, color
FROM jbparts
WHERE jbparts.weight > (SELECT weight FROM jbparts WHERE name = "card reader");

/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.00 sec)

11) Formulate the same query as above, but without a subquery. 
    (The query must not contain the weight as a constant.)*/

SELECT parts1.name, parts1.color
FROM jbparts parts1, jbparts parts2
WHERE parts1.weight > parts2.weight
AND parts2.name = "card reader";

/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.00 sec)

12) What is the average weight of black parts?*/

SELECT avg(weight)
FROM jbparts
WHERE color LIKE 'black';

/*
+-------------+
| avg(weight) |
+-------------+
|    347.2500 |
+-------------+
1 row in set (0.01 sec)

13) What is the total weight of all parts that each supplier in Massachusetts (“Mass”) has delivered? 
    Retrieve the name and the total weight for each of these suppliers. 
    Do not forget to take the quantity of delivered parts into account. 
    Note that one row should be returned for each supplier.*/

SELECT sup.name as supplier, sum(supply.quan * parts.weight) as total_w 
FROM jbsupplier sup, jbcity city, jbparts parts, jbsupply supply 
WHERE sup.city = city.id 
AND sup.id = supply.supplier 
AND supply.part = parts.id 
AND city.state LIKE 'Mass' 
GROUP BY sup.name;

/*
+--------------+---------+
| supplier     | total_w |
+--------------+---------+
| DEC          |    3120 |
| Fisher-Price | 1135000 |
+--------------+---------+
2 rows in set (0.00 sec)

14) Create a new relation (a table), with the same attributes as the table items using the CREATE TABLE syntax 
    where you define every attribute explicitly (i.e. not as a copy of another table). 
    Then fill the table with all items that cost less than the average price for items. 
    Remember to define primary and foreign keys in your table!*/

CREATE TABLE Own_table (
id integer PRIMARY KEY,
name varchar(15),
dept integer,
price integer,
qoh integer,
supplier integer,
FOREIGN KEY (supplier) REFERENCES jbsupplier(id));

/*
Query OK, 0 rows affected (0.06 sec) */

INSERT INTO Own_table
SELECT * 
FROM jbitem
WHERE price < (SELECT avg(price) FROM jbitem);

/*
Query OK, 14 rows affected (0.01 sec)
Records: 14  Duplicates: 0  Warnings: 0 */

SELECT * FROM Own_table;

/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0.00 sec)

15) Create a view that contains the items that cost less than the average price for items.*/

CREATE VIEW cheap_items AS
SELECT * FROM jbitem WHERE price < (SELECT avg(price) FROM jbitem);

/*
Query OK, 0 rows affected (0.04 sec)

16) What is the difference between a table and a view? One is static and the other is dynamic. 
    Which is which and what do we mean by static respectively dynamic?

A view (dynamic) is a virtual table derived from other tables. It is built using a SQL-Query with a FROM-clause
which refers to other tables. Therefore, the view depends on the data included in the tables named in the
FROM-clause. If this data in the database tables on which the view depends changes, the view will also show 
other results. Database tables are static because the data included can be only changed manually. In contrast,
the output of the view always depends on these database tables, so that its output changes dynamically.

17) Create a view, using only the implicit join notation, i.e. only use where statements but no inner join, 
    right join or left join statements, that calculates the total cost of each debit, by considering 
    price and quantity of each bought item. (To be used for charging customer accounts). 
    The view should contain the sale identifier (debit) and total cost.*/

CREATE VIEW debit_costs1 AS
SELECT jbsale.debit, sum(jbsale.quantity * jbitem.price) as total_cost
FROM jbsale, jbitem
WHERE jbsale.item = jbitem.id
GROUP BY jbsale.debit;

/*Query OK, 0 rows affected (0.04 sec)*/

SELECT * FROM debit_costs1;

/*
+--------+------------+
| debit  | total_cost |
+--------+------------+
| 100581 |       2050 |
| 100582 |       1000 |
| 100586 |      13446 |
| 100592 |        650 |
| 100593 |        430 |
| 100594 |       3295 |
+--------+------------+
6 rows in set (0.00 sec)

18) Do the same as in (17), using only the explicit join notation, i.e. using only left, right or inner joins 
    but no where statement. Motivate why you use the join you do (left, right or inner), and why this is the 
    correct one (unlike the others).*/

CREATE VIEW debit_costs2 AS
SELECT jbsale.debit, sum(jbsale.quantity * jbitem.price) as total_cost
FROM jbsale inner join jbitem on jbsale.item = jbitem.id
GROUP BY jbsale.debit;

/*
Query OK, 0 rows affected (0.05 sec)*/

SELECT * FROM debit_costs2;

/*
+--------+------------+
| debit  | total_cost |
+--------+------------+
| 100581 |       2050 |
| 100582 |       1000 |
| 100586 |      13446 |
| 100592 |        650 |
| 100593 |        430 |
| 100594 |       3295 |
+--------+------------+
6 rows in set (0.00 sec)

We used the inner join, because then all the items which are in both tables the jbsale and jbitem included are used.

19) Oh no! An earthquake!

a) Remove all suppliers in Los Angeles from the table jbsupplier. 
   This will not work right away (you will receive error code 23000) which you will have to solve by deleting 
   some other related tuples. However, do not delete more tuples from other tables than necessary and do not 
   change the structure of the tables, i.e. do not remove foreign keys. Also, remember that you are only allowed 
   to use “Los Angeles” as a constant in your queries, not “199” or “900”.

First, we try to delete tuples from jbsupplier with the id for Los Angeles. 

DELETE FROM jbsupplier
WHERE jbsupplier.city in (
SELECT jbcity.id 
FROM jbcity
WHERE jbcity.name like 'Los Angeles');
ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails 
(`lensc874`.`Own_table`, CONSTRAINT `Own_table_ibfk_1` FOREIGN KEY (`supplier`) REFERENCES `jbsupplier` (`id`))

As expected, the error code 23000 will be returned.
The trial to delete tuples from jbsupplier with the id for Los Angeles fails, because of the Foreign Key-constraint.
Remember that we created the table "Own_table" using the setup that Own_table.supplier is a FK related to 
jbsupplier.id. Thus, we would delete tuples from jbsupplier with id's which are still present in Own_table.supplier.
Therefore, we will remove the corresponding tuples from Own_table. */

DELETE FROM Own_table
WHERE Own_table.supplier in (
SELECT jbsupplier.id
FROM jbsupplier
WHERE jbsupplier.city in (
SELECT jbcity.id
FROM jbcity
WHERE jbcity.name like 'Los Angeles'));

/*
Query OK, 1 row affected (0.02 sec)

Again, we try the same step as before to delete the tuples from jbsupplier with the id for Los Angeles.

mysql> DELETE FROM jbsupplier
    -> WHERE jbsupplier.city in (
    -> SELECT jbcity.id 
    -> FROM jbcity
    -> WHERE jbcity.name like 'Los Angeles');
ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails 
(`lensc874`.`jbitem`, CONSTRAINT `fk_item_supplier` FOREIGN KEY (`supplier`) REFERENCES `jbsupplier` (`id`))

The same error is returned. However, this time, the trial fails because of the Foreign Key-constraint related to the table jbitem.
As a consequence, we also remove the corresponding tuples within the table jbitem.

mysql> DELETE FROM jbitem
    -> WHERE jbitem.supplier in (
    -> SELECT jbsupplier.id
    -> FROM jbsupplier
    -> WHERE jbsupplier.city in (
    -> SELECT jbcity.id
    -> FROM jbcity
    -> WHERE jbcity.name like 'Los Angeles'));
ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails 
(`lensc874`.`jbsale`, CONSTRAINT `fk_sale_item` FOREIGN KEY (`item`) REFERENCES `jbitem` (`id`))

We can't delete the corresponding tuples from the table jbitem, because there is still another FK-constraint related to the table jbsale.
Thus, we first need to delete the corresponding items from jbsale.*/

DELETE FROM jbsale 
WHERE jbsale.item in (
SELECT jbitem.id 
FROM jbitem 
WHERE jbitem.supplier in (
SELECT jbsupplier.id 
FROM jbsupplier 
WHERE jbsupplier.city in (
SELECT jbcity.id 
FROM jbcity 
WHERE jbcity.name like 'Los Angeles')));

/*
Query OK, 1 row affected (0.01 sec)

This deleting process worked out. Thus, we try again to remove the tuples within the table jbitem. */

DELETE FROM jbitem
WHERE jbitem.supplier in (
SELECT jbsupplier.id
FROM jbsupplier
WHERE jbsupplier.city in (
SELECT jbcity.id
FROM jbcity
WHERE jbcity.name like 'Los Angeles'));

/*
Query OK, 2 rows affected (0.08 sec)

Again, the the process worked out. Finally, we now also try again to remove the tuples within the table jbsupplier. */

DELETE FROM jbsupplier
WHERE jbsupplier.city in (
SELECT jbcity.id 
FROM jbcity
WHERE jbcity.name like 'Los Angeles');

/*
Query OK, 1 row affected (0.03 sec)

The supplier could has been removed - the process is done.

b) Explain what you did and why.

All explanations are given in a) already.

20) An employee has tried to find out which suppliers that have delivered items that have been sold. 
    He has created a view and a query that shows the number of items sold from a supplier.*/

CREATE VIEW jbsale_supply(supplier, item, quantity) AS 
SELECT jbsupplier.name, jbitem.name, jbsale.quantity
FROM jbsupplier, jbitem, jbsale
WHERE jbsupplier.id = jbitem.supplier
AND jbsale.item = jbitem.id; 

/*
Query OK, 0 rows affected (0.01 sec) */

SELECT supplier, sum(quantity) AS sum 
FROM jbsale_supply
GROUP BY supplier;

/*
    +--------------+---------------+
    | supplier     | sum(quantity) |
    +--------------+---------------+
    | Cannon       | 	         6 |
    | Levi-Strauss | 	         1 |
    | Playskool    | 	         2 |
    | White Stag   | 	         4 |
    | Whitman's    | 	         2 |
    +--------------+---------------+
    The employee would also like include the suppliers which has delivered some items, although for whom no 
    items have been sold so far. In other words he wants to list all suppliers, which has supplied any item, 
    as well as the number of these items that have been sold. Help him! Drop and redefine jbsale_supply to 
    consider suppliers that have delivered items that have never been sold as well.
    Hint: The above definition of jbsale_supply uses an (implicit) inner join that removes suppliers that 
    have not had any of their delivered items sold. */

DROP VIEW IF EXISTS jbsale_supply CASCADE;

CREATE view jbsale_supply(supplier, item, quantity) as 
SELECT jbsupplier.name, jbitem.name, jbsale.quantity 
FROM jbsupplier join jbitem on jbsupplier.id = jbitem.supplier left join jbsale on jbsale.item = jbitem.id;

/*
Query OK, 0 rows affected (0.05 sec)*/

SELECT supplier, sum(quantity) 
FROM jbsale_supply
GROUP BY supplier;
/*
+--------------+---------------+
| supplier     | sum(quantity) |
+--------------+---------------+
| Cannon       |             6 |
| Fisher-Price |          NULL |
| Levi-Strauss |             1 |
| Playskool    |             2 |
| White Stag   |             4 |
| Whitman's    |             2 |
+--------------+---------------+
6 rows in set (0.01 sec) */