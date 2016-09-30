/* For GVCO Project with status of Done for Issue Type Content Batch */
SELECT (CAST(p.pkey as varchar) + CAST(' - ' as varchar) + CAST(ji.issuenum as varchar)) as issuekey,ji.issuenum,ci.FIELD,ci.OLDSTRING,ci.NEWSTRING,ji.CREATED,cg.CREATED as transitiontime,cg.AUTHOR, DATEDIFF(DAY,ji.CREATED,cg.CREATED)  as resolutiontime
FROM changeitem ci
JOIN changegroup cg ON
cg.ID = ci.groupid
JOIN jiraissue ji ON
ji.ID = cg.issueid
JOIN issuestatus iss ON 
iss.ID = ji.issuestatus
JOIN project p ON
p.ID = ji.PROJECT
JOIN project_key pk ON
pk.PROJECT_ID = P.ID
WHERE pk.PROJECT_KEY = 'GVCO' AND ci.FIELD = 'status' AND ji.issuestatus = 10019 AND ji.issuetype = 11402 AND NEWSTRING LIKE 'Done' 
ORDER BY ji.issuenum DESC
