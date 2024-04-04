Select *
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths]
Where continent is not null
Order by 3,4

--Select *
--From PortfolioProjects..[CovidVaccinations.xlsx - CovidVaccinations]

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths]
order by 1,2

--looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percent
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths]
Where location like '%states%'
order by 1,2

--looking at total cases vs population

Select location, date, total_cases,population, (total_cases/population)*100 as PopulationPercent
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths]
Where location like '%states%'
order by 1,2

--what countries have highest infection rates compared to population

Select location,population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as 
    PercentPopulationInfected
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths]
--Where location like '%states%'
Group By location,population
--order by 1,2
Order by PercentPopulationInfected desc

--Showing countries with highest death count per population

Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths]
--Where location like '%states%'
where continent is not null
Group By location
Order by TotalDeathCount desc

--top five countries by totaldeathcount are : United States, Brazil, Mexico, India, United Kingdom
--Lets break this down by continent

Select continent, MAX(total_deaths) as TotalDeathCount
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths]
--Where location like '%states%'
where continent is not null
Group By continent
Order by TotalDeathCount desc

Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths]
--Where location like '%states%'
where continent is null
Group By location
Order by TotalDeathCount desc
-----------------

--Showing continents with highest death count

Select continent, MAX(total_deaths) as TotalDeathCount
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths]
--Where location like '%states%'
where continent is not null
Group By continent
Order by TotalDeathCount desc
---------

Select continent, MAX(total_deaths) as TotalDeathCount
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths]
--Where location like '%states%'
where continent is not null
Group By continent
Order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as TotalCases, SUM(new_deaths)as TotalNewDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths]
--Where location like '%states%'
Where continent is not null
--Group by date
order by 1,2
-----

--Looking at total number of vaccinations in the world

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,
    dea.date) as RollingPeopleVaccinated
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths] dea
Join PortfolioProjects..[CovidVaccinations.xlsx - CovidVaccinations] vac
    on dea.location = vac.location
    and dea.date = vac.date 
Where dea.continent is not null
order by 2,3

--USE CTE

WITH PopvsVacc (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS

(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,
    dea.date) as RollingPeopleVaccinated
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths] dea
Join PortfolioProjects..[CovidVaccinations.xlsx - CovidVaccinations] vac
    on dea.location = vac.location
    and dea.date = vac.date 
Where dea.continent is not null)
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as PercentVacc
From PopvsVacc

---TEMP Table

Create Table #PercentPopulationVaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    new_vaccinations numeric,
    RollingPeopleVaccinated numeric

)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,
    dea.date) as RollingPeopleVaccinated
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths] dea
Join PortfolioProjects..[CovidVaccinations.xlsx - CovidVaccinations] vac
    on dea.location = vac.location
    and dea.date = vac.date 
--Where dea.continent is not null

--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-----
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,
    dea.date) as RollingPeopleVaccinated
From PortfolioProjects..[CovidDeaths.xlsx - CovidDeaths] dea
Join PortfolioProjects..[CovidVaccinations.xlsx - CovidVaccinations] vac
    on dea.location = vac.location
    and dea.date = vac.date 
where dea.continent is not null 
--order by 2,3