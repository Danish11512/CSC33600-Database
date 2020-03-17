-- By Danish Faruqi

-------------------------HW6------------------------

-- 1 --

-- pg_dump -U dfaruqi -d ass456 > backup.sql

-- 2 --

create view portfolio as 
securities.company, securities.sector, securities.sub_industry, securities.initial_trade_date,
prices.*, extract(year from date) as year, fundamentals.cash_and_cash_equivalents, 
fundamentals.earnings_before_interest_and_taxes, fundamentals.gross_margin, 
fundamentals.net_income, fundamentals.total_asset, fundamentals.total_liabilities, fundamentals.total_revenue, 
fundamentals.year, fundamentals.earnings_per_share, fundamentals.shares_outstanding
from prices
	inner join fundamentals.symbol = prices.symbol and fundamentals.year = extract(year from prices.date)
	inner join securities.symbol = prices.symbol
where (prices.symbol = 'ALXN ' or prices.symbol = 'DLTR' or prices.symbol = 'UAL' or prices.symbol = 'XRX'
 	or prices.symbol = 'NWSA' or prices.symbol = 'CF' or prices.symbol = 'AAL' or prices.symbol = 'CTSH'
 	or prices.symbol = 'EQR' or prices.symbol = 'EW') and extract(year from date) > 2016
order by price.date desc, price.symbol;

select * from portfolio;

-- 3 --

-- psql -U dfaruqi -tAF, -f ass6.sql > comp_portfolio.csv

-- 4 --

-- Source: Nasdaq
	
--  symbol |            company             |        2017         |       2016        |   Percent Return    | 
-- --------+--------------------------------+---------------------+-------------------+---------------------+
--  ALXN   | Alexion Pharmaceuticals        |		 119.59	 	   |	 122.35		   |		-2.26% 
--  DLTR   | Dollar Tree                    |		 107.31		   |	  77.18		   |		39.03%
--  UAL    | United Continental Holdings    |		   67.4		   |	  72.88		   |	   -11.64%
--  XRX    | Xerox Corp.                    |		  29.15		   |	  26.12		   |	 	11.60%					
--  NWSA   | News Corp. Class A             |		  16.21		   |	  11.46		   |		41.44% 
--  CF     | CF Industries Holdings Inc     |		  42.54		   |	  31.48		   |	 	35.13%
--  AAL    | American Airlines Group        |		  52.03		   |	  46.69		   |	 	11.44%
--  CTSH   | Cognizant Technology Solutions |		  71.02		   |	  56.03		   |	 	26.75%
--  EQR    | Equity Residential             |		  63.77		   |	  64.36		   |	   -00.91%
--  EW     | Edwards Lifesciences 			 |		 112.71		   |	   93.7		   |	 	20.29%

--  																			Sum	   | 		170.87%