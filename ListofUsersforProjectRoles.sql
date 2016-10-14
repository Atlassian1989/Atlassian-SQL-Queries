SELECT DISTINCT u.display_name, p.pname, p.pkey, pr.NAME
FROM projectroleactor pra
INNER JOIN projectrole pr ON pr.ID = pra.PROJECTROLEID
INNER JOIN project p ON p.ID = pra.PID
INNER JOIN app_user au ON au.lower_user_name = pra.ROLETYPEPARAMETER
INNER JOIN cwd_user u ON u.user_name = au.user_key WHERE u.display_name LIKE '%X]' order by p.pname DESC;
