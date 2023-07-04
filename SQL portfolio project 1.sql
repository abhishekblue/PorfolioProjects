update population
set Capital = 'Washington', continent = 'DC', "2022 Population"= 376870696
where population.rank = 3;

ALTER TABLE population
ALTER COLUMN "2022 Population" decimal(20,2);

ALTER TABLE population
ALTER COLUMN "2020 Population" decimal(20,2);

ALTER TABLE population
ALTER COLUMN "1990 Population" decimal(20,2);

ALTER TABLE population
ALTER COLUMN "1980 Population" decimal(20,2);

ALTER TABLE population
ALTER COLUMN "1970 Population" decimal(20,2);

ALTER TABLE population
ALTER COLUMN "2015 Population" decimal(20,2);

ALTER TABLE population
ALTER COLUMN "2010 Population" decimal(20,2);

ALTER TABLE population
ALTER COLUMN "2000 Population" decimal(20,2);

ALTER TABLE population
ALTER COLUMN "Area sqkm" decimal(20,2);

ALTER TABLE population
ALTER COLUMN "Density per sqkm" decimal(20,2);

ALTER TABLE population
ALTER COLUMN "Growth Rate" decimal(20,2);


SELECT * from population
order by cast(Rank as int)

-- Total population of all countries in each year.

select [country territory],
SUM("2022 Population") as "Total Population 2022",
sum("2020 Population") as "Total Population 2020",
sum("2015 Population") as "Total Population 2015",
sum("2010 Population") as "Total Population 2010",
sum("2000 Population") as "Total Population 2000",
sum("1990 Population") as "Total Population 1990",
sum("1980 Population") as "Total Population 1980",
sum("1970 Population") as "Total Population 1970"
from population 
group by [Country Territory]


-- Average population density (per km²) of all countries in each year

SELECT [country territory],
CAST([2022 Population] AS DECIMAL(20,2)) / [Area sqkm] AS PopulationDensity2022,
CAST([2020 Population] AS DECIMAL(20,2)) / [Area sqkm] AS PopulationDensity2020,
CAST([2015 Population] AS DECIMAL(20,2)) / [Area sqkm] AS PopulationDensity2015,
CAST([2010 Population] AS DECIMAL(20,2)) / [Area sqkm] AS PopulationDensity2010,
CAST([2000 Population] AS DECIMAL(20,2)) / [Area sqkm] AS PopulationDensity2000,
CAST([1990 Population] AS DECIMAL(20,2)) / [Area sqkm] AS PopulationDensity1990,
CAST([1980 Population] AS DECIMAL(20,2)) / [Area sqkm] AS PopulationDensity1980,
CAST([1970 Population] AS DECIMAL(20,2)) / [Area sqkm] AS PopulationDensity1970
FROM population
order by 1;


-- Total population for each continent in each year 
--for this I needed to change data type to decimal(20, 2) from int because of 'Arithmetic overflow error converting expression to data type int'

select Continent,
sum("2022 Population") as "Total Population 2022",
sum("2020 Population") as "Total Population 2020",
sum("2015 Population") as "Total Population 2015",
sum("2010 Population") as "Total Population 2010",
sum("2000 Population") as "Total Population 2000",
sum("1990 Population") as "Total Population 1990",
sum("1980 Population") as "Total Population 1980",
sum("1970 Population") as "Total Population 1970"
from population 
group by Continent


-- countries with highest growth rate from 1970 to 2022

select "Country Territory",
("2022 Population"-"1970 Population")/"1970 Population" * 100 as growth_percentage
FROM Population
order by growth_percentage desc;


-- countries have seen a decrease in population since 1970

select "Country Territory",
("2022 Population"-"1970 Population")/"1970 Population" * 100 as growth_percentage
FROM Population
where (("2022 Population"-"1970 Population")/"1970 Population" * 100 < 0)
order by growth_percentage;

select "Country Territory", "1970 Population","2022 Population", "1970 Population"-"2022 Population" as Population_diff from population
where "2022 Population" < "1970 Population"
order by Population_diff;


--countries with a population above the average population of their respective continents in 2022

select "Country Territory", p1.continent, p1."2022 population", p2.AvgPopulation from Population p1
inner join (
	select continent, avg("2022 population") as AvgPopulation
	from population
	group by Continent
)p2 on p1.Continent = p2.continent
where p2.AvgPopulation < p1."2022 population"


--Countries that had a larger population in 1970 than another country's population in 2022:

select
    A.[Country Territory] AS Country1970, A.[1970 Population],
    B.[Country Territory] AS Country2022, B.[2022 Population]
from population A
inner join population B
on A.[1970 Population] > B.[2022 Population];