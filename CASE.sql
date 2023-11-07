--1. Guest Loyalty Program
--The hotel chain is keen to reward its loyal customers and is in the process of 
--classifying them based on the frequency of their stays. Given the data, determine 
--how many guests fall into the 'Bronze', 'Silver', or 'Gold' categories based on their 
--number of bookings. 
--You can categorize the number of bookings as Bronze (1-3 stays), Silver (4-6 stays), 
--Gold (7 or more stays) OR however you think best. Please provide notes regarding 
--the reasons for your category choices.
--How do these categories compare in size?

SELECT customer_booking_frequencies, Count (*) AS total_frequency
FROM (SELECT customer_name, COUNT (customer_name) AS customer_booking_frequencies
FROM bookings
GROUP BY customer_name)
GROUP BY customer_booking_frequencies
ORDER By COUNT (*) DESC;

SELECT customer_name, COUNT (customer_name) AS total_bookings,
CASE
	WHEN COUNT (customer_name) BETWEEN 2 AND 4 THEN 'Bronze'
	WHEN COUNT (customer_name) BETWEEN 5 AND 7 THEN 'Silver'
	WHEN COUNT (customer_name) >= 8 THEN 'Gold'
	ELSE 'Valued Guest'
	END AS RewardsLevel
FROM bookings
GROUP BY customer_name
ORDER BY total_bookings DESC;

SELECT RewardsLevel, COUNT(*)
FROM (SELECT customer_name, COUNT (customer_name) AS total_bookings,
	  CASE
	  WHEN COUNT (customer_name) BETWEEN 2 AND 4 THEN 'Bronze'
	  WHEN COUNT (customer_name) BETWEEN 5 AND 7 THEN 'Silver'
	  WHEN COUNT (customer_name) >= 8 THEN 'Gold'
	  ELSE 'Valued Guest'
	  END AS RewardsLevel
	  FROM bookings
	  WHERE is_canceled = 0
	  GROUP BY customer_name
	  ORDER BY total_bookings DESC) AS temp
GROUP BY RewardsLevel;

--I chose to increase the criteria for bronze tier by 1 bookings because I felt it would be
--less than ideal for the 95% of single visit customers to be in the rewards program. As an 
--incentive, I feel they should have to visit a second time. I created the "Valued Guest" tier
--to capture those visitors. The brass ring should not be on the floor. Of the remaining tiers,
--Bronze is the overwhelmingly largest category, followed by Silver and a much smaller Gold tier.

--2. Seasonal Pricing Analysis
--Seasonal trends often influence room rates. The finance department suspects that 
--certain months fetch higher rates due to demand. Analyze the dataset to classify the 
--average daily rate (ADR) by month. Which months see the highest average rates, and 
--how do they align with traditional seasons? Assume summer months (June, July, 
--August) usually have higher rates.

SELECT arrival_date_month, MONEY(AVG(adr)) AS avg_daily_rate
FROM bookings
GROUP BY arrival_date_month
ORDER BY AVG(adr) DESC;

SELECT BookingSeason, MONEY(AVG(avg_daily_rate)) AS avg_rate
FROM (SELECT arrival_date_month_numeric, (AVG(adr)) AS avg_daily_rate,
	  CASE
	  WHEN arrival_date_month_numeric IN (12,1,2) THEN 'Winter'
	  WHEN arrival_date_month_numeric IN (3,4,5) THEN 'Spring'
	  WHEN arrival_date_month_numeric IN (6,7,8) THEN 'Summer'
	  WHEN arrival_date_month_numeric IN (9,10,11) THEN 'Autumn'
	  ELSE 'Incorrect Data'
	  END AS BookingSeason
FROM bookings
GROUP BY arrival_date_month_numeric
ORDER BY avg_daily_rate DESC) AS temp
GROUP BY BookingSeason
ORDER BY avg_rate DESC;

--As predicted in the question, the Summer months were the highest grossing months by adr. 
--Spring followed as the second highest grossing season while Autumn and Winter were third and
--fourth respectively. 

--3. Booking Source Analysis
--Different booking sources can offer varying returns on investment. The marketing 
--team wants to understand the distribution of booking sources. Investigate how many 
--bookings are made directly, through agents, or via corporate channels. Which source 
--dominates?

SELECT DISTINCT distribution_channel, COUNT(*)
FROM bookings
GROUP BY distribution_channel;

SELECT *
FROM bookings
WHERE distribution_channel ILIKE ('undefined');

SELECT BookingSource, SUM (bookings) AS total_bookings
FROM (SELECT distribution_channel, COUNT(*) AS bookings,
	  CASE
	  WHEN distribution_channel IN ('TA/TO','GDS') THEN 'Agent'
	  WHEN distribution_channel = 'Corporate' THEN 'Corporate'
	  WHEN distribution_channel = 'Direct' THEN 'Direct'
	  ELSE 'N/A'
	  END AS BookingSource
FROM bookings
GROUP BY distribution_channel) AS temp
GROUP BY BookingSource
ORDER BY total_bookings DESC;

--Agents overwhelmingly dominate the the booking sources. I combined GDS with TO/TA as research
--led me to believe that GDS stood for Global Distribution System which appears to be systems
--used by agents to book travel details. 

--4. Guest Feedback Strategy
--The hotel believes in continuous improvement. They hypothesize that guests staying 
--longer might have more insights about the hotel's services. Examine the lengths of 
--stays and categorize them. 
--Categorize stays as 'Short', 'Medium', or 'Long' (1-3 days, 4-7 days, more than 7 days, 
--respectively).
--Which category is the most common, and which might provide the most 
--comprehensive feedback?

--SELECT customer_name, (reservation_status_date - arrival_date) AS total_days
--FROM bookings
--WHERE reservation_status = 'Check-Out'
--ORDER BY customer_name ASC

--LEGACY CODE - DO NOT EVALUATE - FOR FUN
--SELECT BookingLength, COUNT (BookingLength) AS booking_frequency
--FROM (SELECT customer_name, reservation_status_date - arrival_date - 1 AS total_days,
--CASE
--	WHEN reservation_status_date - arrival_date - 1 IN (1,2,3) THEN 'Short'
--	WHEN reservation_status_date - arrival_date - 1 IN (4,5,6,7) THEN 'Medium'
--	WHEN reservation_status_date - arrival_date - 1 > 7 THEN 'Long'
--	ELSE 'N/A'
--	END AS BookingLength
--FROM bookings
--WHERE reservation_status = 'Check-Out'
--GROUP BY customer_name, total_days) AS temp
--GROUP BY BookingLength
--ORDER BY booking_frequency DESC

SELECT customer_name, (stays_in_weekend_nights::INT + stays_in_week_nights::INT) AS total_days
FROM bookings
WHERE is_canceled = '0'
ORDER BY customer_name ASC

SELECT BookingLength, COUNT (BookingLength) AS booking_frequency
FROM (SELECT customer_name, stays_in_weekend_nights::INT + stays_in_week_nights::INT AS total_days,
     CASE
	 WHEN stays_in_weekend_nights::INT + stays_in_week_nights::INT IN (1,2,3) THEN 'Short'
     WHEN stays_in_weekend_nights::INT + stays_in_week_nights::INT IN (4,5,6,7) THEN 'Medium'
     WHEN stays_in_weekend_nights::INT + stays_in_week_nights::INT > 7 THEN 'Long'
	 ELSE 'N/A'
	 END AS BookingLength
FROM bookings
WHERE is_canceled = '0'
GROUP BY customer_name, total_days) AS temp
GROUP BY BookingLength
ORDER BY booking_frequency DESC

--Of the categories, most people fall into the "Short" grouping. I feel
--that the "Medium" group would be best to call on. They would most likely
--have experienced the length and breadth of amenities at the hotel while
--being ~712% larger than the "Long" group, thus representing more typical
--stays at the hotel.


--5. Cancellation Insights
--Lost bookings, especially last-minute cancellations, can impact revenue. The 
--operations team wishes to understand the typical lead time before a booking is 
--canceled. 
--Categorize cancellations based on lead time: 'Last Minute' (less than 7 days), 'Short 
--Notice' (7-30 days), and 'Advanced Notice' (more than 30 days) then analyze the data 
--to determine the distribution of cancellation lead times. 
--Are last-minute cancellations more common than advanced notice ones?

SELECT CancellationNotice, COUNT(*)
FROM (SELECT customer_name,
	  CASE
	  WHEN lead_time < 7 THEN 'Last Minute'
	  WHEN lead_time BETWEEN 7 AND 30 THEN 'Short Notice'
	  WHEN lead_time > 30 THEN 'Advance Notice'
	  ELSE 'N/A'
	  END AS CancellationNotice
FROM bookings
WHERE is_canceled = 1) AS temp
GROUP BY CancellationNotice
ORDER BY Count(*) DESC

--Based on my output, it appears that 'Advance Notice' is the overwhelming majority grouping
--of cancellation lead times. Last minute represents the smallest proportion of the population.
