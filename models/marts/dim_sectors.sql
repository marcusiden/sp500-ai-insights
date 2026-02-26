with stg as (
    select * from {{ ref('stg_sp500_financials') }}
)

select distinct
    {{ dbt_utils.generate_surrogate_key(['sector']) }} as sector_key,
    sector,
    count(*) over (partition by sector) as company_count

from stg