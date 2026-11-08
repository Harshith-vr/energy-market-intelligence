-- Database schema for the Energy Market Intelligence project
-- Compatible with MySQL 8.0+
-- Run this file before importing the CSV files.

CREATE DATABASE IF NOT EXISTS energy_analysis
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE energy_analysis;

CREATE TABLE IF NOT EXISTS Dim_Country (
    Country VARCHAR(100) NOT NULL,
    Region  VARCHAR(100) NOT NULL,
    PRIMARY KEY (Country)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Dim_Year (
    Year SMALLINT NOT NULL,
    PRIMARY KEY (Year)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Fact_Production (
    Country    VARCHAR(100) NOT NULL,
    Year       SMALLINT NOT NULL,
    Production DECIMAL(18,6) NOT NULL,
    PRIMARY KEY (Country, Year),
    CONSTRAINT fk_production_country
        FOREIGN KEY (Country) REFERENCES Dim_Country (Country),
    CONSTRAINT fk_production_year
        FOREIGN KEY (Year) REFERENCES Dim_Year (Year)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Fact_Consumption (
    Country     VARCHAR(100) NOT NULL,
    Year        SMALLINT NOT NULL,
    Consumption DECIMAL(18,6) NOT NULL,
    PRIMARY KEY (Country, Year),
    CONSTRAINT fk_consumption_country
        FOREIGN KEY (Country) REFERENCES Dim_Country (Country),
    CONSTRAINT fk_consumption_year
        FOREIGN KEY (Year) REFERENCES Dim_Year (Year)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Fact_Trade (
    Country VARCHAR(100) NOT NULL,
    Year    SMALLINT NOT NULL,
    Exports DECIMAL(18,6) NOT NULL,
    Imports DECIMAL(18,6) NOT NULL,
    PRIMARY KEY (Country, Year),
    CONSTRAINT fk_trade_country
        FOREIGN KEY (Country) REFERENCES Dim_Country (Country),
    CONSTRAINT fk_trade_year
        FOREIGN KEY (Year) REFERENCES Dim_Year (Year)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Fact_oilsales (
    Year      SMALLINT NOT NULL,
    oilprices DECIMAL(18,6) NOT NULL,
    PRIMARY KEY (Year),
    CONSTRAINT fk_oilsales_year
        FOREIGN KEY (Year) REFERENCES Dim_Year (Year)
) ENGINE=InnoDB;
