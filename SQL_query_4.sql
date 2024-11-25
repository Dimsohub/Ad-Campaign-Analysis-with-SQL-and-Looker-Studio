WITH combined_ads AS (
SELECT
	ad_date,
	'Facebook Ads' AS media_source,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
FROM
	facebook_ads_basic_daily f
WHERE
		ad_date IS NOT NULL
UNION ALL
SELECT
	ad_date,
	'Google Ads' AS media_source,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
FROM
	google_ads_basic_daily g
WHERE
	ad_date IS NOT NULL
)
SELECT
	ad_date,
	media_source,
	sum (spend) AS spend,
	sum (impressions) AS impressions,
	sum (clicks) AS clicks,
	sum (value) AS value
FROM
	combined_ads
WHERE
	reach > 0
	AND leads > 0
	AND clicks > 0
	AND impressions > 0
	AND spend > 0
	AND impressions > 0
GROUP BY
	ad_date,
	media_source
ORDER BY
	ad_date,
	media_source DESC;

	
    
    














