# S&P 500 Financial Data Warehouse - Schema Description

## Database: SP500_FINANCIALS
## Production Schema: MARTS_MARTS

---

## Tables

### fct_sp500_financials
The main fact table. One row per S&P 500 company with all financial metrics.

Columns:
- ticker: Stock ticker symbol (e.g. AAPL, MSFT)
- company_name: Full company name
- sector: Industry sector (e.g. Technology, Healthcare, Finance)
- stock_price: Current stock price in USD
- week_52_low: Lowest stock price in the last 52 weeks
- week_52_high: Highest stock price in the last 52 weeks
- price_position_pct: Where current price sits between 52 week low and high (0-100%)
- price_to_earnings: P/E ratio - how expensive the stock is relative to earnings
- price_to_sales: P/S ratio - stock price relative to revenue
- price_to_book: P/B ratio - stock price relative to book value
- valuation_label: Undervalued / Fairly Valued / Overvalued / Highly Overvalued / Negative Earnings
- market_cap: Total company value in USD
- ebitda: Earnings before interest taxes depreciation and amortization
- earnings_per_share: Profit per share
- dividend_yield: Annual dividend as percentage of stock price
- market_cap_tier: Mega Cap / Large Cap / Mid Cap / Small Cap
- avg_market_cap_by_sector: Average market cap of all companies in same sector
- avg_ebitda_by_sector: Average EBITDA of all companies in same sector
- avg_eps_by_sector: Average earnings per share of all companies in same sector
- market_cap_vs_sector_avg: How much above or below sector average this company's market cap is
- eps_vs_sector_avg: How much above or below sector average this company's EPS is

### dim_companies
Company dimension table.

Columns:
- company_key: Surrogate primary key
- ticker: Stock ticker symbol
- company_name: Full company name
- sector: Industry sector
- sec_filings_url: Link to SEC filings
- market_cap_tier: Mega Cap / Large Cap / Mid Cap / Small Cap

### dim_sectors
Sector dimension table.

Columns:
- sector_key: Surrogate primary key
- sector: Industry sector name
- company_count: Number of companies in this sector

---

## Common Questions and Hints

- To find undervalued companies use valuation_label = 'Undervalued'
- To compare sectors use GROUP BY sector
- To find the biggest companies use ORDER BY market_cap DESC
- To find dividend paying companies use dividend_yield > 0
- Prices and market caps are in USD
- All data comes from a single point in time snapshot