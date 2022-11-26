SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('***********************| CHECKLIST7: ROLLBACK and  SAVEPOINT |************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

drop user abdel cascade;
create user abdel identified by abdel;

grant myrole to abdel;
grant create any sequence to abdel;
 
create undo tablespace udtbs2 datafile 'C:\USERS\DE0L\DESKTOP\ORA\oradata\oracl\undotbs02' size 3m;
alter system set undo_tablespace=UDTBS2 scope=both;

alter system set undo_retention=200 scope=both;


create tablespace tbs1 datafile 'C:\USERS\DE0L\DESKTOP\ORA\oradata\oracl\tbs01' size 2m autoextend on;
alter user abdel default tablespace tbs1;
alter user abdel quota unlimited on tbs1;

conn abdel/abdel;

create table test (id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1), value INT);
BEGIN
   FOR counter IN 1..500 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
   sys.dbms_session.sleep(2);
END;
/

select status, count(*) from dba_undo_extents where tablespace_name='UDTBS2' group by status;
savepoint a;
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('>>>>> Savepoint A');

END;
/
select count(*) from test;

BEGIN
   FOR counter IN 1..500 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
   sys.dbms_session.sleep(2);
END;
/

select status, count(*) from dba_undo_extents where tablespace_name='UDTBS2' group by status;
savepoint b;
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('>>>>> Savepoint B');

END;
/
select count(*) from test;

BEGIN
   FOR counter IN 1..500 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
   sys.dbms_session.sleep(2);
END;
/

select status, count(*) from dba_undo_extents where tablespace_name='UDTBS2' group by status;
savepoint C;
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('>>>>> Savepoint C');

END;
/
select count(*) from test;

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('>>>>> ROLLBACK to SAVEPOINT B');

END;
/
rollback to savepoint b;
select count(*) from test;

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('>>>>> ROLLBACK to SAVEPOINT A');

END;
/
rollback to savepoint a;
select count(*) from test;
commit;

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('>>>>> COMMIT');
END;
/
select status, count(*) from dba_undo_extents where tablespace_name='UDTBS2' group by status;

conn sys/oracle as sysdba

-- drop tablespace tbs1 including contents and datafiles;


/*
Les savepoint ne sont pas commités
 Questions:
  c'est quoi l'intêret de unexpired extends => si retention garantee est activée et je fais commit les modifs sont dans redo logs dans ce cas unexpired extents est sans intérêt.
*/