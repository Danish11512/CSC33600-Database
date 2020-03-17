-- Assingment 3 - Danish Faruqi

pset footer off 

----------------------------------------------------------------

\echo 'Question 1'

select buyers.referrer, count(buyers.referrer)

from buyers
	inner join transactions on transactions.cust_id = buyers.cust_id
group by buyers.referrer
order by count(buyers.referrer) desc;

----------------------------------------------------------------

\echo 'Question 2'

select buyers.fname, buyers.lname, buyers.cust_id
from buyers
	left join transactions on transactions.cust_id = buyers.cust_id
	 where transactions.cust_id is null
group by buyers.cust_id
order by buyers.cust_id;

----------------------------------------------------------------

\echo 'Question 3'

select boats.brand, boats.category, boats.prod_id
from boats
	left join transactions on transactions.prod_id = boats.prod_id
	where transactions.cust_id is null
group by boats.prod_id
order by boats.prod_id;

----------------------------------------------------------------

\echo 'Question 4'

select buyers.fname, buyers.lname, boats.brand, boats.category, transactions.trans_id,
		buyers.cust_id
from buyers
	inner join transactions on transactions.cust_id = buyers.cust_id
	inner join boats on transactions.prod_id = boats.prod_id
	where buyers.fname = 'Alan' and buyers.lname = 'Weston';

----------------------------------------------------------------

\echo 'Question 5'

select buyers.fname, buyers.lname, buyers.cust_id, count(buyers.cust_id)
from buyers
	inner join transactions on transactions.cust_id = buyers.cust_id
group by buyers.fname, buyers.lname, buyers.cust_id
having count(buyers.cust_id) > 1
order by count(buyers.cust_id);

----------------------------------------------------------------

\echo 'By Danish Faruqi'

