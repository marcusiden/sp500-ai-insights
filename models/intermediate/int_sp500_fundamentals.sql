with stg as (
    select * from {{ ref('stg_sp500_financials') }}
),

sector_avg as (
    select
        sector,
        round(avg(market_cap), 2)           as avg_market_cap_by_sector,
        round(avg(ebitda), 2)               as avg_ebitda_by_sector,
        round(avg(earnings_per_share), 2)   as avg_eps_by_sector
    from stg
    group by sector
)

select
    s.ticker,
    s.company_name,
    s.sector,
    s.market_cap,
    s.ebitda,
    s.earnings_per_share,
    s.dividend_yield,

    sa.avg_market_cap_by_sector,
    sa.avg_ebitda_by_sector,
    sa.avg_eps_by_sector,

    -- how does this company compare to sector average
    round(s.market_cap - sa.avg_market_cap_by_sector, 2)    as market_cap_vs_sector_avg,
    round(s.earnings_per_share - sa.avg_eps_by_sector, 2)   as eps_vs_sector_avg,

    -- market cap tier
    case
        when s.market_cap >= 200000000000 then 'Mega Cap'
        when s.market_cap >= 10000000000 then 'Large Cap'
        when s.market_cap >= 2000000000 then 'Mid Cap'
        else 'Small Cap'
    end as market_cap_tier

from stg s
left join sector_avg sa on s.sector = sa.sector