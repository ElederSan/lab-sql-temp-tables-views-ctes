/*
Creating a Customer Summary Report

In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

Step 1: Create a View
First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

*/

-- Step 1: Create a View First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

SELECT * FROM sakila.payment;

CREATE VIEW rental_customer AS(
SELECT r.customer_id AS customer_id,c.first_name AS first_name,c.last_name AS last_name,c.email,COUNT(distinct r.rental_id) AS rental_count
FROM sakila.rental r
LEFT JOIN sakila.customer c
ON r.customer_id = c.customer_id
GROUP BY customer_id,first_name,last_name,email
);

SELECT * FROM sakila.rental_customer;


-- Step 2: Create a Temporary Table Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
-- Note: Not sure I understood this correctly. I have created the table only with the customer_id and sum of rental amount, as we will join the previous view/table rental_customer and this one amount_customer on Step 3, showing the whole picture.

CREATE TEMPORARY TABLE amount_customer AS(
SELECT customer_id,SUM(amount) AS amount_rental 
FROM sakila.payment
GROUP BY customer_id
);


-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

CREATE TEMPORARY TABLE customer_summary_report AS(
SELECT r.customer_id AS customer_id,r.first_name AS first_name,r.last_name AS last_name,r.email AS email, r.rental_count AS rental_count,ac.amount_rental AS amount_rental
FROM sakila.rental_customer r
LEFT JOIN sakila.amount_customer ac
ON r.customer_id = ac.customer_id
ORDER BY amount_rental DESC);

SELECT * FROM customer_summary_report;

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

CREATE TEMPORARY TABLE final_report AS(
SELECT r.customer_id AS customer_id,r.first_name AS first_name,r.last_name AS last_name,r.email AS email, r.rental_count AS rental_count,ac.amount_rental AS amount_rental, (ac.amount_rental / r.rental_count) AS avg_payment_per_rental
FROM sakila.rental_customer r
LEFT JOIN sakila.amount_customer ac
ON r.customer_id = ac.customer_id
ORDER BY amount_rental DESC);

SELECT * FROM final_report;
