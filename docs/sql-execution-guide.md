# MySQL setup and execution guide

This guide uses **MySQL 8.0+** and the six CSV files in [data/processed](../data/processed/).

## 1. Download the repository

Clone the repository, or download it as a ZIP and extract it. Keep the folder structure intact so the relative paths in this guide are easy to follow.

## 2. Create the database tables

1. Open MySQL Workbench and connect to your MySQL server.
2. Open `sql/schema.sql`.
3. Execute the script (the lightning-bolt button).
4. In the Schemas panel, refresh and confirm that the `energy_analysis` schema contains these six tables:
   - `Dim_Country`
   - `Dim_Year`
   - `Fact_Production`
   - `Fact_Consumption`
   - `Fact_Trade`
   - `Fact_oilsales`

The schema defines primary keys and foreign keys. The three country-year fact tables use `(Country, Year)` as a composite primary key, preventing duplicate country-year rows.

## 3. Import the CSV files

Use MySQL Workbench's **Table Data Import Wizard**. Import dimension tables before fact tables because the fact tables reference the dimensions.

For each CSV:

1. In the Schemas panel, expand `energy_analysis`.
2. Right-click the target table and select **Table Data Import Wizard**.
3. Browse to the matching CSV under `data/processed/`.
4. Select the option to import into the existing table (not to create a new table).
5. Confirm that the column mapping matches the table, then complete the import.

Import in this order:

| Order | CSV file | Target table | Expected data rows |
|---:|---|---|---:|
| 1 | `Dim_Country.csv` | `Dim_Country` | 12 |
| 2 | `Dim_Year.csv` | `Dim_Year` | 19 |
| 3 | `Fact_Production.csv` | `Fact_Production` | 228 |
| 4 | `Fact_Consumption.csv` | `Fact_Consumption` | 228 |
| 5 | `Fact_Trade.csv` | `Fact_Trade` | 228 |
| 6 | `Fact_oilsales.csv` | `Fact_oilsales` | 19 |

If you are re-importing into tables that already contain data, clear the existing rows first in child-to-parent order (facts before dimensions), or use a fresh database. Do not append a second copy of the same CSV rows.

## 4. Validate the imported data

Run these checks after importing. Each count should match the expected value in the table above.

```sql
USE energy_analysis;

SELECT 'Dim_Country' AS table_name, COUNT(*) AS row_count FROM Dim_Country
UNION ALL
SELECT 'Dim_Year', COUNT(*) FROM Dim_Year
UNION ALL
SELECT 'Fact_Production', COUNT(*) FROM Fact_Production
UNION ALL
SELECT 'Fact_Consumption', COUNT(*) FROM Fact_Consumption
UNION ALL
SELECT 'Fact_Trade', COUNT(*) FROM Fact_Trade
UNION ALL
SELECT 'Fact_oilsales', COUNT(*) FROM Fact_oilsales;
```

Check for duplicate country-year combinations (each query should return no rows):

```sql
SELECT Country, Year, COUNT(*) AS records
FROM Fact_Trade
GROUP BY Country, Year
HAVING COUNT(*) > 1;

SELECT Country, Year, COUNT(*) AS records
FROM Fact_Production
GROUP BY Country, Year
HAVING COUNT(*) > 1;

SELECT Country, Year, COUNT(*) AS records
FROM Fact_Consumption
GROUP BY Country, Year
HAVING COUNT(*) > 1;
```

Check that all 12 countries have 19 years in the country-year fact tables:

```sql
SELECT Country, COUNT(*) AS year_count,
       MIN(Year) AS first_year, MAX(Year) AS last_year
FROM Fact_Trade
GROUP BY Country
HAVING COUNT(*) <> 19 OR MIN(Year) <> 2000 OR MAX(Year) <> 2018;
```

This query should also return no rows. Repeat it for `Fact_Production` and `Fact_Consumption` if desired.

## 5. Run the analysis queries

After the CSV data is loaded and validated:

1. Open `sql/energy_analysis.sql`.
2. Execute the script in MySQL Workbench.
3. Review each result set in the output tabs.

The analysis script includes ranking, production-consumption gaps, regional aggregation, average annual net trade, year-over-year growth, a rolling average, and crude oil price conversion.

## 6. Important unit checks

- Production and consumption are in **TWh**.
- Imports and exports are in **kb/d** (annual average rates). A multi-year average is meaningful for comparing rates; summing annual rates does not produce cumulative barrels.
- The price query in `energy_analysis.sql` divides `oilprices` by **6.2898**. Keep this conversion only if the CSV values are still in **USD per cubic metre**. If the values have already been converted to USD per barrel, remove the division before running that query.

## 7. Connect Power BI

1. Open `powerbi/Energy_analysis.pbix`.
2. If Power BI prompts for data sources, select the MySQL database connection or the CSV source locations used when the report was built.
3. If connecting directly to MySQL, use the `energy_analysis` database and check that the table names and column names match the model.
4. Select **Refresh** and confirm that visuals load without errors.

If your Power BI report was originally built from local CSV files, update the file paths in Power Query rather than assuming the report is already connected to MySQL.
