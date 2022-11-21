SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| CHECKLIST3: Gestion des profiles |*********************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

create user abdel identified by abdel;
create profile myprofile limit connect_time 1
	failed_login_attempts 1;

select * from dba_profiles where profile = 'MYPROFILE';

alter user abdel profile myprofile;
grant create session to abdel;

select username, profile, account_status from dba_users where username ='ABDEL';

/* le mot de pass reste valide pendant 100 jours */
alter profile myprofile limit password_life_time 100

SET SERVEROUTPUT ON
BEGIN
	DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| TEST LOGIN FAILED |************************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/
conn abdel/re

conn abdel/abdel

conn sys/oracle as sysdba;
select username, profile, account_status from dba_users where username ='ABDEL';

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| Devrouiller le compte ABDEL |**************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/
alter user abdel identified by abdel account unlock;

select username, profile, account_status from dba_users where username ='ABDEL';

show user
drop profile myprofile cascade; 
select username, profile from dba_users where username = 'ABDEL';
drop user abdel;

