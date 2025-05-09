-- Question set 1: EASY
-- Q1 Who is the senior most employee based on job title
select *
from employee
order by levels desc
limit 1
;

-- Q2 Which countries have the most invoices

select billing_country, count(*) as cnt
from invoice
group by billing_country
order by cnt desc;

-- Q3 What are the top 3 values of total invoices

select total
from invoice
order by total desc
limit 3

--Q4 Which city has the best customer? We would like to throw a
--promotional music festival in the city we made the most money.
--write a query that returns one city that has the highest sum of 
--invoice totals. Return both city name & sum of invoice totals

select billing_city, sum(total) as invoice_totals
from invoice
group by billing_city
order by invoice_totals desc
limit 1

--Q5 Who is best customer? The customer who has spent the most money
--will be declared the best customer. Write a query that returns the
--person who has spent the most money

select c.customer_id, c.first_name, c.last_name, sum(i.total) as total_invoices
from customer as c
join invoice as i
	on c.customer_id = i.customer_id
group by c.customer_id
order by total_invoices desc
limit 1







