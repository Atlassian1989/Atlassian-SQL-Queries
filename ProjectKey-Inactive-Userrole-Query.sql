SELECT pkey FROM project WHERE ID IN (SELECT PID from projectroleactor where PID in 
(select SOURCE_NODE_ID from nodeassociation where ROLETYPEPARAMETER IN ('DSummers'))
 AND ROLETYPE <> 'atlassian-group-role-actor')