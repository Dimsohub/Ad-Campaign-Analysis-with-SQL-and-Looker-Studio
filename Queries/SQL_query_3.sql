WITH combi_data AS (
SELECT
	fbd.ad_date,
	'Facebook Ads' AS media_source,
	fc.campaign_name,
	fa.adset_name,
	fbd.spend,
	fbd.impressions,
	fbd.reach,
	fbd.clicks,
	fbd.leads,
	fbd.value
FROM
	facebook_ads_basic_daily fbd
LEFT JOIN facebook_adset fa ON
	fbd.adset_id = fa.adset_id
LEFT JOIN facebook_campaign fc ON
	fbd.campaign_id = fc.campaign_id
WHERE
	fbd.ad_date IS NOT NULL
UNION ALL
SELECT
	g.ad_date,
	'Google Ads' AS media_source,
	g.campaign_name,
	g.adset_name,
	g.spend,
	g.impressions,
	g.reach,
	g.clicks,
	g.leads,
	g.value
FROM
	google_ads_basic_daily g
WHERE
	g.ad_date IS NOT NULL	
)
SELECT
	ad_date,
	media_source,
	campaign_name,
	adset_name,
	sum (spend) AS total_spend,
	sum (impressions) AS total_impressions,
	sum (clicks) AS total_clicks,
	sum (value) AS total_value
FROM
	combi_data
GROUP BY
	ad_date,
	media_source,
	campaign_name,
	adset_name
ORDER BY 
	ad_date DESC;
