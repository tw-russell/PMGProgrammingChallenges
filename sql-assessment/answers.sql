
-- 1: Write a query to get the sum of impressions by day.
SELECT date, sum(impressions)
FROM marketing_data
GROUP BY date;

-- 2: Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?
SELECT state, sum(revenue)
FROM website_revenue
GROUP BY state
ORDER BY sum(revenue) DESC
LIMIT 3;
   -- The third best state, Ohio, generated 37577.0.

-- 3: Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.
SELECT name, total_cost, total_impressions, total_clicks, total_revenue
FROM campaign_info
JOIN (SELECT campaign_id as marketID, sum(cost) as total_cost, sum(impressions) as total_impressions, sum(clicks) as total_clicks
	FROM marketing_data
	GROUP BY campaign_id) ON marketID = id
JOIN (SELECT campaign_id as webID, sum(revenue) as total_revenue
	FROM website_revenue
	GROUP BY campaign_id) ON webID = id
ORDER BY name;

-- 4: Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?
SELECT geo, sum(conversions)
FROM marketing_data
WHERE campaign_id = 99058240
GROUP BY geo;
   -- Most conversions in Campaign5 were from GA, with 672.0

-- 5: In your opinion, which campaign was the most efficient, and why?
SELECT name, (total_cost / total_conversions) as cost_per_conversion, ((total_revenue - total_cost) / total_cost) as ROI
FROM campaign_info
JOIN (SELECT campaign_id as marketID, sum(cost) as total_cost, sum(conversions) as total_conversions
	FROM marketing_data
	GROUP BY campaign_id) ON marketID = id
JOIN (SELECT campaign_id as webID, sum(revenue) as total_revenue
	FROM website_revenue
	GROUP BY campaign_id) ON webID = id
ORDER BY cost_per_conversion;
   /* The most effecicient campaign would be the one with the minimum cost per conversion. This number makes campaign4 the most efficient.
   Another angle on efficiency could be to maximize ROI, which would make campaign5 the most efficient. campaign5 does have the highest cost per conversion,
   though. The ROI calculation assumes all revenue from the website is a direct result of the ad campaign, which may not be true, so I prioritized cost per conversion. */


-- BONUS: Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads. */
SELECT CASE CAST (strftime('%w', substr(date, 1, 10)) AS INTEGER)
	WHEN 0 THEN 'Sunday'
	WHEN 1 THEN 'Monday'
	WHEN 2 THEN 'Tuesday'
	WHEN 3 THEN 'Wednesday'
	WHEN 4 THEN 'Thursday'
	WHEN 5 THEN 'Friday'
	ELSE 'Saturday' END as week_day,
	sum(conversions) as total_conversions, sum(clicks) as total_clicks, sum(impressions) as total_impressions
from marketing_data
GROUP BY week_day
ORDER BY total_conversions DESC;
   -- This query returns days of the week sorted by total conversions. Friday was the day that generated the most conversions,
   -- making it the best day to run ads based on this data.
