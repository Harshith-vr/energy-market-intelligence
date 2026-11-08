# Data dictionary and database prerequisites

The SQL script is written for MySQL 8+ and expects the following tables to be loaded before most analysis queries run.

| Table | Required columns | Description |
|---|---|---|
| Dim_Country | Country, Region | One row per selected country and its region |
| Fact_Production | Country, Year, Production | Annual oil production; TWh |
| Fact_Consumption | Country, Year, Consumption | Annual oil consumption; TWh |
| Fact_Trade | Country, Year, Imports, Exports | Annual average import/export rates; kb/d |
| Fact_oilsales | Year, oilprices | Annual crude oil price; verify original source unit |

## Recommended grain and keys

- Production, consumption, and trade tables should have one record per country and year.
- Use a composite key or unique constraint on (Country, Year) for each country-year fact table.
- Dim_Country.Country should match the country labels used in the fact tables.
- Dim_Year contains the years 2000–2018. The SQL script creates and populates this table safely on repeated runs.

## Important unit notes

- Production and consumption are in TWh.
- Trade is in kb/d. The SQL queries use averages when comparing annual trade rates across multiple years; summing annual rates does not produce cumulative barrels.
- The oil-price query divides by 6.2898 to convert USD/m³ to USD/barrel. Use that expression only if Fact_oilsales.oilprices still contains USD/m³ values. If the column is already converted, remove the division.
