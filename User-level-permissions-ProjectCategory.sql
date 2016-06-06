SELECT ROLETYPE,ROLETYPEPARAMETER, PROJECTROLEID,PID from projectroleactor where PID in 
(select SOURCE_NODE_ID from nodeassociation where SINK_NODE_ENTITY = 'ProjectCategory' AND SINK_NODE_ID = 10800)
 AND ROLETYPE = 'atlassian-group-role-actor' ORDER BY ROLETYPEPARAMETER ASC;