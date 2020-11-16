drop index "NICK"."WF_CTRY_CURR_IDX";
drop index "NICK"."WF_CTRY_REG_IDX";

--query number of languages by region
select
    wfr.region_name,
    count(distinct wfc.country_name) as country_count,
    count(distinct wla.language_name) as language_count
from
    wf_countries wfc
    join wf_spoken_languages wsp
        on wfc.country_id = wsp.country_id
    join wf_languages wla
        on wsp.language_id = wla.language_id
    join wf_world_regions wfr
        on wfc.region_id = wfr.region_id
group by
    wfr.region_name
order by
    wfr.region_name;
    
--query highest and lowest elevation by region
select
    wfr.region_name,
    min(wfc.lowest_elevation) as lowest_elevation,
    max(wfc.highest_elevation) as highest_elevation
from
    wf_countries wfc
    join wf_spoken_languages wsp
        on wfc.country_id = wsp.country_id
    join wf_languages wla
        on wsp.language_id = wla.language_id
    join wf_world_regions wfr
        on wfc.region_id = wfr.region_id
group by
    wfr.region_name
order by
    wfr.region_name; 
    
--query highest and lowest elevations in the Americas
select
    wfr.region_name,
    min(wfc.lowest_elevation) as lowest_elevation,
    max(wfc.highest_elevation) as highest_elevation
from
    wf_countries wfc
    join wf_spoken_languages wsp
        on wfc.country_id = wsp.country_id
    join wf_languages wla
        on wsp.language_id = wla.language_id
    join wf_world_regions wfr
        on wfc.region_id = wfr.region_id
where
    wfr.region_id in (select distinct region_id from wf_world_regions where region_name like '%America%')
group by
    wfr.region_name
order by
    wfr.region_name; 
    
--query country name with lowest elevation by region
select
    iq.region_name,
    iq.country_name,
    iq.lowest_elevation
from
    (
    select
        wfr.region_name,
        wfc.country_name,
        wfc.lowest_elevation,
        row_number() over (partition by(wfc.lowest_elevation) order by wfc.lowest_elevation) as row_num
    from
        wf_countries wfc
        join wf_spoken_languages wsp
            on wfc.country_id = wsp.country_id
        join wf_languages wla
            on wsp.language_id = wla.language_id
        join wf_world_regions wfr
            on wfc.region_id = wfr.region_id
    ) iq
where
    iq.row_num = 1
order by
    iq.region_name,
    iq.country_name;    
    
    
--query country name with highest elevation by region
select
    iq.region_name,
    iq.country_name,
    iq.highest_elevation
from
    (
    select
        wfr.region_name,
        wfc.country_name,
        wfc.highest_elevation,
        row_number() over (partition by(wfc.highest_elevation) order by wfc.highest_elevation) as row_num
    from
        wf_countries wfc
        join wf_spoken_languages wsp
            on wfc.country_id = wsp.country_id
        join wf_languages wla
            on wsp.language_id = wla.language_id
        join wf_world_regions wfr
            on wfc.region_id = wfr.region_id
    ) iq
where
    iq.row_num = 1
order by
    iq.region_name,
    iq.country_name;     