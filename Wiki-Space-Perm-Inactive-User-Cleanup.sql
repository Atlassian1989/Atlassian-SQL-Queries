/* Checked Inactive User relationships with Confluence Spaces as of 7/15/2016 */
SELECT sp.SPACEID,s.SPACEKEY,s.SPACENAME,um.username FROM SPACEPERMISSIONS sp JOIN user_mapping  um ON
um.user_key = sp.PERMUSERNAME
JOIN SPACES s ON 
sp.SPACEID = s.SPACEID
WHERE sp.PERMUSERNAME IS NOT NULL AND um.username LIKE '%skumaravel%'
