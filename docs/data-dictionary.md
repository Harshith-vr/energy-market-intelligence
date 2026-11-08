# Data dictionary and database schema

The project uses MySQL 8.0+. Run [schema.sql](../sql/schema.sql) to create the database and tables before importing the CSV files.

| Table | Columns | Description |
|---|---|---|
| Dim_Country | Country (PK), Region | One row per selected country and its region |
| Dim_Year | Year (PK) | Analysis years 2000–2018 |
| Fact_Production | Country (FK), Year (FK), Production | Annual oil production; TWh |
| Fact_Consumption | Country (FK), Year (FK), Consumption | Annual oil consumption; TWh |
| Fact_Trade | Country (FK), Year (FK), Exports, Imports | Annual average trade rates; kb/d |
| Fact_oilsales | Year (FK), oilprices | Annual crude oil price; verify source unit |

## Grain and keys

- Production, consumption, and trade each contain one record per country and year.
- The country-year fact tables use a composite primary key on `(Country, Year)`.
- `Dim_Country.Country` is the country key referenced by the country-year fact tables.
- `Dim_Year.Year` contains the years 2000–2018 and is referenced by all fact tables.
- `Fact_oilsales` has one row per year.

## Column types

The schema uses `VARCHAR(100)` for country and region labels, `SMALLINT` for years, and `DECIMAL(18,6)` for numeric measures. This preserves the decimal values in the CSV exports without using floating-point storage.

## Units

- Production and consumption: TWh.
- Imports and exports: kb/d, annual average rates.
- Oil prices: confirm the original source unit. The analysis query divides by 6.2898 to convert USD/m³ to USD/barrel only if the values are still in USD/m³. If already converted, remove that division.
