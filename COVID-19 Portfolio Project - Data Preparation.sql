/*

COVID-19 Portfolio Project: Import Data to MySQL

*/


-- Step 1: Download data
	-- https://ourworldindata.org/covid-deaths#explore-the-global-data-on-confirmed-covid-19-deaths
    
-- Step 2: Preprocess the COVID-19 CSV file
	-- split the file into two CSV files: covid_deaths & covid_vaccinations (check the CREATE TABLE statements below for column splitting)
	-- add a blank column at the end of each CSV file
	-- replace all blank entries with \N, which semantically will be interpreted by MySQL as meaning NULL
	-- check the data type of each column
	-- change the dates column to the format of 'yyyy-mm-dd''

-- Step 3: Import CSV file into MySQL table using command line

/* Access MySQL Shell
1. log into MySQL and run this command: mysql -u root -p
2. set the global variables by using this command: mysql> SET GLOBAL local_infile=1;
3. quit current server: mysql> quit
4. connect to the server with local-infile system variable: mysql --local-infile=1 -u root -p 
(replace root with your username)
*/

-- Create database & table using command line

CREATE DATABASE portfolio_project_covid;

USE portfolio_project_covid;

CREATE TABLE covid_deaths
(
	iso_code VARCHAR(10) NOT NULL,
	continent VARCHAR(15),
	location VARCHAR(40) NOT NULL,
	dates DATE NOT NULL,
	population BIGINT,
	total_cases INT,
	new_cases INT,
	new_cases_smoothed FLOAT,
	total_deaths INT,
	new_deaths MEDIUMINT,
	new_deaths_smoothed FLOAT,
	total_cases_per_million FLOAT,
	new_cases_per_million FLOAT,
	new_cases_smoothed_per_million FLOAT,
	total_deaths_per_million FLOAT,
	new_deaths_per_million FLOAT,
	new_deaths_smoothed_per_million FLOAT,
	reproduction_rate FLOAT,
	icu_patients MEDIUMINT,
	icu_patients_per_million FLOAT,
	hosp_patients MEDIUMINT,
	hosp_patients_per_million FLOAT,
	weekly_icu_admissions SMALLINT,
	weekly_icu_admissions_per_million FLOAT,
	weekly_hosp_admissions MEDIUMINT
);

CREATE TABLE covid_vaccinations
(
	iso_code VARCHAR(10),
	continent VARCHAR(15),
	location VARCHAR(40),
	dates DATE,
	total_tests INT,
	new_tests INT,
	total_tests_per_thousand FLOAT,
	new_tests_per_thousand FLOAT,
	new_tests_smoothed INT,
	new_tests_smoothed_per_thousand FLOAT,
	positive_rate FLOAT,
	tests_per_case FLOAT,
	tests_units VARCHAR(17),
	total_vaccinations BIGINT,
	people_vaccinated BIGINT,
	people_fully_vaccinated BIGINT,
	total_boosters BIGINT,
	new_vaccinations INT,
	new_vaccinations_smoothed INT,
	total_vaccinations_per_hundred FLOAT,
	people_vaccinated_per_hundred FLOAT,
	people_fully_vaccinated_per_hundred FLOAT,
	total_boosters_per_hundred FLOAT,
	new_vaccinations_smoothed_per_million MEDIUMINT,
	new_people_vaccinated_smoothed INT,
	new_people_vaccinated_smoothed_per_hundred FLOAT,
	stringency_index FLOAT,
	population_density FLOAT,
	median_age FLOAT,
	aged_65_older FLOAT,
	aged_70_older FLOAT,
	gdp_per_capita FLOAT,
	extreme_poverty FLOAT,
	cardiovasc_death_rate FLOAT,
	diabetes_prevalence FLOAT,
	female_smokers FLOAT,
	male_smokers FLOAT,
	handwashing_facilities FLOAT,
	hospital_beds_per_thousand FLOAT,
	life_expectancy FLOAT,
	human_development_index FLOAT,
	excess_mortality_cumulative_absolute FLOAT,
	excess_mortality_cumulative FLOAT,
	excess_mortality FLOAT,
	excess_mortality_cumulative_per_million FLOAT
);

-- Load CSV file into table

LOAD DATA LOCAL INFILE '/covid_deaths.csv' -- change this path to match the path and filename of your CSV file
INTO TABLE covid_deaths_test
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/covid_vaccinations.csv' -- change this path to match the path and filename of your CSV file
INTO TABLE covid_vaccinations_test
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Step 4: Check the number of rows of the table in MySQL workbench and match it with the CSV file
	-- to ensure the CSV file is fully loaded into the MySQL table

SELECT * 
FROM covid_deaths;

SELECT * 
FROM covid_vaccinations;
