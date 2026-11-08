# Energy Market Intelligence Dashboard

A SQL and Power BI project exploring oil production, consumption, international trade, and crude oil price trends across 12 countries from **2000 to 2018**.

## Dashboard pages

1. **Global Overview** – high-level production, consumption, and price indicators.
2. **Country Comparison** – compare production and consumption across countries.
3. **Trade Analysis** – examine imports, exports, and net trade positions.
4. **Oil Price Trends** – explore crude oil price movements over time.

## Dashboard screenshots

**Global overview**

![Global overview](screenshots/global-overview.png)

**Country comparison**

![Country comparison](screenshots/country-comparison.png)

**Trade analysis**

![Trade analysis](screenshots/trade-analysis.png)

**Oil price trends**

![Oil price trends](screenshots/oil-price-trends.png)

## Countries covered

Brazil, Canada, China, India, Iran, Iraq, Mexico, Norway, Russia, Saudi Arabia, the United Arab Emirates, and the United States.

## Tools used

- **MySQL 8+** – joins, aggregations, CTEs, and window functions.
- **Microsoft Power BI** – data modelling, DAX measures, and interactive dashboards.

## Repository structure

- `sql/` – MySQL analysis queries
- `powerbi/` – Power BI report
- `data/processed/` – six cleaned CSV tables used in the analysis
- `screenshots/` – dashboard screenshots
- `docs/` – data sources, preparation notes, and data dictionary

## Data files and row counts

The processed tables are included in [data/processed](data/processed/):

| File | Data rows | Description |
|---|---:|---|
| `Dim_Country.csv` | 12 | Country-to-region mapping |
| `Dim_Year.csv` | 19 | Years 2000–2018 |
| `Fact_Production.csv` | 228 | 12 countries × 19 years |
| `Fact_Consumption.csv` | 228 | 12 countries × 19 years |
| `Fact_Trade.csv` | 228 | 12 countries × 19 years |
| `Fact_oilsales.csv` | 19 | Annual crude oil prices |

The three country-year fact tables are sorted by **Country, then Year**. No data rows were intentionally removed during sorting or upload. Zero values in the trade table have been preserved.

## Data and units

- Production and consumption are represented in **TWh**.
- Imports and exports are represented in **thousand barrels per day (kb/d)**. These are annual average rates; do not sum them across years and describe the result as cumulative physical volumes.
- Crude oil prices are converted from **USD per cubic metre to USD per barrel** by dividing by 6.2898, only when the source values are still in USD/m³. The result is in current USD, not inflation-adjusted USD.

## How to use

1. Review the source links in [docs/data-sources.md](docs/data-sources.md).
2. Review the expected database columns in [docs/data-dictionary.md](docs/data-dictionary.md).
3. Load the CSV files from `data/processed/` into the corresponding MySQL tables.
4. Run [sql/energy_analysis.sql](sql/energy_analysis.sql) in MySQL 8 or later.
5. Open [powerbi/Energy_analysis.pbix](powerbi/Energy_analysis.pbix), update the data-source connection if needed, and refresh the report.

**Important:** The SQL script creates and populates `Dim_Year`, but expects `Dim_Country` and the fact tables to be loaded beforehand. Check the oil-price source unit before using the conversion expression in SQL; do not convert the prices twice.

## Key analysis questions

- Which countries have the highest total oil production and consumption?
- How did production and consumption change year over year?
- Which countries are net exporters or net importers on average?
- How did crude oil prices change between 2000 and 2018?
- How do regional production and consumption trends compare?

This is an exploratory historical analysis. Results depend on source coverage, country mappings, and data preparation choices.
