SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| CHECKLIST5: Gestion des tablespaces |******************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

drop user abdel cascade;
create user abdel identified by abdel;
/* MYROLE
create role myrole;
grant create session to myrole;
grant create table to myrole;
grant create any sequence to myrole;
grant select any sequence to myrole;
*/

grant myrole to abdel;

CREATE TABLESPACE tbs1 DATAFILE 'C:\Users\de0l\Desktop\ora\oradata\ORACL\MYTBS01.DBF' SIZE 1m, 'C:\Users\de0l\Desktop\ora\oradata\ORACL\MYTBS02.DBF' SIZE 1m;

select * from dba_data_files where tablespace_name='TBS1';

alter user abdel quota unlimited on tbs1;
conn abdel/abdel;

create table test (id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1), value INT);
BEGIN
   FOR counter IN 1..1000 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
END;
/

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('******| IL ne peut insérer, par ce que default tablespae is USERS |*******************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

conn sys/oracle as sysdba;
select owner, table_name, tablespace_name from all_tables where table_name = 'TEST';
alter user abdel default tablespace TBS1;
ALTER TABLE abdel.test MOVE TABLESPACE TBS1;
conn abdel/abdel;

BEGIN
   FOR counter IN 1..30000 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
END;
/
conn sys/oracle as sysdba;
select segment_name,segment_type, bytes, tablespace_name, extents, blocks from dba_segments WHERE segment_name ='TEST';

-- /* TWO WAYS to extent tablespace
--     1. extent datafile
-- */
alter database datafile 'C:\Users\de0l\Desktop\ora\oradata\ORACL\mytbs02.dbf' RESIZE 2M;

conn abdel/abdel;

BEGIN
   FOR counter IN 1..250000 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
END;
/
conn sys/oracle as sysdba;
select segment_name,segment_type, bytes, tablespace_name, extents, blocks from dba_segments WHERE segment_name ='TEST';



-- /*  2. add a datafile */
ALTER TABLESPACE tbs1 ADD DATAFILE 'C:\Users\de0l\Desktop\ora\oradata\ORACL\mytbs03.dbf' SIZE 1m autoextend on;

conn abdel/abdel;

BEGIN
   FOR counter IN 1..250000 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
END;
/
conn sys/oracle as sysdba;
select segment_name,segment_type, bytes, tablespace_name, extents, blocks from dba_segments WHERE segment_name ='TEST';

/* 
                          MOVE OR RENAME A DATAFILE
      1. ALTER TABLESPACE tbs1 OFFLINE NORMAL;
      2. cp C:\Users\de0l\Desktop\Ora\oradata\ORACL\mytbs03.dbf to C:\Users\de0l\Desktop\Ora\oradata\ORACL\tbs03.dbf 
      3. ALTER TABLESPACE tbs1 RENAME DATAFILE 'C:\Users\de0l\Desktop\ora\oradata\ORACL\mytbs03.dbf' to 'C:\Users\de0l\Desktop\ora\oradata\ORACL\tbs03.dbf';
      4. ALTER TABLESPACE tbs1 ONLINE;
      5. détruire C:\Users\de0l\Desktop\Ora\oradata\ORACL\mytbs03.dbf 
*/

drop tablespace tbs1 including contents and datafiles;