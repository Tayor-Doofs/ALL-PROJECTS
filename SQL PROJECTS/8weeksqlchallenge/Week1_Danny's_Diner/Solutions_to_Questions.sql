-- Question 1
-- What is the total amount each customer spent at the restaurant?

SELECT s.customer_id, sum(m.price) as total_price
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
USING (product_id)
GROUP BY s.customer_id;

-- Question 2
-- How many days has each customer visited the restaurant?

SELECT customer_id, count(DISTINCT order_date) as days
FROM dannys_diner.sales
GROUP BY customer_id;

-- Question 3
-- What was the first item from the menu purchased by each customer?

SELECT t.customer_id, t.first_item_purchased
FROM
(SELECT s.customer_id, m.product_name as first_item_purchased,
ROW_NUMBER()
		OVER
			(
				PARTITION BY s.customer_id
                ORDER BY s.order_date ASC
			) AS rownumber
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
USING (product_id)
) t
WHERE rownumber = 1;

-- Question 4
-- What is the most purchased item on the menu and
-- how many times was it purchased by all customers?

SELECT m.product_name, count(*) as purchase_count
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
USING (product_id)
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1;

-- Question 5
-- Which item was the most popular for each customer?

SELECT x.customer_id, x.product_name
FROM
(SELECT t.customer_id, t.product_name, t.purchase_count,
RANK()
			OVER (
					PARTITION BY t.customer_id
                    ORDER BY t.customer_id, t.purchase_count DESC
				 ) AS rownumber
FROM
(SELECT s.customer_id, m.product_name, count(*) as purchase_count
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
USING (product_id)
GROUP BY s.customer_id, m.product_name
) t
) x
WHERE x.rownumber = 1;

-- Question 6
-- Which item was purchased first by the customer
-- after they became a member?

SELECT t.customer_id, t.product_name
FROM
(SELECT s.customer_id, m.product_name, s.order_date, me.join_date,
ROW_NUMBER()
			OVER (
					PARTITION BY s.customer_id
                    ORDER BY s.customer_id, s.order_date ASC
				 ) AS rownumber
FROM dannys_diner.sales s
LEFT JOIN dannys_diner.menu m
USING(product_id)
LEFT JOIN dannys_diner.members me
USING(customer_id)
WHERE s.order_date > me.join_date
) t
WHERE t.rownumber = 1;

-- Question 7
-- Which item was purchased just before the customer became a member?

SELECT t.customer_id, t.product_name
FROM
(
SELECT s.customer_id, m.product_name, s.order_date, me.join_date,
ROW_NUMBER()
			OVER (
					PARTITION BY s.customer_id
                    ORDER BY s.customer_id, s.order_date DESC
				 ) AS rownumber
FROM dannys_diner.sales s
LEFT JOIN dannys_diner.menu m
USING(product_id)
LEFT JOIN dannys_diner.members me
USING(customer_id)
WHERE s.order_date < me.join_date
) t
WHERE t.rownumber = 1;

-- Question 8
-- What is the total items and amount spent for each member
-- before they became a member?

SELECT t.customer_id, count(t.product_name) as total_items,
SUM(t.price) AS total_amount_spent
FROM
(
SELECT s.customer_id, m.product_name, s.order_date, me.join_date,
m.price
FROM dannys_diner.sales s
LEFT JOIN dannys_diner.menu m
USING(product_id)
LEFT JOIN dannys_diner.members me
USING(customer_id)
WHERE s.order_date < me.join_date
) t
GROUP BY t.customer_id;

-- Question 9
-- If each $1 spent equates to 10 points and
-- sushi has a 2x points multiplier 
-- how many points would each customer have?

SELECT t.customer_id, SUM(t.total_price *
CASE WHEN t.product_name = "sushi" then 2 else 1 end * 10) as points
FROM
(SELECT s.customer_id, m.product_name,
SUM(m.price) as total_price
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
USING (product_id)
GROUP BY s.customer_id, m.product_name
) t
GROUP BY t.customer_id;

-- Question 10
-- In the first week after a customer joins the program
-- (including their join date) they earn 2x points on all items,
-- not just sushi - how many points do customer A and B
-- have at the end of January?

SELECT s.customer_id, 
case when s.order_date >= me.join_date then SUM(m.price * 2 * 10) else SUM(m.price * 10) end as points
FROM dannys_diner.sales s
LEFT JOIN dannys_diner.menu m
USING (product_id)
LEFT JOIN dannys_diner.members me
USING (customer_id)
WHERE s.order_date <= "2022-01-31"
and s.customer_id != "C"
GROUP BY s.customer_id;

-- BONUS QUESTION 1

SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE WHEN s.order_date < me.join_date or me.join_date is null THEN "N" else "Y" end as `member`
FROM dannys_diner.sales s
LEFT JOIN dannys_diner.menu m
USING (product_id)
LEFT JOIN dannys_diner.members me
USING (customer_id);

-- BONUS QUESTION 2

SELECT t.customer_id, t.order_date, t.product_name, t.price, t.member,
CASE WHEN t.member = "N" THEN null else
RANK()
			OVER (
					PARTITION BY t.customer_id, t.member
                    ORDER BY t.customer_id, t.order_date ASC
				 )
END AS ranking
FROM
(SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE WHEN s.order_date < me.join_date or me.join_date is null THEN "N" else "Y" end as `member`
FROM dannys_diner.sales s
LEFT JOIN dannys_diner.menu m
USING (product_id)
LEFT JOIN dannys_diner.members me
USING (customer_id)
) t;
