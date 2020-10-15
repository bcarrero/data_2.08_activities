/*2.08 Activity 1
In this activity, we will be using the table district from the bank database and according to the description for the different columns:
    A4: no. of inhabitants
    A9: no. of cities
    A10: the ratio of urban inhabitants
    A11: average salary
    A12: the unemployment rate

*/
  --  Rank districts by different variables.
  select * from district;
  -- # of inhabitants
  select A2,A4,A9, A10,A11,A12, rank() over (order by A4 desc) as 'Rank'
from district;
-- A9: no. of cities
select A3,A9,rank() over (order by A9 desc) as 'Rank'
from district;
-- A10: the ratio of urban inhabitants
select A3,A9,rank() over (order by A9 desc) as 'Rank'
from district;

select A3,A9,rank() over (order by A9 desc) as 'Rank'
from district;

select A2,A3,A9,dense_rank() over (order by A9 desc) as 'Dense Rank'
from district;

  
2  --  Do the same but group by region.
select A3,A4,rank() over (partition by A4) as 'Rank'
from district
group by A3;

select A3,A4,rank() over (partition by A4) as 'Dense Rank'
from district
group by A3;
---------------------------------------------------
-- 2.08 Activity 2
--    Use the transactions table in the bank database to find the Top 20 account_ids based on the balances.
select account_id, balance, rank() over (order by balance DESC) as 'Rank_1', dense_rank() over (order by balance DESC) as 'Dense Rank_1'
from trans
LIMIT 20;

select * 
from (select account_id, balance, rank() over (partition by account_id order by account_id) AS Rank_1 from bank.trans) as limit_1
where limit_1.Rank_1 >=1;

select *, rank() over (partition by account_id) AS 'Rank' from bank.trans;

select *, dense_rank() over (partition by account_id) as 'Dense rank'
from trans
ORDER BY account_id
LIMIT 20;

--    Illustrate the difference between Rank() and Dense_Rank().

-- 2.08 Activity 3
-- Keep using the bank database.
-- 1    Get a rank of districts ordered by the number of customers.
select d.A2, count(c.client_id) AS customers from district as d
INNER join client as c ON d.A1 = c.district_id
group by d.A2
ORDER by customers DESC;

select d.A2, count(c.client_id) from district as d
INNER join client as c ON d.A1 = c.district_id
group by d.A2
ORDER BY count(c.client_id) DESC;
-- 2    Get a rank of regions ordered by the number of customers.
select d.A3, count(c.client_id) AS 'customer_count' from district as d
INNER join client as c ON d.A1 = c.district_id
group by d.A3
order by count(c.client_id) DESC;

select d.A2, count(c.client_id) AS 'customer_count', rank() over(order by count(client_id) desc) as ranking 
from district as d
INNER join client as c ON d.A1 = c.district_id
group by d.A2
order by count(c.client_id) DESC;

-- 3    Get the total amount borrowed by the district together with the average loan in that district.
select * from loan;
select a.district_id, sum(l.amount) AS 'loan_amount', round(avg((l.amount)),0) AS 'average_loan' from account as a
INNER join loan as l ON a.account_id = l.account_id 
group by a.district_id
ORDER by loan_amount DESC;
-- 4    Get the number of accounts opened by district and year.
select district_id, year(date) as year, count(account_id) as accounts_openned from account
group by district_id, year
ORDER BY accounts_openned DESC;
