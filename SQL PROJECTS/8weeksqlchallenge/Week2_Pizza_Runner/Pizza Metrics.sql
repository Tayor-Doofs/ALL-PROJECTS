-- SOLUTIONS TO PIZZA METRICS QUESTIONS

-- QUESTION 1
-- How many pizzas were ordered?

SELECT COUNT(pizza_id) AS pizza_ordered_count
FROM pizza_runner.customer_orders;

-- QUESTION 2
-- How many unique customer orders were made?

SELECT COUNT(DISTINCT customer_id) AS unique_customer_count
FROM pizza_runner.customer_orders;

-- QUESTION 3
-- How many successful orders were delivered by each runner?

SELECT runner_id, COUNT(*) AS count_of_successful_orders
FROM pizza_runner.runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

-- QUESTION 4
-- How many of each type of pizza was delivered?

SELECT n.pizza_name, COUNT(*) AS count_of_deliveries
FROM pizza_runner.runner_orders ro
JOIN pizza_runner.customer_orders co
USING (order_id)
JOIN pizza_runner.pizza_names n
ON n.pizza_id = co.pizza_id
WHERE cancellation IS NULL
GROUP BY n.pizza_name;

-- QUESTION 5
-- How many Vegetarian and Meatlovers were ordered by each customer?

SELECT co.customer_id,
COUNT(IF(co.pizza_id = 1, 1, NULL)) AS meatlovers_pizza_count,
COUNT(IF(co.pizza_id = 2, 1, NULL)) AS vegetarian_pizza_count
FROM pizza_runner.customer_orders co
JOIN pizza_runner.pizza_names n
ON n.pizza_id = co.pizza_id
GROUP BY co.customer_id;

-- QUESTION 6
-- What was the maximum number of pizzas delivered in a single order?

SELECT MAX(pizza_delivery_count) AS MaxPizzaDelivered
FROM
(SELECT co.order_id, COUNT(pizza_id) AS pizza_delivery_count
FROM pizza_runner.customer_orders co
JOIN pizza_runner.runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.order_id) x;

-- QUESTION 7
-- For each customer, how many delivered pizzas had at least 1 change and
-- how many had no changes?

SELECT co.customer_id,
COUNT(IF((co.exclusions IS NOT NULL OR co.extras IS NOT NULL), 1, NULL)) AS atleast_one_change_in_pizza,
COUNT(IF((co.exclusions IS NULL AND co.extras IS NULL), 1, NULL)) AS no_change_in_pizza
FROM pizza_runner.customer_orders co
JOIN pizza_runner.runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.customer_id;

-- QUESTION 8
-- How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(IF((co.exclusions IS NOT NULL AND co.extras IS NOT NULL), 1, NULL))
AS count_of_pizza_delivered_with_exclusions_and_extras
FROM pizza_runner.customer_orders co
JOIN pizza_runner.runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.cancellation IS NULL;

-- QUESTION 9
-- What was the total volume of pizzas ordered for each hour of the day?

SELECT CASE
		WHEN hour(order_time) NOT BETWEEN 11 AND 19
		THEN CASE
				WHEN RIGHT(hour(order_time),1) = 1 THEN CONCAT(hour(order_time),"st hour")
				WHEN RIGHT(hour(order_time),1) = 2 THEN CONCAT(hour(order_time),"nd hour")
				WHEN RIGHT(hour(order_time),1) = 3 THEN CONCAT(hour(order_time),"rd hour")
			 END
	   ELSE CONCAT(hour(order_time),"th hour")
       END AS hour_of_the_day,
COUNT(pizza_id) AS total_volumes_of_pizza_ordered
FROM pizza_runner.customer_orders
GROUP BY hour_of_the_day;

-- QUESTION 10
-- What was the volume of orders for each day of the week?

SELECT dayname(order_time) AS day_of_the_week,
COUNT(pizza_id) AS total_volumes_of_pizza_ordered
FROM pizza_runner.customer_orders
GROUP BY day_of_the_week
ORDER BY weekday(order_time);
