# Data preparation notes

1. Download the datasets listed in [data-sources.md](data-sources.md).
2. Restrict the analysis to 2000–2018 and the 12 countries listed in the project README.
3. Standardize country names consistently across production, consumption, trade, and country-region mapping data.
4. Keep annual production and consumption in TWh.
5. Keep imports and exports in kb/d as annual average rates. Do not sum these rates across years and describe the result as cumulative trade volume.
6. Verify the crude oil price unit in the downloaded source. If values are USD/m³, convert to USD/barrel by dividing by 6.2898 exactly once.
7. The processed CSV files are stored in `data/processed/`. The country-year production, consumption, and trade files are sorted by Country and then Year.
8. Import the CSVs into the MySQL tables created by [schema.sql](../sql/schema.sql). See the [SQL execution guide](sql-execution-guide.md) for the recommended import order and validation queries.
9. Configure the Power BI model to use the same country labels, year values, and units, then refresh the report.

The processed CSV files contain 12 country records, 19 year records, 228 production records, 228 consumption records, 228 trade records, and 19 annual oil-price records. See the README and execution guide for the row-count checks.
