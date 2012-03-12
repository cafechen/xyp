select orgs.*, org_types.name as org_type_name, user_orgs.user_id as user_id, users.name as creater
from orgs 
left join org_types 
on org_types.id = orgs.org_type_id
left join user_orgs 
on user_orgs.org_id = orgs.id and user_orgs.role_id = 1
left join users
on users.id = user_id