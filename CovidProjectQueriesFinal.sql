--SELECT * 
--FROM PortfolioProject..CovidDeaths
--ORDER BY 3, 4

SELECT * 
FROM PortfolioProject..CovidVaccinations
WHERE continent is not null
ORDER BY 3, 4

-- Select Data we finna use

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

-- total cases v. total deaths

--DECLARE @total_deaths int;
--DECLARE @total_cases int;
--ALTER TABLE CovidDeaths
--ALTER COLUMN deaths_by_case INT;
-- cases and deaths were not INT data types. Had to change them. Also to get a decimal result, had to turn one of the columns into FLOATs.

SELECT Location, date, total_cases, total_deaths, (cast(total_deaths AS FLOAT)/total_cases)*100 AS percent_of_death_by_cases -- CAST(@numerator AS FLOAT)
FROM PortfolioProject..CovidDeaths
WHERE  Location LIKE '%Phil%'
ORDER BY 2 desc, 5 DESC, 1

-- shows the liklihood of dying if you contract covid in the philippines

-- Looking at Total Cases vs Population

SELECT Location, date, population, total_cases, (cast(total_cases AS FLOAT)/population)*100 AS death_percentage -- CAST(@numerator AS FLOAT)
FROM PortfolioProject..CovidDeaths
WHERE  Location LIKE '%Canada%'
ORDER BY 5 desc

-- Looking at Countries with highest infection rate compared to population

SELECT Location, population, MAX(total_cases) AS highest_infection_count, MAX((cast(total_cases AS FLOAT)/population))*100 AS percent_pop_infected
FROM CovidDeaths
--WHERE  Location LIKE '%Canada%'
GROUP BY Location, population
ORDER BY 4 desc, 3 desc, 1, 2

-- Showing countries w/ highest death count per population

SELECT Location, MAX(Total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc

-- Break things down by **continent; need to include this in tableau



-- showing continents with highest death count per population; how can we visualize this?

SELECT continent, MAX(Total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc



-- calculate everything across the entire world (global numbers)

SELECT SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, 
		(SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100) as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
	AND new_cases !=0 
	AND new_cases IS NOT NULL
--group by date
ORDER BY 3 desc, 1 desc

-- calculate everything across the globe by date

SELECT date, SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, 
		(SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100) as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
	AND new_cases !=0 
	AND new_cases IS NOT NULL
group by date
ORDER BY 1, 2









-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
	SUM(CAST(vax.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPPLVaxxed
	-- (RollingPPLVaxxed/population)*100 -- error!!!, CANNOT use a column we just created to calculate. NEED TO MAKE CTE/Temp table!!!!
FROM PortfolioProject..CovidDeaths as dea
	JOIN PortfolioProject..CovidVaccinations as vax
		ON  dea.location = vax.location
		AND dea.date = vax.date
where dea.continent IS NOT NULL AND dea.location LIKE '%Canada%'
ORDER BY 2,3 desc


--	Using CTE
WITH PopvsVax (continent, location, date, population, new_vaccinations, RollingPPLVaxxed)
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
	SUM(CAST(vax.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPPLVaxxed
	-- (RollingPPLVaxxed/population)*100 -- error!!!, CANNOT use a column we just created to calculate. NEED TO MAKE CTE/Temp table!!!!
FROM PortfolioProject..CovidDeaths as dea
	JOIN PortfolioProject..CovidVaccinations as vax
		ON  dea.location = vax.location
		AND dea.date = vax.date
where dea.continent IS NOT NULL AND dea.location LIKE '%Canada%'
--ORDER BY 2,3 desc
)
SELECT *, (RollingPPLVaxxed/population)*100
FROM PopvsVax



-- Using Temp table
DROP TABLE IF EXISTS #PercentPopVaxxed
CREATE TABLE #PercentPopVaxxed (
	Continent nvarchar(500),
	Location nvarchar(500),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPPLVaxxed numeric
	)

INSERT INTO #PercentPopVaxxed
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
	SUM(CAST(vax.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPPLVaxxed
	-- (RollingPPLVaxxed/population)*100 -- error!!!, CANNOT use a column we just created to calculate. NEED TO MAKE CTE/Temp table!!!!
FROM PortfolioProject..CovidDeaths as dea
	JOIN PortfolioProject..CovidVaccinations as vax
		ON  dea.location = vax.location
		AND dea.date = vax.date
--where dea.continent IS NOT NULL AND dea.location LIKE '%Canada%'
--ORDER BY 2,3 desc


SELECT *, (RollingPPLVaxxed/population)*100
FROM #PercentPopVaxxed


-- When you create a VIEW you can use it as a visualization. Permanent**


-- Creating VIEW to stre data for later viz (continents)
CREATE VIEW PercentPopVaxxed AS
SELECT continent, MAX(Total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
--ORDER BY TotalDeathCount desc

SELECT * 
FROM PercentPopVaxxed
ORDER BY 2 desc

-- Create VIEW to store data for later viz (Canada)
CREATE VIEW PercerntCanadaVaxxed AS
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
	SUM(CAST(vax.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPPLVaxxed
	-- (RollingPPLVaxxed/population)*100 -- error!!!, CANNOT use a column we just created to calculate. NEED TO MAKE CTE/Temp table!!!!
FROM PortfolioProject..CovidDeaths as dea
	JOIN PortfolioProject..CovidVaccinations as vax
		ON  dea.location = vax.location
		AND dea.date = vax.date
where dea.continent IS NOT NULL AND dea.location LIKE '%Canada%'
--ORDER BY 2,3 desc

SELECT *
FROM PercerntCanadaVaxxed
ORDER BY 2, 3 DESC
