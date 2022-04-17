SELECT *
FROM covid_19.covid_deaths
ORDER BY 3,4;
 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_19.covid_deaths
ORDER BY 1;

-- Total Cases v Total Deaths Per Country
-- Likelihood of dying if you contract COVID-19 in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM covid_19.covid_deaths
WHERE location like '%states%'
ORDER BY 1;

-- Total Cases v Population
-- Shows what percentage of population contracted COVID-19

SELECT location, date, population, total_cases, (total_cases/population)*100 AS Percent_Population_Infected
FROM covid_19.covid_deaths
WHERE location like '%states%'
ORDER BY 1;

-- Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/population))*100 AS Percent_Population_Infected
FROM covid_19.covid_deaths
GROUP BY location, population
ORDER BY percent_population_infected DESC;

-- Countries with the highest death count per population

SELECT location, MAX(convert(total_deaths, unsigned integer)) AS Total_Death_Count
FROM covid_19.covid_deaths
WHERE dea.continent IS NOT NULL
GROUP BY location
ORDER BY Total_Death_Count DESC;

-- Showing continents with highest death count

SELECT continent, MAX(convert(total_deaths, unsigned integer)) AS Total_Death_Count
FROM covid_19.covid_deaths
WHERE dea.continent IS NOT NULL
GROUP BY continent 
ORDER BY Total_Death_Count DESC;

-- Global numbers

SELECT SUM(new_cases) AS Total_Cases,
SUM(convert(new_deaths, unsigned integer)) AS Total_Deaths,
SUM(convert(new_deaths, unsigned integer))/SUM(new_cases)*100 AS Death_Percentage
FROM covid_19.covid_deaths
WHERE dea.continent IS NOT NULL;

-- Looking at Total Population v Vaccinations

SELECT dea.continent,
dea.location, dea.date,
dea.population,
vac.new_vaccinations,
SUM(convert(new_vaccinations, unsigned integer)) OVER (ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM covid_19.covid_deaths dea
JOIN covid_19.covid_vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- Use CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
AS
(
SELECT dea.continent,
dea.location, dea.date,
dea.population,
vac.new_vaccinations,
SUM(convert(new_vaccinations, unsigned integer)) OVER (ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM covid_19.covid_deaths dea
JOIN covid_19.covid_vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (rolling_people_vaccinated/population)*100 AS Percent_Population_Vaccinated
FROM PopvsVac;

-- Temp Table

CREATE TABLE Percent_Population_Vaccinated
(
Continent text,
Location text,
Date datetime,
Population numeric,
New_Vaccination numeric,
Rolling_People_Vaccinated numeric
);

UPDATE covid_deaths
SET
continent = NULLIF(continent,'')
WHERE 
continent = '';

INSERT INTO Percent_Population_Vaccinated
SELECT dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(convert(new_vaccinations, unsigned integer)) OVER (ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM covid_19.covid_deaths dea
JOIN covid_19.covid_vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT *, (rolling_people_vaccinated/population)*100
FROM Percent_Population_Vaccinated;
