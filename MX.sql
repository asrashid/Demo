SELECT * FROM [dbo].[2014_2015_BR_all-groups] ORDER BY acct_key

DELETE FROM [dbo].[2014_2015_BR_all-groups] WHERE cntry_cd<>'BR'

SELECT 
	acct_key
	,sum(grs_sls_amt) as total_sales
	,sum(grs_sls_amt)/count(cmpgn_nr) as average_sales
	,max(ordnry_loa_nr) as max_loa  
INTO  #temp1 
FROM [dbo].[2014_2015_BR_all-groups] 
Group by acct_key 
ORDER BY acct_key

SELECT 
	A.*
	,B.total_sales
	,B.average_sales
	,B.max_loa 
INTO  #temp2 
FROM [dbo].[2014_2015_BR_all-groups] A 
JOIN  #temp1 B 
ON A.acct_key=B.acct_key 
ORDER BY A.acct_key


SELECT 
	A.cntry_cd	
	,A.acct_key	
	,A.fld_sls_cmpgn_perd_id	
	,A.cmpgn_yr_nr	
	,A.cmpgn_nr	
	,A.qtr_yr_nr	
	,A.qtr_nr	
	,A.ordnry_loa_nr	
	,A.grs_sls_amt	
		,  CASE WHEN ( max_loa<=6) THEN 1 
			   WHEN (average_sales<=32 and max_loa>6) THEN 2  
			   WHEN (average_sales>32 and max_loa BETWEEN 7 and 19 ) THEN 3
		       WHEN (average_sales BETWEEN 32.001 and 106.99 and max_loa>19) THEN 4
		       WHEN (average_sales BETWEEN 107 AND 159.99 and max_loa>6) THEN 5
		       WHEN (average_sales>=160 and max_loa>6) THEN 6
		   END as segment
INTO [2014_2015_BR_all-groups_new]
FROM #temp2 A
ORDER BY acct_key 

SELECT  acct_key, count(distinct(segment)) as A FROM [2014_2015_BR_all-groups_new] group by acct_key HAVING count(distinct(segment))>1 ORDER BY A

SELECT *  FROM [2014_2015_BR_all-groups_new] where segment is null order by acct_key

SELECT acct_key,sum(grs_sls_amt) a  into #ab FROM  [2014_2015_BR_all-groups_new] group by acct_key

SELECT SUM(a) FROM #ab    5212469429
SELECT count(distinct(acct_key)) from  [2014_2015_BR_all-groups_new]



