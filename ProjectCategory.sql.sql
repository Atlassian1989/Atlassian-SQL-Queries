Project - project-Category


SELECT pc.cname AS PROJECT_CATEGORY,p.pname AS PROJECT_NAME,p.LEAD AS PROJECT_LEAD from project p
 join nodeassociation n ON n.SOURCE_NODE_ID= p.ID
 join projectcategory pc ON pc.ID = n.SINK_NODE_ID
 where n.SINK_NODE_ENTITY = 'ProjectCategory'
 ORDER BY pc.cname ASC;
 
 
 
 
 
 


 
 