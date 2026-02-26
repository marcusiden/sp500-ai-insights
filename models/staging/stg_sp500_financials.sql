with source as (
    select * from {{ source('raw', 'RAW_SP500_FINANCIALS') }}
),

renamed as (
    select
        -- company identifiers
        SYMBOL                          as ticker,
        NAME                            as company_name,
        SECTOR                          as sector,

        -- pricing
        PRICE                           as stock_price,
        "52 Week Low"                   as week_52_low,
        "52 Week High"                  as week_52_high,

        -- valuation ratios
        "Price/Earnings"                as price_to_earnings,
        "Price/Sales"                   as price_to_sales,
        "Price/Book"                    as price_to_book,

        -- financials
        DIVIDEND_YIELD                  as dividend_yield,
        "Earnings/Share"                as earnings_per_share,
        MARKET_CAP                      as market_cap,
        EBITDA                          as ebitda,

        -- reference
        SEC_FILINGS                     as sec_filings_url

    from source
)

select * from renamed