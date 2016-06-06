/*SQL Query to Identify all purged pages */
select COUNT(*) AS num_del_pages,SPACEID from CONTENT where CONTENT_STATUS = 'deleted' AND CONTENTTYPE = 'PAGE' GROUP BY SPACEID; 
select SPACENAME from SPACES where SPACEID in (select SPACEID from CONTENT where CONTENT_STATUS = 'deleted' AND CONTENTTYPE = 'PAGE'); 


/*  SQL Query to Identify Inactive users from Jan 1 2015 */
 
SELECT b.lower_username username, a.SUCCESSDATE lastlogin 
FROM dbo.logininfo a, dbo.user_mapping b 
where b.user_key = a.USERNAME and a.SUCCESSDATE < '2015-01-01' 
order by a.SUCCESSDATE desc; 
