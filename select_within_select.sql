-- Author: Xi Zhang (xizhang1@cs.stonybrook.edu)
-- SQLZOO: SELECT within SELECT Tutorial
-- url: https://sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial

-- 1.
-- List each country name where the population is larger than that of 'Russia'.
-- world(name, continent, area, population, gdp)

SELECT name FROM world
	WHERE population >
	(SELECT population FROM world
		WHERE name='Russia')


-- 2.
-- Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.

select name from world
	where continent = 'Europe' and gdp/population >
	(select gdp/population from world 
		where name = 'United Kingdom')


-- 3.
-- List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.

select name, continent from world
	where continent in 
	(select continent from world 
		where name in ('Argentina', 'Australia') )
	order by name


-- 4.
-- Which country has a population that is more than Canada but less than Poland? Show the name and the population.

select name, population from world
	where population > (select population from world 
		where name = 'Canada')
	and population < (select population from world 
		where name = 'Poland')


-- 5.
-- Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.
-- Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.

select name, CONCAT( cast(round(population/(select population from world 
		where name = 'Germany')*100, 0) as char), '%' )
	from world 
	where continent = 'Europe'


-- 6.
-- Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)

select name from world
	where gdp > all(select gdp from world 
		where continent = 'Europe' and gdp > 0)


-- 7.
-- Find the largest country (by area) in each continent, show the continent, the name and the area:

SELECT continent, name, area FROM world x
	WHERE area >= ALL(
		SELECT area FROM world y
			WHERE y.continent=x.continent
			AND area>0)


-- 8.
-- List each continent and the name of the country that comes first alphabetically.

select continent, name from world a
	where name <= all( 
		select name from world b
			where a.continent = b.continent)


-- 9.
-- Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.

select name, continent, population from world a
	where 25000000 >= all (
		select population from world b
			where a.continent = b.continent
			and b.population > 0)


-- 10.
-- Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.

select name, continent from world a
	where population > all (
		select population*3 from world b
			where a.continent = b.continent
			and a.name != b.name )

