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

- sql/ – MySQL analysis queries
- powerbi/ – Power BI report
- data/processed/ – location for prepared CSV files
- screenshots/ – dashboard screenshots
- docs/ – data sources, preparation notes, and data dictionary

## Data and units

- Production and consumption are represented in **TWh**.
- Imports and exports are represented in **thousand barrels per day (kb/d)**.
- Crude oil prices are converted from **USD per cubic metre to USD per barrel** by dividing by 6.2898, only when the source values are still in USD/m³. The result is in current USD, not inflation-adjusted USD.
- Trade values in kb/d are annual average rates. They should be compared as yearly rates or averages, not summed and described as cumulative physical volumes.

The processed CSV files are not included yet. See [data sources](docs/data-sources.md) and [data preparation notes](docs/data-preparation.md) before loading data.

## How to use

1. Download the source datasets listed in docs/data-sources.md.
2. Prepare the country-year tables and load them into the MySQL tables described in docs/data-dictionary.md.
3. Run sql/energy_analysis.sql in MySQL 8 or later.
4. Open powerbi/Energy_analysis.pbix, update the data-source connection, and refresh the report.

**Important:** The SQL script creates and populates Dim_Year, but expects Dim_Country and the fact tables to be loaded beforehand. Review the data dictionary before running it.

## Key analysis questions

- Which countries have the highest total oil production and consumption?
- How did production and consumption change year over year?
- Which countries are net exporters or net importers on average?
- How did crude oil prices change between 2000 and 2018?
- How do regional production and consumption trends compare?

This is an exploratory historical analysis. Results depend on source coverage, country mappings, and data preparation choices.
