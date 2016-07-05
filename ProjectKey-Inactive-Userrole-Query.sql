/* Checked Inactive User relationships with JIRA Projects as of 7/5/2016 */
SELECT pkey FROM project WHERE ID IN (SELECT PID from projectroleactor where PID in 
(select SOURCE_NODE_ID from nodeassociation where ROLETYPEPARAMETER LIKE '%TMyers%')
 AND ROLETYPE <> 'atlassian-group-role-actor')
 
 
 
 
