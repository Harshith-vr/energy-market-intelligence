# Data preparation notes

1. Download the datasets listed in data-sources.md.
2. Restrict the analysis to 2000–2018 and the 12 countries listed in the project README.
3. Standardize country names consistently across production, consumption, trade, and country-region mapping data.
4. Keep annual production and consumption in TWh.
5. Keep imports and exports in kb/d as annual average rates. Do not sum these rates across years and describe the result as cumulative trade volume.
6. Verify the crude oil price unit in the downloaded source. If values are USD/m³, convert to USD/barrel by dividing by 6.2898 exactly once.
7. Load the prepared country-year tables into the MySQL tables described in data-dictionary.md.
8. Configure the Power BI model to use the same country labels, year values, and units, then refresh the report.

The prepared CSV files are not present in the repository yet, so exact source-to-column transformations and row counts are not documented here. Add those details after the final prepared files are committed.
