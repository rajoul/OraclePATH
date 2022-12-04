SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*********************| CHECKLIST11: TABLE COMPRESSION |*******************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

/*
Basic table compression   ->   ROW STORE COMPRESS [BASIC]
Advanced row compression  ->   ROW STORE COMPRESS ADVANCED
Warehouse compression (Hybrid Columnar Compression)   -> COLUMN STORE COMPRESS FOR QUERY [LOW|HIGH]
Archive compression (Hybrid Columnar Compression)     -> COLUMN STORE COMPRESS FOR ARCHIVE [LOW|HIGH]
*/

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

alter user abdel quota unlimited on users;


alter user abdel quota unlimited on users;
conn abdel/abdel;

create table test (id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1), value INT) COMPRESS BASIC;
select compression, compress_for from user_tables where table_name='TEST';
BEGIN
   FOR counter IN 1..200 loop
      INSERT INTO test(value)
      VALUES(counter);
   END loop;
END;
/
alter table test nocompress;
select compression, compress_for from user_tables where table_name='TEST';

-- les données existants dans la table ne seront pas compressés seulement les future DML will be compressed
alter table test row store compress advanced;

-- This approach will enable Advanced Row Compression for future DML and will compress existing data
alter table test move row store compress advanced;


conn sys/oracle as sysdba;