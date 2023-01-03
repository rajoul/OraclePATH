SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('***********************| CHECKLIST7: FLASHBACK TABLES  |******************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/


drop user abdel cascade;
create user abdel identified by abdel;

grant myrole to abdel;
create tablespace tbs1 datafile 'C:\USERS\DE0L\DESKTOP\ORA\oradata\oracl\tbs01' size 10m;
alter user abdel default tablespace tbs1;
alter user abdel quota unlimited on tbs1;

alter system set undo_retention = 50;

conn abdel/abdel

create table test (id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1), username VARCHAR2(255), salary INT);
ALTER TABLE test ENABLE ROW MOVEMENT;
INSERT INTO test(username, salary) values ('abdel', 1000);
select SYSTIMESTAMP from dual;
COMMIT;
select * from test;
BEGIN
   sys.dbms_session.sleep(5);
END;
/

select SYSTIMESTAMP from dual;
INSERT INTO test(username, salary) values ('user1', 2000);
COMMIT;
select * from test;


FLASHBACK TABLE test TO TIMESTAMP SYSTIMESTAMP - interval '1' second;  

select * from test;

conn sys/oracle as sysdba

/* Conclusion
  - les flashback table utilise les UNDO TBS
  - les flashback permet de revenir en arrière (dans les anciens commit), parfois ce n'est pas possible de faire flashback dans un temps T1, pourquoi ?
  Par ce que:
    1. la taille du datafile est fixe et non autoextend, 
    Par example supposons que le datafile est de taille 2Mo (non autoextend). et undo_retention est egale à 10 minutes, dans ce cas si je fais 100 commit dans 10 minutes
    et chaque commit pèsent 200 Ko, en total c'est 20Mo sachant que mon datafile est 2Mo dans ce cas c'est sure certain données sont ecrasé => incapable de récupérer certaines 
    snapshots

*/
