# Postgres

## Commands
- \d
  - list all tables
- \d users
  - show users table and columns

## Joins

- When you want to combine data from two different tables
- When two tables are related, they ared done so by __keys__

# SQL

## Query syntax

```sql
  SELECT table_column_names
  FROM table_name
    INNER JOIN character_tv_show
      ON character.id = character_tv_show.character_id
  WHERE condition_is_true
    AND other_condition_is_true
    AND another_condition_is_true;
  GROUP BY some_clause_likely_to_manipulate_data
```
- note that it ends a statement with ` ; `

### ` SELECT ` columns from a table
- After `SELECT` you list what columns of data you want to return
- ` * ` is a helper which returns all columns in a table

### ` FROM ` What Table

### `WHERE` Conditions Are True

__Return A Row When (i.e. `WHERE`) Condition:__

- ` = `,  ` > `,  ` < `,  ` >= `,  ` <= `
  - Matches value according to referenced math symbol
  - `SELECT * FROM family_members WHERE species = 'human';`
    - Note that the _quotes_ have to be around the word _human_.

- ` AND `
  - Matches all of the conditions
  - `SELECT * FROM friends_of_pickles WHERE height_cm > 25 AND species = 'cat';`

- ` OR `
  - Matches at least 1 of the conditions
  - `SELECT * FROM friends_of_pickles WHERE height_cm > 25 OR species = 'cat';`

- ` IN `
  - Matches matches a value _in_ a list of values
  - `SELECT * FROM friends_of_pickles WHERE species IN ('cat', 'human');`

- ` NOT IN `
  - Have a value _not in_ a given list of values
  - `SELECT * FROM friends_of_pickles WHERE species NOT IN ('cat', 'human');`

- `IS NULL` and/or `IS NOT NULL` conditions
  - When a row does not have a value, it is known as `NULL`
  - `SELECT * FROM family_members WHERE favorite_book IS NOT NULL`

#### Date Values: `1985-08-17`

- Syntax: `YEAR-MONTH-DAY`
- The mathematical value of a date the number/count of grains of sand at the bottom of an hour glass. The later you check it, the greater the count/value.
  - Whichever Date/Time comes later will have higher value.
  - This is important to remember when comparing date values ` = `,  ` > `,  ` < `,  ` >= `,  ` <= `

#### `LIKE` string conditional

  - Use `LIKE` in order to search through a text based value.
  - `LIKE` is _not_ case sensitive
  - `SELECT * FROM robots WHERE name LIKE "%Robot%";`

  - ` % ` and ` _ ` are two special characters in the `LIKE` syntax
    - Need to put the value in _quotes_ with the special character.
    - ` % ` represents 0 or more characters
    - ` _ ` represents 1 character.

  - `LIKE "%SUPER"`, can return:
    - "SUPER"
    - "Hethe is SUPER"
    - "3... 2... 1... SuPeR"
  - `LIKE "SUPER%"`
    - "SUPER"
    - "Superman is here to save the day!"
    - "Super Troopers is overrated."
  - `LIKE "%SUPER%"`
    - "SUPER"
    - "Hethe is SUPER"
    - "3... 2... 1... SuPeR"
    - "Superman is here to save the day!"
    - "Super Troopers is overrated."
    - "Hethe is Batman. Hethe kicked Superman's butt!"
    - "It would be sUpEr to be rich!"

#### `SUBSTR(---, ---, ---)` to search substring of text.

- Use value of cell and extract a substring to then run a conditional.
  - `SELECT * FROM robots WHERE SUBSTR(name, -4) LIKE '20__';`
    - Note: the last `_` and `_` are special characters of `LIKE`

- `SUBSTR(column_name, index, number_of_characters)`
  - `column_name`, i.e. `table.column_name`
  - `index` start point of substring
    - 1 is the first character (not 0)
    - -1 is the last character
  - `number_of_characters` is optional. if left out, it will search to the end of the string



#### `DISTINCT` Columns Only, i.e. Unique

__Only Unique Rows Are Returned__
- Note: `SELECT DISTINCT`, it is added after select
- When you specifiy the columns you want to return, there is likely a large number of repeated results.
- When you return all the records with ` * ` there is not likely to be any repeated records because each returned row will have an ` id ` column which is unique
- `SELECT DISTINCT gender, species FROM friends_of_pickles WHERE height_cm < 100;`

### `ORDER BY` some condition

__specifies how you want to sort the results__

- `SELECT * FROM friends_of_pickles ORDER BY name;`
  - In order to put the names in descending order, you would add a `DESC` at the end of the query.
    - `SELECT * FROM friends_of_pickles ORDER BY name DESC;`

### `LIMIT` Number of returned rows

- `SELECT * FROM friends_of_pickles ORDER BY height_cm DESC LIMIT 2;`

### `COUNT(column_names)` of rows this query would return
- Note: `SELECT COUNT( DISTINCT column_names )`, puts the column names inside the parentheses.

### `MATH_FUNCTION_ON(column_name)` of row's values

### `MATH_FUNCTION_ON(column_name)` of row's values

- `SUM(---)`, `AVG(---)`, `MIN(---)`, `MAX(---)`
  - `SELECT SUM(salary) FROM family_members;`
  - `SELECT AVG(salary) FROM family_members;`
  - `SELECT MIN(salary) FROM family_members;`
  - `SELECT MAX(salary) FROM family_members;`
  - `SELECT COUNT(salary) FROM family_members;`
- Only one column to get value's added together
  - To do a math function on the values in a column, use `GROUP BY`
- Any code related to the columns goes in side the function
  - `SELECT COUNT(*) FROM friends_of_pickles`
  - `SELECT COUNT( DISTINCT gender ) FROM friends_of_pickles`

### `GROUP BY` a column

__When you `GROUP BY` something, you split the table into different piles based on the value of each row__
- This is handy when you do a Function and then return rows of those function _grouped by_ a column

1. This will select the column you choose in the `GROUP BY`
1. Create a new temp table with the column headers being:
  - The `GROUP BY` column name
  - The function result on that group's values

- `SELECT COUNT(*), species FROM friends_of_pickles GROUP BY species;`
  - `SELECT SUM(*), species FROM friends_of_pickles GROUP BY species;`
  - `SELECT AVG(*), species FROM friends_of_pickles GROUP BY species;`
  - `SELECT MIN(*), species FROM friends_of_pickles GROUP BY species;`
  - `SELECT MAX(*), species FROM friends_of_pickles GROUP BY species;`


## Nested SQL queries

__You can put a SQL query inside another SQL query__
- Nested queries are FULL queries, so you'll need at a minimum:
  - `SELECT` columns
  - `FROM` table_name
- The inner parentheses is executed first and then outer parentheses.

- `SELECT * FROM family_members WHERE num_legs = (SELECT MIN(num_legs) FROM family_members);`

## Joins

__Different parts of information can be stored in different tables, and in order to put them together, we use _inner joins_ __
- Joining tables is the core of SQL functionality
- On join tables, we store the `table_row_id` so we don't have to duplicate data.
  - If the `table_row_id` has a column value change, we don't have to change the data in two tables.

- Join tables can be a query or persisted data.


### `INNER JOIN ... ON ...`
  - Goal is to get the data from other tables on to the rows of `FROM table_name`
    - We do this by using `INNER JOIN table_name ON #{table_connection_mapping}`
  - To query `ON` two tables you need to reference one table's `id` with another table's `table_row_id`.

__Single Inner Join Table__
- The following will return a table where table_one column value and table_two's column value where table_one's id column is `ON` table_two _as_ the column table_row_id

```
  SELECT table_one.column_name, table_two.another_column_name
  FROM table_one
  INNER JOIN table_two
  ON table_one.id = table_two.table_one_id;
```

- `ON` starts the comparison where the value of one column needs to be the value of another column
  - `ON` table_one.column_name `~ is/= ~` table_two.column_name

- `INNER JOIN` - Return ONLY rows wWhere there is data for the selected columns in BOTH tables
- `LEFT JOIN` - Return all rows of the main `FROM table_1`. Then add all columns of the `LEFT JOIN table_2`, putting `NULL` in the columns where there is no current data
- `RIGHT JOIN` and `OUTER JOIN` not supported in ActiveRecord or SQLite

```
  SELECT character.name, character_tv_show.tv_show_name
  FROM character
  INNER JOIN character_tv_show
  ON character.id = character_tv_show.character_id;
```

#### Multiple Inner Join Table
- Use as many `INNER JOIN`'s as you need.

- __How to think of it:__
  1. You will use all the rows in the main table, i.e. `FROM table_1`
  1. Every `INNER JOIN` with the goal of being mapped to this main table.
  1. Because you use every row on this table, you will use the `table_1.id` of the main table and the associated value of the next table
    - It likely it would `table_2.table_1_id`
    - `table_1.id = table_2.table_1_id`
  1. You will `table_3` to `table_2` in the same manner.
    - `table_2.id = table_3.table_2_id`
  1. `table_name_id` is known as the `key` to the associated table.
    - By default, a table's row is the primary key because they are unique. The key doesn't have to be name `table_name_id` and it doesn't have to be an integer.
    - The key has to be unique
    - They key is used to map the rows.
    - Buy using two keys on one table you can have polymorphic association.
      - Refer to multiple tables instead of just one.
    - By mapping a key to another attribute on same table, you can have self referencing tables.
      - Like a users table with a `manager_id`
  1. Once you have the rows of data from all the tables, you can use `WHERE` conditionals.
    - You'll have to mention both the Table Name and Table Column to get the value.
    - Use __Dot Notation__ to access the correct data from the right
      - `table_1.column_name == 'Value' AND table_2.column_name != 'Value'`
      - `character.name != 'Barney Stinson' AND tv_show.name != 'Buffy `
    - Pluralization is singular in SQL but ActiveRecord is different.

### `AS` a alias name, tables and columns

- Queries can get long and having to use the full table name can get very cumbersome.
- Use an `as` to create an alias for the table name

#### Table Aliasing
  - Do so after the table is first mentioned, like so:
    - `FROM character AS c`
    - `LEFT JOIN character_tv_show AS ct`
    - `INNER JOIN tv_show AS t`
    - Future Use:
      - `ON c.id = ct.character_id`
      - `ON ct.tv_show_id = t.id;`

#### Column Aliasing
  - When combining tables columns in a query, sometime sthe table's will have the column names.
    - This would be buggy confusing when seeing the returned query table
  - Use Column Aliasing so the returned query can have a different name for the columns
  - Do so after the column is first selected, like so:
    - `SELECT character.name AS character, tv_show.name AS name`
      - Returned columns would be "character" and "name"

### `Self Joins

- In order to self joins, you _have_ to create aliases to the tables in order to determin which data is from the "First" (i.e. left) table.
  - Note: You use the alias names in the select statement even though you create the alias later on in the query.

```
  SELECT table_alias_1.name AS object, table_alias_2.name AS beats
  FROM only_table AS table_alias_1
  INNER JOIN only_table AS table_alias_2
  ON table_alias_1.defeats_id = table_alias_2.id;
```

## `CASE` statements can be used to add columns

- You can use a CASE statement to return certain values when certain scenarios are true.
  - Must provide a column name for the added column
    - `... AS num_legs  ...`

```
  CASE
  WHEN *first thing is true*
    THEN *value1*
  WHEN *second thing is true*
    THEN *value2*
  ...
  ELSE
    *value for all other situations*
  END
  AS *case_column_name*
```

```
  SELECT
    *,
    CASE
    WHEN species = 'human'
      THEN 1
    WHEN species = 'monkey'
      THEN 2
    ELSE
      3
    END
    AS num_legs
  FROM friends_of_pickles;
  END
```

## `COALESCE(column_a, column_b, column_c)` column values and return the first one that is not null
  - `SELECT name, COALESCE(tank, gun, sword) AS weapon FROM fighters;`
  - Must provide a column name for the added column
    - `... AS weapon ...`
  - returns _null_ if all column values are null
