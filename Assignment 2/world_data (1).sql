--  Danish Faruqi 

-- this is in 2NF, one critieeria is to be in 1NF which it 
-- already is; it has atomic and homogeneus data. 
-- to turn it into 3NF make another table that holds continent and 
-- region with a foriegn key (continent)








-- 1. What are the top ten countries by economic activity (Gross National Product - ‘gnp’).



\echo '\n Question 1 \n'
select name, gnp
from country
order by gnp desc limit 10;



-- 2. What are the top ten countries by GNP per capita?
-- (watch out for division by zero here !)



\echo '\n Question 2 \n'
select name, gnp, population, (gnp/population) as gnp_per_capita
from country
where population <> 0
order by gnp_per_capita desc limit 10;



-- 3. What are the ten most densely populated countries, and ten least
-- densely populated countries?



\echo '\n Question 3 \n'
select name as most_densely_populated, population, surfacearea, (population/surfacearea) as population_density
from country
where surfacearea > 0 and population > 0
order by population_density desc limit 10;
select name as least_densely_populated, population, surfacearea, (population/surfacearea) as population_density
from country
where surfacearea > 0 and population > 0
order by population_density limit 10;



-- 4. What different forms of; government are represented in this data?
-- (‘DISTINCT’ keyword should help here.)
-- Which forms of government are most frequent?
-- (distinct, count, group by order by)
-- make anotther table to just get those numbers



\echo '\n Question 4 \n'
select governmentform, count(governmentform)
from country
group by governmentform
order by count(governmentform) desc;


select governmentform, count(governmentform)
from country
group by governmentform
having count(governmentform) > 4
order by count(governmentform) desc ;



-- 5. Which countries have the highest life expectancy? (watch for NULLs).



\echo '\n Question 5 \n'
select name as country_name, lifeexpectancy
from country
where lifeexpectancy is not null and lifeexpectancy > 80
order by lifeexpectancy desc;



-- Getting more serious – joins, joins with conditions, joins that require subqueries:
-- 6. What are the top ten countries by total population, and what is the official language
-- spoken there? (basic inner join)



\echo '\n Question 6 \n'
select country.name as country, country.population, countrylanguage.language as official_language
from country
inner join countrylanguage on country.code = countrylanguage.countrycode
where countrylanguage.isofficial = 't'
group by country.code, country.name, countrylanguage.language
order by country.population desc limit 10;



-- 7. What are the top ten most populated cities – along with which country they are in,
-- and what continent they are on? (basic inner join)



\echo '\n Question 7 \n'
select city.name as city_name, country.name as country, city.population, country.continent
from city
inner join country on country.code = city.countrycode
group by city.name, country.name, city.population, country.continent
order by city.population desc limit 10;



-- 8. What is the official language of the top ten cities you found in Question #7?
-- (three-way inner join).


\echo '\n Question 8 \n'
select city.name as city_name, countrylanguage.language as offical_language
from city
inner join country on country.code = city.countrycode
inner join countrylanguage on city.countrycode = countrylanguage.countrycode
where countrylanguage.isofficial = 't'
group by city.name, countrylanguage.language, city.population
order by city.population desc limit 10;



-- 9. Which of the cities from Question #7 are capitals of their country?
-- (requires a join and a subquery).
-- run quesry 7 as subquery then copare if capital


\echo '\n Question 9 \n'

with temp as (

select city.id as city_id, city.name as city_name, country.name as country, city.population, country.continent
from city
inner join country on country.code = city.countrycode
group by city.name, country.name, city.population, country.continent, city.id
order by city.population desc limit 10
)

select city_name, country.name as country

from temp
inner join country on country.capital = city_id
group by city_name, country.name;



-- 10. For the cities found in Question#9, what percentage of the country’s population
-- lives in the capital city? (watch your int’s vs floats !).

-- with capitals as (with temp as (

-- select city.id as city_id, city.name as city_name, country.name as country, city.population as city_pop, country.continent,
-- country.population
-- from city
-- inner join country on country.code = city.countrycode
-- group by city.name, country.name, city_pop, country.continent, city.id, country.population
-- order by city.population desc limit 10
-- )

-- select city_name, country

-- from temp
-- inner join country on country.capital = city_id
-- group by city_name, country)

-- select city_name, country, city_pop, country.population as country_population,
-- city.population/country.population
-- from capitals;

\echo '\n Question 10 \n'


with capitals as (with temp as (

select city.id as city_id, city.name as city_name, country.name as country, city.population, country.continent
from city
inner join country on country.code = city.countrycode
group by city.name, country.name, city.population, country.continent, city.id
order by city.population desc limit 10
)

select city_name, country.name as country, country.population as country_pop

from temp
inner join country on country.capital = city_id
group by city_name, country.name, country_pop)



select city_name, country, city.population, country_pop, ((city.population :: float) /country_pop)*100 as city_pop_percetage

from capitals
inner join city on city.name = city_name
group by city_name, country, country_pop, city.population, city.population/country_pop










