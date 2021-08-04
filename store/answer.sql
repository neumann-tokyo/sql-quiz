with
with_lastweek_price as (
  select
    item_name
    ,weeknum
    ,lag(price) over (partition by item_name order by weeknum) as lastweek_price
    ,price
  from
    reports
)
,with_diff as (
  select
    item_name
    ,weeknum
    ,case when lastweek_price is null then 0 else lastweek_price end as lastweek_price
    ,price
    ,price - (case when lastweek_price is null then 0 else lastweek_price end) as diff
  from
    with_lastweek_price
)
select
  item_name
  ,weeknum
  ,lastweek_price
  ,price
  ,case
    when diff > 0 then '^'
    when diff < 0 then '_'
    else '-'
  end as mark
from
  with_diff
;
