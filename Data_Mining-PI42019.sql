-- Get Jira Project ID for PI42019 
select * from project WHERE pkey LIKE 'PI42019'

-- Custom field id of Related ART field
select * from customfield where cfname LIKE 'Related ART'

-- Issue Type ID of Epic 
select * from issuetype where pname LIKE 'Epic'

-- Number of Epics in PI42019 Project synced from Jama
select count(*) from jiraissue where project = 19001 AND issuetype = 6

-- Get Issues from PI42019 project with Related ART field not NULL
select STRINGVALUE as "Related ART",count(*) as "Number of Features" from customfieldvalue
where CUSTOMFIELD = 19904 AND ISSUE IN(select ID from jiraissue where issuetype = 6 AND project = 19001)
group by STRINGVALUE

-- Get number of stories linked to Epic of a PI42019 project
SELECT  CAST(p.pkey as varchar) + '-'+ CAST(ji.issuenum as varchar) as issuekey, count(*) AS num_linked_stories  from jiraissue ji
JOIN project p ON ji.PROJECT = p.ID 
RIGHT JOIN issuelink il ON il.SOURCE = ji.ID WHERE
il.LINKTYPE = 10400 AND p.pkey = 'PI42019' group by CAST(p.pkey as varchar) + '-'+ CAST(ji.issuenum as varchar) 
ORDER BY num_linked_stories DESC



-- Get status Category (2: Backlog, 3: In Progress, 4: Done)
select CAST(p.pkey as varchar) + '-'+ CAST(ji.issuenum as varchar) as issuekey,
iss.pname AS workflowStatus,itp.pname as issuetypeName, 
ji.CREATED as CreatedDate,ji.UPDATED as UpdatedDate, cfv.STRINGVALUE as "Related ART",
iss.STATUSCATEGORY from customfieldvalue cfv
JOIN customfield cf ON cfv.CUSTOMFIELD = cf.ID
JOIN jiraissue ji ON cfv.ISSUE = ji.ID
JOIN issuetype itp ON itp.ID = ji.issuetype
JOIN issuestatus iss ON iss.ID = ji.issuestatus
JOIN project p ON p.ID = ji.PROJECT
WHERE p.pkey = 'PI42019' AND cf.cfname in ('Related ART') 
ORDER BY ji.UPDATED DESC
