WITH cte_facebook_ads AS (
SELECT
	fad.ad_date,
	fad.url_parameters,
	COALESCE(fad.spend,
	0) AS spend,
	COALESCE(fad.impressions,
	0) AS impressions,
	COALESCE(fad.reach,
	0) AS reach,
	COALESCE(fad.clicks,
	0) AS clicks,
	COALESCE(fad.leads,
	0) AS leads,
	COALESCE(fad.value,
	0) AS value
FROM
	facebook_ads_basic_daily AS fad
JOIN facebook_adset AS fas ON
	fad.adset_id = fas.adset_id
JOIN facebook_campaign AS fc ON
	fad.campaign_id = fc.campaign_id
),
cte_google_ads AS (
SELECT
	gad.ad_date,
	gad.url_parameters,
	COALESCE(gad.spend,
	0) AS spend,
	COALESCE(gad.impressions,
	0) AS impressions,
	COALESCE(gad.reach,
	0) AS reach,
	COALESCE(gad.clicks,
	0) AS clicks,
	COALESCE(gad.leads,
	0) AS leads,
	COALESCE(gad.value,
	0) AS value
FROM
	google_ads_basic_daily AS gad
),
cte_combined_ads AS (
SELECT
	ad_date,
	url_parameters,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
FROM
	cte_facebook_ads
UNION ALL
SELECT
	ad_date,
	url_parameters,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
FROM
	cte_google_ads
),
cte_parsed_data AS (
SELECT
	ad_date,
	spend,
	impressions,
	clicks,
	value,
	LOWER(NULLIF(SUBSTRING(url_parameters FROM 'utm_campaign=([^&]+)'), 'nan')) AS utm_campaign
FROM
	cte_combined_ads
)
SELECT
	ad_date,
	utm_campaign,
	SUM(spend) AS total_spend,
	SUM(impressions) AS total_impressions,
	SUM(clicks) AS total_clicks,
	SUM(value) AS total_value,
	CASE
		WHEN SUM(impressions) = 0 THEN 0
		ELSE ROUND((SUM(clicks) * 100.0 / SUM(impressions)),
		2)
	END AS ctr,
	CASE
		WHEN SUM(clicks) = 0 THEN 0
		ELSE ROUND((SUM(spend)::NUMERIC / SUM(clicks)),
		2)
	END AS cpc,
	CASE
		WHEN SUM(impressions) = 0 THEN 0
		ELSE ROUND((SUM(spend) * 1000.0 / SUM(impressions)),
		2)
	END AS cpm,
	CASE
		WHEN SUM(spend) = 0 THEN 0
		ELSE ROUND(((SUM(value) - SUM(spend))::NUMERIC / SUM(spend)) * 100.00,
		2)
	END AS romi
FROM
	cte_parsed_data
GROUP BY
	ad_date,
	utm_campaign
ORDER BY
	ad_date;
