# Data Exploration using SQL

 The goal of this project is to deep dive into historic data of COVID 19 deaths and vaccines using SQL and get valuable insights out of it.
Data exploration is the first step of data analysis used to explore and visualize data to uncover insights from the start or identify areas or patterns to dig into more. Using interactive dashboards and point-and-click data exploration, users can better understand the bigger picture and get to insights faster. 

 SQL is the language used to interact with relational databases. Since most systems today capture the data using one or more databases (like MySQL, Oracle, Redshift, SQL Server, etc.), we wanted to take advantage of  SQL to extract data from these systems and then work with it. The postgreSQL was used in this exploration.

## Approach

 Our data analysis method begins with exploratory data analysis (EDA). Making sense of the data we have at this point will help us choose what questions to ask, how to frame them, and the best way to use the data we have to our advantage in order to obtain the answers we require. We accomplish this by taking a comprehensive look at patterns, trends, outliers, unexpected outcomes, and other features in our data and utilising quantitative and visual tools to understand the story it tells. We're seeking for hints that point to our logical next actions, inquiries, or study areas.
 
 ## Data Preparation
 We have data sourced from [here](https://ourworldindata.org/covid-deaths) where it provides data on the number of confirmed deaths from COVID-19. For the initial arrangement of the data we have downloaded the csv files and set them up as required using spreadsheet software. The two files we initially sourced are 'CovidDeaths.csv' and 'CovidVaccinations.csv'.

## Importing Datasets into database
 We have downloaded and installed *PostgreSQL* Open source PostgreSQL packages and installers from EDB. Select the appropriate platform you wish to run in this [website](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads). After the installation on our Computer, the preceding package installation will be combined with the installation of pgAdmin 4, a potent graphical user interface that makes the construction, upkeep, and usage of database objects simpler. Using this we will start the exploration process further.

* Creating a DATABASE in the postgreSQL server locally
```sql
-- Database: CovidExplorations

-- DROP DATABASE IF EXISTS "CovidExplorations";

CREATE DATABASE "CovidExplorations"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
```
Upon successful creation of database it will be listed along with the existing databases.

* importing data into Postgres

 The `COPY` command can import data to Postgres if access to text, CSV, or binary format data. Since we have our datasets in CSV format let us use this. Initially we will create two tables before importing data from the csv files. The tables are to be created in line with the structure of the data we already have.

Creating table for storing deaths data with table name 'CovidDeaths'
```sql
-- Table: public.CovidDeaths

-- DROP TABLE IF EXISTS public."CovidDeaths";

CREATE TABLE IF NOT EXISTS public."CovidDeaths"
(
    iso_code text COLLATE pg_catalog."default",
    continent text COLLATE pg_catalog."default",
    location text COLLATE pg_catalog."default",
    date date,
    population numeric,
    total_cases numeric,
    new_cases numeric,
    new_cases_smoothed numeric,
    total_deaths numeric,
    new_deaths numeric,
    new_deaths_smoothed numeric,
    total_cases_per_million numeric,
    new_cases_per_million numeric,
    new_cases_smoothed_per_million numeric,
    total_deaths_per_million numeric,
    new_deaths_per_million numeric,
    new_deaths_smoothed_per_million numeric,
    reproduction_rate numeric,
    icu_patients numeric,
    icu_patients_per_million numeric,
    hosp_patients numeric,
    hosp_patients_per_million numeric,
    weekly_icu_admissions numeric,
    weekly_icu_admissions_per_million numeric,
    weekly_hosp_admissions numeric,
    weekly_hosp_admissions_per_million numeric
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."CovidDeaths"
    OWNER to postgres;
```
Creating table for storing vaccines data with table name 'CovidVaccinations'
```sql
-- Table: public.CovidVaccinations

-- DROP TABLE IF EXISTS public."CovidVaccinations";

CREATE TABLE IF NOT EXISTS public."CovidVaccinations"
(
    iso_code text COLLATE pg_catalog."default",
    continent text COLLATE pg_catalog."default",
    location text COLLATE pg_catalog."default",
    date date,
    new_tests numeric,
    total_tests numeric,
    total_tests_per_thousand numeric,
    new_tests_per_thousand numeric,
    new_tests_smoothed numeric,
    new_tests_smoothed_per_thousand numeric,
    positive_rate numeric,
    tests_per_case numeric,
    tests_units text COLLATE pg_catalog."default",
    total_vaccinations numeric,
    people_vaccinated numeric,
    people_fully_vaccinated numeric,
    new_vaccinations numeric,
    new_vaccinations_smoothed numeric,
    total_vaccinations_per_hundred numeric,
    people_vaccinated_per_hundred numeric,
    people_fully_vaccinated_per_hundred numeric,
    new_vaccinations_smoothed_per_million numeric,
    stringency_index numeric,
    population_density numeric,
    median_age numeric,
    aged_65_older numeric,
    aged_70_older numeric,
    gdp_per_capita numeric,
    extreme_poverty numeric,
    cardiovasc_death_rate numeric,
    diabetes_prevalence numeric,
    female_smokers numeric,
    male_smokers numeric,
    handwashing_facilities numeric,
    hospital_beds_per_thousand numeric,
    life_expectancy numeric,
    human_development_index numeric
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."CovidVaccinations"
    OWNER to postgres;
```
 The tables are succesfully created and can be viewed under `CovidExplorations/Schemas/public/Tables` in *pgadmin4*

The exploration was continued exactly in the below order which can be seen in the <>
* How many continents do we have data for
* Possibility of dying from Covid
* Percent of population infected with Covid
* Countries with highest infection per population
* Countries with highest deaths from COVID19
* Continents with highest deaths from COVID19
* Global Covid cases and death
* Number of people vaccinated
* Using CTE in postgreSQL Server
* Using Temporary Tables in posrgreSQL Server
* Using Views in postgreSQL Server

