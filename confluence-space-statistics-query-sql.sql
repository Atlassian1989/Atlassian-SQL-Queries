select count(CONTENT.SPACEID) as pagecount,SPACES.SPACENAME as spacename,SPACES.CREATOR as creator,SPACES.CREATIONDATE as creationdate,
SPACES.LASTMODIFIER as lastmodifier,
SPACES.LASTMODDATE as lastmoddate
from
    SPACES, CONTENT
where
    SPACES.SPACEID = CONTENT.SPACEID
group by
    CONTENT.SPACEID, 
    SPACES.SPACENAME, 
    SPACES.CREATOR, 
    SPACES.CREATIONDATE, 
    SPACES.LASTMODIFIER, 
    SPACES.LASTMODDATE
order by 
    lastmoddate;