if exists(select 1 from INFORMATION_SCHEMA.tables where table_name like 'ns' and TABLE_TYPE = 'VIEW')
DROP VIEW ns
go
CREATE VIEW ns AS
select CAST(p.pkey as varchar) + '-' + CAST(ji.issuenum as varchar) as Epicissuekey, il.SOURCE AS EpicId, il.DESTINATION as StoryId,
iss.pname as EpicStatus, itp.pname as IssueTypeName, il.DESTINATION, cfv.STRINGVALUE as EpicProductOwner
from jiraissue ji JOIN project p ON ji.PROJECT = p.ID
JOIN issuestatus iss ON ji.issuestatus = iss.ID
JOIN issuetype itp ON ji.issuetype = itp.ID
JOIN issuelink il ON il.SOURCE= ji.ID
JOIN customfieldvalue cfv ON ji.ID = cfv.ISSUE
JOIN customfield cf ON cfv.CUSTOMFIELD = cf.ID
where il.LINKTYPE = 10400 AND (p.pkey = 'PI42019' OR p.pkey LIKE 'PI%%') AND itp.pname = 'Epic' AND iss.STATUSCATEGORY =3 AND cf.cfname LIKE 'Product Owner'
go
WAITFOR DELAY '00:00:05';
go
select CAST(pr.pkey as varchar) + '-' + CAST(ij.issuenum as varchar) as StoryKey, ij.ASSIGNEE,ssi.pname as StoryStatus,ns.Epicissuekey,ns.EpicStatus, ns.EpicProductOwner from jiraissue ij 
JOIN  ns ON ij.ID = ns.StoryId
JOIN issuestatus ssi ON ij.issuestatus = ssi.ID
JOIN project pr ON ij.PROJECT = pr.ID WHERE pr.pkey LIKE 'PI%' AND ssi.STATUSCATEGORY != 3 
ORDER BY ns.Epicissuekey DESC;
/*
select count(DISTINCT ns.Epicissuekey) from jiraissue ij 
JOIN  ns ON ij.ID = ns.StoryId
JOIN issuestatus ssi ON ij.issuestatus = ssi.ID
JOIN project pr ON ij.PROJECT = pr.ID WHERE pr.pkey LIKE 'PI%' AND ssi.STATUSCATEGORY != 3 
*/