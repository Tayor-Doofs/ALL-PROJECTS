-- SOLUTIONS TO INGREDIENT OPTIMIZATION QUESTIONS

-- QUESTION 1
-- What are the standard ingredients for each pizza?

SELECT pizza_name, group_concat(topping_name) AS standard_ingredients
FROM (SELECT n.pizza_name, r.toppings, t.topping_name
	FROM pizza_runner.pizza_recipes1 r
	JOIN pizza_runner.pizza_names n
	USING (pizza_id)
	JOIN pizza_runner.pizza_toppings t
	ON r.toppings = t.topping_id
    ) x
GROUP BY pizza_name;


-- QUESTION 2
-- What was the most commonly added extra?

with cte as (
SELECT n.num, SUBSTRING_INDEX(SUBSTRING_INDEX(all_tags, ',', num), ',', -1) as one_tag
FROM (
	  SELECT
		GROUP_CONCAT(extras SEPARATOR ',') AS all_tags,
		LENGTH(GROUP_CONCAT(extras SEPARATOR ',')) - LENGTH(REPLACE(GROUP_CONCAT(extras SEPARATOR ','), ',', '')) + 1 AS count_tags
	  FROM pizza_runner.customer_orders
	) t
JOIN numbers n
ON n.num <= t.count_tags)

select one_tag as Extras,pizza_toppings.topping_name as ExtraTopping, count(one_tag) as Occurrencecount
from cte
inner join pizza_toppings
on pizza_toppings.topping_id = cte.one_tag
where one_tag != 0
group by one_tag;


-- QUESTION 3
-- What was the most common exclusion?

with cte as (
SELECT n.num, SUBSTRING_INDEX(SUBSTRING_INDEX(all_tags, ',', num), ',', -1) as one_tag
FROM (
	  SELECT
		GROUP_CONCAT(exclusions SEPARATOR ',') AS all_tags,
		LENGTH(GROUP_CONCAT(exclusions SEPARATOR ',')) - LENGTH(REPLACE(GROUP_CONCAT(exclusions SEPARATOR ','), ',', '')) + 1 AS count_tags
	  FROM pizza_runner.customer_orders
	) t
JOIN numbers n
ON n.num <= t.count_tags)

select one_tag as Exclusions,pizza_toppings.topping_name as ExcludedTopping, count(one_tag) as Occurrencecount
from cte
inner join pizza_toppings
on pizza_toppings.topping_id = cte.one_tag
where one_tag != 0
group by one_tag;

-- QUESTION 4
-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- * Meat Lovers
-- * Meat Lovers - Exclude Beef
-- * Meat Lovers - Extra Bacon
-- * Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

WITH main AS (
SELECT co.order_id, co.customer_id, co.pizza_id, na.pizza_name, co.exclusions,
CASE
	WHEN co.exclusions IS NOT NULL THEN CONCAT(co.order_id, REPLACE(co.exclusions, ", ", ""))
ELSE NULL END AS exclusions_id,
co.extras,
CASE
	WHEN co.extras IS NOT NULL THEN CONCAT(co.order_id, REPLACE(co.extras, ", ", ""))
ELSE NULL END AS extras_id,
co.order_time
FROM pizza_runner.customer_orders co
JOIN pizza_runner.pizza_names na
USING (pizza_id)
),
exc AS (
SELECT order_id, CONCAT(order_id, REPLACE(GROUP_CONCAT(exclusions SEPARATOR ","), ",", "")) AS all_exclusions_id, GROUP_CONCAT(topping_name SEPARATOR ", ") AS all_exclusions
FROM (SELECT DISTINCT ex.order_id, ex.exclusions, tp.topping_name
	FROM exclusions ex
	JOIN pizza_toppings tp
	ON ex.exclusions = tp.topping_id
    ) x
GROUP BY order_id
),
ext AS (
SELECT order_id, CONCAT(order_id, REPLACE(GROUP_CONCAT(extras SEPARATOR ","), ",", "")) AS all_extras_id, GROUP_CONCAT(topping_name SEPARATOR ", ") AS all_extras
FROM (SELECT DISTINCT et.order_id, et.extras, tp.topping_name
	FROM extras et
	JOIN pizza_toppings tp
	ON et.extras = tp.topping_id
    ) y
GROUP BY order_id
)

SELECT main.order_id, main.customer_id, main.pizza_id, main.exclusions, main.extras, main.order_time,
CASE
	WHEN main.exclusions IS NOT NULL OR main.extras IS NOT NULL THEN
    CASE
		WHEN main.exclusions IS NULL THEN CONCAT(main.pizza_name, " - Extra ", ext.all_extras)
        WHEN main.extras IS NULL THEN CONCAT(main.pizza_name, " - Exclude ", exc.all_exclusions)
	ELSE CONCAT(main.pizza_name, " - Exclude ", exc.all_exclusions, " - Extra ", ext.all_extras) END
ELSE main.pizza_name END AS order_item
FROM main
LEFT JOIN exc
ON exc.all_exclusions_id = main.exclusions_id
LEFT JOIN ext
ON ext.all_extras_id = main.extras_id;


-- QUESTION 5
-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

SELECT *
FROM pizza_runner.customer_orders co
JOIN pizza_runner.pizza_recipes1 re
ON re.pizza_id = co.pizza_id
WHERE co.exclusions != cast(re.toppings as int);

-- QUESTION 6
-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

SELECT runner_id, ROUND(AVG(distance_km/(duration_mins/60)),2) AS average_speed
FROM pizza_runner.runner_orders ro
GROUP BY runner_id;
