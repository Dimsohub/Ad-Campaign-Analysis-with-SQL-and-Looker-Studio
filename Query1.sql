SELECT 
    f.ad_date, 
    f.campaign_id, 
    sum (f.spend) as spend,
    sum (f.impressions) as impressions,
    sum (f.clicks) as clicks,
    sum (f.value) as value,
    sum (f.spend) / sum (f.clicks) as CPC,
    round((sum(f.spend) ::numeric  / sum(f.impressions)) * 1000, 2) AS CPM,
    round((sum(f.clicks) ::numeric / sum(f.impressions)) * 100, 2) AS CTR,
    round((((sum(f.value) - sum(f.spend)) ::numeric / sum(f.spend))) * 100, 2) AS ROMI
from 
   facebook_ads_basic_daily f
where 
	f.campaign_id is not null
	and f.clicks > 0
	and f.impressions > 0
	and f.spend > 0
	and f.impressions > 0
group by 
	f.ad_date, f.campaign_id
order by
	f.ad_date desc;



