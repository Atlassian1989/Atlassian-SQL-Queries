select AL.airline
,bt.batch
,tl.Titles
,F.*
from (
select 
 t1.rn
,t1.issuekey
,t1.summary
,t1.issue
,T1.OLDSTRING
,T1.NEWSTRING
,t1.Transition
,isnull(t2.transitiontime,t1.CREATED) Start_Date_Time
,t1.transitiontime End_Date_Time
,datediff(day,isnull(t2.transitiontime,t1.CREATED),t1.transitiontime) Duration
from (
	select row_number() over (partition by issue order by transitiontime desc) RN
	--,row_number() over (partition by issue order by transitiontime asc) RN_ASC
	,issuekey
	,summary
	,issue
	,OLDSTRING
	,NEWSTRING
	,Transition
	,CREATED
	,transitiontime
	from (
	SELECT 
	 (CAST(p.pkey as varchar) + CAST(' - ' as varchar) + CAST(ji.issuenum as varchar)) as issuekey
	,ji.summary
	,ji.id ISSUE
	--,ji.issuenum
	--,ci.FIELD
	--,ci.OLDSTRING,ci.NEWSTRING
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' 
		ELSE 'Removed Status' 
	 END OLDSTRING
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar) 
		ELSE 'Removed Status' 
	 END NEWSTRING
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) + ' - ' + 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' + ' - ' + CAST(newstring as varchar) 
		ELSE 'Removed Status' + ' - ' + 'Removed Status' 
	 END Transition
	,min(ji.CREATED) CREATED
	,min(cg.CREATED) as transitiontime
	--,cg.AUTHOR
	--, DATEDIFF(DAY,ji.CREATED,cg.CREATED)  as resolutiontime
	FROM [JIRAPRD7010].[dbo].changeitem ci
	JOIN [JIRAPRD7010].[dbo].changegroup cg ON cg.ID = ci.groupid
	JOIN [JIRAPRD7010].[dbo].jiraissue ji ON ji.ID = cg.issueid
	JOIN [JIRAPRD7010].[dbo].issuestatus iss ON iss.ID = ji.issuestatus
	JOIN [JIRAPRD7010].[dbo].project p ON p.ID = ji.PROJECT
	--JOIN [JIRAPRD7010].[dbo].project_key pk ON pk.PROJECT_ID = P.ID
	WHERE p.pname = 'GVCO' AND ci.FIELD = 'status' 
	--and ji.issuestatus IN (11561,11559, 11558, 11562, 10019)
	and ji.id in (select source from [JIRAPRD7010].[dbo].[issuelink] )
	--AND ji.issuestatus = 10019 /*done*/ --AND ji.issuetype = 11402 /*content batch*/ 
	--AND NEWSTRING LIKE 'Done' /*new change item */
	--and ji.id = '124104'
	--and ji.summary like '%GOL%1%'
	group by (CAST(p.pkey as varchar) + CAST(' - ' as varchar) + CAST(ji.issuenum as varchar)) 
	,ji.summary
	--,ji.issuenum
	,ji.id 
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) + ' - ' + 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' + ' - ' + CAST(newstring as varchar) 
		ELSE 'Removed Status' + ' - ' + 'Removed Status' 
	 END 
	 	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' 
		ELSE 'Removed Status' 
	 END 
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar) 
		ELSE 'Removed Status' 
	 END 
	--ORDER BY 1 DESC, 6 desc
	) t
) t1
left join (
	select row_number() over (partition by issue order by transitiontime desc) RN
	--,row_number() over (partition by issue order by transitiontime asc) RN_ASC
	,issuekey
	,summary
	,issue
	,OLDSTRING
	,NEWSTRING
	,Transition
	,CREATED
	,transitiontime
	from (
	SELECT 
	 (CAST(p.pkey as varchar) + CAST(' - ' as varchar) + CAST(ji.issuenum as varchar)) as issuekey
	,ji.summary
	,ji.id ISSUE
	--,ji.issuenum
	--,ci.FIELD
	--,ci.OLDSTRING,ci.NEWSTRING
		,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' 
		ELSE 'Removed Status' 
	 END OLDSTRING
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar) 
		ELSE 'Removed Status' 
	 END NEWSTRING
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) + ' - ' + 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' + ' - ' + CAST(newstring as varchar) 
		ELSE 'Removed Status' + ' - ' + 'Removed Status' 
	 END Transition
	,min(ji.CREATED) CREATED
	,min(cg.CREATED) as transitiontime
	--,cg.AUTHOR
	--, DATEDIFF(DAY,ji.CREATED,cg.CREATED)  as resolutiontime
	FROM [JIRAPRD7010].[dbo].changeitem ci
	JOIN [JIRAPRD7010].[dbo].changegroup cg ON cg.ID = ci.groupid
	JOIN [JIRAPRD7010].[dbo].jiraissue ji ON ji.ID = cg.issueid
	JOIN [JIRAPRD7010].[dbo].issuestatus iss ON iss.ID = ji.issuestatus
	JOIN [JIRAPRD7010].[dbo].project p ON p.ID = ji.PROJECT
	--JOIN [JIRAPRD7010].[dbo].project_key pk ON pk.PROJECT_ID = P.ID
	WHERE p.pname = 'GVCO' AND ci.FIELD = 'status' 
	and ji.id in (select source from [JIRAPRD7010].[dbo].[issuelink] )
	--and ji.issuestatus IN (11561,11559, 11558, 11562, 10019)
	--AND ji.issuestatus = 10019 /*done*/ --AND ji.issuetype = 11402 /*content batch*/ 
	--AND NEWSTRING LIKE 'Done' /*new change item */
	--and ji.id = '124104'
	--and ji.summary like '%GOL%1%'
	group by (CAST(p.pkey as varchar) + CAST(' - ' as varchar) + CAST(ji.issuenum as varchar)) 
	,ji.summary
	--,ji.issuenum
	,ji.id 
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' 
		ELSE 'Removed Status' 
	 END
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar) 
		ELSE 'Removed Status' 
	 END 
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) + ' - ' + 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' + ' - ' + CAST(newstring as varchar) 
		ELSE 'Removed Status' + ' - ' + 'Removed Status' 
	 END 
	 ) t
	--ORDER BY 1 DESC, 6 desc
	) t2 on t1.issue = t2.issue and t1.rn+1 = t2.rn

union 

select T.rn, T.issuekey
,T.summary
,T.issue
,T.NEWSTRING OLDSTRING
,CASE 
	WHEN T.NEWSTRING = 'Media & Metadata Processing' THEN 'Dev & SIT Testing'
	WHEN T.NEWSTRING = 'Dev & SIT Testing' THEN 'USB Replication'
	WHEN T.NEWSTRING = 'USB Replication' THEN 'Field Installation'
	ELSE 'Done'
 END NEWSTRING
,T.NEWSTRING + ' - ' + CASE 
	WHEN T.NEWSTRING = 'Media & Metadata Processing' THEN 'Dev & SIT Testing'
	WHEN T.NEWSTRING = 'Dev & SIT Testing' THEN 'USB Replication'
	WHEN T.NEWSTRING = 'USB Replication' THEN 'Field Installation'
	ELSE 'Done'
 END Transition
, T.transitiontime Start_Date_Time
,NULL End_Date_Time
,datediff(day,T.transitiontime, GETDATE()) Duration
from (
select row_number() over (partition by issue order by transitiontime desc) RN
	,row_number() over (partition by issue order by transitiontime asc) RN_ASC
	,issuekey
	,summary
	,issue
	,OLDSTRING
	,NEWSTRING
	,Transition
	,CREATED
	,transitiontime
	from (
	SELECT 
	 (CAST(p.pkey as varchar) + CAST(' - ' as varchar) + CAST(ji.issuenum as varchar)) as issuekey
	,ji.summary
	,ji.id ISSUE
	--,ji.issuenum
	--,ci.FIELD
	--,ci.OLDSTRING,ci.NEWSTRING
		,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' 
		ELSE 'Removed Status' 
	 END OLDSTRING
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar) 
		ELSE 'Removed Status' 
	 END NEWSTRING
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) + ' - ' + 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' + ' - ' + CAST(newstring as varchar) 
		ELSE 'Removed Status' + ' - ' + 'Removed Status' 
	 END Transition
	,min(ji.CREATED) CREATED
	,min(cg.CREATED) as transitiontime
	--,cg.AUTHOR
	--, DATEDIFF(DAY,ji.CREATED,cg.CREATED)  as resolutiontime
	FROM [JIRAPRD7010].[dbo].changeitem ci
	JOIN [JIRAPRD7010].[dbo].changegroup cg ON cg.ID = ci.groupid
	JOIN [JIRAPRD7010].[dbo].jiraissue ji ON ji.ID = cg.issueid
	JOIN [JIRAPRD7010].[dbo].issuestatus iss ON iss.ID = ji.issuestatus
	JOIN [JIRAPRD7010].[dbo].project p ON p.ID = ji.PROJECT
	--JOIN [JIRAPRD7010].[dbo].project_key pk ON pk.PROJECT_ID = P.ID
	WHERE p.pname = 'GVCO' AND ci.FIELD = 'status' 
	and ji.id in (select source from [JIRAPRD7010].[dbo].[issuelink] )
	--AND ji.issuestatus = 10019 /*done*/ --AND ji.issuetype = 11402 /*content batch*/ 
	--AND NEWSTRING LIKE 'Done' /*new change item */
	--and ji.id = '124104'
	--and ji.summary like '%GOL%1%'
	group by (CAST(p.pkey as varchar) + CAST(' - ' as varchar) + CAST(ji.issuenum as varchar)) 
	,ji.summary
	--,ji.issuenum
	,ji.id 
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) 
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' 
		ELSE 'Removed Status' 
	 END
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN CAST(newstring as varchar) 
		ELSE 'Removed Status' 
	 END 
	,CASE 
		WHEN cast(oldstring as varchar) IN ('Not Started') AND CAST(newstring as varchar) NOT IN ('Media & Metadata Processing') THEN cast(oldstring as varchar) + ' - ' + 'Removed Status' 
		WHEN cast(oldstring as varchar) IN ('Field Installation') AND CAST(newstring as varchar) IN ('Done') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar) 
		WHEN cast(oldstring as varchar) IN ('Open', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Done', 'Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN cast(oldstring as varchar) + ' - ' + CAST(newstring as varchar)
		WHEN cast(oldstring as varchar) NOT IN ('Open', 'Field Installation', 'USB Replication','Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') AND CAST(newstring as varchar) IN ('Field Installation', 'USB Replication', 'Not Started', 'Media & Metadata Processing', 'Dev & SIT Testing') THEN 'Removed Status' + ' - ' + CAST(newstring as varchar) 
		ELSE 'Removed Status' + ' - ' + 'Removed Status' 
	 END 	 
) T1
) t
where t.rn = 1 and t.Transition <> 'Field Installation - Done'
and t.NEWSTRING not in ('Not Started', 'Removed Status')
) f
LEFT JOIN (
	select DISTINCT cfv.issue, case when cf.customvalue = 'JAL' then 'JAL/JAIR' when cf.customvalue = 'JAIR' then 'JAL/JAIR' ELSE cf.customvalue END Airline
	from [JIRAPRD7010].[dbo].customfieldvalue cfv 
	inner join [JIRAPRD7010].[dbo].customfieldoption cf on (cfv.customfield = cf.customfield and cast(cfv.stringvalue as int) = cf.id and cf.CUSTOMFIELD = 11002)	
	) AL ON F.ISSUE = AL.issue
LEFT JOIN (
	select cfv.issue, cfv.numbervalue Batch
	from [JIRAPRD7010].[dbo].customfieldvalue cfv where cfv.customfield = '15308'	
	) BT ON F.ISSUE = BT.issue
LEFT JOIN (
	select cfv.issue, cfv.numbervalue Titles
	from [JIRAPRD7010].[dbo].customfieldvalue cfv where cfv.customfield = '15314'	
	) tl ON F.ISSUE = tl.issue
--where f.OLDSTRING not in ('Open', 'Removed Status')
order by F.ISSUE, F.Start_Date_Time
