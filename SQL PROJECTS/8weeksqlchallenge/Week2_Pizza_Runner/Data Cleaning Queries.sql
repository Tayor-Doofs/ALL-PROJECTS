-- DATA CLEANING

-- The query below changes blank cells and cells equal to "null" in
-- the exclusions and extras columns found in the customer orders
-- table to NULL

UPDATE customer_orders
SET exclusions = NULL
WHERE exclusions = "null" OR exclusions = "";

UPDATE customer_orders
SET extras = NULL
WHERE extras = "null" OR extras = "";

-- The query below changes blank cells and cells equal to "null" in
-- the pickup_time, distance, duration, and cancellation columns found
-- in the runner_orders table to NULL

UPDATE runner_orders
SET pickup_time = NULL
WHERE pickup_time = "null" OR pickup_time = "";

UPDATE runner_orders
SET distance = NULL
WHERE distance = "null" OR distance = "";

UPDATE runner_orders
SET duration = NULL
WHERE duration = "null" OR duration = "";

UPDATE runner_orders
SET cancellation = NULL
WHERE cancellation = "null" OR cancellation = "";

-- The query below changes duration and distance column in the runner_orders column from "varchar" datatypes to int
-- while also removing the unit "km" and "minutes" from each values,

UPDATE runner_orders
SET distance = TRIM(REPLACE(distance, "km", ""));

ALTER TABLE runner_orders
MODIFY distance float;

ALTER TABLE runner_orders
RENAME COLUMN distance TO distance_km;

ALTER TABLE runner_orders
RENAME COLUMN duration TO duration_mins;

UPDATE runner_orders
SET duration_mins = TRIM(REPLACE(duration_mins, "minutes", ""));

UPDATE runner_orders
SET duration_mins = TRIM(REPLACE(duration_mins, "minute", ""));

UPDATE runner_orders
SET duration_mins = TRIM(REPLACE(duration_mins, "mins", ""));

ALTER TABLE runner_orders
MODIFY duration_mins int;

-- Normalize Pizza Recipe table
DROP TABLE IF EXISTS pizza_recipes1;

CREATE TABLE pizza_recipes1 (
	pizza_id int,
    toppings int
    );
    
INSERT INTO pizza_recipes1
(pizza_id, toppings) 
VALUES
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(1,6),
(1,8),
(1,10),
(2,4),
(2,6),
(2,7),
(2,9),
(2,11),
(2,12);

-- to answers question 2 in 'Ingredient Optimization' questions

drop table if exists numbers;
CREATE TABLE numbers (
  num INT PRIMARY KEY
);

INSERT INTO numbers VALUES
( 1 ), ( 2 ), ( 3 ), ( 4 ), ( 5 ), ( 6 ), ( 7 ), ( 8 ), ( 9 ), ( 10 ),( 11 ), ( 12 ), ( 13 ), ( 14 );


-- to answer question 4
drop table if exists exclusions;
CREATE TABLE exclusions (
	order_id INT,
    exclusions INT
    );
    
INSERT INTO exclusions
VALUES (1, NULL), (2, NULL), (3, NULL),(3, NULL), (4, 4), (4, 4), (4, 4), (5, NULL), (6, NULL), (7, NULL), (8, NULL), (9, 4), (10, NULL), (10, 2), (10, 6);


CREATE TABLE extras (
	order_id INT,
    extras INT
    );
    
INSERT INTO extras
VALUES (1, NULL), (2, NULL), (3, NULL),(3, NULL), (4, NULL), (4, NULL), (4, NULL), (5, 1), (6, NULL), (7, 1), (8, NULL), (9, 1), (9, 5), (10, NULL), (10, 1), (10, 4);