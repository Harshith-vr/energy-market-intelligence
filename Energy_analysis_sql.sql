CREATE DATABASE IF NOT EXISTS energy_analysis;
USE energy_analysis;

CREATE TABLE Dim_Year(
Year INT PRIMARY KEY
);

INSERT INTO Dim_Year(Year)
VALUES
(2000),(2001),(2002),(2003),(2004),
(2005),(2006),(2007),(2008),(2009),
(2010),(2011),(2012),(2013),(2014),
(2015),(2016),(2017),(2018);

#total oil production by country
SELECT Country,SUM(Production) AS total_Production,
DENSE_RANK() OVER(ORDER BY SUM(Production) DESC) AS r
FROM Fact_Production
GROUP BY Country
ORDER BY total_Production DESC;

#total oil consumption by country



SELECT Country,SUM(Consumption) AS total_Consumption,
DENSE_RANK() OVER(ORDER BY SUM(Consumption) DESC) AS r
FROM Fact_Consumption
GROUP BY Country
ORDER by r;

#production-consumption gap for each country and year.

SELECT p.Country,p.Year,p.Production-c.Consumption as p_c_gap
FROM Fact_Production as p
JOIN Fact_Consumption as c
ON p.Country=c.Country AND p.Year=c.Year
ORDER BY p.Country,p.Year;

#oil production for each year.

# Oil production for each country by year
SELECT
    Country,
    Year,
    Production
FROM Fact_Production
ORDER BY Country, Year;

#total production by region and year

SELECT c.Region,p.Year,SUM(p.Production) as Reg_production
FROM Dim_Country as c
JOIN Fact_Production as p
ON c.Country=p.Country
GROUP BY c.Region,p.Year
ORDER BY c.Region,p.Year,Reg_production DESC;

#net trade using exports minus imports.


SELECT Country,(SUM(exports)-SUM(imports)) AS net_trade,
DENSE_RANK() OVER(ORDER BY (SUM(exports)-SUM(imports)) DESC) AS r
FROM Fact_Trade
GROUP BY Country;

#highest production year for each country.
SELECT t.Country,t.Year,t.Production
FROM(
SELECT *,DENSE_RANK() OVER(PARTITION BY Country ORDER BY Production DESC) AS r
FROM Fact_Production
) as t
WHERE t.r=1;

#countries where consumption exceeded production.

SELECT
    c.Country
FROM Fact_Consumption AS c
JOIN Fact_Production AS p
    ON c.Country = p.Country
   AND c.Year = p.Year
GROUP BY c.Country
HAVING SUM(c.Consumption) > SUM(p.Production);

#top net exporting countries.
SELECT
    Country,
    SUM(Exports) - SUM(Imports) AS Net_exports
FROM Fact_Trade
GROUP BY Country
ORDER BY Net_exports DESC
LIMIT 5;

#top net importing countries.
SELECT
    Country,
    SUM(Imports) - SUM(Exports) AS Net_imports
FROM Fact_Trade
GROUP BY Country
ORDER BY Net_imports DESC
LIMIT 5;

#yoy consumption growth percentage;

-- SELECT a.country,a.year,(((a.Production-b.Production)/a.Production)*100) as Production_rate
-- FROM Fact_Consumption as a
-- join FacT_Consumption as b 
-- on a.country=b.country and a.year=b.year+1;

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
        ((Consumption - Previous_Year_Consumption)
        / NULLIF(Previous_Year_Consumption,0)) * 100,
        2
    ) AS Consumption_YoY_Percent
FROM ConsumptionGrowth;

#yoy production rate

WITH ProductionGrowth AS(
SELECT
	country,Year,Production,
    LAG(Production) OVER(
    PARTITION BY country
    ORDER BY Year)
    AS Prev_Year_Production
    FROM Fact_Production
    )

SELECT 
	country,Year,
    ROUND(((Production-Prev_Year_Production)/NULLIF(Prev_Year_Production,0))*100,2) as Production_YoY_percentage
    FROM ProductionGrowth;
    
#oil price trend
SELECT
    Year,
    oilprices / 6.2898 AS price_per_barrel
FROM Fact_oilsales;

#3 year rolling average
SELECT 
Country,Year,
avg(Production) 
OVER(PARTITION BY COUNTRY ORDER BY Year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
AS rolling_avg_3_year
FROM Fact_Production;
	
#Compare oil production and consumption trends by region.

SELECT a.Region,b.Year,SUM(b.Production) AS Total_Production,SUM(c.Consumption) AS Total_Consumption
FROM Dim_Country AS a
JOIN Fact_Production AS b
ON a.Country=b.Country
JOIN Fact_Consumption AS c
ON b.Country=c.Country AND b.Year=c.Year
GROUP BY a.Region,b.Year
ORDER BY a.Region,b.Year;

    