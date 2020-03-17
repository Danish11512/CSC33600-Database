
-- Danish Faruqi		Assingment 4

-- Query starts from here 
begin;

\echo '\nAnnual Returns per Company\n'
\echo '------------------------------'


-- Calculate all annual returns for each symbol for each year and sort them by performance.
-- (not daily - just yearly is good enough).Annual Return Formula:  (good for one year only - multi-year is different).   
-- R =  (end_price / start_price) - 1          
-- (%)Example:  Start at $100, end at $115:R =  ($115 / $100) - 1  =  (1.15) - 1  =  0.15  =  15%

-- one table whic has window function that sections every symbol as it;s own section, 
-- create another table that choses the highest and the lower from both and orders it


with groupbysymbol as (
select *, 
	row_number() over( partition by symbol, extract(year from date) order by date)
from prices
),

 groupbydate as (
select *,
	first_value(close) over( partition by symbol, extract(year from date) order by date desc) as end_price,
	first_value(open) over( partition by symbol, extract(year from date) order by date) as start_price 
from groupbysymbol
),

annual_return as (select extract(year from date) as year, symbol, cast((((end_price/start_price)-1)*100) as float) as annual_return
from groupbydate
group by year, symbol, annual_return
order by symbol, year desc)

select*
from annual_return;

\echo '\nCompany Portfolio\n'
\echo '------------------------------'

-- Select a group of 30-60 or so companies with very good annual returns.  You may want the top group, or you may want to eliminate
--  a few from the very top - if you are suspicious that they might be anomalies, and that the company cannot consistently repeat 
--  these very high returns.Save these high-performing companies into a table for use in HW5.Hint: 
--   CREATE TABLE awesome_performers AS   SELECT ...  FROM ...  WHERE ...  ;
--   Hint II:  You may want to use OFFSET if you don't want to take the top 30.  
--    I.e., to eliminate the top 3 and take numbers 4 through 34:SELECT   ...     LIMIT 30 OFFSET 3;


with groupbysymbol as (
select *, 
	row_number() over( partition by symbol, extract(year from date) order by date)
from prices
),

 groupbydate as (
select *,
	first_value(close) over( partition by symbol, extract(year from date) order by date desc) as end_price,
	first_value(open) over( partition by symbol, extract(year from date) order by date) as start_price 
from groupbysymbol
),

annual_return as (select extract(year from date) as year, symbol, cast((((end_price/start_price)-1)*100) as float) as annual_return
from groupbydate
group by year, symbol, annual_return
order by symbol, year desc)

select distinct annual_return.symbol, securities.company, securities.sector, 
sum(annual_return.annual_return) over(partition by annual_return.symbol) as net_annual_return_percent
from annual_return
	inner join securities on annual_return.symbol = securities.symbol
order by net_annual_return_percent desc limit 60;


commit;