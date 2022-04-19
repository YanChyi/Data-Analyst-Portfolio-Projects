/* 
COVID-19 Portfolio Project: Data Exploration 
	
Skills used: Joins, CTE's, Temporary Tables, Subqueries, Windows Functions, Aggregate Functions, Creating Views

*/

USE portfolio_project_covid;

SELECT *
FROM covid_deaths
ORDER BY 3,4
;

SELECT *
FROM covid_vaccinations
ORDER BY 3,4
;


-- BREAKDOWN BY COUNTRY

-- Create a temporary table and select data that we are going to start with

DROP TEMPORARY TABLE IF EXISTS covid_cases__deaths_vaccinations_by_country;

CREATE TEMPORARY TABLE covid_cases__deaths_vaccinations_by_country
SELECT
	dea.location,
    dea.dates,
    dea.population,
    dea.total_cases,
    dea.new_cases,
    dea.total_deaths,
    dea.new_deaths,
    vac.total_vaccinations,
    vac.people_fully_vaccinated
FROM covid_deaths dea
	INNER JOIN covid_vaccinations vac
			ON dea.location = vac.location
            AND dea.dates = vac.dates
WHERE dea.continent IS NOT NULL -- to filter out the continents and income groups in location column
ORDER BY 1,2
;


-- Total Cases vs Total Deaths
-- Shows the COVID-19 death rate in a country

SELECT
	location,
    dates,
    total_cases,
    total_deaths,
    (total_deaths/total_cases)*100 AS death_rate
FROM covid_cases__deaths_vaccinations_by_country
WHERE 
	location = 'Malaysia' -- choose an arbitrary country
ORDER BY 1,2
;


-- Total Cases vs Population
-- Shows the percentage of population infected with COVID-19 in a country

SELECT
	location,
    dates,
    population,
    total_cases,
    (total_cases/population)*100 AS percent_population_infected
FROM covid_cases__deaths_vaccinations_by_country
WHERE 
	location = 'Malaysia' -- choose an arbitrary country
ORDER BY 1,2
;


-- Vaccination vs Population
-- Shows the percentage of population fully vaccinated in a country

SELECT
	location,
    dates,
    population,
    total_vaccinations AS doses_given,
    people_fully_vaccinated AS fully_vaccinated,
    (people_fully_vaccinated/population)*100 AS percent_population_fully_vaccinated
FROM covid_cases__deaths_vaccinations_by_country
WHERE 
	location = 'Malaysia' -- choose an arbitrary country
    AND total_vaccinations IS NOT NULL
ORDER BY 1,2
;


-- Countries with Highest Infection Rate compared to Population

SELECT
	location,
    population,
    MAX(total_cases) AS highest_infection_count,
    MAX((total_cases/population))*100 AS percent_population_infected
FROM covid_cases__deaths_vaccinations_by_country
GROUP BY
	location,
    population
ORDER BY
	percent_population_infected DESC
;


-- Countries with Highest Death Count per Population

SELECT
	location,
    MAX(total_deaths) AS total_death_count
FROM covid_cases__deaths_vaccinations_by_country
GROUP BY location
ORDER BY total_death_count DESC
;


-- Countries with Highest Fully Vaccination Rate compared to Population

SELECT
	location,
    population,
    MAX(people_fully_vaccinated) AS highest_fully_vaccinated,
    MAX((people_fully_vaccinated/population))*100 AS percent_population_fully_vaccinated
FROM covid_cases__deaths_vaccinations_by_country
GROUP BY
	location,
    population
ORDER BY
	percent_population_fully_vaccinated DESC
;



-- BREAKDOWN BY CONTINENT

-- Check how many distinct continents

SELECT DISTINCT continent
FROM covid_deaths
ORDER BY 1
;

-- Create a temporary table and select data that we are going to start with

DROP TEMPORARY TABLE IF EXISTS covid_cases__deaths_vaccinations_by_continent;

CREATE TEMPORARY TABLE covid_cases__deaths_vaccinations_by_continent
SELECT
	dea.location,
    dea.dates,
    dea.population,
    dea.total_cases,
    dea.new_cases,
    dea.total_deaths,
    dea.new_deaths,
	vac.total_vaccinations,
    vac.people_fully_vaccinated
FROM covid_deaths dea
	INNER JOIN covid_vaccinations vac
			ON dea.location = vac.location
            AND dea.dates = vac.dates
WHERE
	dea.continent IS NULL -- to filter out the countries in location column
	AND dea.location in ('Africa', 'Asia', 'Europe', 'North America', 'Oceania', 'South America')
ORDER BY 1,2
;


-- Total Cases vs Total Deaths
-- Shows the COVID-19 death rate in a continent

SELECT
	location AS continent,
    dates,
    total_cases,
    total_deaths,
    (total_deaths/total_cases)*100 AS death_rate
FROM covid_cases__deaths_vaccinations_by_continent
WHERE 
	location = 'Asia' -- choose an arbitrary continent
ORDER BY 1,2
;


-- Total Cases vs Population
-- Shows the percentage of population infected with COVID-19 in a continent

SELECT
	location AS continent,
    dates,
    population,
    total_cases,
    (total_cases/population)*100 AS percent_population_infected
FROM covid_cases__deaths_vaccinations_by_continent
WHERE 
	location = 'Asia' -- choose an arbitrary continent
ORDER BY 1,2
;


-- Vaccination vs Population
-- Shows the percentage of population fully vaccinated in a continent

SELECT
	location AS continent,
    dates,
    population,
    total_vaccinations AS doses_given,
    people_fully_vaccinated AS fully_vaccinated,
    (people_fully_vaccinated/population)*100 AS percent_population_fully_vaccinated
FROM covid_cases__deaths_vaccinations_by_continent
WHERE 
	location = 'Asia' -- choose an arbitrary continent
    AND total_vaccinations IS NOT NULL
ORDER BY 1,2
;


-- Continents with Highest Infection Rate compared to Population

SELECT
	location AS continent,
    population,
    MAX(total_cases) AS highest_infection_count,
    MAX((total_cases/population))*100 AS percent_population_infected
FROM covid_cases__deaths_vaccinations_by_continent
GROUP BY
	location,
    population
ORDER BY
	percent_population_infected DESC
;


-- Continents with Highest Death Count per Population

SELECT
	location AS continent,
    MAX(total_deaths) AS total_death_count
FROM covid_cases__deaths_vaccinations_by_continent
GROUP BY location
ORDER BY total_death_count DESC
;


-- Continents with Highest Fully Vaccination Rate compared to Population

SELECT
	location AS continent,
    population,
    MAX(people_fully_vaccinated) AS highest_fully_vaccinated,
    MAX((people_fully_vaccinated/population))*100 AS percent_population_fully_vaccinated
FROM covid_cases__deaths_vaccinations_by_continent
GROUP BY
	location,
    population
ORDER BY
	percent_population_fully_vaccinated DESC
;



-- BREAKDOWN BY INCOME GROUP

-- Check how many distinct income groups

SELECT DISTINCT location
FROM covid_deaths
WHERE
	continent IS NULL -- to filter out the countries in location column
	AND location LIKE '%income%'
ORDER BY 1
;

-- Create a temporary table and select data that we are going to start with

DROP TEMPORARY TABLE IF EXISTS covid_cases__deaths_vaccinations_by_income_group;

CREATE TEMPORARY TABLE covid_cases__deaths_vaccinations_by_income_group
SELECT
	dea.location,
    dea.dates,
    dea.population,
    dea.total_cases,
    dea.new_cases,
    dea.total_deaths,
    dea.new_deaths,
	vac.total_vaccinations,
    vac.people_fully_vaccinated
FROM covid_deaths dea
	INNER JOIN covid_vaccinations vac
			ON dea.location = vac.location
            AND dea.dates = vac.dates
WHERE
	dea.continent IS NULL -- to filter out the countries in location column
	AND dea.location LIKE '%income%'
ORDER BY 1,2
;


-- Income Groups with Highest Infection Rate compared to Population

SELECT
	location AS income_group,
    population,
    MAX(total_cases) AS income_group_infection_count,
    MAX((total_cases/population))*100 AS income_group_percent_population_infected
FROM covid_cases__deaths_vaccinations_by_income_group
GROUP BY
	location,
    population
ORDER BY
	income_group_percent_population_infected DESC
;


-- Income Groups with Highest Death Count per Population

SELECT
	location AS income_group,
    MAX(total_deaths) AS total_death_count
FROM covid_cases__deaths_vaccinations_by_income_group
GROUP BY location
ORDER BY total_death_count DESC
;


-- Income Groups with Highest Fully Vaccination Rate compared to Population

SELECT
	location AS income_group,
    population,
    MAX(people_fully_vaccinated) AS highest_fully_vaccinated,
    MAX((people_fully_vaccinated/population))*100 AS percent_population_fully_vaccinated
FROM covid_cases__deaths_vaccinations_by_income_group
GROUP BY
	location,
    population
ORDER BY
	percent_population_fully_vaccinated DESC
;



-- GLOBAL NUMBERS

-- Total Cases vs Total Deaths
-- Shows the global COVID-19 death rate

SELECT
	dates,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths)/SUM(new_cases)*100 AS death_rate
FROM covid_deaths
WHERE continent IS NOT NULL -- to filter out the continents and income groups in location column
GROUP BY 1
ORDER BY 1
;



-- Vaccination overview

-- Total Population vs Vaccinations
-- Shows the percentage of population that has received at least one COVID-19 vaccine

SELECT 
	dea.continent,
    dea.location,
    dea.dates,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.dates) AS rolling_people_vaccinated
    -- (rolling_people_vaccinated/dea.population)*100
FROM covid_deaths dea
	INNER JOIN covid_vaccinations vac
		ON dea.location = vac.location
        AND dea.dates = vac.dates
WHERE dea.continent IS NOT NULL -- to filter out the continents and income groups in location column
ORDER BY 2,3
;


-- Using CTE to perform Calculation on Partition By in previous query

WITH population_vs_vaccination 
AS (
SELECT 
	dea.continent,
    dea.location,
    dea.dates,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.dates) AS rolling_people_vaccinated
FROM covid_deaths dea
	JOIN covid_vaccinations vac
		ON dea.location = vac.location
        AND dea.dates = vac.dates
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
)
SELECT 
	*,
    (rolling_people_vaccinated/population)*100 AS percent_people_vaccinated
FROM population_vs_vaccination
;


-- Using Temporary Table to perform Calculation on Partition By in previous query

DROP TEMPORARY TABLE IF EXISTS percent_population_vaccinated;

CREATE TEMPORARY TABLE percent_population_vaccinated
SELECT 
	dea.continent,
    dea.location,
    dea.dates,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.dates) AS rolling_people_vaccinated
FROM covid_deaths dea
	JOIN covid_vaccinations vac
		ON dea.location = vac.location
        AND dea.dates = vac.dates
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
;

SELECT 
	*,
    (rolling_people_vaccinated/population)*100 AS percent_people_vaccinated
FROM percent_population_vaccinated
;


-- Using Subquery to perform Calculation on Partition By in previous query

SELECT
	*,
    (rolling_people_vaccinated/population)*100 AS percent_people_vaccinated
FROM (
SELECT 
	dea.continent,
    dea.location,
    dea.dates,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.dates) AS rolling_people_vaccinated
FROM covid_deaths dea
	JOIN covid_vaccinations vac
		ON dea.location = vac.location
        AND dea.dates = vac.dates
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
) AS pop_vaccinated
;



-- Creating View to store data for later visualizations

CREATE VIEW percentage_population_vaccinated AS
SELECT 
	dea.continent,
    dea.location,
    dea.dates,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.dates) AS rolling_people_vaccinated
	-- (rolling_people_vaccinated/dea.population)*100
FROM covid_deaths dea
	JOIN covid_vaccinations vac
		ON dea.location = vac.location
        AND dea.dates = vac.dates
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
;