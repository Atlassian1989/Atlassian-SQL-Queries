// get list of filters which has share type as "share with everyone" (i.e. global)
SELECT sr.filtername, sp.sharetype AS current_share_state, sr.username AS owner_name, sr.reqcontent AS JQL
FROM searchrequest sr
INNER JOIN sharepermissions sp ON sp.entityid = sr.id 
WHERE sp.sharetype='global' and sp.entitytype ='SearchRequest';

// get list of Agile broads which has share type as "share with everyone" (i.e. global)
SELECT DISTINCT "rv"."NAME" as "Board Name", sr.filtername, sp.sharetype AS current_share_state, sr.username AS owner_name
FROM "AO_60DB71_RAPIDVIEW" as rv 
INNER JOIN searchrequest sr ON sr.id = rv."SAVED_FILTER_ID"
INNER JOIN sharepermissions sp ON sp.entityid = sr.id 
WHERE sp.sharetype='global' and sp.entitytype ='SearchRequest';

// get list of Dashboard which has share type as "share with everyone" (i.e. global)
SELECT DISTINCT pp.id as Dashboard_Id, pp.pagename AS Dashboard_name, sp.sharetype AS current_share_state, pp.username AS owner_name
FROM portalpage pp
INNER JOIN sharepermissions sp ON sp.entityid = pp.id 
WHERE sp.sharetype='global' and sp.entitytype ='PortalPage'
ORDER BY pp.id;
