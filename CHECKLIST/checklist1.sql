SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------<  Checklist1: create and grant priviliges to users <-------------');
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------> Create user1 and abdel <--------------------------------------');
END;
/
create user abdel identified by abdel;
create user user1 identified by user;


BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------> GRANT privileges to user1 and abdel <-------------------------');
END;
/
grant create session to abdel;
grant create table to abdel;

grant create session to user1;
grant select on hr.regions to user1;
select * from dba_sys_privs where grantee IN ('ABDEL', 'USER1');

alter user abdel quota unlimited on users;
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------> User ABDEL is connected <------------------------------------');
END;
/
conn abdel/abdel;
select * from user_sys_privs;

create table test(id int primary key, name varchar2(255) not null);
insert into test values (1, 'abdel');

select * from abdel.test;

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------> User SYS is connected <-------------------------------------');
END;
/

conn sys/oracle as sysdba;
grant select on abdel.test to user1;
select * from dba_tab_privs where grantee = 'USER1';

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------> User USER1 is connected <-----------------------------------');
END;
/
conn user1/user;
select * from user_sys_privs;
select * from abdel.test;
select * from hr.regions;
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------> User SYS is connected <-------------------------------------');
END;
/

conn sys/oracle as sysdba;
drop user user1 cascade;
drop user abdel cascade;


/* Conclusions:

1. il faut d'abord créer les tables et ensuite attribuer les privilèges à des users sur ces tables

*/