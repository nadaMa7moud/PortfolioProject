select * from coviddeaths
order by 3,4;
--select * from covidaccvation
--order by 3,4;

-- select data that we are goig to us 
select location,date,total_cases,new_cases,total_deaths,population
from coviddeaths
order by 1,2;
-- looking at total cases vs total deaths 
select  location,date,total_cases,total_deaths,100 * CAST(total_deaths AS Integer) / CAST(total_cases AS Integer)  as deathpreacnage
from coviddeaths

order by 1,2
--looking at total cases vs population
-- show what percentage of population got covid 
select  location,date,total_cases, population, 100 *(CAST(total_cases AS Integer) / population)  as populationinfactedpercent
from coviddeaths
--where location like '%africa%'
order by 1,2
-- looking at countries with hightest infaction rate compared to population
select  location,population, max (total_cases) as hightestinfactedcantrey, population, 100 *max((CAST(total_cases AS Integer) )/ population)  as percentpopulationinfacted
from coviddeaths
group by location,population
order by percentpopulationinfacted desc


-- showing countries with hightest death count per population

select  location, max (cast(total_deaths as int)) as totaldeathcoun
from coviddeaths 
where continent is not null
group by location

order by totaldeathcoun desc
 -- lest break things down by continent

 select  location, max (cast(total_deaths as int)) as totaldeathcount
from coviddeaths 
where continent is null
group by location
order by totaldeathcount

-- showing continent with hightest death count per population 

select  continent, max (cast(total_deaths as int)) as totaldeathcount
from coviddeaths 
where continent is not null
group by  continent
order by totaldeathcount desc

-- golbal numbers
select sum(new_cases) as totalcases, sum(cast (new_deaths as int)) as total_deaths,   sum(cast(new_deaths as int))/ nullif (  sum(new_cases) ,0)*100 as deathpreacnage
from coviddeaths

where continent is not null
--group by date
order by 1,2

-- looking at total population va vaccinations
  select  dea. location,dea.date ,dea.population,vac.new_vaccinations ,sum(cast( vac. new_vaccinations as  BIGINT)) over (partition by dea.location order by dea.location ,dea.date) as rollingpeaplevaccsbted
  from  coviddeaths dea
  join covidvacsnation vac
  on dea.location = vac.location
  and dea.date=vac.date
-- where continent is not null
  order by 1,2
-- use CTE
with popvsvac ( location , date, population , new_vaccinations , rollingpeaplevaccsbted)
as
(
select  dea. location,dea.date ,dea.population,vac.new_vaccinations
,sum(cast( vac. new_vaccinations as  BIGINT)) over (partition by dea.location order by dea.location 
,dea.date) as rollingpeaplevaccsbted
  from  coviddeaths dea
  join covidvacsnation vac
  on dea.location = vac.location
  and dea.date=vac.date

  )
  select *, (rollingpeaplevaccsbted/population*100) as percentage
  from popvsvac

  -- greating tabel 
  drop table if exists #percentpopulationvaccinated
  create table #percentpopulationvaccinated
  (
  location nvarchar(255),
  date datetime,
  population numeric ,
  new_vaccinations numeric,
  rollingpeaplevaccsbted numeric
  )
  insert into #percentpopulationvaccinated
  select  dea. location,dea.date ,dea.population,vac.new_vaccinations
,sum(cast( vac. new_vaccinations as  BIGINT)) over (partition by dea.location order by dea.location 
,dea.date) as rollingpeaplevaccsbted
  from  coviddeaths dea
  join covidvacsnation vac
  on dea.location = vac.location
  and dea.date=vac.date
  -- creating veiw to store data for later visualization
  create view percentpopulationvaccinated as 
  select  dea. location,dea.date ,dea.population,vac.new_vaccinations
,sum(cast( vac. new_vaccinations as  BIGINT)) over (partition by dea.location order by dea.location 
,dea.date) as rollingpeaplevaccsbted
  from  coviddeaths dea
  join covidvacsnation vac
  on dea.location = vac.location
  and dea.date=vac.date
  select * from percentpopulationvaccinated 