with stg as (
    select * from {{ ref('stg_sp500_financials') }}
),

fundamentals as (
    select * from {{ ref('int_sp500_fundamentals') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['stg.ticker']) }} as company_key,
    stg.ticker,
    stg.company_name,
    stg.sector,
    stg.sec_filings_url,
    fundamentals.market_cap_tier

from stg
left join fundamentals on stg.ticker = fundamentals.ticker