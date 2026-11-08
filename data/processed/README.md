# Processed data

This folder contains the six cleaned CSV tables used by the SQL analysis and Power BI report.

| File | Data rows |
|---|---:|
| Dim_Country.csv | 12 |
| Dim_Year.csv | 19 |
| Fact_Production.csv | 228 |
| Fact_Consumption.csv | 228 |
| Fact_Trade.csv | 228 |
| Fact_oilsales.csv | 19 |

The production, consumption, and trade tables are sorted by Country and then Year. All source rows were retained; zero values in trade data were preserved.

Units:
- Production and consumption: TWh.
- Imports and exports: kb/d (annual average rates).
- Oil prices: original source unit should be verified before conversion to USD/barrel.

See [data sources](../../docs/data-sources.md), [data preparation](../../docs/data-preparation.md), and the [data dictionary](../../docs/data-dictionary.md).
