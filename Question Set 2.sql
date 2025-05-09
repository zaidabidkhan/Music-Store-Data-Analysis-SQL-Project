-- Question set 2: MODERATE
-- Q1 Write query to return the email, first name, last name & genre of
-- of all rock music listeners. return your list ordered alphabetically
-- by email strating with A

select distinct c.email, c.first_name, c.last_name
from customer as c
join invoice as i
	on c.customer_id = i.customer_id
join invoice_line as il
	on i. invoice_id = il.invoice_id
join track as t
	on il.track_id = t.track_id
join genre as g
	on t.genre_id = g.genre_id
where g.name like 'Rock'
order by c.email

--OR

select distinct c.email, c.first_name, c.last_name
from customer as c
join invoice as i
	on c.customer_id = i.customer_id
join invoice_line as il
	on i. invoice_id = il.invoice_id
where il.track_id in (
						Select t.track_id
						from track as t
						join genre as g
							on t.genre_id = g.genre_id
						where g.name like 'Rock'
						)
order by c.email;
-- Q2 Let's invite the artists who has written the most rock music in our
-- dataset. Write a query that returns the Artist name and total track 
-- count of the top 10 rock bands

select art.name, count(*) as total_track
from track as t
join album as alb
	on t.album_id =  alb.album_id
join artist as art
	on alb.artist_id = art.artist_id
join genre as g
	on t.genre_ID = g.genre_id
where g.name like 'Rock'
group by art.name
order by total_track desc
limit 10;

-- Q3 Return all the track names that have a song length longer than the avg song
-- length. Return the name and milliseconds for each track. Order by the song length
-- with longest songs listed first

select t.name, t.milliseconds
from track as t
where t.milliseconds > (
						select avg(milliseconds)
						from track
						)
order by t.milliseconds desc
