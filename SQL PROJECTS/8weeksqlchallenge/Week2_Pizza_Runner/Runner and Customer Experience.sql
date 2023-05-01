-- SOLUTIONS TO RUNNER AND CUSTOMER EXPERIENCE QUESTIONS

-- QUESTION 1
-- How many runners signed up for each 1 week period?
-- (i.e. week starts 2021-01-01)

SELECT CONCAT("Week", " ", week(registration_date, "2021-01-01") + 1) AS `Week`, 
COUNT(*) AS runners_count
FROM pizza_runner.runners
GROUP BY `Week`;

-- QUESTION 2
-- What was the average time in minutes it took for each runner
-- to arrive at the Pizza Runner HQ to pickup the order?

SELECT ROUND(AVG(TIMESTAMPDIFF(SECOND, co.order_time, ro.pickup_time)/60)) AS avg_minutes_to_pickup
FROM pizza_runner.customer_orders co
INNER JOIN pizza_runner.runner_orders ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL;

-- QUESTION 3
-- Is there any relationship between the number of pizzas and how long the order
-- takes to prepare?

SELECT co.order_id,
COUNT(
(LENGTH(pr.toppings) - LENGTH(REPLACE(pr.toppings, ",", "")) + 1) +
(CASE WHEN co.extras IS NULL THEN 0 ELSE LENGTH(co.extras) - LENGTH(REPLACE(co.extras, ",", "")) + 1 END) -
(CASE WHEN co.exclusions IS NULL THEN 0 ELSE LENGTH(co.exclusions) - LENGTH(REPLACE(co.exclusions, ",", "")) + 1 END)
) AS no_of_pizza_ordered,
SUM(
(LENGTH(pr.toppings) - LENGTH(REPLACE(pr.toppings, ",", "")) + 1) +
(CASE WHEN co.extras IS NULL THEN 0 ELSE LENGTH(co.extras) - LENGTH(REPLACE(co.extras, ",", "")) + 1 END) -
(CASE WHEN co.exclusions IS NULL THEN 0 ELSE LENGTH(co.exclusions) - LENGTH(REPLACE(co.exclusions, ",", "")) + 1 END)
) AS final_ingredients_count
FROM pizza_runner.customer_orders co
JOIN pizza_runner.pizza_recipes pr
ON co.pizza_id = pr.pizza_id
GROUP BY co.order_id;

-- QUESTION 4
-- What was the average distance travelled for each customer?

SELECT co.customer_id, ROUND(AVG(distance_km),2) AS average_distance_travelled
FROM pizza_runner.runner_orders ro
JOIN pizza_runner.customer_orders co
USING (order_id)
GROUP BY co.customer_id;

-- QUESTION 5
-- What was the difference between the longest and shortest delivery times for all orders?

SELECT CONCAT(MAX(duration_mins) - MIN(duration_mins), " minutes") AS MaxMinDelvTimeDiff
FROM pizza_runner.runner_orders ro;

-- QUESTION 6
-- What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT runner_id, order_id, ROUND(AVG(distance_km/(duration_mins/60)),2) AS average_speed
FROM pizza_runner.runner_orders ro
GROUP BY runner_id, order_id;

-- QUESTION 7
-- What is the successful delivery percentage for each runner?

SELECT runner_id, CONCAT(ROUND(COUNT(CASE WHEN cancellation IS NULL THEN 1 END)*100/COUNT(runner_id), 2), "%") AS successful_delivery_percentage
FROM pizza_runner.runner_orders ro
GROUP BY runner_id;