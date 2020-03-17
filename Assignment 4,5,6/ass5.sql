-- By Danish Faruqi


begin;

-------------------------The tables from HW4------------------------

-- with one as (
-- select *, 
-- 	row_number() over( partition by symbol, extract(year from date) order by date)
-- from prices
	
-- ),

--  two as (
-- select *,
-- 	first_value(close) over( partition by symbol, extract(year from date) order by date desc) as end_price,
-- 	first_value(open) over( partition by symbol, extract(year from date) order by date) as start_price 
-- from one
-- ),

-- three as (select extract(year from date) as year, symbol, cast((((end_price/start_price)-1)*100) as float) as annual_returns
-- from two
-- group by year, symbol, annual_returns
-- order by symbol, year desc),

-- four as (select *,  
-- 	first_value(annual_returns) over( partition by symbol) as starting_annual_return,
-- 	last_value(annual_returns) over( partition by symbol) as ending_annual_return
-- from three),

-- five as (
-- select four.symbol, securities.company as company, ((ending_annual_return - starting_annual_return) / (count(year) -1)) as annual_returns_slope
-- from four
-- 	inner join securities on securities.symbol = four.symbol
-- group by four.symbol, ending_annual_return, starting_annual_return, securities.company
-- having count(year) > 1
-- order by annual_returns_slope desc limit 60)


-------------------------HW5------------------------

-- 1 -- 

\echo '--------------------------------------------------------------'


with one as (select *, 
	row_number() over( partition by symbol, extract(year from date) order by date)
from prices),

 two as (select *,
	first_value(close) over( partition by symbol, extract(year from date) order by date desc) as end_price,
	first_value(open) over( partition by symbol, extract(year from date) order by date) as start_price 
from one),

three as (select extract(year from date) as year, symbol, cast((((end_price/start_price)-1)*100) as float) as annual_returns
from two
group by year, symbol, annual_returns
order by symbol, year desc),

four as (select *,  
	first_value(annual_returns) over( partition by symbol) as starting_annual_return,
	last_value(annual_returns) over( partition by symbol) as ending_annual_return
from three),

five as (
select four.symbol, securities.company as company, ((ending_annual_return - starting_annual_return) / (count(year) -1)) as annual_returns_slope
from four
	inner join securities on securities.symbol = four.symbol
group by four.symbol, ending_annual_return, starting_annual_return, securities.company
having count(year) > 1
order by annual_returns_slope desc limit 60 offset 3),


template as (select three.*, fundamentals.total_asset as total_yr_asset, fundamentals.total_liabilities as total_yr_liabilities,
						 (fundamentals.total_asset - fundamentals.total_liabilities ) as net_yr_worth,
						 fundamentals.net_income as net_income, fundamentals.total_revenue as total_revenue,
						 fundamentals.earnings_per_share as earnings_per_share, 
						 fundamentals.cash_and_cash_equivalents as cash_and_cash_equivalents, 
						 five.annual_returns_slope as annual_returns_slope,
						 two.end_price as closing 

from three
	inner join fundamentals on fundamentals.symbol = three.symbol and fundamentals.year = three.year
	inner join five on fundamentals.symbol = five.symbol
	inner join two on fundamentals.symbol = two.symbol
	-- inner join prices on prices.symbol = three.symbol
order by three.symbol, year),


-- Queries --


\echo '\n Net Worth Per Year Summation \n'


-- net_worth_temp as (
-- select year, symbol, net_yr_worth, annual_returns_slope, 
-- lag(net_yr_worth) over(partition by symbol order by year ) as lag_net_worth
-- from template)

-- select year, symbol, 
-- ((sum(net_yr_worth)::float - sum(lag_net_worth)::float)/sum(lag_net_worth)::float) * 100 as net_worth_growth, annual_returns_slope
-- from net_worth_temp
-- group by year, symbol, annual_returns_slope
-- order by annual_returns_slope desc, year desc, net_worth_growth desc nulls last;


\echo '\n Income Growth Per Year Summation   \n'


-- income_growth_temp as (
-- select year,symbol, net_income, annual_returns_slope, 
-- lag(net_yr_worth) over ( partition by symbol order by year ) as lag_income_growth 
-- from template)

-- select year, symbol,
-- ((sum(net_income)::float - sum(lag_income_growth))/sum(lag_income_growth)) *100 as net_income_growth, annual_returns_slope
--  from income_growth_temp
--  group by year, symbol, annual_returns_slope
--  order by annual_returns_slope desc, year desc, net_income_growth desc nulls last;
 

\echo '\n Revenue Growth Per Year Summation   \n'


-- revenue_growth_temp as(
-- select year, symbol, total_revenue, annual_returns_slope, 
-- lag(total_revenue) over ( partition by symbol order by year ) as lag_total_revenue 
-- from template)

-- select year, symbol, 
-- ((sum(total_revenue)::float - sum(lag_total_revenue))/sum(lag_total_revenue)) *100 as net_revenue_growth, annual_returns_slope
-- from revenue_growth_temp
--  group by year, symbol, annual_returns_slope
--  order by annual_returns_slope desc, year desc, net_revenue_growth desc nulls last;


\echo '\n EPS Growth Summation \n'


-- eps_growth_temp as(
-- select year, symbol, earnings_per_share, annual_returns_slope, 
-- lag(earnings_per_share) over ( partition by symbol order by year ) as lag_eps 
-- from template)

-- select year, symbol, 
-- ((sum(earnings_per_share)::float - sum(lag_eps))/sum(lag_eps)) *100 as eps_growth, annual_returns_slope
--  from eps_growth_temp
--  group by year, symbol, annual_returns_slope
--  order by annual_returns_slope desc, eps_growth desc nulls last, year desc;


\echo '\n Price to Earnings Ratio (progression each year) \n'


-- ratio as (select year, symbol, (sum(closing)/sum(earnings_per_share)) as Price_to_earnings_ratio, annual_returns_slope
-- from template
-- group by year, symbol, annual_returns_slope, closing, earnings_per_share
-- order by annual_returns_slope desc,  year desc, Price_to_earnings_ratio desc nulls last)

-- select * from ratio;


\echo '\n Liquid Cash vs. Total Liabilities (progression over the year) \n'


-- liquid as(select year, symbol, cash_and_cash_equivalents::float/total_yr_liabilities as cash_vs_liabilties, annual_returns_slope 
-- from template
-- group by year, symbol, cash_vs_liabilties, annual_returns_slope
-- order by annual_returns_slope desc, year desc, cash_vs_liabilties desc nulls last)

-- select * from liquid;


\echo '\n Factors - \n  Decreasing net worth growth \n  Decreasing net revenue growth'
\echo '  Increasing EPS growth \n  Increasing Price to Earnings Ratio per Year'
\echo '\n Choosing Price to Earnings Ratio\n\n'


-- 2 --


\echo '\n Potential Candidates for Investment\n'

-- sper_temp as (
-- select year, symbol, (sum(closing)/sum(earnings_per_share)) as price_to_earnings_ratio, annual_returns_slope, 
-- first_value((sum(closing)/sum(earnings_per_share))) over ( partition by symbol order by year desc ) as last,
-- first_value((sum(closing)/sum(earnings_per_share))) over ( partition by symbol order by year ) as first
-- from template
-- group by year, symbol, annual_returns_slope
-- having count(year) > 1), 

-- sper2_temp as (select year, symbol, price_to_earnings_ratio, annual_returns_slope, (last - first)/count(year) as price_to_earnings_slope,
-- row_number() over ( partition by symbol order by year desc ) as row_number
-- from sper_temp
-- group by year, symbol, price_to_earnings_ratio, annual_returns_slope, last, first
-- order by price_to_earnings_slope desc nulls last, year desc),

-- selection as (select symbol, price_to_earnings_slope 
-- from sper2_temp
-- group by symbol, price_to_earnings_slope
-- order by price_to_earnings_slope desc nulls last limit 30 )

-- select * from selection;

-- 3 --

\echo '\n Top 10 Candidates for Investment\n'

-- sper_temp as (
-- select year, symbol, (sum(closing)/sum(earnings_per_share)) as price_to_earnings_ratio, annual_returns_slope, 
-- first_value((sum(closing)/sum(earnings_per_share))) over ( partition by symbol order by year desc ) as last,
-- first_value((sum(closing)/sum(earnings_per_share))) over ( partition by symbol order by year ) as first
-- from template
-- group by year, symbol, annual_returns_slope
-- having count(year) > 1), 

-- sper2_temp as (select year, symbol, price_to_earnings_ratio, annual_returns_slope, (last - first)/count(year) as price_to_earnings_slope,
-- row_number() over ( partition by symbol order by year desc ) as row_number
-- from sper_temp
-- group by year, symbol, price_to_earnings_ratio, annual_returns_slope, last, first
-- order by price_to_earnings_slope desc nulls last, year desc),

-- selection as (select symbol, price_to_earnings_slope 
-- from sper2_temp
-- group by symbol, price_to_earnings_slope
-- order by price_to_earnings_slope desc nulls last limit 30 )

-- select selection.symbol, securities.company, securities.sector
-- from selection
-- 	inner join securities on securities.symbol = selection.symbol
-- where selection.symbol <> 'RL' and  selection.symbol <> 'NLSN' and selection.symbol <> 'TSCO'
-- order by selection.price_to_earnings_slope desc limit 10;

\echo'\n Final seletion was made by considering sector diversification'


-- My top 10 selection
--  symbol |            company             |         sector         
-- --------+--------------------------------+------------------------
--  ALXN   | Alexion Pharmaceuticals        | Health Care
--  DLTR   | Dollar Tree                    | Consumer Discretionary
--  UAL    | United Continental Holdings    | Industrials
--  XRX    | Xerox Corp.                    | Information Technology
--  NWSA   | News Corp. Class A             | Consumer Discretionary
--  CF     | CF Industries Holdings Inc     | Materials
--  AAL    | American Airlines Group        | Industrials
--  CTSH   | Cognizant Technology Solutions | Information Technology
--  EQR    | Equity Residential             | Real Estate
--  EW     | Edwards Lifesciences           | Health Care


 

-- By looking at the annual returns slope which gave me a trend line showing how likely a company was growing. I used characteristics that those company
-- shared such as their price to earings ratio and finding companies to invest in which shared the same attributes. I also found that these companies
-- also had high annual returns slopes which showed that they are likely to grow overall and return a higher investment.




















commit;

