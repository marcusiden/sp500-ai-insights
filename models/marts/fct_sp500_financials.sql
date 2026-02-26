with stg as (
    select * from {{ ref('stg_sp500_financials') }}
),

valuation as (
    select * from {{ ref('int_sp500_valuation') }}
),

fundamentals as (
    select * from {{ ref('int_sp500_fundamentals') }}
)

select
    -- keys
    {{ dbt_utils.generate_surrogate_key(['stg.ticker']) }} as financial_key,
    stg.ticker,
    stg.company_name,
    stg.sector,

    -- pricing
    stg.stock_price,
    stg.week_52_low,
    stg.week_52_high,
    val.price_position_pct,

    -- valuation
    stg.price_to_earnings,
    stg.price_to_sales,
    stg.price_to_book,
    val.valuation_label,

    -- fundamentals
    stg.market_cap,
    stg.ebitda,
    stg.earnings_per_share,
    stg.dividend_yield,
    fund.market_cap_tier,

    -- vs sector averages
    fund.avg_market_cap_by_sector,
    fund.avg_ebitda_by_sector,
    fund.avg_eps_by_sector,
    fund.market_cap_vs_sector_avg,
    fund.eps_vs_sector_avg

from stg
left join valuation val      on stg.ticker = val.ticker
left join fundamentals fund  on stg.ticker = fund.ticker