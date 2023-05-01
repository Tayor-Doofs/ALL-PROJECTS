# SQL-PROJECTS
All my SQL projects can be found here

** 8 week SQL challenge
	i. Danny's Diner:

	   Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns,
	   how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers
	   will help him deliver a better and more personalised experience for his loyal customers.

	   The DB contains 3 entities (sales, menu, and members).
	
	   Case Study Questions
	   Each of the following case study questions can be answered using a single SQL statement:

         a. What is the total amount each customer spent at the restaurant?
	   b. How many days has each customer visited the restaurant?
	   c. What was the first item from the menu purchased by each customer?
	   d. What is the most purchased item on the menu and how many times was it purchased by all customers?
	   e. Which item was the most popular for each customer?
	   f. Which item was purchased first by the customer after they became a member?
	   g. Which item was purchased just before the customer became a member?
	   h. What is the total items and amount spent for each member before they became a member?
	   i. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
	   j. In the first week after a customer joins the program (including their join date) they earn 2x points on all items,
		not just sushi - how many points do customer A and B have at the end of January?

	   Attached are the queries used to create the schema and the queries used to answer the questions.

	   Bonus questions are also answered


	ii. Pizza Runner:
		
	    This case study has LOTS of questions - they are broken up by area of focus including:

	    *  Pizza Metrics
	    a. How many pizzas were ordered?
	    b. How many unique customer orders were made?
	    c. How many successful orders were delivered by each runner?
	    d. How many of each type of pizza was delivered?
	    e. How many Vegetarian and Meatlovers were ordered by each customer?
	    f. What was the maximum number of pizzas delivered in a single order?
	    g. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
	    h. How many pizzas were delivered that had both exclusions and extras?
	    i. What was the total volume of pizzas ordered for each hour of the day?
	    j. What was the volume of orders for each day of the week?

	    *  Runner and Customer Experience
	    a. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
	    b. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
	    c. Is there any relationship between the number of pizzas and how long the order takes to prepare?
	    d. What was the average distance travelled for each customer?
	    e. What was the difference between the longest and shortest delivery times for all orders?
	    f. What was the average speed for each runner for each delivery and do you notice any trend for these values?
	    e. What is the successful delivery percentage for each runner?

	    *  Ingredient Optimisation
	    a. What are the standard ingredients for each pizza?
	    b. What was the most commonly added extra?
	    c. What was the most common exclusion?
	    d. Generate an order item for each record in the customers_orders table in the format of one of the following:
		 -- Meat Lovers
	    	 -- Meat Lovers - Exclude Beef
		 -- Meat Lovers - Extra Bacon
		 -- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
	    e. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant
		 ingredients
		 -- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
	    f. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

	    *  Pricing and Ratings
	    a. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no
		 delivery fees?
	    b. What if there was an additional $1 charge for any pizza extras?
		 -- Add cheese is $1 extra
	    c. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for
		 this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
	    d. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
		 -- customer_id
		 -- order_id
		 -- runner_id
		 -- rating
		 -- order_time
		 -- pickup_time
		 -- Time between order and pickup
		 -- Delivery duration
		 -- Average speed
		 -- Total number of pizzas
	    e. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how
		 much money does Pizza Runner have left over after these deliveries?

	    *  Bonus DML Challenges (DML = Data Manipulation Language)
	    a. If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen
		 if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
