SELECT *
FROM public."CovidDeaths"
WHERE continent IS NOT NULL

SELECT location,date, total_cases, new_cases, total_deaths, population
FROM public."CovidDeaths"
WHERE continent is NOT NULL
ORDER BY 1,2

-- Looking at Total Cases versus Total Deaths

-- Shows the likelihood of dying if one contracts covid in India

SELECT location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM public."CovidDeaths"
WHERE location like '%India%'
ORDER BY 1,2

--Looking at Total Cases versus Population

--Shows what percentage of population contracted covid

SELECT location,date, total_cases, population, (total_cases/population)*100 as population_contract_percentage
FROM public."CovidDeaths"
WHERE location = 'India' AND continent is NOT NULL

--Looking at countries with highest infection rate

SELECT MAX(total_cases)AS HighestInfectionCount,location, population, MAX(total_cases/population)*100 AS infected_percentage
FROM public."CovidDeaths"
WHERE continent IS NOT NULL AND total_cases IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC

--Showing Countries with highest death count per population

SELECT location,MAX(total_deaths) AS total_death_count
FROM public."CovidDeaths"
WHERE total_deaths IS NOT NULL AND continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC

--Showing continents with death count per population

SELECT continent, MAX(total_deaths) AS death_count
FROM public."CovidDeaths"
WHERE total_deaths IS NOT NULL AND continent IS NOT NULL
GROUP BY continent
ORDER BY death_count DESC

--GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as death_percentage
FROM public."CovidDeaths"
WHERE continent IS NOT NULL
ORDER BY 1,2


--COVID VACCINATIONS

SELECT *
FROM public."CovidVaccinations"


--Let us join the two tables CovidDeaths and CovidVacciantions from the database

SELECT * 
FROM public."CovidDeaths" dea JOIN public."CovidVaccinations" vac 
ON dea.location = vac.location AND dea.date = vac.date

--Looking at total population versus total vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM public."CovidDeaths" dea JOIN public."CovidVaccinations" vac 
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

--Using CTE (Commom Table Expression)

WITH pop_vs_vac (Continent, Location, Date, Population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM public."CovidDeaths" dea JOIN public."CovidVaccinations" vac 
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT *, (rolling_people_vaccinated/population)*100
FROM pop_vs_vac

--Using TEMP table

DROP TABLE IF EXISTS percent_population_vaccinated
CREATE TEMPORARY TABLE percent_population_vaccinated(Continent text, 
 Location text, 
 Date date, 
 Population numeric, 
 new_vaccinations numeric, 
 rolling_people_vaccinated numeric);
 
INSERT INTO percent_population_vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM public."CovidDeaths" dea JOIN public."CovidVaccinations" vac 
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (rolling_people_vaccinated/population)*100
FROM percent_population_vaccinated

--Creating VIEW for storing data for visualizations

CREATE VIEW percent_population_vaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM public."CovidDeaths" dea JOIN public."CovidVaccinations" vac 
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL