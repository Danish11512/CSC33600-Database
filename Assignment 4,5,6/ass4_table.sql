
-- Danish Faruqi		Assingment 4



begin;

drop table if exists fundamentals cascade;

drop table if exists securities cascade;

drop table if exists prices cascade;

create table securities(

	symbol character(6),
	company text, 
	sector text, 
	sub_industry text, 
	initial_trade_date date
	);

create table fundamentals(
	id integer,
	symbol character(6), 
	year_ending date, 
	cash_and_cash_equivalents bigint,
	earnings_before_interest_and_taxes bigint,
	gross_margin smallint, 
	net_income bigint, 
	total_asset bigint, 
	total_liabilities bigint,
	total_revenue bigint, 
	year smallint, 
	earnings_per_share float, 
	shares_outstanding float
	-- foreign key (symbol) references securities(symbol) on update cascade on delete cascade
	);

create table prices(
	date date,
	symbol character(6),
	open float, 
	close float, 
	low float, 
	high float, 
	volume int
	-- foreign key (symbol) references securities(symbol) on update cascade on delete cascade
	);

copy securities from '/Users/dfaruqi/Desktop/dbdata/assn_456_data/securities.csv' with delimiter ',' csv header;
copy fundamentals from '/Users/dfaruqi/Desktop/dbdata/assn_456_data/fundamentals.csv' with delimiter ',' csv header;
copy prices from '/Users/dfaruqi/Desktop/dbdata/assn_456_data/prices.csv' with delimiter ',' csv header;

commit;