
/*

Exploring the dataset
Skills used: Joins, CASE, Temp Tables, Aggregate Functions
Data obtained from Our World In Data website

*/

SELECT *
FROM
	[dbo].[owid_Cases_Deaths]


SELECT Distinct
	continent, location
FROM
	[dbo].[owid_Cases_Deaths]
Order by
	continent asc


SELECT
	location, date, total_cases, new_cases, total_deaths, new_deaths, population
FROM
	[dbo].[owid_Cases_Deaths]
WHERE
	continent is not null
Order by 1,2


----------------------------------------------------------------------------------------------------

/*

An Overview of Covid-19 Globally

We will explore the data as follows:
- Percent Population Infected
- Death Percentage
- Total Vaccination doses taken per country
- Percent of people fully vaccinated compared to population
- Total vaccination rate of the population

*/

-- 1. Percent Population Infected

SELECT
	Location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM
	[dbo].[owid_Cases_Deaths]
WHERE
	continent is not null
ORDER BY 1,2

-- 2. Death Percentage globally

SELECT
	location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM
	[dbo].[owid_Cases_Deaths]
WHERE
	continent is not null
ORDER BY 1,2

-- 3. Total Vaccination doses taken per country

SELECT Distinct
	cas.continent, cas.location, cas.population, MAX(vac.total_vaccinations) as Total_Vaccination_Doses
FROM
	[dbo].[owid_Cases_Deaths] cas
JOIN
	[dbo].[owid_Vaccinations] vac
	ON cas.date = vac.date
	AND cas.location = vac.location
WHERE
	cas.continent is not null
GROUP BY
	cas.continent, cas.location, cas.population
ORDER BY 
	4 desc

-- 4. Percent of people fully vaccinated compared to population

SELECT Distinct
	cas.continent, cas.location, cas.population, MAX(vac.people_fully_vaccinated) as Total_People_Vaccinated, MAX(vac.people_fully_vaccinated/cas.population)*100 as Percentage_People_Vaccinated
FROM
	[dbo].[owid_Cases_Deaths] cas
JOIN
	[dbo].[owid_Vaccinations] vac
	ON cas.date = vac.date
	AND cas.location = vac.location
WHERE
	cas.continent is not null
GROUP BY
	cas.continent, cas.location, cas.population
ORDER BY 
	5 desc

-- 6. Total vaccination rate of the population

WITH VacPop (continent, location, population, Percentage_People_Vaccinated)
AS
(
SELECT Distinct
	cas.continent, cas.location, cas.population, MAX(vac.people_fully_vaccinated/cas.population)*100 as Percentage_People_Vaccinated
		
FROM
	[dbo].[owid_Cases_Deaths] cas
JOIN
	[dbo].[owid_Vaccinations] vac
	ON cas.date = vac.date
	AND cas.location = vac.location
WHERE
	cas.continent is not null
GROUP BY
	cas.continent, cas.location, cas.population
--ORDER BY 
	--4 desc
)
Select *,
CASE 
	WHEN Percentage_People_Vaccinated > 50 THEN 'Higher than 50%'
	WHEN Percentage_People_Vaccinated = 50 THEN 'Equals 50%'
	ELSE 'Lower than 50%'
END as Total_vaccination_rate
FROM VacPop
ORDER BY 1,2,5 asc

------------------------------------------------------------------------------------------------------------

/*

An Overview of Covid-19 In Saudi Arabia

We will explore the data as follows:
- Percent Population Infected
- Death Percentage
- Saudi Arabia in October

*/

-- 1. Percent Population Infected in Saudi Arabia
SELECT
	Location, date, Population, total_cases, (total_cases/population)*100 as KSAPercentPopulationInfected
FROM
	[dbo].[owid_Cases_Deaths]
WHERE
	location like '%saudi%' 
	AND continent is not null
ORDER BY 2

-- 2. Death Percentage in Saudi Arabia

SELECT
	location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as KSADeathPercentage
FROM
	[dbo].[owid_Cases_Deaths]
WHERE
	location like '%saudi%'
	AND continent is not null
ORDER BY 1,2

-- 3. Saudi Arabia in October

SELECT
	cas.location, cas.date, cas.new_cases, cas.new_deaths, vac.new_vaccinations
FROM
	[dbo].[owid_Cases_Deaths] cas
JOIN
	[dbo].[owid_Vaccinations] vac
	ON cas.location = vac.location
	AND cas.date = vac.date
WHERE
	cas.location like '%saudi%'
	AND cas.date >= '2021-10-01'
ORDER BY 2