SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| CHECKLIST5: RESUMABLE SESSION |************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

drop user abdel cascade;
drop tablespace tbs1 including contents and datafiles;
create user abdel identified by abdel;

grant myrole to abdel;
grant select on dba_segments to abdel;

CREATE TABLESPACE tbs1 DATAFILE 'C:\Users\de0l\Desktop\ora\oradata\ORACL\MYTBS01.DBF' SIZE 1m;
select * from dba_data_files where tablespace_name='TBS1';

alter user abdel default tablespace tbs1;
alter user abdel quota unlimited on tbs1;

-- désactiver l'allocation résumable

alter system set resumable_timeout=0;
conn abdel/abdel;

create table test (id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1), value INT);
BEGIN
   FOR counter IN 1..100000 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
END;
/
select segment_name, segment_type, extents, blocks, bytes from dba_segments where segment_name='TEST';

conn sys/oracle as sysdba;
-- Lorsque il manque d'espace la session reste en suspend 10 secondes
 alter system set resumable_timeout=20;

conn abdel/abdel;

BEGIN
   FOR counter IN 1..100000 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
END;
/
/* 
Dans cette 20 seconde :
1. connecte à une autre session as sysdba
2. resize the tablespace: 
  ALTER database DATAFILE 'C:\Users\de0l\Desktop\ora\oradata\ORACL\MYTBS01.DBF' RESIZE 3m;
Après ces 20 secondes tout les données vont être insérés
*/
select segment_name, segment_type, extents, blocks, bytes from dba_segments where segment_name='TEST';



conn sys/oracle as sysdba;