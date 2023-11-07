-- Date / Time Function in PostgreSQL

/* 1. We want to understand the distribution of bookings across the days of the week. 
This can help in determining the busiest days for hotel bookings. 
So find the number of bookings made for each day of the week 
(0 for Sunday, 1 for Monday, and so on). */

SELECT DATE_PART('dow', arrival_date) AS weekday, COUNT(*) AS bookings
FROM bookings
GROUP BY weekday
ORDER BY bookings DESC;

/* 2. We want to see the monthly trend of bookings. By aggregating the bookings 
month-wise, we can identify peak and off-peak months. Calculate the total number 
of bookings per month. */

SELECT DATE_TRUNC ('month', arrival_date)::DATE AS month, COUNT(*) AS bookings
FROM bookings
GROUP BY month
ORDER BY bookings DESC;

SELECT EXTRACT (MONTH FROM arrival_date) AS month, COUNT(*) AS bookings
FROM bookings
GROUP BY month
ORDER by bookings DESC;

/* 3. Sometimes, we want to see bookings at a higher level, like quarterly, 
to determine seasonal trends. Get the total number of bookings for each quarter of the year. */

SELECT 'Q' || EXTRACT (QUARTER FROM arrival_date) AS quarter, COUNT(*) AS bookings
FROM bookings
GROUP BY quarter
ORDER BY quarter;

SELECT 'Q' || EXTRACT (QUARTER FROM arrival_date) AS quarter, COUNT(*) AS bookings
FROM bookings
GROUP BY quarter
ORDER BY bookings DESC;

SELECT arrival_date_year AS year, 'Q' || EXTRACT (QUARTER FROM arrival_date) AS quarter, COUNT(*) AS bookings
FROM bookings
GROUP BY arrival_date_year, quarter
ORDER BY bookings DESC;

/* 4. Retrieve the bookings made in the 7 days leading up to the most 
recent date in the dataset. */

SELECT MAX(arrival_date)
FROM bookings

SELECT id, customer_name, arrival_date
FROM bookings
WHERE arrival_date > (SELECT MAX(arrival_date) - INTERVAL '7 days' FROM bookings) 
AND arrival_date <= (SELECT MAX(arrival_date) FROM bookings)
ORDER BY arrival_date DESC;

--BETWEEN is inclusive so must cut off one day
SELECT id, customer_name, arrival_date
FROM bookings
WHERE arrival_date BETWEEN (SELECT MAX(arrival_date) - INTERVAL '6 days' FROM bookings) 
AND (SELECT MAX(arrival_date) FROM bookings)
ORDER BY arrival_date DESC;
