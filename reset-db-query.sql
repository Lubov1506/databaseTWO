/* Удаляем таблицы, если они были - в порядке подчиненности, сначала удаляются подчиненные таблицы, потом главные (а иначе главные и не удалятся вовсе, если на них кто-то ссылается*/

DROP TABLE IF EXISTS "orders_to_phones"; 
DROP TABLE IF EXISTS "phones"; 
DROP TABLE IF EXISTS "orders"; 

/* Создаем их все заново, определяем столбцы */
/* Структура такая:
Таблица телефонов содержит товары(телефоны)
Таблица заказов относится к таблице юзеров как 1:m
Таблица заказов_к_телефонам - связующая таблица для телефонов и заказов
(связь m:n)

*/


CREATE TABLE "phones"(
    "id" serial PRIMARY KEY,
    "brand" varchar(64) NOT NULL CHECK ("brand" != ''),
    "model" varchar(64) NOT NULL CHECK ("model" != ''),
    "quantity" int NOT NULL CHECK ("quantity" > 0),
    "price" decimal(16, 2) NOT NULL CHECK ("price" > 0),
    UNIQUE ("brand", "model")
);

CREATE TABLE "orders"(
    "id" serial PRIMARY KEY,
   "user_id" int REFERENCES "users"("id")
);

CREATE TABLE "orders_to_phones"(
    "phone_id" int REFERENCES "phones"("id"),
   "order_id" int REFERENCES "orders"("id"),
   "quantity" int NOT NULL CHECK ("quantity" > 0),
   "status" boolean NOT NULL DEFAULT false,
   PRIMARY KEY("phone_id", "order_id")
);

--practise--
--1--
SELECT sum("quantity") as "Продано телефонов" FROM "orders_to_phones";
--2--
SELECT sum("quantity") AS "Телефонов на складе" FROM "phones";
--3--
SELECT avg("price") FROM "phones";
--4--
SELECT avg("price"), "brand" FROM "phones"
GROUP BY "brand";
--5--
SELECT sum("quantity" * "price") AS "Стоимость товаров от 1000$ до 2000$"
FROM "phones"
WHERE "price" BETWEEN 1000 AND 2000;
--6--
SELECT count(*), "brand"
FROM "phones"
GROUP BY "brand";

SELECT * FROM "phones"
WHERE "brand" = 'Nokia';
--7--
SELECT sum("quantity"), "order_id"
FROM "orders_to_phones"
GROUP BY "order_id"
ORDER BY "order_id";

SELECT count(*), user_id
FROM orders
GROUP BY user_id
ORDER BY user_id;
--8--
SELECT avg("price")
FROM "phones"
WHERE "brand" = 'Nokia';

--sort--
--по высоте, возрастающая
SELECT * FROM "users"
ORDER BY "height" ASC;
--по высоте, если высота одинаковая - по дате рождения
SELECT * FROM "users"
ORDER BY "height" ASC, "birthday" ASC;

--2--
SELECT * FROM "phones"
ORDER BY "price" desc
LIMIT 10;

--1--
SELECT *, EXTRACT('year' from age("birthday")) AS "age"
FROM "users"
ORDER BY EXTRACT('year' from age("birthday")) ASC, "first_name";

SELECT * FROM 
    (SELECT *, EXTRACT('year' from age("birthday")) AS "age"
    FROM "users") AS "u_w_age"
ORDER BY "age", "u_w_age"."first_name";

SELECT count(*), "age" FROM 
    (SELECT *, EXTRACT('year' from age("birthday")) AS "age"
    FROM "users") AS "u_w_age"
GROUP BY "age"
ORDER BY "age";

SELECT count(*), "age" FROM 
    (SELECT *, EXTRACT('year' from age("birthday")) AS "age"
    FROM "users") AS "u_w_age"
GROUP BY "age"
HAVING count(*) >= 5
ORDER BY count(*) desc;
--3--
SELECT sum("quantity"), "brand"
FROM "phones"
GROUP BY "brand"
HAVING  sum("quantity") > 1000
ORDER BY "brand" asc;

--text.pattern
--LIKE
--ILIKE - "AbaB", "abab"
--SIMILAR TO - работает с регулярками и 
-- ~ -  с регулярками , регистрозависимая
-- ~* - с регулярками, регистронезависимая
SELECT * FROM "users"
WHERE "first_name" ~ '.*e{2}.*';
SELECT * FROM "users"
WHERE "first_name" ~* '.*e{2}.*';

SELECT char_length(concat("first_name", ' ', "last_name")) AS "name_length", *
FROM "users"
ORDER BY "name_length" DESC
LIMIT 1;

SELECT char_length(concat("first_name", ' ', "last_name")) AS "name_length", count(*)
FROM "users"
GROUP BY "name_length"
HAVING char_length(concat("first_name", ' ', "last_name")) > 15
ORDER BY "name_length";

DROP TABLE a;
DROP TABLE b;

CREATE TABLE a (
    v char(3),
    t int
);

CREATE TABLE b (
    v char(3)
);

INSERT INTO a VALUES
('XXX', 1), ('XYX', 1), ('XYY', 1), 
('XXZ', 2), ('XZZ', 2), ('XXZ', 2), 
('XYZ', 3), ('XZY', 3), ('XZA', 3), 
('ZZX', 3), ('XZX', 3), ('ZZZ', 3);

INSERT INTO b VALUES
('AAS'), ('XYX'), ('XYY'), 
('XXZ'), ('AAA'), ('XXZ');

SELECT * FROM a, b; -- декартово произведение

--Объединение - 1 и 2 табл соединяются, повторяющиеся значения исключаются
SELECT v FROM a
UNION
SELECT * FROM b;

--Пересечение - значения, которые есть в 1 и в 2й таблицах
SELECT v FROM a
INTERSECT
SELECT * FROM b;

-- Вычитание - только те значения а, которых нет в b
SELECT v FROM a
EXCEPT
SELECT * FROM b;
-- только те значения b, которых нет в a
SELECT * FROM b
EXCEPT
SELECT v FROM a;

INSERT INTO users (
    first_name,
    last_name,
    email,
    gender,
    is_subscribe,
    birthday,
    height,
    weight
  )
VALUES (
    'hello',
    'world',
    'emailT@.com',
    'male',
    true,
    '1995/02/05',
    1.3,
    95
  ),
  (
    'fred',
    'john',
    'ema111ilT@.com',
    'female',
    true,
    '2005/06/05',
    1.8,
    85
  );
--юзеры, которые делали заказы
SELECT "id" FROM "users"
INTERSECT
SELECT "user_id" FROM "orders";
--юзеры, которые не делали заказы
SELECT "id" FROM "users"
EXCEPT
SELECT "user_id" FROM "orders";

-- Плохой код
--соединение таблиц
SELECT * FROM a,b
WHERE a.v = b.v; 
--с переименованием атрибутов
SELECT a.v as "model",
a.t AS "id",
b.v AS "brand"
FROM a,b
WHERE a.v = b.v;


-- JOIN - хороший вариант
SELECT *
FROM a JOIN b
ON a.v = b.v;



-- Предикат - чаще всего PrimaryKey = ForeignKey

SELECT *
FROM "users" JOIN "orders"
ON

SELECT u.*, o.id AS "order_number"
FROM 
users AS u
JOIN orders AS o
ON o.user_id = u.id
WHERE u.id = 2;



SELECT * 
FROM a 
JOIN b ON a.v=b.v
JOIN phones ON a.t=phones.id;


-- найти id всех заказов, в которых есть телефон бренда SAMSUNG

SELECT o.id AS "Order number", p.model
FROM orders AS o
JOIN orders_to_phones AS otp
ON o.id = otp.order_id
JOIN phones AS p
ON p.id = otp. phone_id
WHERE p.brand ILIKE 'samsung';

SELECT o.id AS "Order number",  count(p.model)
FROM orders AS o
JOIN orders_to_phones AS otp
ON o.id = otp.order_id
JOIN phones AS p
ON p.id = otp. phone_id
WHERE p.brand ILIKE 'samsung'
GROUP BY o.id;

INSERT INTO phones (brand, model, quantity, price)
VALUES (
    'FRESHPHONE',
    'X',
    3,
    30000
  );


SELECT phone_id, p.model, sum(otp.quantity) AS "summary"
FROM orders_to_phones AS otp
LEFT OUTER JOIN phones AS p
ON p.id=otp.null
GROUP BY phone_id, p.model
ORDER BY phone_id;


SELECT DISTINCT users.email FROM users
JOIN orders
ON users.id = orders.user_id
GROUP BY users.email;

-- email пользователей, которые покупали SAMSUNG
SELECT u.email
FROM users AS u
JOIN orders AS o
ON u.id = o.user_id
JOIN orders_to_phones AS otp
ON o.id=otp.order_id
JOIN phones AS p
ON otp.phone_id = p.id
WHERE p.brand ILIKE 'samsung'
GROUP BY u.email;

-- найдем пользователей и их количество заказов
SELECT count(o.id) AS "Order quantity", u.*
FROM users AS u
LEFT JOIN orders AS o
ON o.user_id = u.id
GROUP BY o.user_id, u.id
ORDER BY "Order quantity";

--Найти стоимость каждого заказа

SELECT o.id AS "Номер заказа", sum(otp.quantity*p.price) AS "Сумма заказа"
FROM orders AS o
JOIN orders_to_phones AS otp 
ON o.id=otp.order_id
JOIN phones AS p
ON otp.phone_id = p.id
GROUP BY o.id
ORDER BY o.id;

--Найти количество заказов конкретного пользователя, вывести его email

SELECT u.id, count(o.id)
FROM users AS u
JOIN orders AS o
ON u.id=o.user_id
WHERE u.id=101
GROUP BY u.id;

SELECT *
FROM orders
WHERE user_id = 101;

--Достать все заказы, где есть IPhone

SELECT otp.order_id AS "Order Number", p.model, p.brand
FROM orders_to_phones AS otp
JOIN phones AS p
ON otp.phone_id=p.id
WHERE p.brand ILIKE 'iphone' AND p.model ILIKE '5%';

--Посчитать, сколько заказов
SELECT count(*), p.model
FROM orders_to_phones AS otp
JOIN phones AS p
ON otp.phone_id=p.id
WHERE p.brand ILIKE 'iphone' AND p.model ILIKE '5%'
GROUP BY p.model;

--1 Извлечь все купленные телефоны (бренд+модель) конкретного заказа
SELECT p.brand, p.model
FROM orders_to_phones AS otp
JOIN phones AS p
ON otp.phone_id=p.id
WHERE otp.order_id = 100;

--2 Количество позиций в определенном заказе
SELECT order_id AS "Номер заказа", sum(quantity) AS "Количество позиций"
FROM orders_to_phones
GROUP BY order_id
ORDER BY order_id;
--3 Найти самый популярный телефон
SELECT p.*, sum(otp.quantity) AS "Продано"
FROM orders_to_phones AS otp
JOIN phones AS p
ON otp.phone_id=p.id
GROUP BY p.id
ORDER BY sum(otp.quantity) desc
LIMIT 1;

--4 Вытащить всех пользователей и кол-во купленных ими моделей телефона
SELECT u.*, count(*)
FROM users AS u
JOIN orders AS o
ON u.id=o.id
JOIN orders_to_phones AS otp
ON o.id=otp.order_id
GROUP BY otp.order_id, u.id
ORDER BY u.*;

SELECT * FROM users
ORDER BY id;

--5 Средний чек по всем заказам
SELECT avg("sum") AS "Средний чек"  
FROM
    (SELECT sum(otp.quantity*p.price) AS "sum"
    FROM orders_to_phones AS otp
    JOIN phones AS p
    ON otp.phone_id=p.id
    GROUP BY otp.order_id) AS "Sum orders check"
;



--6 Извлечь все заказы, стоимостью выше среднего чека в магазине

SELECT "owc".* FROM 
    (SELECT otp.order_id, sum(otp.quantity*p.price) AS "cost"
    FROM orders_to_phones AS otp
    JOIN phones AS p
    ON otp.phone_id=p.id
    GROUP BY otp.order_id) AS "owc"
    WHERE "owc"."cost" > (
    SELECT avg("cost") AS "Средний чек"  
    FROM
    (SELECT sum(otp.quantity*p.price) AS "cost"
    FROM orders_to_phones AS otp
    JOIN phones AS p
    ON otp.phone_id=p.id
    GROUP BY otp.order_id) AS "owc"
); 


SELECT 
FROM
;



SELECT "owq".* FROM 
    (SELECT u.*, count(*) AS "qo"
    FROM users AS u
    JOIN orders AS o
    ON u.id=o.user_id
    JOIN orders_to_phones AS otp
    ON o.id=otp.order_id
    GROUP BY otp.order_id, u.id
    ORDER BY u.id )
    AS "owq"
    WHERE "owq"."qo" > (
    SELECT avg("qo") FROM
        (SELECT count(*) AS "qo"
        FROM users AS u
        JOIN orders AS o
        ON u.id=o.user_id
        JOIN orders_to_phones AS otp
        ON o.id=otp.order_id
        GROUP BY otp.order_id, u.id
        ORDER BY otp.order_id) AS "owq"
);

--рефактор

WITH "orders_with_costs" AS (
    SELECT otp.order_id, sum(otp.quantity*p.price) AS "cost"
    FROM orders_to_phones AS otp
    JOIN phones AS p
    ON otp.phone_id=p.id
    GROUP BY otp.order_id
)
SELECT "owc".*
FROM "orders_with_costs" AS "owc"
WHERE "owc"."cost" > (
    SELECT avg("owc"."cost")
    FROM "orders_with_costs" AS "owc"
);

--7 Извлечь пользователей, у которых кол-во заказов выше среднего

SELECT "owq".* FROM
(SELECT count(o.*) AS "qo", u.*
FROM users AS u
JOIN orders AS o
ON u.id=o.user_id
GROUP BY u.id
ORDER BY u.id) AS "owq"
WHERE "owq"."qo"> (
    SELECT avg("qo") FROM
    (SELECT count(o.*) AS "qo"
    FROM users AS u
    JOIN orders AS o
    ON u.id=o.user_id
    GROUP BY o.user_id
    ORDER BY o.user_id) AS "owq");

--рефактор

WITH "order_with_quantity" AS (
    SELECT count(o.*) AS "qo", u.*
    FROM users AS u
    JOIN orders AS o
    ON u.id=o.user_id
    GROUP BY u.id
    ORDER BY u.id)
SELECT "owq".*
FROM "order_with_quantity" AS "owq"
WHERE "owq"."qo" > (
    SELECT avg("owq"."qo")
    FROM "order_with_quantity" AS "owq"
);

--7.1 Извлечь пользователей, у которых кол-во телефонов в заказе выше среднего

(
SELECT  sum(otp.quantity) AS "qo" 
FROM users AS u
JOIN orders AS o
ON u.id=o.user_id
JOIN orders_to_phones AS otp
ON o.id=otp.order_id
GROUP BY otp.order_id
ORDER BY otp.order_id;
) AS "owq";

SELECT avg("qo") FROM
(
SELECT  sum(otp.quantity) AS "qo" 
FROM users AS u
JOIN orders AS o
ON u.id=o.user_id
JOIN orders_to_phones AS otp
ON o.id=otp.order_id
GROUP BY otp.order_id
ORDER BY otp.order_id
) AS "owq";
SELECT sum(quantity)
FROM orders_to_phones
WHERE order_id=2
GROUP BY order_id
ORDER BY order_id;