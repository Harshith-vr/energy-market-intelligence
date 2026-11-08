CREATE DATABASE IF NOT EXISTS energy_analysis;
USE energy_analysis;

CREATE TABLE IF NOT EXISTS Dim_Year (
    Year INT PRIMARY KEY
);

-- Safe to rerun without duplicate-key errors.
INSERT IGNORE INTO Dim_Year (Year)
VALUES
(2000),(2001),(2002),(2003),(2004),
(2005),(2006),(2007),(2008),(2009),
(2010),(2011),(2012),(2013),(2014),
(2015),(2016),(2017),(2018);

-- Total oil production by country
SELECT
    Country,
    SUM(Production) AS Total_Production,
    DENSE_RANK() OVER (ORDER BY SUM(Production) DESC) AS r
FROM Fact_Production
GROUP BY Country
ORDER BY Total_Production DESC;

-- Total oil consumption by country
SELECT
    Country,
    SUM(Consumption) AS Total_Consumption,
    DENSE_RANK() OVER (ORDER BY SUM(Consumption) DESC) AS r
FROM Fact_Consumption
GROUP BY Country
ORDER BY r;

-- Production-consumption gap for each country and year
SELECT
    p.Country,
    p.Year,
    p.Production - c.Consumption AS Production_Consumption_Gap
FROM Fact_Production AS p
JOIN Fact_Consumption AS c
    ON p.Country = c.Country
   AND p.Year = c.Year
ORDER BY p.Country, p.Year;

-- Oil production for each country by year
SELECT Country, Year, Production
FROM Fact_Production
ORDER BY Country, Year;

-- Total production by region and year
SELECT
    c.Region,
    p.Year,
    SUM(p.Production) AS Regional_Production
FROM Dim_Country AS c
JOIN Fact_Production AS p
    ON c.Country = p.Country
GROUP BY c.Region, p.Year
ORDER BY c.Region, p.Year;

-- Average annual net trade by country (kb/d).
-- Exports minus imports: positive = net exporter; negative = net importer.
SELECT
    Country,
    ROUND(AVG(Exports - Imports), 2) AS Avg_Annual_Net_Trade_kbd,
    DENSE_RANK() OVER (ORDER BY AVG(Exports - Imports) DESC) AS r
FROM Fact_Trade
GROUP BY Country
ORDER BY Avg_Annual_Net_Trade_kbd DESC;

-- Highest production year for each country
SELECT Country, Year, Production
FROM (
    SELECT
        Country,
        Year,
        Production,
        DENSE_RANK() OVER (
            PARTITION BY Country
            ORDER BY Production DESC
        ) AS r
    FROM Fact_Production
) AS t
WHERE r = 1;

-- Countries where total consumption exceeded total production
SELECT c.Country
FROM Fact_Consumption AS c
JOIN Fact_Production AS p
    ON c.Country = p.Country
   AND c.Year = p.Year
GROUP BY c.Country
HAVING SUM(c.Consumption) > SUM(p.Production);

-- Top 5 average annual net exporters (kb/d)
SELECT
    Country,
    ROUND(AVG(Exports - Imports), 2) AS Avg_Annual_Net_Exports_kbd
FROM Fact_Trade
GROUP BY Country
ORDER BY Avg_Annual_Net_Exports_kbd DESC
LIMIT 5;

-- Top 5 average annual net importers (kb/d)
SELECT
    Country,
    ROUND(AVG(Imports - Exports), 2) AS Avg_Annual_Net_Imports_kbd
FROM Fact_Trade
GROUP BY Country
ORDER BY Avg_Annual_Net_Imports_kbd DESC
LIMIT 5;

-- Year-over-year consumption growth percentage
WITH ConsumptionGrowth AS (
    SELECT
        Country,
        Year,
        Consumption,
        LAG(Consumption) OVER (
            PARTITION BY Country
            ORDER BY Year
        ) AS Previous_Year_Consumption
    FROM Fact_Consumption
)
SELECT
    Country,
    Year,
    Consumption,
    Previous_Year_Consumption,
    ROUND(
        (Consumption - Previous_Year_Consumption)
        / NULLIF(Previous_Year_Consumption, 0) * 100,
        2
    ) AS Consumption_YoY_Percent
FROM ConsumptionGrowth;

-- Year-over-year production growth percentage
WITH ProductionGrowth AS (
    SELECT
        Country,
        Year,
        Production,
        LAG(Production) OVER (
            PARTITION BY Country
            ORDER BY Year
        ) AS Previous_Year_Production
    FROM Fact_Production
)
SELECT
    Country,
    Year,
    ROUND(
        (Production - Previous_Year_Production)
        / NULLIF(Previous_Year_Production, 0) * 100,
        2
    ) AS Production_YoY_Percent
FROM ProductionGrowth;

-- Crude oil price in USD/barrel.
-- Correct only when oilprices is still stored in USD/m³; do not divide twice.
SELECT
    Year,
    oilprices / 6.2898 AS Price_Per_Barrel_USD
FROM Fact_oilsales;

-- Three-year rolling average production by country
SELECT
    Country,
    Year,
    AVG(Production) OVER (
        PARTITION BY Country
        ORDER BY Year
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Rolling_Avg_3_Year
FROM Fact_Production;

-- Compare oil production and consumption trends by region
SELECT
    a.Region,
    b.Year,
    SUM(b.Production) AS Total_Production,
    SUM(c.Consumption) AS Total_Consumption
FROM Dim_Country AS a
JOIN Fact_Production AS b
    ON a.Country = b.Country
JOIN Fact_Consumption AS c
    ON b.Country = c.Country
   AND b.Year = c.Year
GROUP BY a.Region, b.Year
ORDER BY a.Region, b.Year;
