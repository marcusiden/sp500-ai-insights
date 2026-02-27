# 📈 S&P 500 AI Insights — dbt + Snowflake + LLM

An end-to-end analytics engineering project that transforms raw S&P 500 financial data into a structured data warehouse, with an AI layer powered by a local LLM for natural language querying.

---

## 📌 Project Overview

This project answers the question: **"What can we learn from S&P 500 company financials?"**

Using 505 S&P 500 company records with 13 financial attributes, this pipeline transforms raw financial data into a structured data warehouse with valuation classifications, sector benchmarking, and market cap tiering — queryable in plain English through a local LLM.

---

## 🏗️ Architecture
```
Raw Layer (Snowflake)
        ↓
Staging Layer        → Clean, rename, cast raw data
        ↓
Intermediate Layer   → Business logic & transformations
        ↓
Marts Layer          → Star schema, ready for analysis
        ↓
AI Layer             → Local LLM (Ollama) + DuckDB for natural language querying
```

---

## 📊 Data Model

### Fact Table
| Table | Description |
|---|---|
| `fct_sp500_financials` | One row per company with all financial metrics, valuation labels and sector comparisons |

### Dimension Tables
| Table | Description |
|---|---|
| `dim_companies` | Company identifiers, sector and market cap tier |
| `dim_sectors` | Sector dimension with company counts |

---

## 🔄 Pipeline Layers

### Staging
- Cleans and renames all raw columns
- Standardizes column names
- Source: `RAW.RAW_SP500_FINANCIALS`

### Intermediate
| Model | Purpose |
|---|---|
| `int_sp500_valuation` | Calculates valuation labels based on P/E ratio and 52 week price position |
| `int_sp500_fundamentals` | Calculates sector averages and market cap tiers |

### Marts
- Star schema design optimized for analytical queries
- Fact table materialized as table, staging and intermediate as views
- Follows Medallion Architecture (Bronze → Silver → Gold)

---

## 🤖 AI Layer

The project includes a local LLM layer built with:
- **Ollama + LLaMA3** — runs completely locally, no API costs, no internet required
- **DuckDB** — lightweight in-memory SQL engine for querying the data
- **Streamlit** — chat interface for asking questions in plain English

Example questions you can ask:
- *"Which sector has the highest average market cap?"*
- *"Show me all undervalued companies in the Technology sector"*
- *"Which companies have the highest dividend yield?"*
- *"Compare earnings per share across sectors"*

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| Snowflake | Cloud data warehouse |
| dbt Cloud | Data transformation and modeling |
| GitHub | Version control and CI/CD |
| Ollama + LLaMA3 | Local LLM for text-to-SQL |
| DuckDB | Local SQL engine |
| Streamlit | Chat interface |
| Python | Orchestration layer |
| S&P 500 Dataset | Source data via Kaggle |

---

## 📁 Project Structure
```
sp500-ai-insights/
├── models/
│   ├── staging/          # Raw data cleaning
│   │   ├── _sources.yml
│   │   └── stg_sp500_financials.sql
│   ├── intermediate/     # Business logic
│   │   ├── int_sp500_valuation.sql
│   │   └── int_sp500_fundamentals.sql
│   └── marts/            # Star schema output
│       ├── _schema.yml
│       ├── dim_companies.sql
│       ├── dim_sectors.sql
│       └── fct_sp500_financials.sql
├── app/
│   ├── data_engine.py    # DuckDB query engine
│   ├── llm_engine.py     # Ollama LLM integration
│   └── streamlit_app.py  # Chat interface
├── schema_context/
│   └── schema_description.md  # LLM schema context
├── data/                 # Local data files (not pushed to GitHub)
├── .env.example          # Example environment variables
├── packages.yml          # dbt packages
├── dbt_project.yml       # dbt project config
└── requirements.txt      # Python dependencies
```

---

## 🚀 How to Run

### Prerequisites
- Snowflake account
- dbt Cloud account
- Python 3.11+
- Ollama installed ([ollama.com](https://ollama.com))
- LLaMA3 model pulled (`ollama pull llama3`)

### Setup

1. Clone this repository:
```bash
git clone https://github.com/YOUR_USERNAME/sp500-ai-insights.git
cd sp500-ai-insights
```

2. Create a virtual environment:
```bash
conda create -n sp500-env python=3.11
conda activate sp500-env
pip install -r requirements.txt
```

3. Copy `.env.example` to `.env` and fill in your credentials:
```bash
cp .env.example .env
```

4. Download the S&P 500 dataset from Kaggle and place it in `data/`

5. Load raw data into Snowflake and run dbt:
```bash
dbt deps
dbt build
```

6. Export `fct_sp500_financials` from Snowflake to `data/fct_sp500_financials.csv`

7. Start Ollama:
```bash
ollama run llama3
```

8. Run the Streamlit app:
```bash
streamlit run app/streamlit_app.py
```

---

## 📈 Key Business Questions Answered

- Which sectors are most overvalued based on P/E ratios?
- Which companies trade near their 52 week high?
- Which companies are undervalued relative to their sector?
- What is the average EBITDA by sector?
- Which companies pay the highest dividends?

---

## 📂 Data Source

[S&P 500 Companies with Financial Information](https://www.kaggle.com/datasets/paytonfisher/sp-500-companies-with-financial-information) — Kaggle
```

---

Also create a `.env.example` file so people know what credentials they need:
```
SNOWFLAKE_ACCOUNT=your_account_identifier
SNOWFLAKE_USER=your_username
SNOWFLAKE_PASSWORD=your_password
SNOWFLAKE_DATABASE=SP500_FINANCIALS
SNOWFLAKE_WAREHOUSE=DBT_WH
OLLAMA_MODEL=llama3
```

Then update `requirements.txt`:
```
streamlit
pandas
duckdb
requests
python-dotenv
snowflake-connector-python