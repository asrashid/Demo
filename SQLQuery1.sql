
--drop table temp2014
--drop table  temp2015
SELECT 
[acct_key],
[cmpgn_yr_nr],
sum (cast([grs_sls_amt] as decimal)) as sumofyear
Into Temp2015
FROM [Royal].[dbo].[RU_all-groups] a
where cmpgn_yr_nr='2015'
GROUP BY [acct_key],
[cmpgn_yr_nr]



--SELECT 
--	a.*,
--	b.sumperyear
--INTO temp2
--from [dbo].[UK_all-groups] a JOIN
--TEMP1 b ON
--a.acct_key=b.acct_key and
--a.cmpgn_yr_nr=b.cmpgn_yr_nr
--order by a.acct_key,a.cmpgn_yr_nr


--SELECT * FROM TEMP2 a order by a.acct_key,a.qtr_yr_nr

--SELECT acct_key,cmpgn_yr_nr

Select c.*
,(b.sumofyear-a.sumofyear)/a.sumofyear as yoy
into [RU_all-groups_new]
from [Royal].[dbo].[RU_all-groups] c left Join
Temp2014 a on
c.acct_key=a.acct_key left Join
Temp2015 b on 
a.acct_key=b.acct_key and
a.sumofyear>0 and b.sumofyear is not Null
order by a.acct_key,a.cmpgn_yr_nr

Select * from [RU_all-groups_new] a where yoy=-1 
order by acct_key,cmpgn_yr_nr


