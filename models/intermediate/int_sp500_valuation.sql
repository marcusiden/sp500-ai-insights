with stg as (
    select * from {{ ref('stg_sp500_financials') }}
)

select
    ticker,
    company_name,
    sector,
    stock_price,
    price_to_earnings,
    price_to_sales,
    price_to_book,

    -- valuation classification based on P/E ratio
    case
        when price_to_earnings < 0 then 'Negative Earnings'
        when price_to_earnings < 15 then 'Undervalued'
        when price_to_earnings < 25 then 'Fairly Valued'
        when price_to_earnings < 40 then 'Overvalued'
        else 'Highly Overvalued'
    end as valuation_label,

    -- 52 week price position (where is current price relative to range)
    round(
        (stock_price - week_52_low) / nullif(week_52_high - week_52_low, 0) * 100
    , 2) as price_position_pct

from stg