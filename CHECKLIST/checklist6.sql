SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('***********************| CHECKLIST6: Gestion des tablespaces UNDO |*******************');
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
grant select on dba_undo_extents to abdel;

 
create undo tablespace udtbs2 datafile 'C:\USERS\DE0L\DESKTOP\ORA\oradata\oracl\undotbs02' size 3m;
alter system set undo_tablespace=UDTBS2 scope=both;

alter system set undo_retention=200 scope=both;




SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('***********************| CHECKLIST6: GET Number of extents of undo TBS2 |*************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/
select a.tablespace_name, a.file_name, b.contents, a.blocks/8 as Totalextents from dba_data_files a join dba_tablespaces b on a.tablespace_name=b.tablespace_name where contents='UNDO';
/* extent actif + unexpired + expired  ne va jamais depasser totalextents */
select status, count(*) from dba_undo_extents where tablespace_name='UDTBS2' group by status;


CREATE TABLESPACE tbs1 DATAFILE 'C:\Users\de0l\Desktop\ora\oradata\ORACL\MYTBS01.DBF' SIZE 1m autoextend on;

alter user abdel default tablespace tbs1;
alter user abdel quota unlimited on tbs1;

conn abdel/abdel;

create table test (id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1), value INT);
BEGIN
   FOR counter IN 1..500 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
   sys.dbms_session.sleep(1);
END;
/

select status, count(*) from dba_undo_extents where tablespace_name='UDTBS2' group by status;
/* totalExtent - unexpired - expired -actif = libre */
BEGIN
   FOR counter IN 1..500 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
   sys.dbms_session.sleep(1);
END;
/
select status, count(*) from dba_undo_extents where tablespace_name='UDTBS2' group by status;
commit;
/* after commit => unexpired = unexpired+active */
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('***********************| CHECKLIST6: COMMIT ACTION  |*********************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/
select status, count(*) from dba_undo_extents where tablespace_name='UDTBS2' group by status;

BEGIN
   FOR counter IN 1..1000 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
   sys.dbms_session.sleep(1);
END;
/
select status, count(*) from dba_undo_extents where tablespace_name='UDTBS2' group by status;

/* NOGRANTEE: veut dire qu'on peut allouer les non expiré extent (puisque sont commitées)
	GARANTEE: veut dire jamais allouer les noexpired extent par ce que la durée de retention n'est pas encore ecoulé
*/
conn sys/oracle as sysdba;
select tablespace_name, retention from dba_tablespaces where tablespace_name='UDTBS2';

/* Statistics about block allocation */
select to_char(begin_time,'YYYY/MM/DD HH24:MI') begin_time,
	UNXPSTEALCNT "#UnexpiredBlksTaken", 
	EXPSTEALCNT "#ExpiredBlksTaken",
	NOSPACEERRCNT "SpaceRequests"
	from v$undostat order by begin_time;


alter system set undo_tablespace=undotbs1;
drop tablespace udtbs2 including contents and datafiles;
drop tablespace tbs1 including contents and datafiles;

/* 
Question:
	pourquoi le totalextents de datafile est different de la somme des extents dans dba_segments
		- select segment_name, blocks, extents from dba_segments where tablespace_name='UDTBS2';
		- select a.tablespace_name, a.file_name, b.contents, a.blocks/8 as Totalextents from dba_data_files a 
		 	join dba_tablespaces b on a.tablespace_name=b.tablespace_name where contents='UNDO';
*/




