-- Question Set 3- Advance

-- Q1 Find how much amount spent by each customer on specific artists? Write
-- a query to return customer name, artist name and total_spent

-- Step 1 : Find the artist who has made the most money from sales suing cte

with best_selling_artist as (
select art.artist_id as artist_id, art.name as artist_name,
sum(il.unit_price * il.quantity) as total_sales
from invoice_line as il
join track as t
	on t.track_id = il.track_id
join album as alb
	on alb.album_id = t.album_id
join artist as art
	on art.artist_id = alb.artist_id
group by art.artist_id, art.name
order by total_sales desc
limit 1
)

select c.customer_id, c.first_name, c.last_name, bsa.artist_name,
round(sum(il.unit_price * il.quantity)::INT,2) as amount_spent
from invoice as i
join customer as c on c.customer_id = i.customer_id
join invoice_line as il on il.invoice_id = i.invoice_id
join track as t on t.track_id = il.track_id
join album as alb on alb.album_id =t.album_id
join best_selling_artist as bsa on bsa.artist_id = alb.artist_id
group by c.customer_id, c.first_name, c.last_name, bsa.artist_name
order by amount_spent desc
;

--Q2 Find how much amount spent by each customer on artists? Write
-- a query to return customer name, artist name and total_spent

select c.first_name || ' ' || c.last_name as customer_name, art.name as artist_name,
round(sum(il.unit_price * il.quantity)::INT,2) as total_spent
from invoice as i
join customer as c
	on c.customer_id = i.customer_id
join invoice_line as il
	on il.invoice_id = i.invoice_id
join track as t
	on t.track_id = il.track_id
join album as alb
	on alb.album_id = t.album_id
join artist as art
	on art.artist_id = alb.artist_id
group by  c.first_name, c.last_name, art.name
order by customer_name, total_spent desc
;

-- Q2 We want to find out the most popular music genre for each country
-- We determine the most popular genre as the genre with the highest
-- amount of purchases. Write a query that returns each country along with
-- top genre. For countries where the maximum number of purchases is shared
-- return all genres

with popular_genre as 
(
	select count(il.quantity) as purchases, c.country, g.name,
	row_number() over (partition by c.country order by count(il.quantity) desc) as Row_num
	from invoice_line as il
	join invoice as i
		on il.invoice_id = i.invoice_id
	join customer as c
		on c.customer_id = i.customer_id
	join track as t
		on t.track_id = il.track_id
	join genre as g
		on g.genre_id = t.genre_id
	group by c.country, g.name
	order by c.country asc , purchases desc
)

select * 
from popular_genre
where Row_num <=1
;

-- Q3 Write a query that determines the customer that has spent the
-- most on music for each country. write a query that returns the country
-- along with the top customer and how much they spent. For Countries where
-- the top amount pent is shared, provide all customer who spent this amount

with most_spent as 
(
	select  c.customer_id, c.first_name || ' ' || c.last_name as customer_name,
	i.billing_country, sum(total) as total_spent,
	row_number() over(partition by i.billing_country order by sum(total) desc) as row_num
	from invoice as i
	join customer as c
		on c.customer_id = i.customer_id
	group by i.billing_country, c.customer_id
	order by i.billing_country, c.customer_id
)

select * from most_spent
where row_num <= 1












