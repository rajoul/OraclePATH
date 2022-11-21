SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------<  Checklist2: creation des roles avec des privilèges <-------------');
END;
/

create user abdel identified by abdel;
create role myrole;
grant create session to myrole;
grant select any table to myrole;

select * from role_sys_privs where role = 'MYROLE';

grant myrole to abdel;

conn abdel/abdel;
show user
select * from hr.departments;

conn sys/oracle as sysdba;
show user;

drop user abdel;
drop role myrole;


SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------<  Scenario pour create role identified  by password <-------------');
END;
/

create user abdel identified by abdel;
create role myrole identified by password;

/* minimum de privilège pour activer le role */	
grant create session to abdel;

grant select any table to myrole;
grant myrole to abdel;
select * from role_sys_privs where role = 'MYROLE';

conn abdel/abdel;
show user;
/* enable the role */
set role myrole identified by password;
select * from hr.jobs;

conn sys/oracle as sysdba;

show user
drop role myrole;
drop user abdel;