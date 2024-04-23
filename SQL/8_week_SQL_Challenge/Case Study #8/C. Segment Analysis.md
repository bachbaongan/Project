## C. Segment Analysis
### 1. Using our filtered dataset by removing the interests with less than 6 months' worth of data, which are the top 10 and bottom 10 interests which have the largest composition values in any `month_year`? Only use the maximum composition value for each interest but you must keep the corresponding `month_year`

TOP 10 interests that have the largest composition values
~~~~sql
WITH max_composition AS (
SELECT month_year, interest_id, MAX(composition) OVER (PARTITION BY interest_id) AS largest_composition
FROM temp_interest_metrics -- Temp table in which interests with less than 6 months are removed
WHERE month_year IS NOT NULL
)
, composition_rank AS (
SELECT *, DENSE_RANK() OVER (ORDER BY largest_composition DESC) as rank
FROM max_composition
)
SELECT cr.interest_id, ma.interest_name, cr.rank
FROM composition_rank cr
JOIN fresh_segments.interest_map ma ON ma.id=cr.interest_id
WHERE cr.rank <=10
GROUP BY cr.rank,cr.interest_id,ma.interest_name
ORDER BY cr.rank;
~~~~
![Screenshot 2024-04-22 at 3 45 00 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/91648430-53f6-4c53-b0e1-9f90e0920910)


Bottom 10 interests that have the largest composition values
~~~~sql
WITH max_composition AS (
SELECT month_year, interest_id, MAX(composition) OVER (PARTITION BY interest_id) AS largest_composition
FROM temp_interest_metrics -- Temp table in which interests with less than 6 months are removed
WHERE month_year IS NOT NULL
)
, composition_rank AS (
SELECT *, DENSE_RANK() OVER (ORDER BY largest_composition DESC) as rank
FROM max_composition
)
SELECT cr.interest_id, ma.interest_name, cr.rank
FROM composition_rank cr
JOIN fresh_segments.interest_map ma ON ma.id=cr.interest_id
GROUP BY cr.rank,cr.interest_id,ma.interest_name
ORDER BY cr.rank DESC
LIMIT 10;
~~~~
![Screenshot 2024-04-22 at 3 48 18 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/6737b9bf-b3ff-47f7-949c-fd539b5f72f4)

### 2. Which 5 interests had the lowest average `ranking` value?
~~~~sql
SELECT me.interest_id, ma.interest_name,
ROUND(AVG(1.00*me.ranking),2) as avg_ranking
FROM temp_interest_metrics me
JOIN fresh_segments.interest_map ma ON me.interest_id = ma.id
GROUP BY me.interest_id, ma.interest_name
ORDER BY avg_ranking
LIMIT 5;
~~~~
![Screenshot 2024-04-22 at 3 50 46 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b4f376bf-918d-4f22-a93d-eee73e537496)

### 3. Which 5 interests had the largest standard deviation in their `percentile_ranking` value?
~~~~sql
SELECT DISTINCT me.interest_id, ma.interest_name,
ROUND(CAST(STDDEV(me.percentile_ranking) OVER (PARTITION BY me.interest_id) AS DECIMAL),2) as std_percentile_ranking
FROM temp_interest_metrics me
JOIN fresh_segments.interest_map ma ON me.interest_id = ma.id
ORDER BY std_percentile_ranking DESC
LIMIT 5;
~~~~
![Screenshot 2024-04-22 at 3 56 06 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/700156b9-a7a3-4203-9757-72355f102d38)

### 4. For the 5 interests found in the previous question - what were the minimum and maximum `percentile_ranking` values for each interest and its corresponding `year_month` value? Can you describe what is happening for these 5 interests?
~~~~sql
WITH largest_std_interest AS (
SELECT DISTINCT me.interest_id, ma.interest_name, ma.interest_summary,
ROUND(CAST(STDDEV(me.percentile_ranking) OVER (PARTITION BY me.interest_id) AS DECIMAL),2) as std_percentile_ranking
FROM temp_interest_metrics me
JOIN fresh_segments.interest_map ma ON me.interest_id = ma.id
ORDER BY std_percentile_ranking DESC
LIMIT 5
)
, max_min_percentiles AS (
SELECT lsi.interest_id,lsi.interest_name, lsi. interest_summary,
me.month_year, me.percentile_ranking,
MAX(me.percentile_ranking) OVER(PARTITION BY lsi.interest_id) AS max_pct_rank,
MIN(me.percentile_ranking) OVER(PARTITION BY lsi.interest_id) AS min_pct_rank
FROM largest_std_interest lsi
JOIN temp_interest_metrics me ON lsi.interest_id = me.interest_id
)
SELECT interest_id, interest_name, interest_summary, 
MAX(CASE WHEN percentile_ranking = max_pct_rank THEN month_year END) AS max_pct_month_year,
MAX(CASE WHEN percentile_ranking = max_pct_rank THEN percentile_ranking END) AS max_pct_rank,
MIN(CASE WHEN percentile_ranking = min_pct_rank THEN month_year END) AS min_pct_month_year,
MIN(CASE WHEN percentile_ranking = min_pct_rank THEN percentile_ranking END) AS min_pct_rank
FROM max_min_percentiles
GROUP BY interest_id, interest_name, interest_summary
~~~~
![Screenshot 2024-04-22 at 4 01 28 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/fc778352-3a69-4432-8abe-b0c482839ec7)

We can see that the the range between the maximum and minimum percentile_ranking of 5 interests in the table above is very large and the months of the maximum and minimum values are different.  these interests may have seasonal demand or there are other underlying reasons related to products, services or prices that we should investigate further.
