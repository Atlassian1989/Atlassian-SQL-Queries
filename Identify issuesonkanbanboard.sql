select CAST(p.pkey as varchar) + CAST(' - ' as varchar) + CAST(j.issuenum as varchar) as issuekey,j.issuestatus from jiraissue j
JOIN project p ON p.ID = j.PROJECT
where j.issuestatus IN (select STATUS_ID from [dbo].[AO_60DB71_COLUMNSTATUS] 
WHERE COLUMN_ID IN ((select ID from [dbo].[AO_60DB71_COLUMN] WHERE RAPID_VIEW_ID IN (select ID from AO_60DB71_RAPIDVIEW WHERE NAME = 'GVCO'))))
AND PROJECT = (select p.ID from project p where p.ID in (select j.PROJECT from jiraissue where issuestatus IN (select STATUS_ID from [dbo].[AO_60DB71_COLUMNSTATUS] 
WHERE COLUMN_ID IN ((select ID from [dbo].[AO_60DB71_COLUMN] WHERE RAPID_VIEW_ID IN (select ID from AO_60DB71_RAPIDVIEW WHERE NAME = 'GVCO'))))) AND p.pkey = 'GVCO')
AND issuetype IN (SELECT ID from issuetype WHERE pname ='Content Batch')
