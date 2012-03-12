alter table organizations change fans fans integer not null default 0;
create table event_types (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name varchar(255))
create table schools (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, school_name varchar(255), school_code INT)
create table events (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, title varchar(255),place varchar(255), beginTime timestamp, endTime timestamp, speaker varchar(255))
create table events (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, title varchar(255),place varchar(255), beginTime timestamp, endTime timestamp, speaker varchar(255))


select orgs.*, org_types.name as org_type_name, user_orgs.user_id as user_id, users.name as creater
    from orgs 
    right join org_types 
    on org_types.id = orgs.org_type_id
    right join user_orgs 
    on user_orgs.org_id = orgs.id and user_orgs.role_id = 1
    right join users
    on users.id = user_id
