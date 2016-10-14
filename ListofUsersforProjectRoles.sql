SELECT p.pname, pr.NAME, u.display_name 
FROM projectroleactor pra
INNER JOIN projectrole pr ON pr.ID = pra.PROJECTROLEID
INNER JOIN project p ON p.ID = pra.PID
INNER JOIN app_user au ON au.lower_user_name = pra.ROLETYPEPARAMETER
INNER JOIN cwd_user u ON u.user_name = au.user_key;

// This is a pretty basic query, so you will probably have to alter it a bit to get the exact results you want. For example, you can add some criteria to limit the results by Project (where p.pname = "My Project") or by role (pr.NAME = "Developers")

// List of users belonging to groups assigned to project roles for all projects
SELECT p.pname as ProjN, pr.NAME as roleN, pra.roletype, pra.roletypeparameter, cmem.child_name, u.display_name
FROM projectroleactor pra
INNER JOIN projectrole pr ON pr.ID = pra.PROJECTROLEID
INNER JOIN project p ON p.ID = pra.PID
INNER JOIN cwd_membership cmem ON lower_parent_name=pra.roletypeparameter
INNER JOIN app_user au ON au.lower_user_name = cmem.child_name
INNER JOIN cwd_user u ON u.user_name = au.user_key
WHERE pra.roletype = 'atlassian-group-role-actor' order by p.pname;
