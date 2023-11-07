--1. Hotel Popularity Analysis
--● The management wants to understand the popularity of the hotel types within 
--their chain. Determine the number of bookings each hotel type has received to 
--assess which one is more popular among guest

SELECT hotel, COUNT (hotel) AS number_of_bookings
FROM bookings
GROUP BY hotel;

--2. Seasonal Booking Insights
--● The operations team is looking to understand the seasonality of bookings to 
--manage staffing and inventory better. Identify the months that receive the 
--highest number of bookings.

SELECT arrival_date_month, COUNT (*) AS total_bookings
FROM bookings
GROUP BY arrival_date_month
ORDER BY COUNT (arrival_date_month) DESC;

--3. Guest Services Enhancement
--● The guest services department wants to tailor their offerings based on the special 
--requests made by guests. Identify the most common counts of special requests 
--among bookings, focusing on those with more than 2 requests.

SELECT total_of_special_requests, COUNT (*) AS frequency
FROM bookings
WHERE total_of_special_requests::INT > 2
GROUP BY total_of_special_requests;

--4. Agent Contribution Analysis
--● As part of the annual review, the HR department wants to recognize top-
--performing agents. Identify the top 5 agents who have secured the most non-
--canceled bookings

SELECT agent, COUNT (*) AS number_of_bookings 
FROM bookings
WHERE is_canceled = 0 AND agent != '0'
GROUP BY agent
ORDER BY number_of_bookings DESC
LIMIT 5;

--5. Revenue Maximization Strategy
--● The finance team is analyzing months that yield higher revenue. Determine the 
--months that have the highest average daily rates for bookings, focusing on rates 
--above $100

SELECT arrival_date_month, AVG (adr) AS average_daily_rate
FROM bookings
GROUP BY arrival_date_month
HAVING AVG (adr) > 100
ORDER BY AVG (adr) DESC;

--6. Target Audience Segmentation
--● The marketing department wants to design campaigns tailored to different 
--customer segments. Find out the number of bookings associated with each 
--customer type, emphasizing segments with more than 10 bookings

SELECT customer_type, COUNT (*) AS customer_frequency
FROM bookings
GROUP BY customer_type
HAVING COUNT (*) >10;

--7. Future Planning Insights
--● The strategic planning team is keen on understanding guest behavior when it 
--comes to advance bookings. Ascertain the months in which guests typically book 
--their stays well in advance

SELECT arrival_date_month, AVG (lead_time) AS days_booked_in_advance
FROM bookings 
GROUP BY arrival_date_month
HAVING AVG (lead_time) > 100
ORDER BY days_booked_in_advance DESC;

--8. Booking Security Analysis
--● To refine the hotel's booking security policy, the management wants insights into 
--deposit trends. Assess the distribution of bookings across various deposit types, 
--particularly types with more than 50 bookings.

SELECT deposit_type, COUNT (*) AS deposit_type_frequency
FROM bookings
GROUP BY deposit_type
HAVING COUNT (*) > 50;

--9. Room Allocation Strategy
--● The housekeeping team is looking to optimize their cleaning schedules based on 
--room popularity. Identify the most popular room types based on reservations, 
--focusing on types with more than 20 bookings.

SELECT reserved_room_type, COUNT(*) AS reservation_frequency
FROM bookings
GROUP BY reserved_room_type
HAVING COUNT (*) > 20
ORDER BY reservation_frequency DESC;

--10.Guest Retention Assessment
--● The customer relations team wants to implement strategies to reduce 
--cancellations. To do this, they need insights into which hotel types experience the 
--highest cancellations. Highlight hotels with more than 10 cancellations

SELECT hotel, COUNT (is_canceled) AS total_cancellations
FROM bookings
WHERE is_canceled = 1
GROUP BY hotel
HAVING COUNT (is_canceled) > 10
