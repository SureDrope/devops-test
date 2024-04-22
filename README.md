### 1. Как создаются в MySQL базы данных и таблицы?
База данных создаётся при помощи команды: `CREATE DATABASE database_name;`.
Перед тем, как создавать таблицу, нужно подключиться к базе данных: `USE database_name;`. Далее:
```sql
CREATE TABLE table_name (
    column1 data_type,
    column2 data_type,
    ...
);
```
где `column` - название столбца, `data_type` - тип данных (например `VARCHAR`, `INT`, `BOOLEAN`, `TIME` и т.д.) 
### 2. Кто такая мария?
Дочь программиста Микаэля Видениуса, в честь которой он назвал СУБД MariaDB

### 3. Как обновить информацию, записанную в базу данных?
При помощи команды `UPDATE`:
```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ... 
[WHERE condition];
```
Использование `WHERE` опционально, но если его не использовать, то будут изменены все строки в таблице